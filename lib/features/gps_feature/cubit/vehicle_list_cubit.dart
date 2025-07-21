import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../repository/gps_login_repository.dart';

part 'vehicle_list_state.dart';

class VehicleListCubit extends BaseCubit<VehicleListState> {
  final GpsLoginRepository _repository;
  List<GpsCombinedVehicleData> _allVehicles = [];
  bool _hasLoadedData = false; // Guard against repeated API calls

  VehicleListCubit({GpsLoginRepository? repository})
    : _repository = repository ?? locator<GpsLoginRepository>(),
      super(VehicleListState());

  /// Test method to verify cubit is working
  void testCubit() {
    emit(state.copyWith(searchQuery: "test"));
  }

  /// Create sample offline data for testing
  Future<void> createSampleOfflineData() async {
    try {
      final sampleVehicles = [
        GpsCombinedVehicleData(
          deviceId: 1,
          vehicleNumber: "MH12AB1234",
          status: "active",
          statusDuration: "2 hours",
          location: "Mumbai, Maharashtra",
          networkSignal: 4,
          hasGPS: true,
          odoReading: "15,000 km",
          todayDistance: "150 km",
          lastSpeed: "45 km/h",
          lastUpdate: DateTime.now(),
        ),
        GpsCombinedVehicleData(
          deviceId: 2,
          vehicleNumber: "DL01CD5678",
          status: "off",
          statusDuration: "1 hour",
          location: "Delhi, NCR",
          networkSignal: 2,
          hasGPS: false,
          odoReading: "25,000 km",
          todayDistance: "0 km",
          lastSpeed: "0 km/h",
          lastUpdate: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        GpsCombinedVehicleData(
          deviceId: 3,
          vehicleNumber: "KA05EF9012",
          status: "idle",
          statusDuration: "30 minutes",
          location: "Bangalore, Karnataka",
          networkSignal: 3,
          hasGPS: true,
          odoReading: "18,500 km",
          todayDistance: "75 km",
          lastSpeed: "0 km/h",
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        GpsCombinedVehicleData(
          deviceId: 4,
          vehicleNumber: "TN07GH3456",
          status: "inactive",
          statusDuration: "5 hours",
          location: "Chennai, Tamil Nadu",
          networkSignal: 1,
          hasGPS: false,
          odoReading: "32,000 km",
          todayDistance: "0 km",
          lastSpeed: "0 km/h",
          lastUpdate: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        GpsCombinedVehicleData(
          deviceId: 5,
          vehicleNumber: "AP09IJ7890",
          status: "active",
          statusDuration: "1 hour",
          location: "Hyderabad, Telangana",
          networkSignal: 4,
          hasGPS: true,
          odoReading: "22,300 km",
          todayDistance: "200 km",
          lastSpeed: "60 km/h",
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ];

      await _repository.saveVehicleData(sampleVehicles);

      // Load the sample data
      _allVehicles = sampleVehicles;
      _setVehicleDataUIState(UIState.success(sampleVehicles));
      _updateStatusCounts();
      _filterVehicles();
    } catch (e) {
      // Handle error silently in production
    }
  }

  /// Load vehicle data from APIs and combine them
  /// Only calls APIs if data hasn't been loaded yet
  Future<void> loadVehicleData() async {
    // Guard against repeated API calls
    if (_hasLoadedData && state.vehicleDataState?.status == Status.SUCCESS) {
      print(
        "📱 VehicleListCubit.loadVehicleData() - Data already loaded, skipping API calls",
      );
      return;
    }

    _setVehicleDataUIState(UIState.loading());

    try {
      // First try to get stored login response to get the token
      final loginResponse = await _repository.getStoredLoginResponse();

      if (loginResponse?.token == null) {
        _setVehicleDataUIState(
          UIState.error(
            ErrorWithMessage(
              message: "No login token found. Please login first.",
            ),
          ),
        );
        return;
      }

      // First try to load from Realm (offline data)
      if (await _repository.hasOfflineData()) {
        print("📱 Loading vehicle data from Realm (offline)...");
        final offlineData = await _repository.getOfflineVehicleData();
        if (offlineData.isNotEmpty) {
          _allVehicles = offlineData;
          _setVehicleDataUIState(UIState.success(offlineData));
          _updateStatusCounts();
          _filterVehicles();
          _hasLoadedData = true;
          _fetchDistanceDataInBackground(loginResponse!.token!,_allVehicles);
          print(
            "✅ Vehicle data loaded from Realm: ${offlineData.length} vehicles",
          );
          return;
        }
      }

      // If no offline data, fetch from API
      print("🌐 No offline data found, fetching from API...");
      final result = await _repository.getAllVehicleData(loginResponse!.token);

      if (result is Success<List<GpsCombinedVehicleData>>) {
        _allVehicles = result.value;
        _setVehicleDataUIState(UIState.success(result.value));
        _updateStatusCounts();
        _filterVehicles();
        _hasLoadedData = true; // Mark as loaded to prevent future API calls

        // Fetch addresses in background for vehicles that don't have them
        _fetchAddressesInBackground(result.value);
        _fetchDistanceDataInBackground(loginResponse.token!,_allVehicles);

        print(
          "✅ Vehicle data fetched from API: ${result.value.length} vehicles",
        );
      } else if (result is Error) {
        _setVehicleDataUIState(UIState.error((result as Error).type));
        print("❌ Failed to fetch vehicle data from API");

        // Create sample data for testing when API fails
        await createSampleOfflineData();
      }
    } catch (e) {
      _setVehicleDataUIState(UIState.error(GenericError()));
      print("❌ Error in loadVehicleData: $e");
    }
  }





  /// Load vehicle data from offline storage only
  Future<void> loadOfflineData() async {
    _setVehicleDataUIState(UIState.loading());

    try {
      final offlineData = await _repository.getOfflineVehicleData();
      _allVehicles = offlineData;
      _setVehicleDataUIState(UIState.success(offlineData));
      _updateStatusCounts();
      _filterVehicles();
    } catch (e) {
      _setVehicleDataUIState(UIState.error(GenericError()));
    }
  }

  /// Select a tab (All, Off, Active, Inactive)
  void selectTab(VehicleTabType tabType) {
    emit(state.copyWith(selectedTab: tabType));
    _filterVehicles();
  }

  /// Search vehicles by vehicle number
  void searchVehicles(String query) {
    emit(state.copyWith(searchQuery: query));
    _filterVehicles();
  }

  /// Refresh data - resets the guard flag and reloads
  Future<void> refreshData() async {
    print("🔄 VehicleListCubit.refreshData() called");
    _hasLoadedData = false; // Reset the guard flag
    await loadVehicleData();
  }

  /// Check if data has been loaded
  bool get hasLoadedData => _hasLoadedData;

  /// Toggle between map and list view
  void toggleMapView(bool showMap) {
    emit(state.copyWith(showMapView: showMap));
  }

  void toggleTraffic() {
    emit(state.copyWith(trafficEnabled: !(state.trafficEnabled)));
  }

  void toggleMapType() {
    emit(
      state.copyWith(
        mapType:
            (state.mapType == MapType.normal
                ? MapType.satellite
                : MapType.normal),
      ),
    );
  }

  void _setVehicleDataUIState(UIState<List<GpsCombinedVehicleData>>? uiState) {
    emit(state.copyWith(vehicleDataState: uiState));
  }

  void _updateStatusCounts() {
    if (_allVehicles.isNotEmpty && _allVehicles.first.apiCounts != null) {
      final apiCounts = _allVehicles.first.apiCounts!;
      emit(
        state.copyWith(
          statusCount: StatusCount(
            total: apiCounts.total ?? 0,
            ignitionOn: apiCounts.ignitionOn ?? 0,
            ignitionOff: apiCounts.ignitionOff ?? 0,
            idle: apiCounts.idle ?? 0,
            inactive: apiCounts.inactive ?? 0,
          ),
        ),
      );
    } else {
      int ignitionOnCount = 0;
      int ignitionOffCount = 0;
      int idleCount = 0;
      int inactiveCount = 0;

      for (final vehicle in _allVehicles) {
        final status = vehicle.status?.toUpperCase();
        if (status == 'IGNITION_ON') {
          ignitionOnCount++;
        } else if (status == 'IGNITION_OFF') {
          ignitionOffCount++;
        } else if (status == 'IDLE') {
          idleCount++;
        } else if (status == 'INACTIVE') {
          inactiveCount++;
        }
      }

      emit(
        state.copyWith(
          statusCount: StatusCount(
            total: _allVehicles.length,
            ignitionOn: ignitionOnCount,
            ignitionOff: ignitionOffCount,
            idle: idleCount,
            inactive: inactiveCount,
          ),
        ),
      );
    }
  }

  void _filterVehicles() {
    List<GpsCombinedVehicleData> filtered = _allVehicles;

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered =
          filtered.where((vehicle) {
            return vehicle.vehicleNumber?.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ) ??
                false;
          }).toList();
    }

    // Apply tab filter
    switch (state.selectedTab) {
      case VehicleTabType.Total:
        break;
      case VehicleTabType.IgnitionON:
        filtered =
            filtered
                .where(
                  (vehicle) => vehicle.status?.toUpperCase() == 'IGNITION_ON',
                )
                .toList();
        break;
      case VehicleTabType.IgnitionOFF:
        filtered =
            filtered
                .where(
                  (vehicle) => vehicle.status?.toUpperCase() == 'IGNITION_OFF',
                )
                .toList();
        break;
      case VehicleTabType.Idle:
        filtered =
            filtered
                .where((vehicle) => vehicle.status?.toUpperCase() == 'IDLE')
                .toList();
        break;
      case VehicleTabType.Inactive:
        filtered =
            filtered
                .where((vehicle) => vehicle.status?.toUpperCase() == 'INACTIVE')
                .toList();
        break;
    }

    emit(state.copyWith(filteredVehicles: filtered));
  }

  /// Fetch addresses in background for vehicles that don't have them
  void _fetchAddressesInBackground(List<GpsCombinedVehicleData> vehicles) {
    // Run in background without blocking the UI
    Future.microtask(() async {
      try {
        await _repository.fetchAndUpdateAddresses(vehicles);

        // Reload data from realm to get updated addresses
        final updatedVehicles = await _repository.getOfflineVehicleData();
        if (updatedVehicles.isNotEmpty) {
          _allVehicles = updatedVehicles;
          _filterVehicles();
        }
      } catch (e) {
        // Silently handle errors in background
        print("Background address fetch error: $e");
      }
    });
  }

  /// Fetch distance data in background
  void _fetchDistanceDataInBackground(String token, List<GpsCombinedVehicleData> vehicles) {
    // Run in background without blocking the UI
    Future.microtask(() async {
      try {
        await _repository.fetchAndStoreDistanceData(token, vehicles);
        print("✅ Distance data fetched and stored successfully");
      } catch (e) {
        // Silently handle errors in background
        print("Background distance fetch error: $e");
      }
    });
  }

  /// Get distance data for dashboard for a specific vehicle
  Future<Map<String, dynamic>> getDistanceDataForDashboard({String? selectedVehicleNumber}) async {
    try {
      final distanceData = await _repository.getAllDistanceReportData();
      final deviceDistances = <String, Map<String, dynamic>>{};
      
      for (final data in distanceData) {
        final deviceId = data.deviceId;
        
        if (!deviceDistances.containsKey(deviceId)) {
          final monthlyDistance = _repository.getMonthlyDistance(deviceId);
          final weeklyDistance = _repository.getWeeklyDistance(deviceId);
          final weekList = _repository.getWeekDistanceList(deviceId, data.deviceName);
          
          deviceDistances[deviceId] = {
            'deviceName': data.deviceName,
            'monthlyDistance': monthlyDistance,
            'weeklyDistance': weeklyDistance,
            'weekList': weekList,
          };
        }
      }
      
      // Get data for selected vehicle if provided
      Map<String, dynamic> selectedVehicleData = {};
      if (selectedVehicleNumber != null) {
        // Find the vehicle in the current list
        final selectedVehicle = _allVehicles.firstWhere(
          (v) => v.vehicleNumber == selectedVehicleNumber,
          orElse: () => _allVehicles.first,
        );
        
        if (selectedVehicle.deviceId != null) {
          final deviceId = selectedVehicle.deviceId.toString();
          final monthlyDistance = _repository.getMonthlyDistance(deviceId);
          final weeklyDistance = _repository.getWeeklyDistance(deviceId);
          final weekList = _repository.getWeekDistanceList(deviceId, selectedVehicle.vehicleNumber);
          
          selectedVehicleData = {
            'deviceId': deviceId,
            'vehicleNumber': selectedVehicle.vehicleNumber,
            'monthlyDistance': monthlyDistance,
            'weeklyDistance': weeklyDistance,
            'weekList': weekList,
          };
        }
      }
      
      return {
        'deviceDistances': deviceDistances,
        'distanceData': distanceData,
        'selectedVehicleData': selectedVehicleData,
      };
    } catch (e) {
      print("❌ Error getting distance data for dashboard: $e");
      return {
        'deviceDistances': {},
        'distanceData': [],
        'selectedVehicleData': {},
      };
    }
  }
}

enum VehicleTabType { Total, IgnitionON, IgnitionOFF, Idle, Inactive }

class StatusCount {
  final int total;
  final int ignitionOn;
  final int ignitionOff;
  final int idle;
  final int inactive;

  const StatusCount({
    required this.total,
    required this.ignitionOn,
    required this.ignitionOff,
    required this.idle,
    required this.inactive,
  });
}
