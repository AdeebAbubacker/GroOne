import 'package:dio/dio.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import '../../../data/model/result.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';
import '../model/gps_vehicle_extra_info_model.dart';

class GpsVehicleExtraInfoService {
  final Dio _dio;
  final ApiService _apiService;

  GpsVehicleExtraInfoService(this._dio, this._apiService);

  /// API call to get vehicle extra info
  Future<Result<List<GpsVehicleExtraInfo>>> getVehicleExtraInfo(String token) async {
    try {
      CustomLog.info(this, "Starting GPS Get Vehicle Extra info...");
      
      // Create headers with authorization token
      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      final response = await _dio.get(
        'https://api.letsgro.co/api/v1/auth/devices?__limit=50000',
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      CustomLog.info(this, "Vehicle extra info API call successful");
      try {
        CustomLog.info(this, "Parsing Vehicle extra info response: ${response.data}");
        
        // Handle the response as a list of vehicle info
        final List<dynamic> dataList = response.data['data'] ?? response.data;
        final List<GpsVehicleExtraInfo> vehicleInfoList = dataList
            .map((item) => GpsVehicleExtraInfo.fromJson(item))
            .toList();

        CustomLog.info(
          this, "Vehicle extra info parsed successfully: ${vehicleInfoList.length} vehicles found",
        );
        return Success(vehicleInfoList);
      } catch (e) {
        CustomLog.error(this, "Error parsing device extra info response", e);
        return Error(DeserializationError());
      }
    } on DioException catch (e) {
      CustomLog.error(this, "Vehicle extra info API call failed", e);
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// API call for Multiple Share (live location sharing)
  Future<Result<String>> getMultipleShare({
    required String token,
    required String deviceId,
    required String validTill,
    required String vehicleName,
    required String category,
  }) async {
    try {
      CustomLog.info(this, "Starting Multiple Share API call...");
      
      // Create headers with authorization token
      final headers = {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      };
      
      // Query parameters (matching Android implementation)
      final queryParams = {
        'device_id': deviceId,
        'valid_till': validTill,
        'device_name': vehicleName,
        'category': category,
      };
      
      final response = await _dio.get(
        'https://api.letsgro.co/api/v1/auth/get_public_tracking_token',
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      CustomLog.info(this, "Multiple Share API call successful");
      
      if (response.statusCode == 200) {
        final String shareToken = response.data['data'] ?? response.data['token'];
        CustomLog.info(this, "Share token generated: $shareToken");
        return Success(shareToken);
      } else {
        CustomLog.error(this, "Multiple Share API failed with status: ${response.statusCode}", null);
        return Error(GenericError());
      }
    } on DioException catch (e) {
      CustomLog.error(this, "Multiple Share API call failed", e);
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Error in Multiple Share API", e);
      return Error(GenericError());
    }
  }

  /// API call to update device speed limit
  Future<Result<bool>> updateSpeedLimit({
    required String token,
    required int deviceId,
    required bool enabled,
    required String speed,
  }) async {
    try {
      CustomLog.info(this, "Starting Speed Limit Update API call...");
      
      // Convert speed to knots if enabled, else use "0"
      final double speedValue = enabled ? double.parse(speed) : 0;
      final double speedKnots = enabled ? speedValue * 0.539957 : 0;

      final attributes = {"speedLimit": speedKnots};
      final data = {
        "device_id": deviceId,
        "attributes": attributes,
      };

      final headers = {
        "Authorization": token,
        "Content-Type": "application/json",
      };

      final response = await _dio.post(
        "https://api.letsgro.co/api/v1/auth/update_device",
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      CustomLog.info(this, "Speed Limit Update API call successful");
      
      if (response.data['success'] == true) {
        CustomLog.info(this, "Speed limit updated successfully");
        return Success(true);
      } else {
        CustomLog.error(this, "Speed Limit Update API failed", null);
        return Error(GenericError());
      }
    } on DioException catch (e) {
      CustomLog.error(this, "Speed Limit Update API call failed", e);
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Error in Speed Limit Update API", e);
      return Error(GenericError());
    }
  }

  /// API call to update device extra info (PATCH request)
  Future<Result<bool>> updateDeviceExtraInfo({
    required String token,
    required String deviceId,
    required Map<String, String> data,
  }) async {
    try {
      CustomLog.info(this, "Starting Device Extra Info Update API call...");

      final headers = {
        "Authorization": token,
        "Content-Type": "application/json",
      };

      final response = await _dio.patch(
        "https://api.letsgro.co/api/v1/auth/devices/$deviceId",
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      CustomLog.info(this, "Device Extra Info Update API call successful");

      if (response.data['success'] == true) {
        CustomLog.info(this, "Device extra info updated successfully");
        return Success(true);
      } else {
        CustomLog.error(this, "Device Extra Info Update API failed", null);
        return Error(GenericError());
      }
    } on DioException catch (e) {
      CustomLog.error(this, "Device Extra Info Update API call failed", e);
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Error in Device Extra Info Update API", e);
      return Error(GenericError());
    }
  }
}
