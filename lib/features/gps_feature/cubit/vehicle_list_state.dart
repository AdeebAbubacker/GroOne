part of 'vehicle_list_cubit.dart';

class VehicleListState {
  final UIState<List<GpsCombinedVehicleData>>? vehicleDataState;
  final List<GpsCombinedVehicleData> filteredVehicles;
  final StatusCount statusCount;
  final VehicleTabType selectedTab;
  final String searchQuery;
  final bool showMapView;
  final bool trafficEnabled;
  final MapType mapType;

  // Dashboard specific state
  final String? selectedVehicleNumber;
  final bool isWeeklyDistanceLoading;
  final List<DistanceData> weeklyDistance;
  final Map<String, dynamic> selectedVehicleDistanceData;

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
    this.trafficEnabled = false,
    this.mapType = MapType.normal,
    this.selectedVehicleNumber,
    this.isWeeklyDistanceLoading = false,
    this.weeklyDistance = const [],
    this.selectedVehicleDistanceData = const {},
  });

  VehicleListState copyWith({
    UIState<List<GpsCombinedVehicleData>>? vehicleDataState,
    List<GpsCombinedVehicleData>? filteredVehicles,
    StatusCount? statusCount,
    VehicleTabType? selectedTab,
    String? searchQuery,
    bool? showMapView,
    bool? trafficEnabled,
    MapType? mapType,
    String? selectedVehicleNumber,
    bool? isWeeklyDistanceLoading,
    List<DistanceData>? weeklyDistance,
    Map<String, dynamic>? selectedVehicleDistanceData,
  }) {
    return VehicleListState(
      vehicleDataState: vehicleDataState ?? this.vehicleDataState,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      statusCount: statusCount ?? this.statusCount,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      showMapView: showMapView ?? this.showMapView,
      trafficEnabled: trafficEnabled ?? this.trafficEnabled,
      mapType: mapType ?? this.mapType,
      selectedVehicleNumber:
          selectedVehicleNumber ?? this.selectedVehicleNumber,
      isWeeklyDistanceLoading:
          isWeeklyDistanceLoading ?? this.isWeeklyDistanceLoading,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      selectedVehicleDistanceData:
          selectedVehicleDistanceData ?? this.selectedVehicleDistanceData,
    );
  }

  bool get isLoading => vehicleDataState?.status == Status.LOADING;
  String? get error => vehicleDataState?.errorType?.toString();

  int get expiringSoonCount =>
      filteredVehicles.where((v) => v.isExpiringSoon == true).length;
}
