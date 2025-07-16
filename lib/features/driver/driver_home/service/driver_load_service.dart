import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';


class DriverLoadService {
  final ApiService _apiService;
  DriverLoadService(this._apiService);

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
     int? loadStatus,
    required String driverId,
    String search = "",
    bool forceRefresh = false
  }) async {
    try {
    String url = "${ApiUrls.driverLoadListBaseUrl}?driverId=$driverId";

    if (loadStatus != null) {
      url += "&loadStatus=$loadStatus";
    }

    // Optionally add search query if not empty
    if (search.isNotEmpty) {
      url += "&search=$search";
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

