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
      
      // Check if we have offline data available
      final hasOfflineData = await _loginRepository.hasOfflineData();
      
      if (hasOfflineData) {
        final offlineVehicles = await _loginRepository.getOfflineVehicleData();
        return Success(offlineVehicles);
      } else {
        
        // Try to get fresh data from API
        final result = await _loginRepository.getAllVehicleData();
        
        if (result is Success<List<GpsCombinedVehicleData>>) {
          return result;
        } else {
          return result;
        }
      }
    } catch (e) {
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
    
    
    final result = await _service.fetchStopReports(
      fromDate: formattedFromDate,
      toDate: formattedToDate,
      vehicleId: vehicleId,
    );
    
    return result;
  }

  Future<Result<List<TripReport>>> fetchTripReports({
    required int vehicleId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final formattedFromDate = _formatDate(fromDate);
    final formattedToDate = _formatDate(toDate);
    
    
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
    
    final result = await _service.fetchDailyKmReports(
      fromDate: _formatDate(fromDate),
      toDate: _formatDate(toDate),
      vehicleId: vehicleId,
    );
    
    if (result is Success<List<DailyDistanceReport>>) {
      
      // Process the date range to ensure all selected dates are included
      final processedReports = await _processDailyKmDateRange(
        result.value,
        fromDate,
        toDate,
        vehicleId,
      );
      
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
    
    final List<DailyDistanceReport> processedReports = [];
    
    // Generate list of all dates in the range
    final List<DateTime> dateRange = [];
    DateTime currentDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final endDate = DateTime(toDate.year, toDate.month, toDate.day);
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dateRange.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    
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
        } else {
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