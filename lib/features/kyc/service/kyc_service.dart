import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/api_request/init_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/model/aadhar_status_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/kyc/model/delete_document_model.dart';
import 'package:gro_one_app/features/kyc/model/doc_verification_model.dart';
import 'package:gro_one_app/features/kyc/model/kyc_init_response.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_aadhhar_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';


class KycService {
  final ApiService _apiService;
  KycService(this._apiService);


  /// Sent Kyc Otp Service
  Future<Result<AadhaarOtpModel>> kycSendOtp(AadhaarOtpApiRequest request) async {
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
      return Error(DeserializationError());
    }
  }


  /// Verify Otp Service
  Future<Result<AadhaarVerifyOtpModel>> kycVerifyOtp(AadhaarVerifyOtpApiRequest request) async {
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
      return Error(DeserializationError());
    }
  }


  /// Verify Gst Service
  Future<Result<bool>> verifyGst(VerifyGstApiRequest request) async {
    final xApiKey = ApiUrls.xApiKey;
    final udid = ApiUrls.fetchUDID;
    try {
      final result = await _apiService.post(ApiUrls.gst, body: request.toJson(),
        customHeaders: {
          "X-API-Key":xApiKey,
          "X-Application-UDID":udid
        },
      );
      if (result is Success) {
        return Success(true);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// Verify Tan Service
  Future<Result<bool>> verifyTan(VerifyTanApiRequest request) async {
    final xApiKey = ApiUrls.xApiKey;
    final udid = ApiUrls.fetchUDID;

    try {
      final result = await _apiService.post(ApiUrls.tan, body: request.toJson(),
        customHeaders: {
          "X-API-Key":xApiKey,
          "X-Application-UDID":udid
        },
      );
      if (result is Success) {
        return Success(true);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// Verified Valid Doc
  Future<Result<DocVerificationModel>> verifiedDocID({String? aadharDoc ,String? panNumber,String? tan,String? gstNumber}) async {
    try {
      final result = await _apiService.post(ApiUrls.verifiedDocument, body: {
        if(aadharDoc!=null)  "aadhar":aadharDoc,
      if(panNumber!=null)  "pan":panNumber,
      if(gstNumber!=null)  "gstin":gstNumber,
      if(tan!=null)  "tan":tan,
      },);
      if (result is Success) {
        return Success(DocVerificationModel.fromJson(result.value));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// Verify Pan Service
  Future<Result<bool>> verifyPan(VerifyPanApiRequest request) async {

    final xApiKey = ApiUrls.xApiKey;
    final udid = ApiUrls.fetchUDID;
    try {
      final result = await _apiService.post(ApiUrls.pan, body: request.toJson(),
        customHeaders: {
          "X-API-Key":xApiKey,
          "X-Application-UDID":udid
        },

      );
      if (result is Success) {
        return Success(true);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
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
      return Error(DeserializationError());
    }
  }

  /// Upload Aadhar Doc
  Future<Result<UploadAadharDocumentModel>> uploadAadharDoc({required File file, required String fileType,required String userId, required String documentType}) async {
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
        final data = UploadAadharDocumentModel.fromJson(result.value);
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
      return Error(DeserializationError());
    }
  }


    /// Get State Service
    Future<Result<StateModel>> fetchStateData({
      String? filter,
      int? page,
      int? pageSize = 10,
    }) async {
      
      try {
     final url = (filter != null && filter.trim().isNotEmpty)
        ? '${ApiUrls.getState}?search=$filter'
        : '${ApiUrls.getState}?page=$page&limit=$pageSize';


        final result = await _apiService.get(url);

        if (result is Success) {
          final data = StateModel.fromJson(result.value);
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


   /// Get City Service
  Future<Result<CityModel>> fetchCityData(String stateName, {String? filter, int? page, int? limit}) async {
    try {
       // Base URL with required params
    String url = '${ApiUrls.getCity}?state=${stateName}&page=${page}&limit=${limit}';

    // Add search if provided
    if (filter != null && filter.trim().isNotEmpty) {
      url = '$url&search=$filter';
    }

    final result = await _apiService.get(url);
      // final url = ApiUrls.getCity;
      // final result = await _apiService.get(url, queryParams: {"state" : stateName, 'search' : filter, 'page' : page,'limit' :limit});
      if (result is Success) {
        final data = CityModel.fromJson(result.value);
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


  /// Create Document Service
  Future<Result<CreateDocumentModel>> createDocument(CreateDocumentApiRequest request) async {
    try {
      final url = ApiUrls.createDocument;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data = CreateDocumentModel.fromJson(result.value);
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


  /// Delete Document Service
  Future<Result<DeleteDocumentModel>> deleteDocument(String documentId) async {
    try {
      final url = ApiUrls.deleteDocument;
      final result = await _apiService.delete(url+documentId);
      if (result is Success) {
        final data = DeleteDocumentModel.fromJson(result.value);
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

  Future<Result<KycInitResponse>> initKycRequest(KycInitRequest initKycRequest) async {
    try {
      final url = ApiUrls.digiLockerInit;
      final xApiKey = ApiUrls.xApiKey;
      final udid = ApiUrls.fetchUDID;
      final result = await _apiService.post(
          customHeaders: {
            "X-API-Key":xApiKey,
            "X-Application-UDID":udid
          },
          url,body:initKycRequest.toJson());
      if (result is Success) {
        final data = KycInitResponse.fromJson(result.value);
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



  Future<Result<AadharVerificationResponse>> getAadharStatus(String request) async {
    try {
      final url = ApiUrls.adharStatus+request;
      final xApiKey = ApiUrls.xApiKey;
      final udid = ApiUrls.fetchUDID;
      final result = await _apiService.get(
         url,
          customHeaders: {
            "X-API-Key":xApiKey,
            "X-Application-UDID":udid
          },
          );
      if (result is Success) {
        final data = AadharVerificationResponse.fromJson(result.value);
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
