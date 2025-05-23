import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/sign_in/api_request/sign_in_api_request.dart';
import 'package:gro_one_app/features/sign_in/model/sign_in_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpCreationService {
  final ApiService _apiService;
  VpCreationService(this._apiService);

  Future<Result<SignInModel>> fetchVpCreationData(SignInApiRequest request) async {
    try {
      final url = "signInApi";
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> SignInModel.fromJson(data));
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