import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/model/trip_statement_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpTripStatementService {
  final ApiService _apiService;
  VpTripStatementService(this._apiService);

  /// Fetch Trip Settlement Service
  Future<Result<TripStatementResponse>> fetchTripStatement() async {
    try {
      final url = ApiUrls.getTripStatement;
      final result = await _apiService.get(url);
      if (result is Success) {
        final data= TripStatementResponse.fromJson(result.value);
        return Success(data);
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