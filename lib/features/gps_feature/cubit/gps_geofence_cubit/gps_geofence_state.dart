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

  const GpsGeofenceLoaded(this.geofences);

  @override
  List<Object?> get props => [geofences];
}

class GpsGeofenceError extends GpsGeofenceState {
  final String message;

  const GpsGeofenceError(this.message);

  @override
  List<Object?> get props => [message];
}
