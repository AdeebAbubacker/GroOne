import 'package:equatable/equatable.dart';
import '../../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../../load_provider/lp_home/model/verify_location.dart';

abstract class GpsGeofenceMapState extends Equatable {
  const GpsGeofenceMapState();

  @override
  List<Object?> get props => [];
}

class GpsGeofenceMapInitial extends GpsGeofenceMapState {}

class GpsGeofenceMapLoading extends GpsGeofenceMapState {}

class GpsGeofenceMapAutoCompleteLoaded extends GpsGeofenceMapState {
  final AutoCompleteModel autoCompleteData;

  const GpsGeofenceMapAutoCompleteLoaded(this.autoCompleteData);

  @override
  List<Object?> get props => [autoCompleteData];
}

class GpsGeofenceMapVerifyLocationLoaded extends GpsGeofenceMapState {
  final VerifyLocationModel verifyLocationData;

  const GpsGeofenceMapVerifyLocationLoaded(this.verifyLocationData);

  @override
  List<Object?> get props => [verifyLocationData];
}

class GpsGeofenceMapError extends GpsGeofenceMapState {
  final String message;

  const GpsGeofenceMapError(this.message);

  @override
  List<Object?> get props => [message];
}
