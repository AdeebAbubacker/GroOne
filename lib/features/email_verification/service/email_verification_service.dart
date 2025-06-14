import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class EmailVerificationService {
  final ApiService _apiService;
  EmailVerificationService(this._apiService);

  /// Send Otp
  Future<Result<EmailOtpModel>> fetchSendOtp(String email) async {
    try {
      final url = ApiUrls.sendEmailOtp;
      final result = await _apiService.post(url, body: {"email": email});
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> EmailOtpModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Resend OTP
  Future<Result<EmailOtpModel>> fetchResendOtpData(String email) async {
    try {
      final url = ApiUrls.resendEmailOtp;
      final result = await _apiService.post(url, body: {"email": email});
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> EmailOtpModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Verify OTP
  Future<Result<VerifyEmailOtpModel>> fetchVerifyOtpData(VerifyEmailOtpApiRequest request) async {
    try {
      final url = ApiUrls.emailOTPCodeVerification;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> VerifyEmailOtpModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

}
