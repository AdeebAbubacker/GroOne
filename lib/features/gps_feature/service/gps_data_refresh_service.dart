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
      "Starting GPS data refresh for $screenType with ${interval.inSeconds}s interval",
    );

    _refreshTimer = Timer.periodic(interval, (timer) {
      if (_isActive) {
        _performDataRefresh();
      }
    });

    // Perform initial refresh immediately
    _performDataRefresh();
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
        return const Duration(seconds: 5000);
      case GpsScreenType.home:
      case GpsScreenType.other:
        return const Duration(seconds: 150000);
    }
  }

  /// Perform the actual data refresh
  Future<void> _performDataRefresh() async {
    try {
      CustomLog.debug(
        this,
        "🔄 Performing GPS data refresh for $_currentScreenType",
      );

      // Refresh login data (includes vehicle data, geofences, etc.)
      await _gpsLoginCubitInstance.refreshData();

      // Refresh vehicle list data
      await _vehicleListCubitInstance.refreshData();

      // Refresh geofence data
      await _gpsGeofenceCubitInstance.refreshData();

      CustomLog.debug(this, "✅ GPS data refresh completed successfully");
    } catch (e) {
      CustomLog.error(this, "❌ Error during GPS data refresh", e);
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
