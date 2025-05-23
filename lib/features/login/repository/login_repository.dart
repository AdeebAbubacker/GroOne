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


}