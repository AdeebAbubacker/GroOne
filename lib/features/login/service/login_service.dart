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
        body: {"mobile": request.mobile, "role": request.role},
      );
      if (result is Success) {
        final data = LoginApiResponseModel.fromJson(result.value);
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


// {
//     "mobile": 9876543210,
//     "role": 2
// }