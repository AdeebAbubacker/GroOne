import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/otp_verification/api_request/otp_request.dart';
import 'package:gro_one_app/features/otp_verification/model/otp_response.dart';

import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../service/otp_service.dart';

class OtpRepository {
  final OtpService _otpService;
  final AuthRepository _authRepository;
  OtpRepository(this._otpService, this._authRepository);

  // Submit Otp
  Future<Result<OtpResponse?>> sendOtp(OtpRequest request) async {
    try {
      Result<dynamic> result =  await _otpService.sendOtp(request);
      if (result is Success<OtpResponse?>) {
        if(result.value != null){
          Result saveUserResult = await _authRepository.saveUserInfoFromLogin(result.value!);
          if(saveUserResult is Success){
            return result;
          }
          if(saveUserResult is Error){
            return Error(saveUserResult.type);
          }
        }
      }
      if(result is Error){
        return Error(result.type);
      }
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  // Resend Otp
  Future<Result<LoginApiResponseModel>> resendOtp(LoginApiRequest request) async {
    try {
      return await _otpService.resendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
