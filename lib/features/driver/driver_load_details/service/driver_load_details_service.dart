
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';


class DriverLoadDetailsService {
  final ApiService _apiService;
  DriverLoadDetailsService(this._apiService);


  Future<Result<DriverLoadDetailsModel>> fetchLoadsById({
    required String loadId,
    bool forceRefresh = false
  }) async {

    try {
      final url = ApiUrls.lpLoadById;
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/load-discovery/api/v1/load/driver/315bafa0-0d0d-4eb6-81d1-85f6e4b79e7c/23d870ee-1134-4860-ae10-edf8d53f0149',
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value;
        final loads = DriverLoadDetailsModel.fromJson(data);
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

