import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';
import 'package:gro_one_app/features/otp_verification/api_request/otp_request.dart';
import 'package:gro_one_app/features/otp_verification/model/otp_response.dart';

import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../service/otp_service.dart';

class OtpRepository {
  final OtpService _otpService;

  OtpRepository(this._otpService);

  Future<Result<OtpResponse>> sendOtp(OtpRequest request) async {
    try {
      return await _otpService.sendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LoginApiResponseModel>> resendOtp(
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
