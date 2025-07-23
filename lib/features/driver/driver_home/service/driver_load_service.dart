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

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
     int? status,
    required String driverId,
    String search = "",
    int? laneId,
    bool forceRefresh = false
  }) async {
    try {
       String url = "${ApiUrls.driverLoadListBaseUrl}&driverId=$driverId";
       if (status != null && status != 3) {
        url += "&loadStatus=$status";
      }
      if (search.isNotEmpty) {
      url += "&search=$search";
      }
      if (laneId != null) {
        url += "&laneId=$laneId";
      }
      final response = await _apiService.get(
        url,
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value['data'] as List;
        final loads = data.map((e) => DriverLoadDetails.fromJson(e)).toList();
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
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

