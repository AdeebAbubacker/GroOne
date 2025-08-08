import 'package:gro_one_app/features/login/api_request/notification_request_model.dart';
import 'package:gro_one_app/features/login/model/notification_response_model.dart';

import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../api_request/login_in_api_request.dart';
import '../model/login_model.dart';
import '../service/login_service.dart';

class LoginInRepository {
  final LoginInService _logInService;
  LoginInRepository(this._logInService);

  Future<Result<LoginApiResponseModel>> requestLogin(LoginApiRequest request) async {
    try {
      return await _logInService.login(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<DeviceTokenModel>> saveDeviceToken(NotificationRequestModel? request) async {
    try {
      return await _logInService.saveDeviceToken(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}