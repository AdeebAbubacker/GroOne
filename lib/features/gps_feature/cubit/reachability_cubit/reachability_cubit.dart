import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/model/result.dart';
import '../../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../../model/gps_combined_vehicle_model.dart';
import '../../models/gps_geofence_model.dart';
import '../../models/reachability_model.dart';
import '../../repository/gps_login_repository.dart';
import '../../service/reachability_service.dart';

part 'reachability_state.dart';

class ReachabilityCubit extends Cubit<ReachabilityState> {
  final ReachabilityService _service;
  final GpsLoginRepository _loginRepository;
  final GpsGeofenceCubit _geofenceCubit;

  ReachabilityCubit({
    required ReachabilityService service,
    required GpsLoginRepository loginRepository,
    required GpsGeofenceCubit geofenceCubit,
  }) : _service = service,
       _loginRepository = loginRepository,
       _geofenceCubit = geofenceCubit,
       super(ReachabilityState());

  /// Initialize the reachability screen with vehicles and geofences
  Future<void> initialize() async {
    if (isClosed) return; // Check if cubit is closed

    emit(state.copyWith(isLoading: true));

    try {
      // Load vehicles
      final vehiclesResult = await _loginRepository.getAllVehicleData();
      List<GpsCombinedVehicleData> vehicles = [];

      if (vehiclesResult is Success<List<GpsCombinedVehicleData>>) {
        vehicles = vehiclesResult.value;
      }

      if (isClosed) return; // Check again after async operation

      // Load geofences
      await _geofenceCubit.loadGeofences();
      final geofences =
          _geofenceCubit.state is GpsGeofenceLoaded
              ? (_geofenceCubit.state as GpsGeofenceLoaded).geofences
              : <GpsGeofenceModel>[];

      if (isClosed) return; // Check again after async operation

      // Convert geofences to reachability geofences
      final reachabilityGeofences =
          geofences.map((geofence) {
            return ReachabilityGeofence(
              id: geofence.id,
              name: geofence.name,
              address: geofence.name, // Use name as address fallback
              latitude: geofence.center?.latitude,
              longitude: geofence.center?.longitude,
              radius: geofence.radius,
              shapeType: geofence.shapeType,
            );
          }).toList();

      if (isClosed) return; // Check before final emit

      emit(
        state.copyWith(
          isLoading: false,
          vehicles: vehicles,
          geofences: reachabilityGeofences,
          selectedVehicle: vehicles.isNotEmpty ? vehicles.first : null,
        ),
      );
    } catch (e) {
      if (isClosed) return; // Check before error emit
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Select a vehicle
  void selectVehicle(GpsCombinedVehicleData? vehicle) {
    if (isClosed) return;
    emit(state.copyWith(selectedVehicle: vehicle));
  }

  /// Set location method
  void setLocationMethod(LocationMethod method) {
    if (isClosed) return;
    emit(state.copyWith(locationMethod: method));
  }

  /// Set location address
  void setLocationAddress(String address) {
    if (isClosed) return;
    emit(state.copyWith(locationAddress: address));
  }

  /// Set radius
  void setRadius(double radius) {
    if (isClosed) return;
    emit(state.copyWith(radius: radius));
  }

  /// Select a geofence
  void selectGeofence(ReachabilityGeofence? geofence) {
    if (isClosed) return;
    emit(state.copyWith(selectedGeofence: geofence));
  }

  /// Set selected date
  void setSelectedDate(DateTime? date) {
    if (isClosed) return;
    emit(state.copyWith(selectedDate: date));
  }

  /// Set selected start time
  void setSelectedStartTime(DateTime? time) {
    if (isClosed) return;
    emit(state.copyWith(selectedStartTime: time));
  }

  /// Set selected end time
  void setSelectedEndTime(DateTime? time) {
    if (isClosed) return;
    emit(state.copyWith(selectedEndTime: time));
  }

  /// Toggle notification method
  void toggleNotificationMethod(NotificationMethod method) {
    if (isClosed) return;

    final currentMethods = List<NotificationMethod>.from(
      state.notificationMethods,
    );

    if (currentMethods.contains(method)) {
      currentMethods.remove(method);
    } else {
      currentMethods.add(method);
    }

    emit(state.copyWith(notificationMethods: currentMethods));
  }

  /// Set map center for location selection
  void setMapCenter(LatLng center) {
    if (isClosed) return;
    emit(state.copyWith(mapCenter: center));
  }

  /// Create reachability configuration
  Future<void> createReachabilityConfig() async {
    if (isClosed) return; // Check if cubit is closed

    if (state.selectedVehicle == null) {
      if (isClosed) return;
      emit(state.copyWith(error: 'Please select a vehicle'));
      return;
    }

    if (state.locationMethod == LocationMethod.newLocation) {
      if (state.locationAddress?.isEmpty ?? true) {
        if (isClosed) return;
        emit(state.copyWith(error: 'Please enter a location address'));
        return;
      }
      if (state.radius == null || state.radius! <= 0) {
        if (isClosed) return;
        emit(state.copyWith(error: 'Please enter a valid radius'));
        return;
      }
      if (state.mapCenter == null) {
        if (isClosed) return;
        emit(state.copyWith(error: 'Please select a location on the map'));
        return;
      }
    } else {
      if (state.selectedGeofence == null) {
        if (isClosed) return;
        emit(state.copyWith(error: 'Please select a geofence'));
        return;
      }
    }

    if (state.notificationMethods.isEmpty) {
      if (isClosed) return;
      emit(
        state.copyWith(error: 'Please select at least one notification method'),
      );
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(isCreating: true, error: null));

    try {
      final config = ReachabilityConfig(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        vehicleId: state.selectedVehicle!.deviceId.toString(),
        vehicleNumber: state.selectedVehicle!.vehicleNumber ?? '',
        locationMethod: state.locationMethod,
        locationAddress:
            state.locationMethod == LocationMethod.newLocation
                ? state.locationAddress
                : state.selectedGeofence?.address,
        latitude:
            state.locationMethod == LocationMethod.newLocation
                ? state.mapCenter?.latitude
                : state.selectedGeofence?.latitude,
        longitude:
            state.locationMethod == LocationMethod.newLocation
                ? state.mapCenter?.longitude
                : state.selectedGeofence?.longitude,
        radius:
            state.locationMethod == LocationMethod.newLocation
                ? state.radius
                : state.selectedGeofence?.radius,
        geofenceId:
            state.locationMethod == LocationMethod.existingGeofence
                ? state.selectedGeofence?.id
                : null,
        geofenceName:
            state.locationMethod == LocationMethod.existingGeofence
                ? state.selectedGeofence?.name
                : null,
        selectedDate: state.selectedDate,
        selectedTime: state.selectedStartTime,
        notificationMethods: state.notificationMethods,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _service.createReachabilityConfig(config);

      if (isClosed) return; // Check after async operation

      if (result is Success) {
        emit(state.copyWith(isCreating: false, isSuccess: true, error: null));
      } else {
        final errorMessage =
            result is Error
                ? 'Failed to create reachability configuration: ${result.toString()}'
                : 'Failed to create reachability configuration';
        emit(state.copyWith(isCreating: false, error: errorMessage));
      }
    } catch (e) {
      if (isClosed) return; // Check before error emit
      emit(state.copyWith(isCreating: false, error: e.toString()));
    }
  }

  /// Reset the form
  void resetForm() {
    if (isClosed) return;
    emit(ReachabilityState());
  }

  /// Clear error
  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(error: null));
  }
}
