import 'package:gro_one_app/features/gps_feature/model/gps_vehicle_extra_info_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';

import '../../../core/reset_cubit_state.dart';
import '../../../data/model/result.dart';
import '../../../data/ui_state/ui_state.dart';
import '../constants/app_constants.dart';

part 'get_vehicle_extra_info_state.dart';

class GpsVehicleExtraInfoCubit extends BaseCubit<GpsVehicleExtraInfoState> {
  final GpsVehicleExtraInfoRepository _repository;
  
  GpsVehicleExtraInfoCubit(this._repository) : super(GpsVehicleExtraInfoState());

  void _setVehicleExtraInfoUIState(UIState<List<GpsVehicleExtraInfo>>? uiState) {
    emit(state.copyWith(gpsVehicleInfoState: uiState));
  }

  Future<void> getVehicleExtraInfo() async {
    _setVehicleExtraInfoUIState(UIState.loading());
    
    try {
      final result = await _repository.getVehicleExtraInfo(AppConstants.token!);
      
      if (result is Success<List<GpsVehicleExtraInfo>>) {
        _setVehicleExtraInfoUIState(UIState.success(result.value));
      }
      if (result is Error) {
        // Try to get data from Realm if API fails
        final offlineResult = await _repository.getVehicleExtraInfoFromRealm();
        if (offlineResult is Success<List<GpsVehicleExtraInfo>>) {
          _setVehicleExtraInfoUIState(UIState.success(offlineResult.value));
        } else {
          _setVehicleExtraInfoUIState(UIState.error(GenericError()));
        }
      }
    } catch (e) {
      _setVehicleExtraInfoUIState(UIState.error(GenericError()));
    }
  }

  // Update device extra info
  Future<void> updateDeviceExtraInfo({
    required String deviceId,
    required Map<String, String> data,
  }) async {
    try {
      final result = await _repository.updateDeviceExtraInfo(
        token: AppConstants.token!,
        deviceId: deviceId,
        data: data,
      );
      
      if (result is Success<bool>) {
        return;
      }
      if (result is Error) {
        throw Exception("Failed to update device info");
      }
    } catch (e) {
      throw Exception("Failed to update device info: $e");
    }
  }
}
