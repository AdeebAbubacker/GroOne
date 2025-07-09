part of 'vehicle_list_cubit.dart';

class VehicleListState {
  final UIState<List<GpsCombinedVehicleData>>? vehicleDataState;
  final List<GpsCombinedVehicleData> filteredVehicles;
  final StatusCount statusCount;
  final VehicleTabType selectedTab;
  final String searchQuery;
  final bool showMapView;

  VehicleListState({
    this.vehicleDataState,
    this.filteredVehicles = const [],
    this.statusCount = const StatusCount(
      total: 0,
      ignitionOn: 0,
      ignitionOff: 0,
      idle: 0,
      inactive: 0,
    ),
    this.selectedTab = VehicleTabType.Total,
    this.searchQuery = '',
    this.showMapView = false,
  });

  VehicleListState copyWith({
    UIState<List<GpsCombinedVehicleData>>? vehicleDataState,
    List<GpsCombinedVehicleData>? filteredVehicles,
    StatusCount? statusCount,
    VehicleTabType? selectedTab,
    String? searchQuery,
    bool? showMapView,
  }) {
    return VehicleListState(
      vehicleDataState: vehicleDataState ?? this.vehicleDataState,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      statusCount: statusCount ?? this.statusCount,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      showMapView: showMapView ?? this.showMapView,
    );
  }

  bool get isLoading => vehicleDataState?.status == Status.LOADING;
  String? get error => vehicleDataState?.errorType?.toString();

  int get expiringSoonCount =>
      filteredVehicles.where((v) => v.isExpiringSoon == true).length;
}
