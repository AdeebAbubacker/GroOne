import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/models/vehicle_data_response.dart';

class DashboardState {
  final VehicleDataResponse? vehicleData;
  final bool isLoading;
  final String? error;

  DashboardState({this.vehicleData, this.isLoading = false, this.error});

  DashboardState copyWith({
    VehicleDataResponse? vehicleData,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      vehicleData: vehicleData ?? this.vehicleData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    emit(state.copyWith(isLoading: true));

    // Mock data - replace with actual API call later
    final mockData = VehicleDataResponse(
      totalVehicles: '23412',
      activeVehicles: '23412',
      inactiveVehicles: '23412',
      idleCount: 7500,
      ignitionOnCount: 7500,
      ignitionOffCount: 7500,
      totalDistance: '10020',
      todaysDistance: '10020',
      yesterdaysDistance: '10020',
      vehicleNumber: 'RTX42C7098',
    );

    emit(state.copyWith(vehicleData: mockData, isLoading: false));
  }

  void refreshData() {
    _loadInitialData();
  }
}
