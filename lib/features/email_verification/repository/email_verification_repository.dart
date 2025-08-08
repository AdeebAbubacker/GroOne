import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/send_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/service/email_verification_service.dart';


class EmailVerificationRepository {
  final EmailVerificationService _emailVerificationService;
  EmailVerificationRepository(this._emailVerificationService);

  /// Send Email Otp Repo
  Future<Result<SendEmailOtpModel>> getSendOtpData(String email, String userId) async {
    try {
      return await _emailVerificationService.fetchSendOtp(email, userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



  /// Verify Email Otp Repo
  Future<Result<VerifyEmailOtpModel>> getVerifyOtpData(VerifyEmailOtpApiRequest request) async {
    try {
      return await _emailVerificationService.fetchVerifyOtpData(request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



}
