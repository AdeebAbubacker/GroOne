import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart'
    as api_models;
import 'package:gro_one_app/features/en-dhan_fuel/model/vehicle_verification_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/service/en-dhan_services.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class EnDhanRepository {
  final EnDhanService _enDhanService;

  EnDhanRepository(this._enDhanService);

  /// Check KYC Documents Repository
  Future<Result<EnDhanKycCheckModel>> checkKycDocuments(String customerId) async {
    try {
      return await _enDhanService.checkKycDocuments(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to check KYC documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload KYC Documents Repository
  Future<Result<EnDhanKycModel>> uploadKycDocuments(
    EnDhanKycApiRequest request,
    String customerId,
  ) async {
    try {
      return await _enDhanService.uploadKycDocuments(request, customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to upload KYC documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Create Customer Repository
  Future<Result<api_models.EnDhanCustomerCreationResponse>> createCustomer(
    EnDhanCustomerCreationApiRequest request,
  ) async {
    try {
      return await _enDhanService.createCustomer(request);
    } catch (e) {
      CustomLog.error(this, "Failed to create customer", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch States Repository
  Future<Result<api_models.EnDhanStateResponse>> fetchStates() async {
    try {
      return await _enDhanService.fetchStates();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch states", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch Districts Repository
  Future<Result<api_models.EnDhanDistrictResponse>> fetchDistricts(
    int stateId,
  ) async {
    try {
      return await _enDhanService.fetchDistricts(stateId);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch districts", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch Zonal Offices Repository
  Future<Result<api_models.EnDhanZonalResponse>> fetchZonalOffices() async {
    try {
      return await _enDhanService.fetchZonalOffices();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch zonal offices", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch Regional Offices Repository
  Future<Result<api_models.EnDhanRegionalResponse>> fetchRegionalOffices(
    int zoneId,
  ) async {
    try {
      return await _enDhanService.fetchRegionalOffices(zoneId);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch regional offices", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch Vehicle Types Repository
  Future<Result<api_models.EnDhanVehicleTypeResponse>>
  fetchVehicleTypes() async {
    try {
      return await _enDhanService.fetchVehicleTypes();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicle types", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload Document Repository
  Future<Result<DocumentUploadResponse>> uploadDocument(File file) async {
    try {
      return await _enDhanService.uploadDocument(file);
    } catch (e) {
      CustomLog.error(this, "Failed to upload document", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload KYC Documents Multipart Repository
  Future<Result<EnDhanKycModel>> uploadKycDocumentsMultipart(
    EnDhanKycMultipartApiRequest request,
    String customerId,
  ) async {
    try {
      return await _enDhanService.uploadKycDocumentsMultipart(request, customerId);
    } catch (e) {
      CustomLog.error(this, "Error uploading KYC documents", e);
      return Error(GenericError());
    }
  }

  /// Fetch Card Balance Repository
  Future<Result<api_models.EnDhanCardBalanceResponse>> fetchCardBalance() async {
    print('🔄 EnDhanRepository.fetchCardBalance called');
    try {
      final result = await _enDhanService.fetchCardBalance();
      print('📥 Repository result: ${result.runtimeType}');
      return result;
    } catch (e) {
      print('❌ Repository error: $e');
      CustomLog.error(this, "Error fetching card balance", e);
      return Error(GenericError());
    }
  }

  /// Fetch Cards List
  Future<Result<api_models.EnDhanCardListModel>> fetchCards({
    String? searchTerm,
  }) async {
    print('🔄 EnDhanRepository.fetchCards called with searchTerm: $searchTerm');
    try {
      final result = await _enDhanService.fetchCards(searchTerm: searchTerm);
      print('📥 Repository result: ${result.runtimeType}');
      return result;
    } catch (e) {
      print('❌ Repository error: $e');
      CustomLog.error(this, "Error fetching cards", e);
      return Error(GenericError());
    }
  }

  // ==================== Aadhaar Verification Repository ====================

  /// Send Aadhaar OTP Repository
  Future<Result<AadhaarSendOtpResponse>> sendAadhaarOtp(
    AadhaarSendOtpRequest request,
  ) async {
    try {
      return await _enDhanService.sendAadhaarOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to send Aadhaar OTP", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify Aadhaar OTP Repository
  Future<Result<AadhaarVerifyOtpResponse>> verifyAadhaarOtp(
    AadhaarVerifyOtpRequest request,
  ) async {
    try {
      return await _enDhanService.verifyAadhaarOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify Aadhaar OTP", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify PAN Repository
  Future<Result<PanVerificationResponse>> verifyPan(
    PanVerificationRequest request,
  ) async {
    try {
      return await _enDhanService.verifyPan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify PAN", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify Vehicle Repository
  Future<Result<VehicleVerificationResponse>> verifyVehicle(
    VehicleVerificationRequest request,
  ) async {
    try {
      return await _enDhanService.verifyVehicle(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify vehicle", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
