import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/model/result.dart';
import '../../models/gps_geofence_model.dart';
import '../../repository/gps_repository.dart';

part 'gps_geofence_state.dart';

class GpsGeofenceCubit extends Cubit<GpsGeofenceState> {
  final GpsRepository _repository;

  GpsGeofenceCubit(this._repository) : super(GpsGeofenceInitial());

  Future<void> loadGeofences() async {
    emit(GpsGeofenceLoading());
    final result = await _repository.fetchGeofences();
    if (result is Success<List<GpsGeofenceModel>>) {
      emit(GpsGeofenceLoaded(result.value));
    } else if (result is Error<List<GpsGeofenceModel>>) {
      emit(GpsGeofenceError(result.type.toString()));
    }
  }

  Future<void> submitGeofence(GpsGeofenceModel model) async {
    emit(GpsGeofenceLoading());
    final result = await _repository.addOrUpdateGeofence(model);
    if (result is Success<void>) {
      await loadGeofences(); // Refresh list on success
    } else if (result is Error<void>) {
      emit(GpsGeofenceError(result.type.toString()));
    }
  }

}
