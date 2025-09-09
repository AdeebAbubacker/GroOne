part of 'vp_home_cubit.dart';

class VpsHomeState extends Equatable {
  final UIState<DriverListResponse>? driverUIState;
  final UIState<VehicleListResponse>? vehicleUIState;

  const VpsHomeState({
    this.driverUIState,
    this.vehicleUIState,
  });

  VpsHomeState copyWith({
    UIState<DriverListResponse>? driverUIState,
    UIState<VehicleListResponse>? vehicleUIState,
  }) {
    return VpsHomeState(
      driverUIState: driverUIState ?? this.driverUIState,
      vehicleUIState: vehicleUIState ?? this.vehicleUIState,
    );
  }

  @override
  List<Object?> get props => [
        driverUIState,
        vehicleUIState,
      ];
}
