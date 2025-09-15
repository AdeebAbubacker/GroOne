import 'dart:async';

import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_login_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/utils/custom_log.dart';

enum GpsScreenType {
  home, // 15 seconds refresh
  map, // 5 seconds refresh
  other, // 15 seconds refresh
}

class GpsDataRefreshService {
  static final GpsDataRefreshService _instance =
      GpsDataRefreshService._internal();
  factory GpsDataRefreshService() => _instance;
  GpsDataRefreshService._internal();

  Timer? _refreshTimer;
  GpsScreenType _currentScreenType = GpsScreenType.other;
  bool _isActive = false;
  bool _isInitialized = false;

  // Lazy initialization of cubit instances
  GpsLoginCubit? _gpsLoginCubit;
  VehicleListCubit? _vehicleListCubit;
  GpsGeofenceCubit? _gpsGeofenceCubit;

  // Initialize the service
  void initialize() {
    if (_isInitialized) return;

    CustomLog.info(this, "GPS Data Refresh Service initialized");
    _isInitialized = true;
  }

  // Lazy getter for cubits
  GpsLoginCubit get _gpsLoginCubitInstance {
    _gpsLoginCubit ??= locator<GpsLoginCubit>();
    return _gpsLoginCubit!;
  }

  VehicleListCubit get _vehicleListCubitInstance {
    _vehicleListCubit ??= locator<VehicleListCubit>();
    return _vehicleListCubit!;
  }

  GpsGeofenceCubit get _gpsGeofenceCubitInstance {
    _gpsGeofenceCubit ??= locator<GpsGeofenceCubit>();
    return _gpsGeofenceCubit!;
  }

  /// Start data refresh for a specific screen type
  void startRefresh(GpsScreenType screenType) {
    if (_isActive && _currentScreenType == screenType) {
      CustomLog.debug(
        this,
        "Refresh already active for screen type: $screenType",
      );
      return;
    }

    _stopRefresh(); // Stop any existing timer
    _currentScreenType = screenType;
    _isActive = true;

    final interval = getRefreshInterval(screenType);
    CustomLog.info(
      this,
      "🚀 Starting GPS data refresh for $screenType with ${interval.inSeconds}s interval at ${DateTime.now().toIso8601String()}",
    );

    _refreshTimer = Timer.periodic(interval, (timer) {
      if (_isActive) {
        _performDataRefresh();
      }
    });

    // Perform initial refresh immediately
    _performDataRefresh();
  }

  /// Pause refresh when app goes to background
  void pauseRefresh() {
    if (_isActive) {
      CustomLog.info(this, "Pausing GPS data refresh due to app background");
      _stopRefresh();
    }
  }

  /// Resume refresh when app comes to foreground
  void resumeRefresh() {
    if (!_isActive) {
      CustomLog.info(this, "Resuming GPS data refresh due to app foreground");
      startRefresh(_currentScreenType);
    }
  }

  /// Restart refresh service after authentication is restored
  void restartAfterAuthRestore() {
    CustomLog.info(
      this,
      "Restarting GPS data refresh after authentication restore",
    );
    _stopRefresh();
    startRefresh(_currentScreenType);
  }

  /// Stop the data refresh
  void stopRefresh() {
    _stopRefresh();
  }

  void _stopRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _isActive = false;
    CustomLog.info(this, "GPS data refresh stopped");
  }

  /// Get refresh interval based on screen type
  Duration getRefreshInterval(GpsScreenType screenType) {
    switch (screenType) {
      case GpsScreenType.map:
        return const Duration(seconds: 5);
      case GpsScreenType.home:
      case GpsScreenType.other:
        return const Duration(seconds: 15);
    }
  }

  /// Perform the actual data refresh with error handling and performance optimization
  Future<void> _performDataRefresh() async {
    try {
      CustomLog.info(
        this,
        "🔄 Performing GPS data refresh for $_currentScreenType at ${DateTime.now().toIso8601String()}",
      );

      // Check if GPS service is properly initialized
      if (!_isGpsServiceInitialized()) {
        CustomLog.error(
          this,
          "GPS service not initialized, skipping refresh",
          null,
        );
        return;
      }

      // Use timeout to prevent hanging operations
      await Future.any([
        _performRefreshOperations(),
        Future.delayed(const Duration(seconds: 10), () {
          throw TimeoutException(
            'GPS refresh timeout',
            const Duration(seconds: 10),
          );
        }),
      ]);

      CustomLog.debug(this, "GPS data refresh completed successfully");
    } catch (e) {
      CustomLog.error(this, "Error during GPS data refresh", e);
      // Don't rethrow to prevent service from stopping
    }
  }

  /// Check if GPS service is properly initialized
  bool _isGpsServiceInitialized() {
    try {
      // Check if we can access the cubits without errors
      final gpsCubit = _gpsLoginCubitInstance;

      // Check if GPS service has valid authentication
      if (!gpsCubit.hasValidAuth) {
        CustomLog.debug(this, "GPS service has no valid authentication");
        return false;
      }

      return true;
    } catch (e) {
      CustomLog.error(this, "GPS service not properly initialized", e);
      return false;
    }
  }

  /// Perform refresh operations with proper error handling
  Future<void> _performRefreshOperations() async {
    final futures = <Future>[];

    // Only refresh critical data based on screen type
    switch (_currentScreenType) {
      case GpsScreenType.map:
        // For map screen, prioritize vehicle data
        futures.add(_vehicleListCubitInstance.refreshData());
        futures.add(_gpsLoginCubitInstance.refreshData());
        break;
      case GpsScreenType.home:
        // For home screen, refresh all data but with lower priority
        futures.add(_gpsLoginCubitInstance.refreshData());
        futures.add(_vehicleListCubitInstance.refreshData());
        futures.add(_gpsGeofenceCubitInstance.refreshData());
        break;
      case GpsScreenType.other:
        // For other screens, only refresh essential data
        futures.add(_gpsLoginCubitInstance.refreshData());
        break;
    }

    // Execute all refresh operations concurrently with error isolation
    final results = await Future.wait(
      futures.map(
        (future) => future.catchError((e) {
          CustomLog.error(this, "Individual refresh operation failed", e);

          // If it's an authentication error, stop the refresh service
          if (e.toString().contains('401') ||
              e.toString().contains('Unauthorized') ||
              e.toString().contains('InvalidToken') ||
              e.toString().contains('UnauthenticatedError')) {
            CustomLog.debug(
              this,
              "Authentication error detected, stopping refresh service",
            );
            _stopRefresh();
          }

          return null; // Continue with other operations
        }),
      ),
      eagerError: false, // Don't fail all if one fails
    );

    // Log results
    final successCount = results.where((result) => result != null).length;
    CustomLog.debug(
      this,
      "Refresh completed: $successCount/${futures.length} operations successful",
    );

    // If all operations failed, stop the refresh service to prevent continuous failures
    if (successCount == 0 && futures.isNotEmpty) {
      CustomLog.debug(
        this,
        "All refresh operations failed, stopping refresh service",
      );
      _stopRefresh();
    }
  }

  /// Check if refresh is currently active
  bool get isActive => _isActive;

  /// Get current screen type
  GpsScreenType get currentScreenType => _currentScreenType;

  /// Dispose the service
  void dispose() {
    _stopRefresh();
    CustomLog.info(this, "GPS Data Refresh Service disposed");
  }
}
