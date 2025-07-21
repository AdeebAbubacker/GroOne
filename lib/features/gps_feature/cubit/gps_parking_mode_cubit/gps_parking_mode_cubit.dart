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
    emit(GpsParkingModeLoading());

    final result = await _repository.updateParkingMode(
      deviceId: model.deviceId,
      parkingMode: newValue,
    );

    if (result is Success<void>) {
      if (currentState is GpsParkingModeLoaded) {
        final updatedList = currentState.modes.map((e) {
          if (e.deviceId == model.deviceId) {
            return GpsParkingModeModel(
              id: e.id,
              deviceId: e.deviceId,
              parkingMode: newValue,
            );
          }
          return e;
        }).toList();
        emit(GpsParkingModeLoaded(updatedList));
      } else {
        await loadParkingModes(); // fallback reload
      }
    } else {
      emit(GpsParkingModeError("Failed to update parking mode"));
    }
  }

}
