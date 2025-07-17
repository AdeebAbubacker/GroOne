import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';


class DriverLoadService {
  final ApiService _apiService;
  DriverLoadService(this._apiService);

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
    required int status,
    required String driverId,
    String search = "",
    int? laneId,
    bool forceRefresh = false
  }) async {
    try {
      // String url = "${ApiUrls.driverLoadListBaseUrl}&driverId=$driverId&loadStatus=$status";
        // String url = "${ApiUrls.driverLoadListBaseUrl}&driverId=$driverId";
        String url = "https://gro-devapi.letsgro.co/load-discovery/api/v1/load/driver/list?isDriver=true&driverId=315bafa0-0d0d-4eb6-81d1-85f6e4b79e7c";  
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
}

