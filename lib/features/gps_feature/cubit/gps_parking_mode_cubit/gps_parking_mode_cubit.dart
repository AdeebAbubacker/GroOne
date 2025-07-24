import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../models/gps_parking_model.dart';
import '../../repository/gps_repository.dart';
import 'gps_parking_mode_state.dart';

class GpsParkingModeCubit extends Cubit<GpsParkingModeState> {
  final GpsRepository _repository;

  GpsParkingModeCubit(this._repository) : super(GpsParkingModeInitial());

  Future<void> loadParkingModes() async {
    emit(GpsParkingModeLoading());

    final result = await _repository.fetchParkingModes();

    if (result is Success<List<GpsParkingModeModel>>) {
      emit(GpsParkingModeLoaded(result.value));
    } else if (result is Error<List<GpsParkingModeModel>>) {
      emit(GpsParkingModeError(result.type.toString()));
    }
  }

  Future<void> toggleParkingMode(GpsParkingModeModel model, bool newValue) async {
    final currentState = state;

    if (currentState is GpsParkingModeLoaded) {
      // Optimistic UI
      final updatedList = currentState.modes.map((e) {
        return e.deviceId == model.deviceId
            ? e.copyWith(parkingMode: newValue)
            : e;
      }).toList();
      emit(GpsParkingModeLoaded(updatedList));

      final result = await _repository.updateParkingMode(
        id: model.id == -1 ? null : model.id,
        deviceId: model.deviceId,
        parkingMode: newValue,
      );

      if (result is Success<GpsParkingModeModel>) {
        final refreshedList = updatedList.map((e) {
          return e.deviceId == result.value.deviceId ? result.value : e;
        }).toList();
        emit(GpsParkingModeLoaded(refreshedList));
      } else {
        // Revert on failure
        final revertedList = currentState.modes.map((e) {
          return e.deviceId == model.deviceId ? model : e;
        }).toList();
        emit(GpsParkingModeLoaded(revertedList));
        // Optional: show error
      }
    }
  }

  Future<Result<void>> updateParkingSchedule({
    required int id,
    required int deviceId,
    required bool parkingSchedule,
    required String parkingScheduleStartUtc,
    required String parkingScheduleEndUtc,
    required List<String> parkingScheduleDays,
  }) async {
    return await _repository.updateParkingModeSchedule(
      id: id,
      deviceId: deviceId,
      parkingSchedule: parkingSchedule,
      parkingScheduleStartUtc: parkingScheduleStartUtc,
      parkingScheduleEndUtc: parkingScheduleEndUtc,
      parkingScheduleDays: parkingScheduleDays,
    );
  }



}
