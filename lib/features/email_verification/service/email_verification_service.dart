import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/send_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';


class EmailVerificationService {
  final ApiService _apiService;
  EmailVerificationService(this._apiService);

  /// Send Otp
  Future<Result<SendEmailOtpModel>> fetchSendOtp(String email, String customerId) async {
    try {
      final url = ApiUrls.sendEmailOtp;
      final result = await _apiService.post(url, body: {"customerId": customerId, "emailId": email});
      if (result is Success) {
       final sendEmailOtpResponse=  SendEmailOtpModel.fromJson(result.value);
        return  Success(sendEmailOtpResponse) ;
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  /// Verify OTP
  Future<Result<VerifyEmailOtpModel>> fetchVerifyOtpData(VerifyEmailOtpApiRequest request) async {
    try {
      final url = ApiUrls.emailOTPCodeVerification;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final verifyOtpModel=VerifyEmailOtpModel.fromJson(result.value);
        return Success(verifyOtpModel);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

}
