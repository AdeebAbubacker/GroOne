import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_screen_manager.dart';

// States
abstract class GpsScreenLifecycleState {}

class GpsScreenLifecycleInitial extends GpsScreenLifecycleState {}

class GpsScreenLifecycleActive extends GpsScreenLifecycleState {
  final GpsScreenType screenType;
  final bool isRefreshActive;

  GpsScreenLifecycleActive({
    required this.screenType,
    required this.isRefreshActive,
  });
}

class GpsScreenLifecycleInactive extends GpsScreenLifecycleState {}

// Cubit
class GpsScreenLifecycleCubit extends Cubit<GpsScreenLifecycleState> {
  final GpsScreenManager _screenManager;

  GpsScreenLifecycleCubit()
    : _screenManager = locator<GpsScreenManager>(),
      super(GpsScreenLifecycleInitial());

  void onScreenEnter(GpsScreenType screenType) {
    _screenManager.onScreenEnter(screenType);
    emit(
      GpsScreenLifecycleActive(
        screenType: screenType,
        isRefreshActive: _screenManager.isRefreshActive,
      ),
    );
  }

  void onScreenExit() {
    _screenManager.onScreenExit();
    emit(GpsScreenLifecycleInactive());
  }

  Future<void> manualRefresh() async {
    await _screenManager.manualRefresh();
    if (state is GpsScreenLifecycleActive) {
      final currentState = state as GpsScreenLifecycleActive;
      emit(
        GpsScreenLifecycleActive(
          screenType: currentState.screenType,
          isRefreshActive: _screenManager.isRefreshActive,
        ),
      );
    }
  }

  bool get isRefreshActive => _screenManager.isRefreshActive;
  GpsScreenType? get currentScreenType => _screenManager.currentScreenType;
}
