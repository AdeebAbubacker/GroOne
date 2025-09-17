import 'package:gro_one_app/features/gps_feature/model/gps_info_window_details_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';

import '../../../core/reset_cubit_state.dart';
import '../../../data/model/result.dart';
import '../../../data/ui_state/ui_state.dart';
import '../constants/app_constants.dart';

part 'gps_info_window_details_state.dart';

class GpsInfoWindowDetailsCubit extends BaseCubit<GpsInfoWindowDetailsState> {
  final GpsVehicleExtraInfoRepository _repository;

  GpsInfoWindowDetailsCubit(this._repository)
    : super(GpsInfoWindowDetailsState());

  void _setInfoWindowDetailsUIState(UIState<GpsInfoWindowDetails>? uiState) {
    if (!isClosed) {
      emit(state.copyWith(infoWindowDetailsState: uiState));
    }
  }

  Future<void> getInfoWindowDetails(String deviceId) async {
    if (isClosed) return;

    _setInfoWindowDetailsUIState(UIState.loading());

    try {
      final result = await _repository.getInfoWindowDetails(
        token: AppConstants.token ?? '',
        deviceId: deviceId,
      );

      if (isClosed) return;

      if (result is Success<GpsInfoWindowDetails>) {
        _setInfoWindowDetailsUIState(UIState.success(result.value));
      } else {
        _setInfoWindowDetailsUIState(UIState.error(GenericError()));
      }
    } catch (e) {
      if (!isClosed) {
        _setInfoWindowDetailsUIState(UIState.error(GenericError()));
      }
    }
  }

  void resetState() {
    if (!isClosed) {
      emit(GpsInfoWindowDetailsState());
    }
  }
}
