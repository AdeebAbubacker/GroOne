import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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


  Future<void> loadGeofences({bool forceRefresh = false}) async {
    if (_hasLoadedData && state is GpsGeofenceLoaded && !forceRefresh) {
      debugPrint("📍 GpsGeofenceCubit.loadGeofences() - Skipping due to cache");
      return;
    }

    emit(GpsGeofenceLoading());

    try {
      if (!forceRefresh) {
        final storedGeofences = await _loginRepository.getStoredGeofences();
        if (storedGeofences.isNotEmpty) {
          debugPrint("📱 Loaded from Realm: ${storedGeofences.length}");
          emit(GpsGeofenceLoaded(storedGeofences));
          _hasLoadedData = true;
          return;
        }
      }

      debugPrint("🌐 Fetching geofences from API...");
      final result = await _repository.fetchGeofences();
      if (result is Success<List<GpsGeofenceModel>>) {
        debugPrint("✅ Fetched from API: ${result.value.length}");
        emit(GpsGeofenceLoaded(result.value));
        _hasLoadedData = true;
      } else if (result is Error<List<GpsGeofenceModel>>) {
        debugPrint("❌ API fetch failed");
        emit(GpsGeofenceError(result.type.toString()));
      }
    } catch (e) {
      debugPrint("❌ Error in loadGeofences: $e");
      emit(GpsGeofenceError(e.toString()));
    }
  }


  Future<void> loadVehicleGeofences({
    required String deviceId,
    required String vehicleId,
  }) async {
    try {
      final result = await _repository.fetchGeofencesForVehicle(
        deviceId
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


  Future<void> submitGeofence(GpsGeofenceModel model) async {
    emit(GpsGeofenceLoading());
    final result = await _repository.addOrUpdateGeofence(model);
    if (result is Success<void>) {
      emit(GpsGeofenceSubmitSuccess()); // ✅ Emit submit success
      _hasLoadedData = false; // Reset flag to allow refresh
      await loadGeofences(forceRefresh: true); // ✅ Refresh list
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
    debugPrint("🔄 GpsGeofenceCubit.refreshData() called");
    _hasLoadedData = false; // Reset the guard flag
    await loadGeofences(forceRefresh: true);
  }
}
