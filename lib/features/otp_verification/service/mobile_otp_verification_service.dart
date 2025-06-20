import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';
import '../api_request/mobile_otp_verification_api_request.dart';
import '../model/mobile_otp_verification_model.dart';

class MobileOtpVerificationService {
  final ApiService _apiService;
  MobileOtpVerificationService(this._apiService);

  //
  Future<Result<MobileOtpVerificationModel>> fetchSendOtpData(OtpRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.login, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => MobileOtpVerificationModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  Future<Result<LoginApiResponseModel>> resendOtp(LoginApiRequest request,
  ) async {
    try {
      final result = await _apiService.post(ApiUrls.resendOtp, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => LoginApiResponseModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
}
