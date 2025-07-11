import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/model/result.dart';
import '../../../../utils/custom_log.dart';
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

  // Future<void> submitGeofence(GpsGeofenceModel model) async {
  //   emit(GpsGeofenceLoading());
  //   final result = await _repository.addOrUpdateGeofence(model);
  //   if (result is Success<void>) {
  //     await loadGeofences(); // Refresh list on success
  //   } else if (result is Error<void>) {
  //     emit(GpsGeofenceError(result.type.toString()));
  //   }
  // }

  Future<void> loadVehicleGeofences({
    required String userId,
    required String deviceId,
    required String vehicleId,
  }) async {
    try {
      final result = await _repository.fetchGeofencesForVehicle(userId, deviceId);
      if (result is Success<List<GpsGeofenceModel>>) {
        final activeGeofenceIds = result.value.map((g) => g.id).toSet();

        if (state is GpsGeofenceLoaded) {
          final currentState = state as GpsGeofenceLoaded;
          final updatedMap = Map<String, Set<String>>.from(currentState.vehicleGeofenceMap)
            ..[vehicleId] = activeGeofenceIds;

          emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
        }
      } else if (result is Error) {
        CustomLog.error(this, "Failed to load geofences for vehicle", result.toString());
      }
    } catch (e) {
      CustomLog.error(this, "Exception loading vehicle geofences", e);
    }
  }


  // Future<void> toggleGeofenceForVehicle({
  //   required String userId,
  //   required String deviceId,
  //   required String vehicleId,
  //   required String geofenceId,
  //   required bool enable, // true = link, false = unlink
  // }) async {
  //   try {
  //     // Call API
  //     final result = await _repository.linkUnlinkGeofenceDevice(
  //       deviceId,
  //       geofenceId,
  //       enable,
  //     );
  //
  //     if (result is Success<void>) {
  //       if (state is GpsGeofenceLoaded) {
  //         final currentState = state as GpsGeofenceLoaded;
  //
  //         // Create a new copy of the vehicleGeofenceMap
  //         final updatedMap = Map<String, Set<String>>.from(
  //           currentState.vehicleGeofenceMap,
  //         );
  //
  //         // Modify the set in a new copy
  //         final updatedGeofenceIds = Set<String>.from(
  //           updatedMap[vehicleId] ?? {},
  //         );
  //
  //         if (enable) {
  //           updatedGeofenceIds.add(geofenceId);
  //         } else {
  //           updatedGeofenceIds.remove(geofenceId);
  //         }
  //
  //         // Update the map
  //         updatedMap[vehicleId] = updatedGeofenceIds;
  //
  //         // Emit new state
  //         emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
  //       }
  //     } else if (result is Error) {
  //       CustomLog.error(this, "Failed to toggle geofence", result.toString());
  //       // TODO: Show error message or rollback state if optimistic
  //     }
  //   } catch (e) {
  //     CustomLog.error(this, "Exception toggling geofence", e);
  //   }
  // }

  Future<void> submitGeofence(GpsGeofenceModel model) async {
    emit(GpsGeofenceLoading());
    final result = await _repository.addOrUpdateGeofence(model);
    if (result is Success<void>) {
      emit(GpsGeofenceSubmitSuccess()); // ✅ Emit submit success
      await loadGeofences(); // ✅ Refresh list
    } else if (result is Error<void>) {
      emit(GpsGeofenceError(result.type.toString()));
    }
  }

  Future<void> toggleGeofenceForVehicle({
    required String userId,
    required String deviceId,
    required String vehicleId,
    required String geofenceId,
    required bool enable,
  }) async {
    final result = await _repository.linkUnlinkGeofenceDevice(
      deviceId,
      geofenceId,
      enable,
    );

    if (result is Success<void>) {
      // if (state is GpsGeofenceLoaded) {
      //   final currentState = state as GpsGeofenceLoaded;
      //   final updatedMap = Map<String, Set<String>>.from(
      //     currentState.vehicleGeofenceMap,
      //   );
      //
      //   final updatedGeofenceIds = Set<String>.from(
      //     updatedMap[vehicleId] ?? {},
      //   );
      //
      //   if (enable) {
      //     updatedGeofenceIds.add(geofenceId);
      //   } else {
      //     updatedGeofenceIds.remove(geofenceId);
      //   }
      //
      //   updatedMap[vehicleId] = updatedGeofenceIds;
      //
      //   emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
      //   emit(GpsGeofenceToggleSuccess()); // ✅ Emit toggle success
      // }
      if (state is GpsGeofenceLoaded) {
        final currentState = state as GpsGeofenceLoaded;
        final updatedMap = Map<String, Set<String>>.from(
          currentState.vehicleGeofenceMap,
        );

        final updatedGeofenceIds = Set<String>.from(
          updatedMap[vehicleId] ?? {},
        );

        if (enable) {
          updatedGeofenceIds.add(geofenceId);
        } else {
          updatedGeofenceIds.remove(geofenceId);
        }

        updatedMap[vehicleId] = updatedGeofenceIds;

        // ✅ Emit loaded state again with updated map
        emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
      }
    } else if (result is Error) {
      emit(GpsGeofenceError(result.type.toString()));
    }
  }





}
