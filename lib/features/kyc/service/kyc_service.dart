import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/model/addhar_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class KycService {
  final ApiService _apiService;
  KycService(this._apiService);


  /// Sent Kyc Otp Service
  Future<Result<AadhaarOtpModel>> kycSendOtp(AddharOtpApiRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.aadhaarSendOtp, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => AadhaarOtpModel.fromJson(data));
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


  /// Verify Otp Service
  Future<Result<AadhaarVerifyOtpModel>> kycVerifyOtp(AddharVerifyOtpApiRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.aadhaarVerifyOtp, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => AadhaarVerifyOtpModel.fromJson(data));
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


  /// Verify Gst Service
  Future<Result<bool>> verifyGst(VerifyGstApiRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.gst, body: request);
      if (result is Success) {
        return Success(true);
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


  /// Verify Tan Service
  Future<Result<bool>> verifyTan(VerifyTanApiRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.tan, body: request);
      if (result is Success) {
        return Success(true);
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


  /// Verify Pan Service
  Future<Result<bool>> verifyPan(VerifyPanApiRequest request) async {
    try {
      final result = await _apiService.post(ApiUrls.pan, body: request);
      if (result is Success) {
        return Success(true);
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


  /// Upload Gst File Repo Service
  Future<Result<UploadGSTDocumentModel>> fetchUploadGstData({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: {
          "userId" : userId,
          "fileType" : fileType,
          "documentType" : documentType,
        },
      );
      if (result is Success) {
        final data = UploadGSTDocumentModel.fromJson(result.value);
        return Success(data);
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


  /// Upload Pan File Repo Service
  Future<Result<UploadPANDocumentModel>> uploadPanDoc({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
          url,
          file,
          pathName: "file",
          fields: {
            "userId" : userId,
            "fileType" : fileType,
            "documentType" : documentType,
          },
      );
      if (result is Success) {
        final data = UploadPANDocumentModel.fromJson(result.value);
        return Success(data);
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


  /// Upload tds File Repo Service
  Future<Result<UploadTDSDocumentModel>> uploadTDSDoc({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: {
          "userId" : userId,
          "fileType" : fileType,
          "documentType" : documentType,
        },
      );
      if (result is Success) {
        final data = UploadTDSDocumentModel.fromJson(result.value);
        return Success(data);
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


  /// Upload Cancelled Check File Repo Service
  Future<Result<UploadCancelledCheckedDocumentModel>> uploadCancelledCheckedDoc({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: {
          "userId" : userId,
          "fileType" : fileType,
          "documentType" : documentType,
        },
      );
      if (result is Success) {
        final data = UploadCancelledCheckedDocumentModel.fromJson(result.value);
        return Success(data);
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


  /// Upload Tan File repo Service
  Future<Result<UploadTANDocumentModel>> uploadTanDoc({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: {
          "userId" : userId,
          "fileType" : fileType,
          "documentType" : documentType,
        },
      );
      if (result is Success) {
        final data = UploadTANDocumentModel.fromJson(result.value);
        return Success(data);
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


  /// submit KYC form repo Service
  Future<Result<SubmitKycModel>> submitKyc(SubmitKycApiRequest request,{required String userID}) async {
    try {
      final result = await _apiService.post(ApiUrls.submitKyc+userID, body: request);
      if (result is Success) {
        final data = SubmitKycModel.fromJson(result.value);
        return Success(data);
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


  /// Get State Service
  Future<Result<StateModel>> fetchStateData() async {
    try {
      final url = ApiUrls.getState;
      final result = await _apiService.get(url);
      if (result is Success) {
        // final data = result.value;
        // if (data is List) {
        //   final data = StateModel.fromJson(result.value);
        //   return Success(data);
        //   // final stateList = data.map((e) => StateModel.fromJson(e)).toList();
        //   // return Success(stateList);
        // } else {
        //   return Error(GenericError());
        // }
        final data = StateModel.fromJson(result.value);
        return Success(data);
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


  /// Get City Service
  Future<Result<CityModel>> fetchCityData(String stateName) async {
    try {
      final url = ApiUrls.getCity;
      final result = await _apiService.get(url, queryParams: {"state" : stateName});
      if (result is Success) {
        // final data = result.value;
        // if (data is List) {
        //   final stateList = data.map((e) => CityModel.fromJson(e)).toList();
        //   return Success(stateList);
        // } else {
        //   return Error(GenericError());
        // }
        final data = CityModel.fromJson(result.value);
        return Success(data);
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
