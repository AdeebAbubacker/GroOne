// lib/features/gps_feature/cubit/report_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/address_model.dart';
import '../repository/report_repository.dart';
import '../service/report_service.dart';

part 'report_state.dart'; // Connects to the state file

class GpsReportCubit extends Cubit<GpsReportState> {
  final GpsReportRepository _repository;
  final GpsReportService _reportService;

  GpsReportCubit({
    GpsReportRepository? repository,
    GpsReportService? reportService,
  })  : _repository = repository ?? locator<GpsReportRepository>(),
        _reportService = reportService ?? locator<GpsReportService>(),
        super(GpsReportState());

  // Date selection methods
  void updateFromDate(DateTime date) {
    emit(state.copyWith(
      fromDate: DateTime(date.year, date.month, date.day, 0, 0, 0, 0),
    ));
  }

  void updateToDate(DateTime date) {
    emit(state.copyWith(
      toDate: DateTime(date.year, date.month, date.day, 23, 59, 59, 999),
    ));
  }

  // Date picker methods - handles UI logic in cubit
  Future<void> pickFromDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: state.fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDate != null) {
      updateFromDate(newDate);
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: state.toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDate != null) {
      updateToDate(newDate);
    }
  }



  // Vehicle selection method
  void selectVehicle(GpsCombinedVehicleData vehicle) {
    emit(state.copyWith(selectedVehicle: vehicle));
  }

  // Report type selection method
  void selectReportType(ReportType reportType) {
    emit(state.copyWith(selectedReportType: reportType));
  }

  // Auto-select first vehicle when vehicles are loaded
  void _autoSelectFirstVehicle() {
    if (state.vehicles.isNotEmpty && state.selectedVehicle == null) {
      emit(state.copyWith(selectedVehicle: state.vehicles.first));
    }
  }

  // This method will be called once when the screen is first loaded.
  // Its job is to fetch the list of vehicles for the dropdown.
  Future<void> loadInitialData() async {
    emit(state.copyWith(vehicleStatus: GpsDataStatus.loading));
    final result = await _repository.getVehicles();

    if (result is Success<List<GpsCombinedVehicleData>>) {
      emit(state.copyWith(
        vehicleStatus: GpsDataStatus.success,
        vehicles: result.value,
      ));
      _autoSelectFirstVehicle(); // Auto-select first vehicle after loading
    } else if (result is Error) {
      final error = (result as Error).type;
      emit(state.copyWith(
        vehicleStatus: GpsDataStatus.error,
        errorMessage: _getErrorMessage(error),
      ));
    }
  }

  // Method to fetch reports using current state values
  Future<void> fetchReports() async {
    if (state.selectedVehicle == null) {
      emit(state.copyWith(
        reportStatus: GpsDataStatus.error,
        errorMessage: 'Please select a vehicle first',
      ));
      return;
    }

    await fetchReportData(
      reportType: state.selectedReportType,
      vehicleId: state.selectedVehicle!.deviceId ?? 0,
      fromDate: state.fromDate,
      toDate: state.toDate,
    );
  }

  // Helper method to convert error types to user-friendly messages
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('InternetNetworkError')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('ErrorWithMessage')) {
      // Extract the actual message from ErrorWithMessage
      final errorStr = error.toString();
      if (errorStr.contains('message: ')) {
        final startIndex = errorStr.indexOf('message: ') + 9;
        final endIndex = errorStr.indexOf(')', startIndex);
        if (endIndex > startIndex) {
          return errorStr.substring(startIndex, endIndex);
        }
      }
      return 'An error occurred while fetching the report.';
    } else if (error.toString().contains('NotFoundError')) {
      return 'No data found for the selected criteria.';
    } else if (error.toString().contains('GenericError')) {
      return 'An unexpected error occurred. Please try again.';
    } else {
      return 'An error occurred: ${error.toString()}';
    }
  }

  // This is the main method called when the user clicks the "Show Report" button.
  Future<void> fetchReportData({
    required ReportType reportType,
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    print("🔍 GpsReportCubit.fetchReportData called");
    print("  - Report Type: $reportType");
    print("  - Vehicle ID: $vehicleId");
    print("  - From Date: $fromDate");
    print("  - To Date: $toDate");
    
    // Immediately tell the UI we are loading the reports.
    emit(state.copyWith(reportStatus: GpsDataStatus.loading, reports: []));

    dynamic result;

    // Use a switch statement to call the correct repository method.
    switch (reportType) {
      case ReportType.stops:
        print("  - Calling fetchStopReports...");
        result = await _repository.fetchStopReports(vehicleId: vehicleId, fromDate: fromDate, toDate: toDate);
        break;
      case ReportType.trips:
        print("  - Calling fetchTripReports...");
        result = await _repository.fetchTripReports(vehicleId: vehicleId, fromDate: fromDate, toDate: toDate);
        break;
      case ReportType.daily:
        print("  - Calling fetchSummaryReports...");
        result = await _repository.fetchSummaryReports(vehicleId: vehicleId, fromDate: fromDate, toDate: toDate);
        break;
      case ReportType.dailyKm:
        print("  - Calling fetchDailyKmReports...");
        result = await _repository.fetchDailyKmReports(vehicleId: vehicleId, fromDate: fromDate, toDate: toDate);
        break;
      case ReportType.reachability:
        print("  - Calling fetchReachabilityReports...");
        result = await _repository.fetchReachabilityReports(vehicleId: vehicleId, fromDate: fromDate, toDate: toDate);
        break;
    }

    print("  - Result type: ${result.runtimeType}");
    
    // Handle the result from the repository
    if (result is Success) {
      print("  - Success! Reports count: ${result.value.length}");
      // If successful, update the state with the new list of reports.
      emit(state.copyWith(
        reportStatus: GpsDataStatus.success,
        reports: result.value,
        currentReportType: reportType,
      ));

      // If this was a trip report, automatically fetch addresses
      if (reportType == ReportType.trips && result.value.isNotEmpty) {
        print("  - Automatically fetching addresses for ${result.value.length} trip reports...");
        fetchAddressesForTrips(result.value);
      }

      // If this was a stop report, automatically fetch addresses
      if (reportType == ReportType.stops && result.value.isNotEmpty) {
        print("  - Automatically fetching addresses for ${result.value.length} stop reports...");
        fetchAddressesForStops(result.value);
      }

      // If this was a summary report, automatically fetch addresses
      if (reportType == ReportType.daily && result.value.isNotEmpty) {
        print("  - Automatically fetching addresses for ${result.value.length} summary reports...");
        fetchAddressesForSummaries(result.value);
      }

      // If this was a reachability report, automatically fetch addresses
      if (reportType == ReportType.reachability && result.value.isNotEmpty) {
        print("  - Automatically fetching addresses for ${result.value.length} reachability reports...");
        fetchAddressesForReachability(result.value);
      }
    } else if (result is Error) {
      final error = (result as Error).type;
      print("  - Error: $error");
      print("  - Error details: $error");
      
      // Special handling for reachability reports: NotFoundError means no alerts, which is normal
      if (reportType == ReportType.reachability && error.toString().contains('NotFoundError')) {
        print("  - NotFoundError for reachability reports treated as empty success");
        emit(state.copyWith(
          reportStatus: GpsDataStatus.success,
          reports: [], // Empty list for no reachability alerts
          currentReportType: reportType,
        ));
      } else {
        // If there was an error, update the state with a user-friendly error message.
        emit(state.copyWith(
          reportStatus: GpsDataStatus.error,
          errorMessage: _getErrorMessage(error),
        ));
      }
    }
  }

  /// Fetch addresses for trip reports
  Future<void> fetchAddressesForTrips(List<dynamic> tripReports) async {
    try {
      print("🌍 Cubit: Starting to fetch addresses for ${tripReports.length} trip reports");
      
      // CRITICAL FIX: Extract trip IDs (start_position_id) not device IDs
      List<int> tripIds = tripReports.map((report) => report.startPositionId as int).toList();
      print("🌍 Cubit: Trip IDs to fetch addresses for: $tripIds");
      
      // CRITICAL FIX: Check if addresses are already cached to prevent duplicate calls
      if (state.addressStatus == GpsDataStatus.success && state.addresses.isNotEmpty) {
        // Check if we already have addresses for all these trip IDs
        bool allAddressesCached = tripIds.every((tripId) => state.addresses.containsKey(tripId));
        
        if (allAddressesCached) {
          print("🌍 Cubit: All addresses already cached, skipping API calls");
          print("🌍 Cubit: Cached trip IDs: ${state.addresses.keys.toList()}");
          print("🌍 Cubit: Requested trip IDs: $tripIds");
          return;
        }
      }
      
      emit(state.copyWith(addressStatus: GpsDataStatus.loading));
      
      final addresses = await _reportService.fetchAddressesForTrips(tripReports);
      
      print("🌍 Cubit: Received ${addresses.length} address responses");
      
      // Create a map for quick lookup using trip IDs
      Map<int, AddressResponse> addressMap = Map.from(state.addresses); // Start with existing cache
      for (var address in addresses) {
        addressMap[address.positionId] = address; // Use positionId (trip ID) as key
        print("🌍 Cubit: Storing address for trip ${address.positionId} (device ${address.deviceId})");
        print("   Start: ${address.startAddress}");
        print("   End: ${address.endAddress}");
      }
      
      print("🌍 Cubit: Address map created with ${addressMap.length} entries");
      print("🌍 Cubit: Address map keys: ${addressMap.keys.toList()}");
      
      emit(state.copyWith(
        addresses: addressMap,
        addressStatus: GpsDataStatus.success,
      ));
      
      print("🌍 Cubit: Address state updated successfully");
    } catch (e) {
      print("🌍 Cubit: Error fetching addresses: $e");
      emit(state.copyWith(addressStatus: GpsDataStatus.error));
    }
  }

  /// Get address for a specific trip
  AddressResponse? getAddressForTrip(int tripId) {
    print("🌍 Cubit: Looking up address for trip $tripId");
    final address = state.addresses[tripId];
    if (address != null) {
      print("🌍 Cubit: Found address: YES (${address.startAddress})");
    } else {
      print("🌍 Cubit: Found address: NO");
    }
    print("🌍 Cubit: Available trip IDs in address map: ${state.addresses.keys.toList()}");
    print("🌍 Cubit: Address status: ${state.addressStatus}");
    return address;
  }

  /// Fetch addresses for stop reports
  Future<void> fetchAddressesForStops(List<dynamic> stopReports) async {
    try {
      print("🌍 Cubit: Starting to fetch addresses for ${stopReports.length} stop reports");
      
      if (stopReports.isNotEmpty) {
        // Get unique stop IDs to check what we already have cached
        final stopIds = stopReports.map((report) => "${report.deviceId}_${report.startTime}").toList();
        
        // Check if we already have addresses for all these stop IDs
        bool allAddressesCached = stopIds.every((stopId) => state.stopAddresses.containsKey(stopId));
        
        if (allAddressesCached) {
          print("🌍 Cubit: All stop addresses already cached, skipping API calls");
          print("🌍 Cubit: Cached stop IDs: ${state.stopAddresses.keys.toList()}");
          print("🌍 Cubit: Requested stop IDs: $stopIds");
          return;
        }
      }
      
      emit(state.copyWith(stopAddressStatus: GpsDataStatus.loading));
      
      final addresses = await _reportService.fetchAddressesForStops(stopReports);
      
      print("🌍 Cubit: Received ${addresses.length} stop address responses");
      
      // Create a map for quick lookup using stop IDs
      Map<String, StopAddressResponse> stopAddressMap = Map.from(state.stopAddresses); // Start with existing cache
      for (var address in addresses) {
        stopAddressMap[address.stopId] = address; // Use stopId as key
        print("🌍 Cubit: Storing address for stop ${address.stopId} (device ${address.deviceId})");
        print("   Address: ${address.address}");
      }
      
      print("🌍 Cubit: Stop address map created with ${stopAddressMap.length} entries");
      print("🌍 Cubit: Stop address map keys: ${stopAddressMap.keys.toList()}");
      
      emit(state.copyWith(
        stopAddresses: stopAddressMap,
        stopAddressStatus: GpsDataStatus.success,
      ));
      
      print("🌍 Cubit: Stop address state updated successfully");
    } catch (e) {
      print("🌍 Cubit: Error fetching stop addresses: $e");
      emit(state.copyWith(stopAddressStatus: GpsDataStatus.error));
    }
  }

  /// Get address for a specific stop
  StopAddressResponse? getAddressForStop(String stopId) {
    print("🌍 Cubit: Looking up address for stop $stopId");
    final address = state.stopAddresses[stopId];
    if (address != null) {
      print("🌍 Cubit: Found stop address: YES (${address.address})");
    } else {
      print("🌍 Cubit: Found stop address: NO");
    }
    print("🌍 Cubit: Available stop IDs in address map: ${state.stopAddresses.keys.toList()}");
    print("🌍 Cubit: Stop address status: ${state.stopAddressStatus}");
    return address;
  }

  /// Fetch addresses for summary reports
  Future<void> fetchAddressesForSummaries(List<dynamic> summaryReports) async {
    try {
      print("🌍 Cubit: Starting to fetch addresses for ${summaryReports.length} summary reports");
      
      if (summaryReports.isEmpty) {
        print("🌍 Cubit: No summary reports to process for addresses");
        return;
      }

      // Update state to show we're loading addresses
      emit(state.copyWith(summaryAddressStatus: GpsDataStatus.loading));
      
      // Fetch addresses from service
      final List<SummaryAddressResponse> addressResponses = 
          await _reportService.fetchAddressesForSummaries(summaryReports);
      
      print("🌍 Cubit: Received ${addressResponses.length} summary address responses");
      
      // Convert list to map for faster lookup
      Map<String, SummaryAddressResponse> addressMap = {};
      for (final response in addressResponses) {
        addressMap[response.summaryId] = response;
        print("🌍 Cubit: Storing summary address for ID ${response.summaryId}");
        print("   Start: ${response.startAddress}");
        print("   End: ${response.endAddress}");
      }
      
      print("🌍 Cubit: Summary address map created with ${addressMap.length} entries");
      print("🌍 Cubit: Summary address map keys: ${addressMap.keys.toList()}");
      
      // Update state with the fetched addresses
      emit(state.copyWith(
        summaryAddressStatus: GpsDataStatus.success,
        summaryAddresses: addressMap,
      ));
      
      print("🌍 Cubit: Summary address state updated successfully");
      
    } catch (e) {
      print("🌍 Cubit: Error fetching summary addresses: $e");
      emit(state.copyWith(
        summaryAddressStatus: GpsDataStatus.error,
        errorMessage: "Failed to load summary addresses: ${e.toString()}",
      ));
    }
  }

  /// Get address for a specific summary
  SummaryAddressResponse? getAddressForSummary(String summaryId) {
    print("🌍 Cubit: Looking up address for summary $summaryId");
    final address = state.summaryAddresses[summaryId];
    if (address != null) {
      print("🌍 Cubit: Found summary address: YES (Start: ${address.startAddress})");
    } else {
      print("🌍 Cubit: Found summary address: NO");
    }
    print("🌍 Cubit: Available summary IDs in address map: ${state.summaryAddresses.keys.toList()}");
    print("🌍 Cubit: Summary address status: ${state.summaryAddressStatus}");
    return address;
  }

  /// Fetch addresses for reachability reports
  Future<void> fetchAddressesForReachability(List<dynamic> reachabilityReports) async {
    try {
      print("🌍 Cubit: Starting to fetch addresses for ${reachabilityReports.length} reachability reports");
      
      if (reachabilityReports.isEmpty) {
        print("🌍 Cubit: No reachability reports to process for addresses");
        return;
      }

      // Get unique reachability IDs to check what we already have cached
      final reachabilityIds = reachabilityReports.map((report) => report.id.toString()).toList();
      
      // Check if we already have addresses for all these reachability IDs
      bool allAddressesCached = reachabilityIds.every((reachabilityId) => state.reachabilityAddresses.containsKey(reachabilityId));
      
      if (allAddressesCached) {
        print("🌍 Cubit: All reachability addresses already cached, skipping API calls");
        print("🌍 Cubit: Cached reachability IDs: ${state.reachabilityAddresses.keys.toList()}");
        print("🌍 Cubit: Requested reachability IDs: $reachabilityIds");
        return;
      }

      // Update state to show we're loading addresses
      emit(state.copyWith(reachabilityAddressStatus: GpsDataStatus.loading));
      
      // Fetch addresses from service
      final List<ReachabilityAddressResponse> addressResponses = 
          await _reportService.fetchAddressesForReachability(reachabilityReports);
      
      print("🌍 Cubit: Received ${addressResponses.length} reachability address responses");
      
      // Convert list to map for faster lookup
      Map<String, ReachabilityAddressResponse> addressMap = Map.from(state.reachabilityAddresses); // Start with existing cache
      for (final response in addressResponses) {
        addressMap[response.reachabilityId] = response;
        print("🌍 Cubit: Storing reachability address for ID ${response.reachabilityId}");
        print("   Address: ${response.address}");
      }
      
      print("🌍 Cubit: Reachability address map created with ${addressMap.length} entries");
      print("🌍 Cubit: Reachability address map keys: ${addressMap.keys.toList()}");
      
      // Update state with the fetched addresses
      emit(state.copyWith(
        reachabilityAddressStatus: GpsDataStatus.success,
        reachabilityAddresses: addressMap,
      ));
      
      print("🌍 Cubit: Reachability address state updated successfully");
      
    } catch (e) {
      print("🌍 Cubit: Error fetching reachability addresses: $e");
      emit(state.copyWith(
        reachabilityAddressStatus: GpsDataStatus.error,
        errorMessage: "Failed to load reachability addresses: ${e.toString()}",
      ));
    }
  }

  /// Get address for a specific reachability alert
  ReachabilityAddressResponse? getAddressForReachability(String reachabilityId) {
    print("🌍 Cubit: Looking up address for reachability $reachabilityId");
    final address = state.reachabilityAddresses[reachabilityId];
    if (address != null) {
      print("🌍 Cubit: Found reachability address: YES (${address.address})");
    } else {
      print("🌍 Cubit: Found reachability address: NO");
    }
    print("🌍 Cubit: Available reachability IDs in address map: ${state.reachabilityAddresses.keys.toList()}");
    print("🌍 Cubit: Reachability address status: ${state.reachabilityAddressStatus}");
    return address;
  }

  /// Helper method to create stop ID from report
  String _createStopId(dynamic stopReport) {
    return "${stopReport.deviceId}_${stopReport.startTime}";
  }
}