import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

class VpHomeService {
  final ApiService _apiService;
  VpHomeService(this._apiService);

  Future<Result<VpMyLoadResponse>> getVpMyLoad({required String userID}) async {
    try {
      final result = await _apiService.get(
        "${ApiUrls.getAllVpLoads}/vp/load",
        queryParams: {'customerId': userID},
        forceRefresh: true,
      );

      if (result is Success) {
        final vpMyLoads = VpMyLoadResponse.fromJson(result.value);
        return Success(vpMyLoads);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<VehicleListResponse>> getVehicleDetails({
    required String userId,
    String? search,
    int? page,
    int? pageSize = 5,
  }) async {
    try {
      // Base URL
      String url =
        "${ApiUrls.vehicleDetails}$userId?page=1&limit=5";

      // Append search if provided
      if (search != null && search.trim().isNotEmpty) {
        url = "$url?search=$search";
      }

      final result = await _apiService.get(url);

      if (result is Success) {
        final vehicleListResponse = VehicleListResponse.fromJson(result.value);
        return Success(vehicleListResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<DriverListResponse>> getDriverDetails({
    required String userId,
    String? search,
    int? page,
    int? pageSize = 10,
  }) async {
    try {
      // Base URL
      String url =
          "${ApiUrls.driverDetails}?customerId=$userId&page=$page&limit=$pageSize";

      // Append search if provided
      if (search != null && search.trim().isNotEmpty) {
        url = "$url&search=${Uri.encodeComponent(search)}";
      }
      final result = await _apiService.get(url);

      if (result is Success) {
        final driverResponse = DriverListResponse.fromJson(result.value);
        return Success(driverResponse);
      } else if (result is Error) {
        print("Error in getDriverDetails Error: $result");
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e, stackTrace) {
      // Print the error and full stack trace
      print("Error in getDriverDetails: $e");
      print(stackTrace);

      // Optionally log it to a monitoring service here

      return Error(DeserializationError());
    }
  }

  Future<Result<ScheduleTripResponse>> scheduleTripResponse({
    required ScheduleTripRequest apiRequest,
  }) async {
    try {
      final result = await _apiService.post(
        ApiUrls.scheduleTrip,
        body: apiRequest,
      );

      if (result is Success) {
        final scheduleTripResponse = ScheduleTripResponse.fromJson(
          result.value,
        );
        return Success(scheduleTripResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<VpRecentLoadResponse>> getVpRecentLoads(
    String customerId,
  ) async {
    try {
      final result = await _apiService.get(
        '${ApiUrls.getAllVpLoads}/vp/load?customerId=$customerId',
        forceRefresh: true,
        queryParams: {"type": 1},
      );

      if (result is Success) {
        final recentLoads = VpRecentLoadResponse.fromJson(result.value);
        return Success(recentLoads);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<VpLoadAcceptModel>> fetchVpAcceptLoad({
    required String userId,
    required String loadId,
  }) async {
    try {
      final result = await _apiService.put(
        '${ApiUrls.vpAcceptLoad}$userId/$loadId',
      );
      if (result is Success) {
        final vpLoadAccepted = VpLoadAcceptModel.fromJson(result.value);
        return Success(vpLoadAccepted);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<DirectionResponse?> getDirectionRoute({
    required String? pickupLat,
    String? pickupLong,
    String? destinationLat,
    String? destinationLong,
  }) async {
    try {
      final result = await _apiService.get(
        ApiUrls.googleDirectionApi,
        queryParams: {
          "origin":
              "${double.tryParse(pickupLat ?? "0")},${double.tryParse(pickupLong ?? "0")}",
          "destination":
              "${double.tryParse(destinationLat ?? "0")},${double.tryParse(destinationLong ?? "0")}",
        },
      );
      if (result is Success) {
        final vpLoadAccepted = DirectionResponse.fromJson(result.value);
        return vpLoadAccepted;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
