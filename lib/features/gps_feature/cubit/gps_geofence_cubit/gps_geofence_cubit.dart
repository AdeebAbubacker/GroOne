import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/result.dart';
import '../../../../utils/custom_log.dart';
import '../../models/gps_geofence_model.dart';
import '../../repository/gps_login_repository.dart';
import '../../repository/gps_repository.dart';

part 'gps_geofence_state.dart';

class GpsGeofenceCubit extends Cubit<GpsGeofenceState> {
  final GpsRepository _repository;
  final GpsLoginRepository _loginRepository;
  bool _hasLoadedData = false; // Guard against repeated API calls

  GpsGeofenceCubit(this._repository, this._loginRepository)
    : super(GpsGeofenceInitial());

  Future<void> loadGeofences() async {
    // Guard against repeated API calls
    if (_hasLoadedData && state is GpsGeofenceLoaded) {
      print(
        "📍 GpsGeofenceCubit.loadGeofences() - Data already loaded, skipping API calls",
      );
      return;
    }

    emit(GpsGeofenceLoading());

    try {
      // First try to load from Realm (offline data)
      final storedGeofences = await _loginRepository.getStoredGeofences();
      if (storedGeofences.isNotEmpty) {
        print(
          "📱 Loading geofences from Realm (offline): ${storedGeofences.length} geofences",
        );
        emit(GpsGeofenceLoaded(storedGeofences));
        _hasLoadedData = true; // Mark as loaded to prevent future API calls
        return;
      }

      // If no offline data, fetch from API
      print("🌐 No offline geofences found, fetching from API...");
      final result = await _repository.fetchGeofences();
      if (result is Success<List<GpsGeofenceModel>>) {
        print("✅ Geofences fetched from API: ${result.value.length} geofences");
        emit(GpsGeofenceLoaded(result.value));
        _hasLoadedData = true; // Mark as loaded to prevent future API calls
      } else if (result is Error<List<GpsGeofenceModel>>) {
        print("❌ Failed to fetch geofences from API");
        emit(GpsGeofenceError(result.type.toString()));
      }
    } catch (e) {
      print("❌ Error in loadGeofences: $e");
      emit(GpsGeofenceError(e.toString()));
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
      final result = await _repository.fetchGeofencesForVehicle(
        userId,
        deviceId,
      );
      if (result is Success<List<GpsGeofenceModel>>) {
        final activeGeofenceIds = result.value.map((g) => g.id).toSet();

        if (state is GpsGeofenceLoaded) {
          final currentState = state as GpsGeofenceLoaded;
          final updatedMap = Map<String, Set<String>>.from(
            currentState.vehicleGeofenceMap,
          )..[vehicleId] = activeGeofenceIds;

          emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
        }
      } else if (result is Error) {
        CustomLog.error(
          this,
          "Failed to load geofences for vehicle",
          result.toString(),
        );
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
      _hasLoadedData = false; // Reset flag to allow refresh
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

  /// Refresh data - resets the guard flag and reloads
  Future<void> refreshData() async {
    print("🔄 GpsGeofenceCubit.refreshData() called");
    _hasLoadedData = false; // Reset the guard flag
    await loadGeofences();
  }
}
