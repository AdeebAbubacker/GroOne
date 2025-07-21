part of 'get_vehicle_extra_info_cubit.dart';

class GpsVehicleExtraInfoState {
  final UIState<List<GpsVehicleExtraInfo>>? gpsVehicleInfoState;

  GpsVehicleExtraInfoState({this.gpsVehicleInfoState});

  GpsVehicleExtraInfoState copyWith({
    UIState<List<GpsVehicleExtraInfo>>? gpsVehicleInfoState,
  }) {
    return GpsVehicleExtraInfoState(
      gpsVehicleInfoState: gpsVehicleInfoState,
    );
  }
}