import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_order_list_models.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_service/gps_order_api_services.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class GpsOrderApiRepository {
  final GpsOrderApiService _gpsOrderApiService;

  GpsOrderApiRepository(this._gpsOrderApiService);

  /// Upload GPS Documents Repository
  Future<Result<GpsDocumentUploadResponse>> uploadGpsDocuments(
    GpsDocumentUploadApiRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.uploadGpsDocuments(request);
    } catch (e) {
      CustomLog.error(this, "Failed to upload GPS documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload GPS Documents Multipart Repository
  Future<Result<GpsDocumentUploadResponse>> uploadGpsDocumentsMultipart(
    GpsDocumentUploadMultipartApiRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.uploadGpsDocumentsMultipart(request);
    } catch (e) {
      CustomLog.error(this, "Error uploading GPS documents", e);
      return Error(GenericError());
    }
  }

  // ==================== Aadhaar Verification Repository ====================

  /// Send Aadhaar OTP Repository
  Future<Result<GpsAadhaarSendOtpResponse>> sendAadhaarOtp(
    GpsAadhaarSendOtpRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.sendAadhaarOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to send Aadhaar OTP", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify Aadhaar OTP Repository
  Future<Result<GpsAadhaarVerifyOtpResponse>> verifyAadhaarOtp(
    GpsAadhaarVerifyOtpRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.verifyAadhaarOtp(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify Aadhaar OTP", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify PAN Repository
  Future<Result<GpsPanVerificationResponse>> verifyPan(
    GpsPanVerificationRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.verifyPan(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify PAN", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch GPS Products Repository
  Future<Result<GpsProductListResponse>> fetchGpsProducts(
    GpsProductListRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.fetchGpsProducts(request);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch GPS products", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetch GPS Addresses Repository
  Future<Result<GpsAddressListResponse>> fetchGpsAddresses({
    required String customerId,
    int limit = 10,
    int page = 1,
    int? addrType,
  }) async {
    try {
      final request = GpsAddressListRequest(
        customerId: customerId,
        limit: limit,
        page: page,
      );
      return await _gpsOrderApiService.fetchGpsAddresses(request, addrType: addrType);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch GPS addresses", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Add GPS Address Repository
  Future<Result<GpsAddAddressResponse>> addGpsAddress(
    GpsAddAddressRequest request,
  ) async {
    try {
      return await _gpsOrderApiService.addGpsAddress(request);
    } catch (e) {
      CustomLog.error(this, "Failed to add GPS address", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Check GPS KYC Documents Repository
  Future<Result<GpsKycCheckModel>> checkKycDocuments(String customerId) async {
    try {
      return await _gpsOrderApiService.checkKycDocuments(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to check GPS KYC documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Create GPS Order Repository
  Future<Result<void>> createGpsOrder(GpsOrderRequest request) async {
    try {
      return await _gpsOrderApiService.createGpsOrder(request);
    } catch (e) {
      CustomLog.error(this, "Failed to create GPS order", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get GPS Order Summary Repository
  Future<Result<GpsOrderSummaryResponse>> getGpsOrderSummary(GpsOrderSummaryRequest request) async {
    try {
      return await _gpsOrderApiService.getGpsOrderSummary(request);
    } catch (e) {
      CustomLog.error(this, "Failed to get GPS order summary", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<GpsOrderListResponse>> getGpsCustomerOrdersList({
    required String customerId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _gpsOrderApiService.getGpsCustomerOrdersList(
        customerId: customerId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get GPS customer orders list", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
