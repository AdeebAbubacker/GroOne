import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/choose_role_screen/model/choose_role_model.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';


class ChooseRoleService {
  final ApiService _apiService;

  ChooseRoleService(this._apiService);

  Future<Result<ChooseRoleResponseModel>> login(LoginApiRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.login,
        body: request,
      );
      if (result is Success) {
        final data = ChooseRoleResponseModel.fromJson(result.value);
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


