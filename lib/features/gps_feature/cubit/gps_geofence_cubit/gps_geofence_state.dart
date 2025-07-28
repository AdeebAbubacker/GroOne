part of 'gps_geofence_cubit.dart';

abstract class GpsGeofenceState extends Equatable {
  const GpsGeofenceState();
  @override
  List<Object?> get props => [];
}

class GpsGeofenceInitial extends GpsGeofenceState {}

class GpsGeofenceLoading extends GpsGeofenceState {}

class GpsGeofenceLoaded extends GpsGeofenceState {
  final List<GpsGeofenceModel> geofences;
  final Map<String, Set<String>> vehicleGeofenceMap;

  const GpsGeofenceLoaded(
      this.geofences, {
        this.vehicleGeofenceMap = const {},
      });

  GpsGeofenceLoaded copyWith({
    List<GpsGeofenceModel>? geofences,
    Map<String, Set<String>>? vehicleGeofenceMap,
  }) {
    return GpsGeofenceLoaded(
      geofences ?? this.geofences,
      vehicleGeofenceMap: vehicleGeofenceMap ?? this.vehicleGeofenceMap,
    );
  }

  @override
  List<Object?> get props => [geofences, vehicleGeofenceMap];
}

class GpsGeofenceSubmitSuccess extends GpsGeofenceState {}

class GpsGeofenceToggleSuccess extends GpsGeofenceState {}

class GpsGeofenceError extends GpsGeofenceState {
  final String message;
  const GpsGeofenceError(this.message);

  @override
  List<Object?> get props => [message];
}

class GpsGeofenceLatLngLoaded extends GpsGeofenceState {
  final LatLng location;
  const GpsGeofenceLatLngLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class GpsGeofenceAutoCompleteLoaded extends GpsGeofenceState {
  final AutoCompleteModel autoCompleteData;

  const GpsGeofenceAutoCompleteLoaded(this.autoCompleteData);

  @override
  List<Object?> get props => [autoCompleteData];
}

class GpsGeofenceVerifyLocationLoaded extends GpsGeofenceState {
  final VerifyLocationModel verifyLocationData;

  const GpsGeofenceVerifyLocationLoaded(this.verifyLocationData);

  @override
  List<Object?> get props => [verifyLocationData];
}

class GpsGeofenceMapInitial extends GpsGeofenceState {}

class GpsGeofenceMapLoading extends GpsGeofenceState {}
