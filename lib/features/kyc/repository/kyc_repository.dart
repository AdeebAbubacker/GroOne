import 'dart:io';

import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/file_upload_response.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';
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

  Future<Result<AadhaarOtpModel>> kycSendOtp(AddharOtpApiRequest request) async {
    try {
      return await _kycService.kycSendOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<AadhaarVerifyOtpModel>> verifyAddharOtp(
    AddharVerifyOtpApiRequest request,
  ) async {
    try {
      return await _kycService.kycVerifyOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<bool>> verifyGST(VerifyGstApiRequest request) async {
    try {
      return await _kycService.verifyGst(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<bool>> verifyTan(VerifyTanApiRequest request) async {
    try {
      return await _kycService.verifyTan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<bool>> verifyPan(VerifyPanApiRequest request) async {
    try {
      return await _kycService.verifyPan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<SubmitKycModel>> submitKyc(SubmitKycApiRequest request,{required String userId}) async {
    try {
      return await _kycService.submitKyc(request,userID:userId );
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload GST Repo
  Future<Result<UploadGSTDocumentModel>> getUploadGstData(File file) async {
    try {
      return await _kycService.fetchUploadGstData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload TAN Repo
  Future<Result<UploadTANDocumentModel>> getUploadTanData(File file) async {
    try {
      return await _kycService.fetchUploadTanData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload PAN Repo
  Future<Result<UploadPANDocumentModel>> getUploadPanData(File file) async {
    try {
      return await _kycService.fetchUploadPanData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload TDS Repo
  Future<Result<UploadTDSDocumentModel>> getUploadTdsData(File file) async {
    try {
      return await _kycService.fetchUploadTdsData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload Cancelled Repo
  Future<Result<UploadCancelledCheckedDocumentModel>> getUploadCancelledCheckedData(File file) async {
    try {
      return await _kycService.fetchUploadCancelledCheckedData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get State Repo
  Future<Result<StateModel>> getStateData() async {
    try {
      return await _kycService.fetchStateData();
    } catch (e) {
      CustomLog.error(this, "Failed to get state data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get City Repo
  Future<Result<CityModel>> getCityData(String stateName) async {
    try {
      return await _kycService.fetchCityData(stateName);
    } catch (e) {
      CustomLog.error(this, "Failed to get city data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}
