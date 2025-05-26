import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/verify_gst_response.dart';

import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../api_request/addhar_otp_request.dart';
import '../api_request/addhar_verify_otp_request.dart';
import '../api_request/verify_pan_request.dart';
import '../api_request/verify_tan_request.dart';
import '../model/addhar_otp_response.dart';
import '../model/verify_pan_response.dart';
import '../model/verify_tan_response.dart';
import '../service/kyc_service.dart';

class KycRepository {
  final KycService _kycService;

  KycRepository(this._kycService);

  Future<Result<AddharOtpResponse>> kycSendOtp(AddharOtpRequest request) async {
    try {
      return await _kycService.kycSendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<AddharVerifyOtpResponse>> verifyAddharOtp(
    AddharVerifyOtpRequest request,
  ) async {
    try {
      return await _kycService.kycVerifyOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VerifyGstResponse>> verifyGST(VerifyGstRequest request) async {
    try {
      return await _kycService.verifyGst(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VerifyTanResponse>> verifyTan(VerifyTanRequest request) async {
    try {
      return await _kycService.verifyTan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VerifyPanResponse>> verifyPan(VerifyPanRequest request) async {
    try {
      return await _kycService.verifyPan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
