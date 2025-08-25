import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/model/result.dart';
import '../../../../utils/custom_log.dart';
import '../../../../utils/safe_api_caller.dart';
import '../../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../../load_provider/lp_home/model/verify_location.dart';
import '../../models/gps_geofence_model.dart';
import '../../repository/gps_login_repository.dart';
import '../../repository/gps_repository.dart';

part 'gps_geofence_state.dart';

class GpsGeofenceCubit extends Cubit<GpsGeofenceState> {
  final GpsRepository _repository;
  final GpsLoginRepository _loginRepository;
  bool _hasLoadedData = false; // Guard against repeated API calls
  bool _isClosed = false;

  GpsGeofenceCubit(this._repository, this._loginRepository)
    : super(GpsGeofenceInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsGeofenceInitial());
  }

  Future<void> loadGeofences({bool forceRefresh = false}) async {
    if (_isClosed) return;

    if (_hasLoadedData && state is GpsGeofenceLoaded && !forceRefresh) {
      debugPrint("📍 GpsGeofenceCubit.loadGeofences() - Skipping due to cache");
      return;
    }

    if (!_isClosed) {
      emit(GpsGeofenceLoading());
    }

    try {
      if (!forceRefresh) {
        final storedGeofences = await _loginRepository.getStoredGeofences();
        if (_isClosed) return;

        if (storedGeofences.isNotEmpty) {
          debugPrint("📱 Loaded from Realm: ${storedGeofences.length}");
          if (!_isClosed) {
            emit(GpsGeofenceLoaded(storedGeofences));
          }
          _hasLoadedData = true;
          return;
        }
      }

      debugPrint("🌐 Fetching geofences from API...");

      // Use safe API caller with retry mechanism
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.fetchGeofences(),
        operationName: 'fetch_geofences',
        maxRetries: 2,
        timeout: const Duration(seconds: 15),
      );

      if (_isClosed) return;

      if (result is Success<List<GpsGeofenceModel>>) {
        debugPrint("✅ Fetched from API: ${result.value.length}");
        if (!_isClosed) {
          emit(GpsGeofenceLoaded(result.value));
        }
        _hasLoadedData = true;
      } else if (result is Error<List<GpsGeofenceModel>>) {
        debugPrint("❌ API fetch failed");
        if (!_isClosed) {
          emit(GpsGeofenceError(result.type.toString()));
        }
      }
    } catch (e) {
      debugPrint("❌ Error in loadGeofences: $e");
      if (!_isClosed) {
        emit(GpsGeofenceError(e.toString()));
      }
    }
  }

  Future<void> loadVehicleGeofences({
    required String deviceId,
    required String vehicleId,
  }) async {
    if (_isClosed) return;

    try {
      // Use safe API caller for vehicle geofences
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.fetchGeofencesForVehicle(deviceId),
        operationName: 'fetch_vehicle_geofences',
        maxRetries: 2,
        timeout: const Duration(seconds: 15),
      );

      if (_isClosed) return;

      if (result is Success<List<GpsGeofenceModel>>) {
        final activeGeofenceIds = result.value.map((g) => g.id).toSet();

        if (state is GpsGeofenceLoaded) {
          final currentState = state as GpsGeofenceLoaded;
          final updatedMap = Map<String, Set<String>>.from(
            currentState.vehicleGeofenceMap,
          )..[vehicleId] = activeGeofenceIds;

          if (!_isClosed) {
            emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
          }
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
    if (_isClosed) return;

    if (!_isClosed) {
      emit(GpsGeofenceLoading());
    }

    try {
      // Use safe API caller with retry for geofence submission
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.addOrUpdateGeofence(model),
        operationName: 'submit_geofence',
        maxRetries: 3, // More retries for submission
        timeout: const Duration(seconds: 20),
      );

      if (_isClosed) return;

      if (result is Success<void>) {
        if (!_isClosed) {
          emit(GpsGeofenceSubmitSuccess()); // ✅ Emit submit success
        }
        _hasLoadedData = false; // Reset flag to allow refresh
        await loadGeofences(forceRefresh: true); // ✅ Refresh list
      } else if (result is Error<void>) {
        if (!_isClosed) {
          emit(GpsGeofenceError(result.type.toString()));
        }
      }
    } catch (e) {
      debugPrint("❌ Error in submitGeofence: $e");
      if (!_isClosed) {
        emit(GpsGeofenceError("Failed to submit geofence: ${e.toString()}"));
      }
    }
  }

  Future<void> toggleGeofenceForVehicle({
    required String deviceId,
    required String vehicleId,
    required String geofenceId,
    required bool enable,
  }) async {
    try {
      // Use safe API caller for device linking
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () =>
            _repository.linkUnlinkGeofenceDevice(deviceId, geofenceId, enable),
        operationName: 'toggle_geofence_device',
        maxRetries: 2,
        timeout: const Duration(seconds: 15),
      );

      if (_isClosed) return;

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
          if (!_isClosed) {
            emit(currentState.copyWith(vehicleGeofenceMap: updatedMap));
          }
        }
      } else if (result is Error) {
        if (!_isClosed) {
          emit(GpsGeofenceError(result.type.toString()));
        }
      }
    } catch (e) {
      debugPrint("❌ Error in toggleGeofenceForVehicle: $e");
      if (!_isClosed) {
        emit(GpsGeofenceError("Failed to toggle geofence: ${e.toString()}"));
      }
    }
  }

  /// Refresh data - resets the guard flag and reloads
  Future<void> refreshData() async {
    debugPrint("🔄 GpsGeofenceCubit.refreshData() called");
    _hasLoadedData = false; // Reset the guard flag
    await loadGeofences();
  }

  Future<void> fetchAutoComplete(String input) async {
    if (_isClosed) return;

    emit(GpsGeofenceLoading());

    try {
      // Use safe API caller for autocomplete
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.getAutoCompleteData(input),
        operationName: 'fetch_autocomplete',
        maxRetries: 2,
        timeout: const Duration(seconds: 10),
      );

      if (_isClosed) return;

      if (result is Success<AutoCompleteModel>) {
        final predictions = result.value.predictions;
        if (predictions.isNotEmpty) {
          emit(GpsGeofenceAutoCompleteLoaded(result.value));
        } else {
          emit(GpsGeofenceError("No suggestions found."));
        }
      } else if (result is Error<AutoCompleteModel>) {
        final errorType = result.type;
        emit(
          GpsGeofenceError(
            errorType is ErrorWithMessage
                ? errorType.message
                : "Autocomplete failed",
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error in fetchAutoComplete: $e");
      if (!_isClosed) {
        emit(GpsGeofenceError("Autocomplete failed: ${e.toString()}"));
      }
    }
  }

  Future<void> fetchLatLngForPlace(String placeId) async {
    if (_isClosed) return;

    emit(GpsGeofenceLoading());

    try {
      // Use safe API caller for place lookup
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.fetchLatLngFromPlaceId(placeId),
        operationName: 'fetch_latlng_from_place',
        maxRetries: 2,
        timeout: const Duration(seconds: 15),
      );

      if (_isClosed) return;

      if (result is Success<LatLng>) {
        emit(GpsGeofenceLatLngLoaded(result.value));
      } else if (result is Error<LatLng>) {
        final err = result.type;
        emit(
          GpsGeofenceError(
            err is ErrorWithMessage ? err.message : "Failed to get location.",
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error in fetchLatLngForPlace: $e");
      if (!_isClosed) {
        emit(GpsGeofenceError("Failed to get location: ${e.toString()}"));
      }
    }
  }

  void resetAutoCompleteState() {
    if (!_isClosed) {
      emit(GpsGeofenceMapInitial());
    }
  }
}
