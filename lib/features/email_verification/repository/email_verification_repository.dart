import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/service/email_verification_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class EmailVerificationRepository {
  final EmailVerificationService _emailVerificationService;
  final UserInformationRepository _userInformationRepository;
  EmailVerificationRepository(this._emailVerificationService, this._userInformationRepository);

  /// Send Email Otp Repo
  Future<Result<EmailOtpModel>> getSendOtpData(String email) async {
    try {
      return await _emailVerificationService.fetchSendOtp(email);
    } catch (e) {
      CustomLog.error(this, "Failed to request send email otp", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Resend Email Otp Repo
  Future<Result<EmailOtpModel>> getResendOtpData(String email) async {
    try {
      return await _emailVerificationService.fetchResendOtpData(email);
    } catch (e) {
      CustomLog.error(this, "Failed to request send email otp", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Verify Email Otp Repo
  Future<Result<VerifyEmailOtpModel>> getVerifyOtpData(VerifyEmailOtpApiRequest request) async {
    try {
      String customerId = await _userInformationRepository.getUserID() ?? "0";
      return await _emailVerificationService.fetchVerifyOtpData(request.copyWith(customerId: int.parse(customerId)));
    } catch (e) {
      CustomLog.error(this, "Failed to request email verification", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



}
