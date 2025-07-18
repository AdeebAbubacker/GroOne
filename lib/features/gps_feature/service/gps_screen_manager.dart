import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class GpsScreenManager {
  static final GpsScreenManager _instance = GpsScreenManager._internal();
  factory GpsScreenManager() => _instance;
  GpsScreenManager._internal();

  GpsDataRefreshService? _refreshService;
  GpsScreenType? _currentScreenType;
  bool _isInitialized = false;

  void initialize() {
    if (_isInitialized) return;

    CustomLog.info(this, "GPS Screen Manager initialized");
    _isInitialized = true;
  }

  // Lazy getter for refresh service
  GpsDataRefreshService get _refreshServiceInstance {
    _refreshService ??= locator<GpsDataRefreshService>();
    return _refreshService!;
  }

  /// Called when a GPS screen becomes active
  void onScreenEnter(GpsScreenType screenType) {
    if (!_isInitialized) {
      CustomLog.debug(this, "GPS Screen Manager not initialized");
      return;
    }

    if (_currentScreenType == screenType) {
      CustomLog.debug(this, "Already on screen type: $screenType");
      return;
    }

    CustomLog.info(this, "Entering GPS screen: $screenType");
    _currentScreenType = screenType;
    _refreshServiceInstance.startRefresh(screenType);
  }

  /// Called when a GPS screen becomes inactive
  void onScreenExit() {
    if (!_isInitialized) return;

    CustomLog.info(this, "Exiting GPS screen: $_currentScreenType");
    _refreshServiceInstance.stopRefresh();
    _currentScreenType = null;
  }

  /// Get the current active screen type
  GpsScreenType? get currentScreenType => _currentScreenType;

  /// Check if refresh is currently active
  bool get isRefreshActive => _refreshServiceInstance.isActive;

  /// Manually trigger a refresh
  Future<void> manualRefresh() async {
    if (!_isInitialized || _currentScreenType == null) {
      CustomLog.debug(this, "Cannot refresh - no active screen");
      return;
    }

    CustomLog.info(this, "Manual refresh triggered for $_currentScreenType");
    _refreshServiceInstance.startRefresh(_currentScreenType!);
  }

  /// Dispose the manager
  void dispose() {
    _refreshServiceInstance.dispose();
    _isInitialized = false;
    CustomLog.info(this, "GPS Screen Manager disposed");
  }
}
