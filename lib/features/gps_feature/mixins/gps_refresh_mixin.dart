import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_screen_manager.dart';

mixin GpsRefreshMixin<T extends StatefulWidget> on State<T> {
  late final GpsScreenManager _screenManager;
  GpsScreenType get screenType;

  @override
  void initState() {
    super.initState();
    _screenManager = locator<GpsScreenManager>();

    // Notify screen manager when screen becomes active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenManager.onScreenEnter(screenType);
    });
  }

  @override
  void dispose() {
    // Notify screen manager when screen becomes inactive
    _screenManager.onScreenExit();
    super.dispose();
  }

  /// Manually trigger a data refresh
  Future<void> manualRefresh() async {
    await _screenManager.manualRefresh();
  }

  /// Check if refresh is currently active
  bool get isRefreshActive => _screenManager.isRefreshActive;

  /// Get current screen type
  GpsScreenType? get currentScreenType => _screenManager.currentScreenType;
}
