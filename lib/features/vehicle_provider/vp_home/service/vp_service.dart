import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpHomeService {
  final ApiService _apiService;
  VpHomeService(this._apiService);

  Future<Result<VpMyLoadResponse>> getVpMyLoad({required String userID}) async {
    try {
      final result = await _apiService.get(

          "${ApiUrls.getAllVpLoads}/vp/load",queryParams: {
            "type":2,
            'customerId':userID},forceRefresh: true);

      if (result is Success) {
        final vpMyLoads=VpMyLoadResponse.fromJson(result.value);
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
  }) async {
    try {
      final result = await _apiService.get(ApiUrls.vehicleDetails + userId);

      if (result is Success) {
        final vehicleListResponse= VehicleListResponse.fromJson(result.value);
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
  }) async {
    try {
      final result = await _apiService.get(
          ApiUrls.driverDetails,
            queryParams: {
            "customerId":userId
      }
      );
      if (result is Success) {
        final driverResponse=DriverListResponse.fromJson(result.value);
        return  Success(driverResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<ScheduleTripResponse>> scheduleTripResponse({
    required ScheduleTripRequest apiRequest,
  }) async {
    try {
      final result = await _apiService.post(ApiUrls.scheduleTrip,body: apiRequest);

      if (result is Success) {
        final scheduleTripResponse= ScheduleTripResponse.fromJson(result.value);
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

  Future<Result<VpRecentLoadResponse>> getVpRecentLoads(String customerId) async {
    try {
      final result = await _apiService.get(

          '${ApiUrls.getAllVpLoads}/vp/load?customerId=$customerId',forceRefresh: true,
      queryParams: {
            "type":1
      }
      );

      if (result is Success) {
       final recentLoads= VpRecentLoadResponse.fromJson(result.value);
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

  Future<Result<VpLoadAcceptModel>> fetchVpAcceptLoad({required String userId,required String loadId}) async {
    try {
      final result = await _apiService.put(
          '${ApiUrls.vpAcceptLoad}$userId/$loadId');
      if (result is Success) {
       final vpLoadAccepted= VpLoadAcceptModel.fromJson(result.value);
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

  Future<DirectionResponse?>  getDirectionRoute({required String? pickupLat,String? pickupLong,String? destinationLat,String? destinationLong}) async {
     Dio _dio=locator<Dio>();
     try {
      return await _dio.get(
          ApiUrls.googleDirectionApi,

          queryParameters: {
            "origin":"${double.tryParse(pickupLat??"0")},${double.tryParse(pickupLong??"0")}",
            "destination":"${double.tryParse(destinationLat??"0")},${double.tryParse(destinationLong??"0")}",
            "key":"AIzaSyAQW_V1fIJSXzYD5gjAh9wnztxLnE_pJ7E"
          }
      ).then((result) {
        if(result.statusCode==200){
          return  DirectionResponse.fromJson(result.data);
        }
        return null;
      },);

    } catch (e) {
      return  null;
    }
  }



}
