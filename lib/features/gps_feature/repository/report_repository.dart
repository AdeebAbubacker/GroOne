// lib/features/gps_feature/repository/report_repository.dart

import 'package:intl/intl.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../model/report_model.dart';
import '../service/report_service.dart';
import 'gps_login_repository.dart';

class GpsReportRepository {
  final GpsReportService _service;
  final GpsLoginRepository _loginRepository;

  GpsReportRepository({GpsReportService? service, GpsLoginRepository? loginRepository})
      : _service = service ?? locator<GpsReportService>(),
        _loginRepository = loginRepository ?? locator<GpsLoginRepository>();

  // --- VEHICLE LIST (Getting from Realm Database) ---
  Future<Result<List<GpsCombinedVehicleData>>> getVehicles() async {
    try {
      print("🔍 GpsReportRepository.getVehicles called");
      
      // Check if we have offline data available
      final hasOfflineData = await _loginRepository.hasOfflineData();
      
      if (hasOfflineData) {
        print("  - Offline data available, fetching from Realm");
        final offlineVehicles = await _loginRepository.getOfflineVehicleData();
        print("  - Found ${offlineVehicles.length} vehicles in Realm");
        return Success(offlineVehicles);
      } else {
        print("  - No offline data available, trying to fetch from API");
        
        // Try to get fresh data from API
        final result = await _loginRepository.getAllVehicleData();
        
        if (result is Success<List<GpsCombinedVehicleData>>) {
          print("  - Successfully fetched ${result.value.length} vehicles from API");
          return result;
        } else {
          print("  - Failed to fetch vehicles from API: ${(result as Error).type}");
          return result;
        }
      }
    } catch (e) {
      print("  - Error in getVehicles: $e");
      return Error(GenericError());
    }
  }

  // Helper to format DateTime to the required UTC string format for the API.
  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date.toUtc());
  }

  // --- REPORT API CALLS ---
  // These methods call the ApiService to get data from the network.

  Future<Result<List<StopReport>>> fetchStopReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final formattedFromDate = _formatDate(fromDate);
    final formattedToDate = _formatDate(toDate);
    
    print("🔍 GpsReportRepository.fetchStopReports called");
    print("  - Vehicle ID: $vehicleId");
    print("  - From Date: $fromDate");
    print("  - To Date: $toDate");
    print("  - Formatted From Date: $formattedFromDate");
    print("  - Formatted To Date: $formattedToDate");
    
    final result = await _service.fetchStopReports(
      fromDate: formattedFromDate,
      toDate: formattedToDate,
      vehicleId: vehicleId,
    );
    
    print("  - Service result type: ${result.runtimeType}");
    return result;
  }

  Future<Result<List<TripReport>>> fetchTripReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final formattedFromDate = _formatDate(fromDate);
    final formattedToDate = _formatDate(toDate);
    
    print("🔍 Date formatting:");
    print("  - Original fromDate: $fromDate");
    print("  - Original toDate: $toDate");
    print("  - Formatted fromDate: $formattedFromDate");
    print("  - Formatted toDate: $formattedToDate");
    
    return await _service.fetchTripReports(
      fromDate: formattedFromDate,
      toDate: formattedToDate,
      vehicleId: vehicleId,
    );
  }

  Future<Result<List<SummaryReport>>> fetchSummaryReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    return await _service.fetchSummaryReports(
      fromDate: _formatDate(fromDate),
      toDate: _formatDate(toDate),
      vehicleId: vehicleId,
    );
  }

  Future<Result<List<DailyDistanceReport>>> fetchDailyKmReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    print("🔍 GpsReportRepository.fetchDailyKmReports called");
    print("  - Vehicle ID: $vehicleId");
    print("  - From Date: $fromDate");
    print("  - To Date: $toDate");
    
    final result = await _service.fetchDailyKmReports(
      fromDate: _formatDate(fromDate),
      toDate: _formatDate(toDate),
      vehicleId: vehicleId,
    );
    
    if (result is Success<List<DailyDistanceReport>>) {
      print("  - API call successful, processing date range...");
      
      // Process the date range to ensure all selected dates are included
      final processedReports = await _processDailyKmDateRange(
        result.value,
        fromDate,
        toDate,
        vehicleId,
      );
      
      print("  - Processed reports count: ${processedReports.length}");
      return Success(processedReports);
    }
    
    return result;
  }

  /// Process daily KM reports to ensure all selected dates are included
  Future<List<DailyDistanceReport>> _processDailyKmDateRange(
    List<DailyDistanceReport> originalReports,
    DateTime fromDate,
    DateTime toDate,
    int vehicleId,
  ) async {
    print("🔍 _processDailyKmDateRange called");
    print("  - Original reports count: ${originalReports.length}");
    print("  - From Date: $fromDate");
    print("  - To Date: $toDate");
    
    final List<DailyDistanceReport> processedReports = [];
    
    // Generate list of all dates in the range
    final List<DateTime> dateRange = [];
    DateTime currentDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final endDate = DateTime(toDate.year, toDate.month, toDate.day);
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dateRange.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    print("  - Date range count: ${dateRange.length}");
    
    // Process each original report
    for (final report in originalReports) {
      final List<DailyDistanceItem> processedItems = [];
      
      // For each date in the range, check if we have data
      for (final date in dateRange) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final displayDate = DateFormat('MMM dd, yyyy').format(date);
        
        // Look for existing data for this date
        DailyDistanceItem? existingItem;
        for (final item in report.dailyDistances) {
          // Try to parse the date from the API response
          try {
            final itemDate = DateTime.parse(item.date);
            final itemFormattedDate = DateFormat('yyyy-MM-dd').format(itemDate);
            
            if (itemFormattedDate == formattedDate) {
              existingItem = item;
              break;
            }
          } catch (e) {
            // If parsing fails, try to match the date string directly
            if (item.date.contains(formattedDate) || item.date.contains(displayDate)) {
              existingItem = item;
              break;
            }
          }
        }
        
        // If no data exists for this date, create a new item with 0 distance
        if (existingItem == null) {
          existingItem = DailyDistanceItem(
            date: displayDate,
            distance: 0.0,
          );
          print("  - Created placeholder for date: $displayDate");
        } else {
          print("  - Found existing data for date: ${existingItem.date}, distance: ${existingItem.distance}");
          print("  - Raw distance value: ${existingItem.distance}");
        }
        
        processedItems.add(existingItem);
      }
      
      // Create new report with processed items
      final processedReport = DailyDistanceReport(
        deviceId: report.deviceId,
        totalDistance: report.totalDistance,
        dailyDistances: processedItems,
      );
      
      processedReports.add(processedReport);
    }
    
    print("  - Processed reports count: ${processedReports.length}");
    return processedReports;
  }

  Future<Result<List<ReachabilityReport>>> fetchReachabilityReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    return await _service.fetchReachabilityReports(
      fromDate: _formatDate(fromDate),
      toDate: _formatDate(toDate),
      vehicleId: vehicleId,
    );
  }
}