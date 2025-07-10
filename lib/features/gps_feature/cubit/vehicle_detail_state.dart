part of 'vehicle_detail_cubit.dart';

class VehicleDetailState {
  final MapType mapType;
  final bool trafficEnabled;

  const VehicleDetailState({
    this.mapType = MapType.normal,
    this.trafficEnabled = false,
  });

  VehicleDetailState copyWith({MapType? mapType, bool? trafficEnabled}) {
    return VehicleDetailState(
      mapType: mapType ?? this.mapType,
      trafficEnabled: trafficEnabled ?? this.trafficEnabled,
    );
  }
}
