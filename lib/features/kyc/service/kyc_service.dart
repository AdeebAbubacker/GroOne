import 'dart:io';

import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/file_upload_response.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/verify_gst_response.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';
import '../api_request/addhar_otp_request.dart';
import '../api_request/addhar_verify_otp_request.dart';
import '../api_request/verify_pan_request.dart';
import '../api_request/verify_tan_request.dart';
import '../model/addhar_otp_response.dart';
import '../model/verify_pan_response.dart';
import '../model/verify_tan_response.dart';

class KycService {
  final ApiService _apiService;

  KycService(this._apiService);

  Future<Result<AddharOtpResponse>> kycSendOtp(AddharOtpRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.aadhaarSendOtp,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => AddharOtpResponse.fromJson(data),
        );
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

  Future<Result<AddharVerifyOtpResponse>> kycVerifyOtp(AddharVerifyOtpRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.aadhaarVerifyOtp,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => AddharVerifyOtpResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }  Future<Result<VerifyGstResponse>> verifyGst(VerifyGstRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.gst,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => VerifyGstResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  } Future<Result<VerifyTanResponse>> verifyTan(VerifyTanRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.tan,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => VerifyTanResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  } Future<Result<VerifyPanResponse>> verifyPan(VerifyPanRequest request) async {
    try {
      final result = await _apiService.post(
        ApiUrls.pan,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => VerifyPanResponse.fromJson(data),
        );
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
  // Fetch Upload File
  Future<Result<UploadFileModel>> fetchUploadFileData(File files) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(url, files, pathName: "file");
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> UploadFileModel.fromJson(data));
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
  //submit KYC form

  Future<Result<SubmitKycResponse>> submitKyc(SubmitKycRequestLp request,{required String userID}) async {
    try {
      final result = await _apiService.post(
        ApiUrls.submitKyc+userID,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
              (data) => SubmitKycResponse.fromJson(data),
        );
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
