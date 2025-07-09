import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class GpsOrderApiService {
  final ApiService _apiService;
  final SecuredSharedPreferences _secureSharedPrefs;

  GpsOrderApiService(this._apiService, this._secureSharedPrefs);

  /// Upload GPS Documents
  Future<Result<GpsDocumentUploadResponse>> uploadGpsDocuments(
    GpsDocumentUploadApiRequest request,
  ) async {
    try {
      final url = ApiUrls.gpsDocumentUpload;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsDocumentUploadResponse.fromJson(data),
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

  /// Upload GPS Documents Multipart
  Future<Result<GpsDocumentUploadResponse>> uploadGpsDocumentsMultipart(
    GpsDocumentUploadMultipartApiRequest request,
  ) async {
    try {
      final url = ApiUrls.gpsDocumentUpload;

      // Get form fields (string data)
      final fields = request.getFormFields();

      // Get files for multipart upload
      final files = request.getFiles();

      CustomLog.debug(
        this,
        "Sending GPS document upload via multipart with ${fields.length} fields and ${files.length} files",
      );

      // Create FormData manually using Dio
      final FormData formData = FormData();

      // Add string fields
      for (final entry in fields.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value));
      }

      // Add files with their specific field names
      for (final entry in files.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        if (await file.exists()) {
          formData.files.add(
            MapEntry(fieldName, await MultipartFile.fromFile(file.path)),
          );
          CustomLog.debug(this, "Added file $fieldName: ${file.path}");
        } else {
          CustomLog.error(this, "File not found: ${file.path}", null);
        }
      }

      CustomLog.debug(
        this,
        "Sending GPS document upload via multipart with ${formData.fields.length} fields and ${formData.files.length} files",
      );

      // Create headers with authentication
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };

      // Add authentication header if token exists
      try {
        String? refreshToken = await _secureSharedPrefs.get(
          AppString.sessionKey.refreshToken,
        );
        if (refreshToken != null && refreshToken.isNotEmpty) {
          headers['Authorization'] = 'Bearer $refreshToken';
          CustomLog.debug(this, "🔐 Using token: $refreshToken");
        } else {
          CustomLog.debug(this, "🔐 No token found");
        }
      } catch (e) {
        CustomLog.error(this, "Error getting authentication token", e);
      }

      // Use Dio directly for multipart upload
      final dio = Dio();
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 30).inMilliseconds,
          receiveTimeout: const Duration(seconds: 30).inMilliseconds,
        ),
      );

      CustomLog.debug(this, "GPS document upload response: ${response.data}");

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic>) {
          // If response is a Map, parse it directly
          return Success(GpsDocumentUploadResponse.fromJson(responseData));
        } else if (responseData is String) {
          // If response is a string, create a success response
          return Success(
            GpsDocumentUploadResponse(success: true, message: response.data, data: null),
          );
        } else {
          return Error(DeserializationError());
        }
      } else {
        return Error(ErrorWithMessage(message: 'Upload failed with status: ${response.statusCode}'));
      }
    } catch (e) {
      CustomLog.error(this, "Error uploading GPS documents", e);
      return Error(GenericError());
    }
  }

  // ==================== Aadhaar Verification Service ====================

  /// Send Aadhaar OTP
  Future<Result<GpsAadhaarSendOtpResponse>> sendAadhaarOtp(
    GpsAadhaarSendOtpRequest request,
  ) async {
    try {
      final url = ApiUrls.aadhaarSendOtp;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsAadhaarSendOtpResponse.fromJson(data),
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

  /// Verify Aadhaar OTP
  Future<Result<GpsAadhaarVerifyOtpResponse>> verifyAadhaarOtp(
    GpsAadhaarVerifyOtpRequest request,
  ) async {
    try {
      final url = ApiUrls.aadhaarVerifyOtp;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsAadhaarVerifyOtpResponse.fromJson(data),
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

  /// Verify PAN
  Future<Result<GpsPanVerificationResponse>> verifyPan(
    GpsPanVerificationRequest request,
  ) async {
    try {
      final url = ApiUrls.panVerification;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsPanVerificationResponse.fromJson(data),
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

  /// Fetch GPS Product List
  Future<Result<GpsProductListResponse>> fetchGpsProducts(
    GpsProductListRequest request,
  ) async {
    try {
      final url = ApiUrls.gpsProductList;
      final queryParams = request.toJson();
      final result = await _apiService.get(url, queryParams: queryParams);

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsProductListResponse.fromJson(data),
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

  /// Fetch GPS Addresses
  Future<Result<GpsAddressListResponse>> fetchGpsAddresses(
    GpsAddressListRequest request,
  ) async {
    try {
      final url = '${ApiUrls.gpsAddressList}/${request.customerId}';
      final queryParams = {
        'limit': request.limit,
        'page': request.page,
      };
      final result = await _apiService.get(url, queryParams: queryParams);

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsAddressListResponse.fromJson(data),
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
