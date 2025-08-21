import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';


class DriverLoadService {
  final ApiService _apiService;
  DriverLoadService(this._apiService);

  Future<Result<DriverListDataDetails>> fetchDriverLoads({
     int? status,
    required String driverId,
    String search = "",
    int? truckTypeId,
    int? commodityTypeId,
    bool forceRefresh = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
       String url = "${ApiUrls.driverLoadListBaseUrl}&driverId=$driverId&page=$page&limit=$limit";
       if (status != null && status > 3) {
      url += "&loadStatus=$status";
      }
      if (search.isNotEmpty) {
        url += "&search=$search"; 
      }
      if (truckTypeId != null) {
        url += "&truckTypeId=$truckTypeId";
      }
      if (commodityTypeId != null) {
        url += "&commodityId=$commodityTypeId";
      }
      final response = await _apiService.get(
        url,
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value;
        final loads = DriverListDataDetails.fromJson(data);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } 
    // catch (e) {
    //   return Error(DeserializationError());
    // }
    catch (e, stackTrace) {
        print("Trip Path Parsing Error: $e");
        print("Stack trace: $stackTrace");
        throw Exception("Failed to fetch trip path data: $e");
      }
  }

  Future<Result<VpLoadAcceptModel>> changeLoadStatus({
  required String? userId,
  required String loadId,
  required int? loadStatus,
}) async {
  try {
 final statusUpdateUrl=ApiUrls.updateLoadStatus;
      final result = await _apiService.put(
        queryParams: {
          "loadStatus":loadStatus
        },
          '$statusUpdateUrl/$userId/$loadId');
    if (result is Success) {
      final changeLoadStatusResponse = VpLoadAcceptModel.fromJson(result.value);
      return Success(changeLoadStatusResponse);
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

