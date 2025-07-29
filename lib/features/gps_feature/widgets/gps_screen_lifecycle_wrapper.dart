import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_screen_lifecycle_cubit.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';

/// A wrapper widget that handles GPS screen lifecycle management.
/// This can be used with both stateless and stateful widgets.
class GpsScreenLifecycleWrapper extends StatefulWidget {
  final Widget child;
  final GpsScreenType screenType;
  final bool enableAutoRefresh;

  const GpsScreenLifecycleWrapper({
    super.key,
    required this.child,
    required this.screenType,
    this.enableAutoRefresh = true,
  });

  @override
  State<GpsScreenLifecycleWrapper> createState() =>
      _GpsScreenLifecycleWrapperState();
}

class _GpsScreenLifecycleWrapperState extends State<GpsScreenLifecycleWrapper> {
  late final GpsScreenLifecycleCubit _lifecycleCubit;

  @override
  void initState() {
    super.initState();
    _lifecycleCubit = GpsScreenLifecycleCubit();

    if (widget.enableAutoRefresh) {
      // Notify screen manager when screen becomes active
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lifecycleCubit.onScreenEnter(widget.screenType);
      });
    }
  }

  @override
  void dispose() {
    if (widget.enableAutoRefresh) {
      _lifecycleCubit.onScreenExit();
    }
    _lifecycleCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _lifecycleCubit, child: widget.child);
  }
}

/// Extension methods for easy access to GPS screen lifecycle functionality
extension GpsScreenLifecycleExtension on BuildContext {
  /// Get the GPS screen lifecycle cubit
  GpsScreenLifecycleCubit get gpsLifecycleCubit =>
      BlocProvider.of<GpsScreenLifecycleCubit>(this);

  /// Manually trigger a GPS data refresh
  Future<void> gpsManualRefresh() async {
    await gpsLifecycleCubit.manualRefresh();
  }

  /// Check if GPS refresh is currently active
  bool get isGpsRefreshActive => gpsLifecycleCubit.isRefreshActive;

  /// Get current GPS screen type
  GpsScreenType? get currentGpsScreenType =>
      gpsLifecycleCubit.currentScreenType;
}
