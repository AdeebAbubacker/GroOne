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
          // Debug logging
          print("=== OTP VERIFICATION DEBUG ===");
          print("User tempflg: ${result.value?.user?.tempflg}");
          print("Token: ${result.value?.token}");
          print("KongToken access_token: ${result.value?.kongToken?.accessToken}");
          print("User ID: ${result.value?.user?.id}");
          print("User mobile: ${result.value?.user?.mobile}");
          print("User role: ${result.value?.user?.role}");
          
          CustomLog.info(this, "=== OTP VERIFICATION DEBUG ===");
          CustomLog.info(this, "User tempflg: ${result.value?.user?.tempflg}");
          CustomLog.info(this, "Token: ${result.value?.token}");
          CustomLog.info(this, "KongToken access_token: ${result.value?.kongToken?.accessToken}");
          CustomLog.info(this, "User ID: ${result.value?.user?.id}");
          CustomLog.info(this, "User mobile: ${result.value?.user?.mobile}");
          CustomLog.info(this, "User role: ${result.value?.user?.role}");
          
          // Always save user info and token regardless of tempflg status
          // This ensures we have the token for API calls even for temporary users
          print("Saving user info and token...");
          CustomLog.info(this, "Saving user info and token...");
          dynamic saveUserResult = await _authRepository.saveUserInfoFromLogin(result.value!);
          
          if (saveUserResult is Success) {
            print("✅ User info and token saved successfully");
            CustomLog.info(this, "User info and token saved successfully");
            return result;
          }
          if (saveUserResult is Error) {
            print("❌ Failed to save user info: ${saveUserResult.type}");
            CustomLog.error(this, "Failed to save user info", saveUserResult.type);
            return Error(saveUserResult.type);
          }
        }
      }
      if (result is Error) {
        print("❌ OTP verification error: ${result.type}");
        return Error(result.type);
      }
      print("❌ Generic error in OTP verification");
      return Error(GenericError());
    } catch (e) {
      print("❌ Failed to request Login: $e");
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
