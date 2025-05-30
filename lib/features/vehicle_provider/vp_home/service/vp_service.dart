import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpHomeService {
  final ApiService _apiService;

  VpHomeService(this._apiService);

  Future<Result<VpMyLoadResponse>> getVpMyLoad() async {
    try {
      _apiService.clearCache();
      final result = await _apiService.get(ApiUrls.vpLoadList);

      if (result is Success) {
        _apiService.clearCache();
        return await _apiService.getResponseStatus(
          result.value,
          (data) => VpMyLoadResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<VehicleListResponse>> getVehicleDetails({
    required String userId,
  }) async {
    try {
      final result = await _apiService.get(ApiUrls.vehicleDetails + userId);
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => VehicleListResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<DriverListResponse>> getDriverDetails({
    required String userId,
  }) async {
    try {
      final result = await _apiService.get(ApiUrls.driverDetails + userId);
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => DriverListResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  } Future<Result<ScheduleTripResponse>> scheduleTripResponse({
    required ScheduleTripRequest apiRequest,
  }) async {
    try {
      final result = await _apiService.post(ApiUrls.scheduleTrip,body: apiRequest);
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => ScheduleTripResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
}
