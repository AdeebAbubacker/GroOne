import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/network/api_urls.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';
import '../api_request/login_in_api_request.dart';
import '../model/login_model.dart';

class LoginInService {
  final ApiService _apiService;

  LoginInService(this._apiService);

  Future<Result<LoginApiResponseModel>> login(LoginApiRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.login,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => LoginApiResponseModel.fromJson(data),
        );
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
