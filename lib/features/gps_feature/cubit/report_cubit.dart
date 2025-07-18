// lib/features/gps_feature/cubit/report_cubit.dart
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
        super(const GpsReportState());

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
    } else if (result is Error) {
      final error = (result as Error).type;
      emit(state.copyWith(
        vehicleStatus: GpsDataStatus.error,
        errorMessage: _getErrorMessage(error),
      ));
    }
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
    } else if (result is Error) {
      final error = (result as Error).type;
      print("  - Error: $error");
      print("  - Error details: $error");
      // If there was an error, update the state with a user-friendly error message.
      emit(state.copyWith(
        reportStatus: GpsDataStatus.error,
        errorMessage: _getErrorMessage(error),
      ));
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
}