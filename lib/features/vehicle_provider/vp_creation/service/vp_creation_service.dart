import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpCreationService {
  final ApiService _apiService;
  VpCreationService(this._apiService);

  Future<Result<VpCreationModel>> fetchVpCreationData(VpCreationApiRequest request) async {
    try {
      final url = ApiUrls.createVpAccount;
      final result = await _apiService.put(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> VpCreationModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }



}