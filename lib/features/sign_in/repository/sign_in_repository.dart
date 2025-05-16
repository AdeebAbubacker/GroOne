import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/sign_in/api_request/sign_in_api_request.dart';
import 'package:gro_one_app/features/sign_in/model/sign_in_model.dart';
import 'package:gro_one_app/features/sign_in/service/sign_in_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class SignInRepository {
  final SignInService _signInService;
  SignInRepository(this._signInService);

  Future<Result<SignInModel>> requestSignIn(SignInApiRequest request) async {
    try {
      return await _signInService.fetchSignInData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Sign In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}