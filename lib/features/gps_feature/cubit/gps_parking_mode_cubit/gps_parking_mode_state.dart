import '../../models/gps_parking_model.dart';

abstract class GpsParkingModeState {}

class GpsParkingModeInitial extends GpsParkingModeState {}

class GpsParkingModeLoading extends GpsParkingModeState {}

class GpsParkingModeLoaded extends GpsParkingModeState {
  final List<GpsParkingModeModel> modes;

  GpsParkingModeLoaded(this.modes);
}

class GpsParkingModeError extends GpsParkingModeState {
  final String message;
  GpsParkingModeError(this.message);
}

class GpsParkingModeDeviceActivationError extends GpsParkingModeState {
  final String message;
  GpsParkingModeDeviceActivationError(this.message);
}
