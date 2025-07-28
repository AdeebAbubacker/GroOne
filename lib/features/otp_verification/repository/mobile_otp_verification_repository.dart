import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/otp_verification/api_request/mobile_otp_verification_api_request.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_resend_model.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/otp_verification/service/mobile_otp_verification_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class MobileOtpVerificationRepository {
  final MobileOtpVerificationService _otpService;
  final AuthRepository _authRepository;
  MobileOtpVerificationRepository(this._otpService, this._authRepository);

  /// Submit Otp Repo
  Future<Result<MobileOtpVerificationModel?>> sendOtp(OtpRequest request) async {
    try {
      Result<dynamic> result = await _otpService.fetchSendOtpData(request);
      if (result is Success<MobileOtpVerificationModel?>) {
        if (result.value != null) {
          dynamic saveUserResult;
            saveUserResult = await _authRepository.saveUserInfoFromLogin(result.value!);
            if (saveUserResult is Success) {
              return result;
            }
            if (saveUserResult is Error) {
              return Error(saveUserResult.type);
            }
        }
      }
      if (result is Error) {
        return Error(result.type);
      }
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Resend Otp Repo
  Future<Result<MobileOtpResendModel>> resendOtp(
    LoginApiRequest request,
  ) async {
    try {
      return await _otpService.resendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}
