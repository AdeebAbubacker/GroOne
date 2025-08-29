import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_resend_model.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../api_request/mobile_otp_verification_api_request.dart';
import '../model/mobile_otp_verification_model.dart';

class MobileOtpVerificationService {
  final ApiService _apiService;
  MobileOtpVerificationService(this._apiService);

  //
  Future<Result<MobileOtpVerificationModel>> fetchSendOtpData(
    OtpRequest request,
  ) async {
    try {
      final result = await _apiService.post(ApiUrls.login, body: request);
      if (result is Success) {
        final data = MobileOtpVerificationModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<MobileOtpResendModel>> resendOtp(
    LoginApiRequest request,
  ) async {
    try {
      final result = await _apiService.post(ApiUrls.resendOtp, body: request);
      if (result is Success) {
        final data = MobileOtpResendModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
}
