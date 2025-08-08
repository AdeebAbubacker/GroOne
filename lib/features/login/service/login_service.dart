import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/login/api_request/notification_request_model.dart';
import 'package:gro_one_app/features/login/model/notification_response_model.dart';

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
        final data = LoginApiResponseModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
  Future<Result<DeviceTokenModel>> saveDeviceToken(NotificationRequestModel? notificationRequestModel) async {
    try {
      final saveDeviceToken= ApiUrls.saveDeviceToken;

      final result = await _apiService.post(
        saveDeviceToken,
        body: notificationRequestModel?.toJson(),
      );

      if (result is Success) {
        final data = DeviceTokenModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
}


