import 'package:gro_one_app/data/network/api_urls.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';
import '../../vp_home/model/vp_recent_load_response.dart';

class VpLoadService {
  final ApiService _apiService;
  VpLoadService(this._apiService);

  Future<Result<List<VpRecentLoadData>>> fetchLoads({
    required String customerId,
    required int type,
    String search = "",
    bool forceRefresh = false
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.getAllVpLoads}/vp/load?customerId=$customerId&type=$type&search=$search',
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value['data'] as List;
        final loads = data.map((e) => VpRecentLoadData.fromJson(e)).toList();
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

