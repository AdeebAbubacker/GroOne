// lib/features/gps_feature/cubit/report_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../model/address_model.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../repository/report_repository.dart';
import '../service/report_service.dart';

part 'report_state.dart'; // Connects to the state file

class GpsReportCubit extends Cubit<GpsReportState> {
  final GpsReportRepository _repository;
  final GpsReportService _reportService;

  GpsReportCubit({
    GpsReportRepository? repository,
    GpsReportService? reportService,
  }) : _repository = repository ?? locator<GpsReportRepository>(),
       _reportService = reportService ?? locator<GpsReportService>(),
       super(GpsReportState());

  // Date selection methods
  void updateFromDate(DateTime date) {
    emit(
      state.copyWith(
        fromDate: DateTime(date.year, date.month, date.day, 0, 0, 0, 0),
      ),
    );
  }

  void resetState() {
    emit(GpsReportState());
  }

  void updateToDate(DateTime date) {
    emit(
      state.copyWith(
        toDate: DateTime(date.year, date.month, date.day, 23, 59, 59, 999),
      ),
    );
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
      emit(
        state.copyWith(
          vehicleStatus: GpsDataStatus.success,
          vehicles: result.value,
        ),
      );
      _autoSelectFirstVehicle(); // Auto-select first vehicle after loading
    } else if (result is Error) {
      final error = (result as Error).type;
      emit(
        state.copyWith(
          vehicleStatus: GpsDataStatus.error,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  // Method to fetch reports using current state values
  Future<void> fetchReports() async {
    if (state.selectedVehicle == null) {
      emit(
        state.copyWith(
          reportStatus: GpsDataStatus.error,
          errorMessage: 'Please select a vehicle first',
        ),
      );
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
    // Immediately tell the UI we are loading the reports.
    emit(state.copyWith(reportStatus: GpsDataStatus.loading, reports: []));

    dynamic result;

    // Use a switch statement to call the correct repository method.
    switch (reportType) {
      case ReportType.stops:
        result = await _repository.fetchStopReports(
          vehicleId: vehicleId,
          fromDate: fromDate,
          toDate: toDate,
        );
        break;
      case ReportType.trips:
        result = await _repository.fetchTripReports(
          vehicleId: vehicleId,
          fromDate: fromDate,
          toDate: toDate,
        );
        break;
      case ReportType.daily:
        result = await _repository.fetchSummaryReports(
          vehicleId: vehicleId,
          fromDate: fromDate,
          toDate: toDate,
        );
        break;
      case ReportType.dailyKm:
        result = await _repository.fetchDailyKmReports(
          vehicleId: vehicleId,
          fromDate: fromDate,
          toDate: toDate,
        );
        break;
      case ReportType.reachability:
        result = await _repository.fetchReachabilityReports(
          vehicleId: vehicleId,
          fromDate: fromDate,
          toDate: toDate,
        );
        break;
    }

    // Handle the result from the repository
    if (result is Success) {
      // If successful, update the state with the new list of reports.
      emit(
        state.copyWith(
          reportStatus: GpsDataStatus.success,
          reports: result.value,
          currentReportType: reportType,
        ),
      );

      // If this was a trip report, automatically fetch addresses
      if (reportType == ReportType.trips && result.value.isNotEmpty) {
        fetchAddressesForTrips(result.value);
      }

      // If this was a stop report, automatically fetch addresses
      if (reportType == ReportType.stops && result.value.isNotEmpty) {
        fetchAddressesForStops(result.value);
      }

      // If this was a summary report, automatically fetch addresses
      if (reportType == ReportType.daily && result.value.isNotEmpty) {
        fetchAddressesForSummaries(result.value);
      }

      // If this was a reachability report, automatically fetch addresses
      if (reportType == ReportType.reachability && result.value.isNotEmpty) {
        fetchAddressesForReachability(result.value);
      }
    } else if (result is Error) {
      final error = (result as Error).type;

      // Special handling for reachability reports: NotFoundError means no alerts, which is normal
      if (reportType == ReportType.reachability &&
          error.toString().contains('NotFoundError')) {
        emit(
          state.copyWith(
            reportStatus: GpsDataStatus.success,
            reports: [], // Empty list for no reachability alerts
            currentReportType: reportType,
          ),
        );
      } else {
        // If there was an error, update the state with a user-friendly error message.
        emit(
          state.copyWith(
            reportStatus: GpsDataStatus.error,
            errorMessage: _getErrorMessage(error),
          ),
        );
      }
    }
  }

  /// Fetch addresses for trip reports
  Future<void> fetchAddressesForTrips(List<dynamic> tripReports) async {
    try {
      // CRITICAL FIX: Extract trip IDs (start_position_id) not device IDs
      List<int> tripIds =
          tripReports.map((report) => report.startPositionId as int).toList();

      // CRITICAL FIX: Check if addresses are already cached to prevent duplicate calls
      if (state.addressStatus == GpsDataStatus.success &&
          state.addresses.isNotEmpty) {
        // Check if we already have addresses for all these trip IDs
        bool allAddressesCached = tripIds.every(
          (tripId) => state.addresses.containsKey(tripId),
        );

        if (allAddressesCached) {
          return;
        }
      }

      emit(state.copyWith(addressStatus: GpsDataStatus.loading));

      final addresses = await _reportService.fetchAddressesForTrips(
        tripReports,
      );

      // Create a map for quick lookup using trip IDs
      Map<int, AddressResponse> addressMap = Map.from(
        state.addresses,
      ); // Start with existing cache
      for (var address in addresses) {
        addressMap[address.positionId] =
            address; // Use positionId (trip ID) as key
      }

      emit(
        state.copyWith(
          addresses: addressMap,
          addressStatus: GpsDataStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(addressStatus: GpsDataStatus.error));
    }
  }

  /// Get address for a specific trip
  AddressResponse? getAddressForTrip(int tripId) {
    return state.addresses[tripId];
  }

  /// Fetch addresses for stop reports
  Future<void> fetchAddressesForStops(List<dynamic> stopReports) async {
    try {
      if (stopReports.isNotEmpty) {
        // Get unique stop IDs to check what we already have cached
        final stopIds =
            stopReports
                .map((report) => "${report.deviceId}_${report.startTime}")
                .toList();

        // Check if we already have addresses for all these stop IDs
        bool allAddressesCached = stopIds.every(
          (stopId) => state.stopAddresses.containsKey(stopId),
        );

        if (allAddressesCached) {
          return;
        }
      }

      emit(state.copyWith(stopAddressStatus: GpsDataStatus.loading));

      final addresses = await _reportService.fetchAddressesForStops(
        stopReports,
      );

      // Create a map for quick lookup using stop IDs
      Map<String, StopAddressResponse> stopAddressMap = Map.from(
        state.stopAddresses,
      ); // Start with existing cache
      for (var address in addresses) {
        stopAddressMap[address.stopId] = address; // Use stopId as key
      }

      emit(
        state.copyWith(
          stopAddresses: stopAddressMap,
          stopAddressStatus: GpsDataStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(stopAddressStatus: GpsDataStatus.error));
    }
  }

  /// Get address for a specific stop
  StopAddressResponse? getAddressForStop(String stopId) {
    return state.stopAddresses[stopId];
  }

  /// Fetch addresses for summary reports
  Future<void> fetchAddressesForSummaries(List<dynamic> summaryReports) async {
    try {
      if (summaryReports.isEmpty) {
        return;
      }

      // Update state to show we're loading addresses
      emit(state.copyWith(summaryAddressStatus: GpsDataStatus.loading));

      // Fetch addresses from service
      final List<SummaryAddressResponse> addressResponses = await _reportService
          .fetchAddressesForSummaries(summaryReports);

      // Convert list to map for faster lookup
      Map<String, SummaryAddressResponse> addressMap = {};
      for (final response in addressResponses) {
        addressMap[response.summaryId] = response;
      }

      // Update state with the fetched addresses
      emit(
        state.copyWith(
          summaryAddressStatus: GpsDataStatus.success,
          summaryAddresses: addressMap,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          summaryAddressStatus: GpsDataStatus.error,
          errorMessage: "Failed to load summary addresses: ${e.toString()}",
        ),
      );
    }
  }

  /// Get address for a specific summary
  SummaryAddressResponse? getAddressForSummary(String summaryId) {
    return state.summaryAddresses[summaryId];
  }

  /// Fetch addresses for reachability reports
  Future<void> fetchAddressesForReachability(
    List<dynamic> reachabilityReports,
  ) async {
    try {
      if (reachabilityReports.isEmpty) {
        return;
      }

      // Get unique reachability IDs to check what we already have cached
      final reachabilityIds =
          reachabilityReports.map((report) => report.id.toString()).toList();

      // Check if we already have addresses for all these reachability IDs
      bool allAddressesCached = reachabilityIds.every(
        (reachabilityId) =>
            state.reachabilityAddresses.containsKey(reachabilityId),
      );

      if (allAddressesCached) {
        return;
      }

      // Update state to show we're loading addresses
      emit(state.copyWith(reachabilityAddressStatus: GpsDataStatus.loading));

      // Fetch addresses from service
      final List<ReachabilityAddressResponse> addressResponses =
          await _reportService.fetchAddressesForReachability(
            reachabilityReports,
          );

      // Convert list to map for faster lookup
      Map<String, ReachabilityAddressResponse> addressMap = Map.from(
        state.reachabilityAddresses,
      ); // Start with existing cache
      for (final response in addressResponses) {
        addressMap[response.reachabilityId] = response;
      }

      // Update state with the fetched addresses
      emit(
        state.copyWith(
          reachabilityAddressStatus: GpsDataStatus.success,
          reachabilityAddresses: addressMap,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          reachabilityAddressStatus: GpsDataStatus.error,
          errorMessage:
              "Failed to load reachability addresses: ${e.toString()}",
        ),
      );
    }
  }

  /// Get address for a specific reachability alert
  ReachabilityAddressResponse? getAddressForReachability(
    String reachabilityId,
  ) {
    return state.reachabilityAddresses[reachabilityId];
  }
}
