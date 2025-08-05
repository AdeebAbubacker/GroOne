import 'dart:io';

import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart' as api_models;
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/api_request/init_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/model/aadhar_status_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/kyc/model/delete_document_model.dart';
import 'package:gro_one_app/features/kyc/model/file_upload_response.dart';
import 'package:gro_one_app/features/kyc/model/kyc_init_response.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/kyc/model/state_response_mode.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_aadhhar_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';
import 'package:gro_one_app/features/kyc/model/verify_gst_response.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/constant_variables.dart';

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
  final KycService _service;
  final UserInformationRepository _userInformationRepository;
  KycRepository(this._service, this._userInformationRepository);


  /// Send Kyc otp repo
  Future<Result<AadhaarOtpModel>> kycSendOtp(AddharOtpApiRequest request) async {
    try {
      return await _service.kycSendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Verify Aadhaar Repo
  Future<Result<AadhaarVerifyOtpModel>> verifyAadhaarOtp(AddharVerifyOtpApiRequest request) async {
    try {
      return await _service.kycVerifyOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Verify Gst Repo
  Future<Result<bool>> verifyGST(VerifyGstApiRequest request) async {
    try {
      return await _service.verifyGst(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Verify Tan Repo
  Future<Result<bool>> verifyTan(VerifyTanApiRequest request) async {
    try {
      return await _service.verifyTan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Verify Pan Repo
  Future<Result<bool>> verifyPan(VerifyPanApiRequest request) async {
    try {
      return await _service.verifyPan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Submit Kyc Repo
  Future<Result<SubmitKycModel>> submitKyc(SubmitKycApiRequest request,{required String userId}) async {
    try {
      return await _service.submitKyc(request,userID:userId );
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload GST Repo
  Future<Result<UploadGSTDocumentModel>> getUploadGstData(File file) async {
    try {
      return await _service.fetchUploadGstData(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: GST_FILE_TYPE,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload TAN Repo
  Future<Result<UploadTANDocumentModel>> getUploadTanData(File file) async {
    try {
      return await _service.uploadTanDoc(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: TAN_FILE_TYPE,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload tan document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload PAN Repo
  Future<Result<UploadPANDocumentModel>> getUploadPanData(File file) async {
    try {
      return await _service.uploadPanDoc(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: PAN_FILE_TYPE,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload pan document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload TDS Repo
  Future<Result<UploadTDSDocumentModel>> getUploadTdsData(File file) async {
    try {
      return await _service.uploadTDSDoc(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: TDS_FILE_TYPE,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload tds document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload TDS Repo
  Future<Result<UploadAadharDocumentModel>> getUploadAadharDocument(File file) async {
    try {
      return await _service.uploadAadharDoc(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: AADHAAR_CARD,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload tds document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload Cancelled Repo
  Future<Result<UploadCancelledCheckedDocumentModel>> getUploadCancelledCheckedData(File file) async {
    try {
      return await _service.uploadCancelledCheckedDoc(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: CHECKED_FILE_TYPE,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload cancelled checked document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get State Repo
  Future<Result<StateModel>> getStateData({String filter = ''}) async {
    try {
      return await _service.fetchStateData(filter: filter);
    } catch (e) {
      CustomLog.error(this, "Failed to get state data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get City Repo
  Future<Result<CityModel>> getCityData(String stateName, {String filter = ''}) async {
    try {
      return await _service.fetchCityData(stateName, filter: filter);
    } catch (e) {
      CustomLog.error(this, "Failed to get city data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Create Document Repo
  Future<Result<CreateDocumentModel>> getCreateDocumentData(CreateDocumentApiRequest request) async {
    try {
      final userId = await _userInformationRepository.getUserID();
      return await _service.createDocument(request.copyWith(createdBy: userId));
    } catch (e) {
      CustomLog.error(this, "Failed to get create document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Delete Document Repo
  Future<Result<DeleteDocumentModel>> getDeleteDocumentData(String documentId) async {
    try {
      return await _service.deleteDocument(documentId);
    } catch (e) {
      CustomLog.error(this, "Failed to get delete document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Init Kyc Request
  Future<Result<KycInitResponse>> initKycRequest(KycInitRequest? initKycRequest) async {
    try {
      return await _service.initKycRequest(initKycRequest!);
    } catch (e) {
      CustomLog.error(this, "Failed to get delete document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Init Kyc Request
  Future<Result<AadharVerificationResponse>> getKYCStatus(String requestId) async {
    try {
      return await _service.getAadharStatus(requestId);
    } catch (e) {
      CustomLog.error(this, "Failed to get delete document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// fetch user role
  Future<int?> getUserRole() async {
    return await _userInformationRepository.getUserRole();
  }

  /// fetch user id
  Future<String?> getUserId() async {
    return await _userInformationRepository.getUserID();
  }

  /// fetch company Type Id
  Future<String?> getCompanyTypeId() async {
    return await _userInformationRepository.getCustomerTypeID();
  }

  

}
