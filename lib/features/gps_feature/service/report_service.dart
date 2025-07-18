// lib/features/gps_feature/service/gps_report_service.dart

import 'dart:convert';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart'; // Your generic ApiService
import '../../../utils/custom_log.dart';
import '../model/report_model.dart';
import '../model/address_model.dart';
import '../repository/gps_login_repository.dart';
import 'package:intl/intl.dart'; // Added for NumberFormat

class GpsReportService {
  final ApiService _apiService;
  final GpsLoginRepository _repository;
  
  // API URL for reverse geocoding (matching Android implementation)
  static const String routingApiUrl = 'https://routing.roadcast.xyz/reverse';

  GpsReportService(this._apiService, this._repository);

  // --- Helper to DRY up response handling ---
  Future<Result<List<T>>> _fetchAndParse<T>({
    required String endpoint,
    required Map<String, dynamic> queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    String baseUrl = 'https://api.letsgro.co/api/v1/auth/';
    try {

      final loginResponse = await _repository.getStoredLoginResponse();
      
      if (loginResponse == null || loginResponse.token == null) {
        CustomLog.error(this, "No GPS login response or token found. Please login to GPS first.", null);
        return Error(ErrorWithMessage(message: "GPS login required. Please login to GPS first."));
      }
      
      CustomLog.info(this, "Making API call to: $baseUrl$endpoint");
      CustomLog.info(this, "Query params: $queryParams");
      
      final response = await _apiService.get(
          '$baseUrl$endpoint',
          queryParams: queryParams,
        customHeaders: {
          'Authorization': loginResponse.token!,
        },
      );

      if (response is Success) {
        CustomLog.info(this, "API call successful, processing response...");
        CustomLog.info(this, "Response value: ${response.value}");
        try {
          final result = await handleGpsApiResponse<List<T>>(
          response.value, (data) {
            CustomLog.info(this, "fromJson function called with data: $data");
            CustomLog.info(this, "data type: ${data.runtimeType}");
            if (data is List) {
              CustomLog.info(this, "data is List with ${data.length} items");
              if (data.isNotEmpty) {
                CustomLog.info(this, "First item: ${data.first}");
              }
            }
            try {
              return (data as List).map((e) {
                CustomLog.info(this, "Processing item: $e");
                return fromJson(e);
              }).toList();
            } catch (e) {
              CustomLog.error(this, "Error in map operation: $e", e);
              rethrow;
            }
          },
        );
          CustomLog.info(this, "GPS API response handled, result: $result");
          return result;
        } catch (e) {
          CustomLog.error(this, "Error in _handleGpsApiResponse: $e", e);
          return Error(GenericError());
        }
      } else {
        CustomLog.error(this, "API call failed: ${(response as Error).type}", null);
        return Error((response as Error).type);
      }
    } catch (e, stackTrace) {
      CustomLog.error(this, "Failed to fetch reports from '$baseUrl$endpoint'", e);
      return Error(GenericError());
    }
  }

  /// Handle GPS API Response Format
  Future<Result<T>> handleGpsApiResponse<T>(
    dynamic result,
    T Function(dynamic) fromJson,
  ) async {
    CustomLog.info(this, "🚀 handleGpsApiResponse called with result: $result");
    try {
      CustomLog.info(this, "Handling GPS API response: $result");
      
      // GPS API returns: {data: [...]} - no status field, just data
      if (result['data'] != null) {
        CustomLog.info(this, "GPS API status is success");
        final data = result['data'];
        CustomLog.info(this, "GPS API data found: $data");
        CustomLog.info(this, "GPS API data type: ${data.runtimeType}");
        
        if (data is List) {
          CustomLog.info(this, "GPS API data is List with ${data.length} items");
          if (data.isNotEmpty) {
            CustomLog.info(this, "First item type: ${data.first.runtimeType}");
            CustomLog.info(this, "First item: ${data.first}");
          }
          
          try {
            CustomLog.info(this, "About to call fromJson with data type: ${data.runtimeType}");
            final parsedData = fromJson(data);
            CustomLog.info(this, "GPS API data parsed successfully, result type: ${parsedData.runtimeType}");
            return Success(parsedData);
          } catch (e, stackTrace) {
            CustomLog.error(this, "Error parsing data: $e", e);
            CustomLog.error(this, "Stack trace: $stackTrace", null);
            return Error(ErrorWithMessage(message: "Error parsing GPS API data: $e"));
          }
        } else {
          CustomLog.error(this, "GPS API data is not a list: $data", null);
          return Error(ErrorWithMessage(message: "Invalid data format from GPS API"));
        }
              } else {
          final message = result['message'] ?? 'GPS API request failed';
          CustomLog.error(this, "GPS API request failed: $message", null);
          CustomLog.error(this, "GPS API status: ${result['status']}", null);
          CustomLog.error(this, "GPS API full result: $result", null);
          return Error(ErrorWithMessage(message: message));
        }
    } catch (e) {
      CustomLog.error(this, "Error parsing GPS API response", e);
      return Error(GenericError());
    }
  }

  // --- API Method for 'STOPS' Report ---
  Future<Result<List<StopReport>>> fetchStopReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) {
    const String inputsJson = "{\"positionDuration\":1,\"withAddress\":false,\"withCoordinates\":false,\"eventsType\":[\"ignitionOn\"],\"timeFilter\":false,\"shiftName\":\"all\",\"geofenceID\":\"0\",\"stopDuration\":5,\"stopsType\":\"stop\",\"timeInputHours\":0,\"timeInputMinutes\":0,\"filterOutlines\":true,\"filter_speed_lesser_than\":null,\"filter_speed_greater_than\":null,\"tripDuration\":5}";

    return _fetchAndParse<StopReport>(
      endpoint: "reports/stop",
      queryParams: {
        'start': fromDate ?? '2025-07-02T18:30:00.000Z',
        'end': toDate ?? '2025-07-04T18:29:59.999Z',
        'device_ids': 2274,
        // 'device_ids': vehicleId ?? 2274,
        'timezone_offset': -330,
        'inputs': inputsJson,
      },
      fromJson: (json) => StopReport.fromJson(json),
    );
  }

  // --- API Method for 'TRIPS' Report ---
  Future<Result<List<TripReport>>> fetchTripReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) {
    return _fetchAndParse<TripReport>(
      endpoint: "reports/trip",
      queryParams: {
        'start': fromDate ?? '2025-07-02T18:30:00.000Z',
        'end': toDate ?? '2025-07-04T18:29:59.999Z',
        'device_ids': 2274,
        // 'device_ids': vehicleId ?? 2274,
        'timezone_offset': -330,
        'inputs': '[]',
      },
      fromJson: (json) => TripReport.fromJson(json),
    );
  }

  // --- API Method for 'DAILY (Summary)' Report ---
  Future<Result<List<SummaryReport>>> fetchSummaryReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) {
    return _fetchAndParse<SummaryReport>(
      endpoint: "reports/summary",
      queryParams: {
        'start': fromDate,
        'end': toDate,
        'device_ids': 2274,
        // 'device_ids': vehicleId,
        'timezone_offset': -330,
        'inputs': '[]',
      },
      fromJson: (json) => SummaryReport.fromJson(json),
    );
  }

  // --- API Method for 'DAILY KM' Report ---
  Future<Result<List<DailyDistanceReport>>> fetchDailyKmReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) {
    return _fetchAndParse<DailyDistanceReport>(
      endpoint: "reports/monthly_distance",
      queryParams: {
        'start': fromDate,
        'end': toDate,
        'device_ids': 2274,
        // 'device_ids': vehicleId.toString(),
        'timezone_offset': -330,
        'inputs': '[]',
      },
      fromJson: (json) => DailyDistanceReport.fromJson(json),
    );
  }

  // --- API Method for 'REACHABILITY' Report ---
  Future<Result<List<ReachabilityReport>>> fetchReachabilityReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) {
    return _fetchAndParse<ReachabilityReport>(
      endpoint: "reachability_alerts",
      queryParams: {
        '__device_id__equal': 2274,
        // '__device_id__equal': vehicleId,
        '__reach_date__datetime_btw': [fromDate, toDate],
      },
      fromJson: (json) => ReachabilityReport.fromJson(json),
    );
  }

  /// Reverse Geocoding - Convert coordinates to addresses
  Future<Result<AddressResponse>> getAddressFromServer(AddressPojo addressPojo) async {
    try {
      print("🌍 Getting address for trip: ${addressPojo.id}");
      print("   Device: ${addressPojo.deviceId}");
      print("   Start: ${addressPojo.startLat}, ${addressPojo.startLon}");
      print("   End: ${addressPojo.endLat}, ${addressPojo.endLon}");

      // Format coordinates exactly like Android code: DecimalFormat("##.###")
      String _formatDecimal(double value) {
        final formatter = NumberFormat("##.###");
        return formatter.format(value);
      }

      // Use exact same structure as Android code with hardcoded IDs
      List<Map<String, Object>> coordinatesList = [
        {
          "id": 12012, // Hardcoded start ID like Android
          "lat": _formatDecimal(addressPojo.startLat),
          "lng": _formatDecimal(addressPojo.startLon),
        },
        {
          "id": 12013, // Hardcoded end ID like Android
          "lat": _formatDecimal(addressPojo.endLat),
          "lng": _formatDecimal(addressPojo.endLon),
        }
      ];

      print("🌍 Request payload: $coordinatesList");

      // Use the original API like Android code
      const String reverseGeocodeBaseUrl = "https://routing.roadcast.xyz";
      final String fullUrl = '$reverseGeocodeBaseUrl/reverse';
      
      print("🌍 Making API call to: $fullUrl");
      print("🌍 Request body: ${jsonEncode(coordinatesList)}");
      
      final result = await _apiService.post(
        fullUrl,
        body: coordinatesList,
      );

      print("🌍 Raw API result type: ${result.runtimeType}");
      
      if (result is Success) {
        print("🌍 API Response success: ${result.value}");
        print("🌍 API Response type: ${result.value.runtimeType}");
        print("🌍 API Response full content: ${jsonEncode(result.value)}");
        
        // Parse response exactly like Android code
        String startAddress = "No Address";
        String endAddress = "No Address";

        // Look for "12012" and "12013" keys exactly like Android
        if (result.value["12012"] != null) {
          final startData = result.value["12012"];
          print("🌍 Start coordinate data: ${jsonEncode(startData)}");
          startAddress = startData["display_name"] ?? "No Address";
          print("🌍 Start address found: $startAddress");
        } else {
          print("🌍 No data found for key '12012'");
          print("🌍 Available keys: ${result.value.keys.toList()}");
        }

        if (result.value["12013"] != null) {
          final endData = result.value["12013"];
          print("🌍 End coordinate data: ${jsonEncode(endData)}");
          endAddress = endData["display_name"] ?? "No Address";
          print("🌍 End address found: $endAddress");
        } else {
          print("🌍 No data found for key '12013'");
        }

        print("🌍 Final addresses - Start: $startAddress, End: $endAddress");
        
        // CRITICAL FIX: Use trip ID (start_position_id) as unique identifier like Android
        final addressResponse = AddressResponse(
          positionId: addressPojo.id, // This is start_position_id - unique per trip!
          deviceId: addressPojo.deviceId, // Keep device ID for reference
          startAddress: startAddress,
          endAddress: endAddress,
        );
        
        return Success(addressResponse);
      } else {
        print("🌍 API call failed: ${result.toString()}");
        return Error(ErrorWithMessage(message: "Failed to fetch addresses"));
      }
    } catch (e) {
      CustomLog.error(this, "Error in getAddressFromServer", e);
      return Error(ErrorWithMessage(message: "Failed to fetch addresses: ${e.toString()}"));
    }
  }

  /// Batch process multiple address requests
  Future<List<AddressResponse>> fetchAddressesForTrips(List<dynamic> tripReports) async {
    List<AddressResponse> addresses = [];
    
    print("🌍 Service: Starting to fetch addresses for ${tripReports.length} trip reports");
    
    // CRITICAL FIX: Process each trip individually (don't deduplicate by device ID)
    // Each trip should have its own unique address based on its specific start/end coordinates
    for (int i = 0; i < tripReports.length; i++) {
      final report = tripReports[i];
      print("🌍 Service: Processing trip ${i + 1}/${tripReports.length}");
      print("   Trip ID: ${report.startPositionId}");
      print("   Device ID: ${report.deviceId}");
      print("   Start: ${report.startLat}, ${report.startLng}");
      print("   End: ${report.endLat}, ${report.endLng}");
      
      final addressPojo = AddressPojo.fromTripReport(report);
      final result = await getAddressFromServer(addressPojo);
      
      if (result is Success<AddressResponse>) {
        addresses.add(result.value);
        print("🌍 Service: Successfully added address for trip ${result.value.positionId} (device ${result.value.deviceId})");
      } else {
        // Add fallback "No Address" entry for failed requests
        final fallbackAddress = AddressResponse(
          positionId: report.startPositionId,
          deviceId: report.deviceId,
          startAddress: "No Address",
          endAddress: "No Address",
        );
        addresses.add(fallbackAddress);
        print("🌍 Service: Added fallback address for failed trip ${report.startPositionId}");
      }
      
      // Add delay between requests to avoid overwhelming the server
      if (i < tripReports.length - 1) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    
    print("🌍 Service: Completed address fetching for trips, returning ${addresses.length} addresses");
    return addresses;
  }

  /// Get address for a single stop location
  Future<Result<StopAddressResponse>> getStopAddressFromServer(StopAddressPojo stopPojo) async {
    try {
      print("🌍 Making API call for stop address: $routingApiUrl");
      
      // Format coordinates to 3 decimal places like Android
      final formatter = NumberFormat("##.###");
      final latStr = formatter.format(stopPojo.latitude);
      final lngStr = formatter.format(stopPojo.longitude);
      
      print("🌍 Stop formatted coordinates: $latStr, $lngStr");
      
      // Create request payload similar to Android - using single coordinate with hardcoded ID 12012
      final requestBody = [
        {
          "id": 12012, // Use hardcoded ID like Android for single location
          "lat": latStr,
          "lng": lngStr,
        }
      ];
      
      print("🌍 Stop API request body: ${jsonEncode(requestBody)}");
      
      final result = await _apiService.post(
        routingApiUrl,
        body: requestBody,
      );
      
      print("🌍 Stop API response result type: ${result.runtimeType}");
      
      if (result is Success) {
        print("🌍 Stop API call successful");
        print("🌍 Stop response data: ${jsonEncode(result.value)}");
        
        String address = "No Address";
        
        // Parse response similar to Android code
        if (result.value.containsKey("12012")) {
          final locationData = result.value["12012"];
          print("🌍 Stop location data: ${jsonEncode(locationData)}");
          address = locationData["display_name"] ?? "No Address";
          print("🌍 Stop address found: $address");
        } else {
          print("🌍 No data found for key '12012' in stop response");
        }

        print("🌍 Final stop address: $address");
        
        final stopAddressResponse = StopAddressResponse(
          stopId: stopPojo.stopId,
          deviceId: stopPojo.deviceId,
          address: address,
        );
        
        return Success(stopAddressResponse);
      } else {
        print("🌍 Stop API call failed: ${result.toString()}");
        return Error<StopAddressResponse>(ErrorWithMessage(message: "Failed to fetch stop address"));
      }
    } catch (e) {
      CustomLog.error(this, "Error in getStopAddressFromServer", e);
      return Error<StopAddressResponse>(ErrorWithMessage(message: "Failed to fetch stop address: ${e.toString()}"));
    }
  }

  /// Batch process multiple stop address requests
  Future<List<StopAddressResponse>> fetchAddressesForStops(List<dynamic> stopReports) async {
    List<StopAddressResponse> addresses = [];
    
    print("🌍 Service: Starting to fetch addresses for ${stopReports.length} stop reports");
    
    for (int i = 0; i < stopReports.length; i++) {
      final report = stopReports[i];
      print("🌍 Service: Processing stop ${i + 1}/${stopReports.length}");
      print("   Device ID: ${report.deviceId}");
      print("   Start Time: ${report.startTime}");
      print("   Location: ${report.latitude}, ${report.longitude}");
      
      final stopPojo = StopAddressPojo.fromStopReport(report);
      final result = await getStopAddressFromServer(stopPojo);
      
      if (result is Success<StopAddressResponse>) {
        addresses.add(result.value);
        print("🌍 Service: Successfully added address for stop ${result.value.stopId} (device ${result.value.deviceId})");
      } else {
        // Add fallback "No Address" entry for failed requests
        final fallbackAddress = StopAddressResponse(
          stopId: stopPojo.stopId,
          deviceId: stopPojo.deviceId,
          address: "No Address",
        );
        addresses.add(fallbackAddress);
        print("🌍 Service: Added fallback address for failed stop ${stopPojo.stopId}");
      }
      
      // Add delay between requests to avoid overwhelming the server
      if (i < stopReports.length - 1) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    
    print("🌍 Service: Completed address fetching for stops, returning ${addresses.length} addresses");
    return addresses;
  }

  /// Get address for a single summary location
  Future<Result<SummaryAddressResponse>> getSummaryAddressFromServer(SummaryAddressPojo summaryPojo) async {
    try {
      print("🌍 Service: Making API call for summary addresses");
      print("   Summary ID: ${summaryPojo.summaryId}");
      print("   Device ID: ${summaryPojo.deviceId}");
      print("   Start: ${summaryPojo.startLat}, ${summaryPojo.startLng}");
      print("   End: ${summaryPojo.endLat}, ${summaryPojo.endLng}");

      // Format coordinates to 3 decimal places matching Android
      final NumberFormat formatter = NumberFormat("##.###");
      final String startLatFormatted = formatter.format(summaryPojo.startLat);
      final String startLngFormatted = formatter.format(summaryPojo.startLng);
      final String endLatFormatted = formatter.format(summaryPojo.endLat);
      final String endLngFormatted = formatter.format(summaryPojo.endLng);

      // Create coordinate list with hardcoded IDs like Android implementation
      final coordinateList = [
        {
          'id': 12012, // Start location (hardcoded like Android)
          'lat': startLatFormatted,
          'lng': startLngFormatted,
        },
        {
          'id': 12013, // End location (hardcoded like Android)
          'lat': endLatFormatted,
          'lng': endLngFormatted,
        }
      ];

      print("🌍 Service: Making POST request to $routingApiUrl");
      print("🌍 Service: Coordinate list: $coordinateList");

      final result = await _apiService.post(
        routingApiUrl,
        body: coordinateList,
      );

      if (result is Success) {
        final Map<String, dynamic> responseData = result.value;
        print("🌍 Service: API response received: $responseData");

        // Parse addresses for start (12012) and end (12013) locations
        String startAddress = "No Address";
        String endAddress = "No Address";

        // Look for start address (12012)
        if (responseData.containsKey("12012")) {
          final startData = responseData["12012"];
          if (startData is Map<String, dynamic> && startData.containsKey("display_name")) {
            startAddress = startData["display_name"] ?? "No Address";
          }
        }

        // Look for end address (12013)
        if (responseData.containsKey("12013")) {
          final endData = responseData["12013"];
          if (endData is Map<String, dynamic> && endData.containsKey("display_name")) {
            endAddress = endData["display_name"] ?? "No Address";
          }
        }

        print("🌍 Service: Final summary addresses - Start: $startAddress, End: $endAddress");

        final summaryAddressResponse = SummaryAddressResponse(
          summaryId: summaryPojo.summaryId,
          deviceId: summaryPojo.deviceId,
          startAddress: startAddress,
          endAddress: endAddress,
        );

        return Success(summaryAddressResponse);
      } else {
        print("🌍 Summary API call failed: ${result.toString()}");
        return Error<SummaryAddressResponse>(ErrorWithMessage(message: "Failed to fetch summary address"));
      }
    } catch (e) {
      CustomLog.error(this, "Error in getSummaryAddressFromServer", e);
      return Error<SummaryAddressResponse>(ErrorWithMessage(message: "Failed to fetch summary address: ${e.toString()}"));
    }
  }

  /// Batch process multiple summary address requests
  Future<List<SummaryAddressResponse>> fetchAddressesForSummaries(List<dynamic> summaryReports) async {
    List<SummaryAddressResponse> addresses = [];
    
    print("🌍 Service: Starting to fetch addresses for ${summaryReports.length} summary reports");
    
    // Process each summary individually
    for (int i = 0; i < summaryReports.length; i++) {
      final report = summaryReports[i];
      print("🌍 Service: Processing summary ${i + 1}/${summaryReports.length}");
      print("   Summary ID: ${report.deviceId}_${report.startTime}");
      print("   Device ID: ${report.deviceId}");
      print("   Start: ${report.startLat}, ${report.startLng}");
      print("   End: ${report.endLat}, ${report.endLng}");
      
      final summaryPojo = SummaryAddressPojo.fromSummaryReport(report);
      final result = await getSummaryAddressFromServer(summaryPojo);
      
      if (result is Success<SummaryAddressResponse>) {
        addresses.add(result.value);
        print("🌍 Service: Successfully got address for summary ${summaryPojo.summaryId}");
      } else {
        // Add fallback "No Address" entry
        final fallbackAddress = SummaryAddressResponse(
          summaryId: summaryPojo.summaryId,
          deviceId: summaryPojo.deviceId,
          startAddress: "No Address",
          endAddress: "No Address",
        );
        addresses.add(fallbackAddress);
        print("🌍 Service: Failed to get address for summary ${summaryPojo.summaryId}, added fallback");
      }
      
      // Rate limiting: wait 1 second between requests
      if (i < summaryReports.length - 1) {
        print("🌍 Service: Waiting 1 second before next request...");
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    
    print("🌍 Service: Completed summary address fetching, returning ${addresses.length} addresses");
    return addresses;
  }
}