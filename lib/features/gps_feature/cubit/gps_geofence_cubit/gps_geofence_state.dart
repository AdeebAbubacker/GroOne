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


// abstract class GpsGeofenceState extends Equatable {
//   const GpsGeofenceState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class GpsGeofenceInitial extends GpsGeofenceState {}
//
// class GpsGeofenceLoading extends GpsGeofenceState {}
//
// class GpsGeofenceLoaded extends GpsGeofenceState {
//   final List<GpsGeofenceModel> geofences;
//   final Map<String, Set<String>> vehicleGeofenceMap;
//   // Map<vehicleId, Set<enabledGeofenceIds>>
//
//   const GpsGeofenceLoaded(
//       this.geofences, {
//         this.vehicleGeofenceMap = const {},
//       });
//
//   GpsGeofenceLoaded copyWith({
//     List<GpsGeofenceModel>? geofences,
//     Map<String, Set<String>>? vehicleGeofenceMap,
//   }) {
//     return GpsGeofenceLoaded(
//       geofences ?? this.geofences,
//       vehicleGeofenceMap: vehicleGeofenceMap ?? this.vehicleGeofenceMap,
//     );
//   }
//
//   @override
//   List<Object?> get props => [geofences, vehicleGeofenceMap];
// }
//
// class GpsGeofenceError extends GpsGeofenceState {
//   final String message;
//
//   const GpsGeofenceError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
