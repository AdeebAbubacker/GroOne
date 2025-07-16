import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';


class DriverLoadService {
  final ApiService _apiService;
  DriverLoadService(this._apiService);

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
    required int loadStatus,
    required String driverId,
    String search = "",
    bool forceRefresh = false
  }) async {
    try {
      final url = "${ApiUrls.driverLoadListBaseUrl}&driverId=$driverId&loadStatus=$loadStatus";
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

