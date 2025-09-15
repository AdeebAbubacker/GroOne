

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_order_list_models.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_payment_status_response.dart';
import 'package:gro_one_app/features/kavach/model/kavach_user_model.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';
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
      CustomLog.debug(this, "GPS Document Upload URL: $url");
      CustomLog.debug(this, "GPS Document Upload Request: ${request.toJson()}");
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

  /// Check GPS KYC Documents
  Future<Result<GpsKycCheckResponseModel>> checkKycDocuments(
    String customerId,
  ) async {
    try {
      final url = ApiUrls.gpsKycCheck(customerId);
      CustomLog.debug(this, "GPS KYC Check URL: $url");
      final result = await _apiService.get(url);

      if (result is Success) {
        try {
          final response = GpsKycCheckResponseModel.fromJson(result.value);
          CustomLog.debug(
            this,
            "GPS KYC Check Response: customerId=${response.customerId}, isKyc=${response.isKyc}, hasDocuments=${response.hasKycDocuments}",
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing GPS KYC check response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        // Handle 404 error as "no KYC documents found" instead of error
        if (result.type is NotFoundError) {
          CustomLog.debug(
            this,
            "GPS KYC Check: 404 error - treating as no KYC documents found",
          );
          // Return a success response indicating no documents found
          return Success(
            GpsKycCheckResponseModel(
              customerId: customerId,
              documents: null,
              isKyc: 0,
            ),
          );
        }
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Upload GPS KYC Documents (new API)
  Future<Result<GpsKycUploadResponseModel>> uploadKycDocuments(
    GpsKycUploadRequest request,
    String customerId,
  ) async {
    try {
      final url = ApiUrls.gpsKycUpload(customerId);
      CustomLog.debug(this, "GPS KYC Upload URL: $url");
      CustomLog.debug(this, "GPS KYC Upload Request: ${request.toJson()}");

      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        try {
          final response = GpsKycUploadResponseModel.fromJson(result.value);
          CustomLog.debug(this, "GPS KYC Upload Response: ${response.message}");
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing GPS KYC upload response", e);
          return Error(DeserializationError());
        }
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
      CustomLog.debug(this, "GPS Document Upload Multipart URL: $url");
      CustomLog.debug(
        this,
        "GPS Document Upload Multipart Request Fields: ${request.getFormFields()}",
      );
      CustomLog.debug(
        this,
        "GPS Document Upload Multipart Request Files: ${request.getFiles().keys.toList()}",
      );

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

      // Debug form data contents
      CustomLog.debug(this, "Form Data Fields:");
      for (final field in formData.fields) {
        CustomLog.debug(this, "  ${field.key}: ${field.value}");
      }
      CustomLog.debug(this, "Form Data Files:");
      for (final file in formData.files) {
        CustomLog.debug(this, "  ${file.key}: ${file.value.filename}");
      }

      // Create headers with authentication
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };

      // Add authentication header if token exists
      try {
        String? refreshToken = await _secureSharedPrefs.get(
          AppString.sessionKey.accessToken,
        );
        CustomLog.debug(this, "🔐 Token retrieval attempt:");
        CustomLog.debug(this, "🔐 Raw token value: '$refreshToken'");
        CustomLog.debug(this, "🔐 Token is null: ${refreshToken == null}");
        CustomLog.debug(this, "🔐 Token is empty: ${refreshToken?.isEmpty}");
        CustomLog.debug(this, "🔐 Token length: ${refreshToken?.length}");

        if (refreshToken != null && refreshToken.isNotEmpty) {
          final authHeader = 'Bearer $refreshToken';
          headers['Authorization'] = authHeader;
          CustomLog.debug(this, "🔐 Using token for API call: $refreshToken");
          CustomLog.debug(this, "🔐 Authorization header set: $authHeader");
          CustomLog.debug(this, "🔐 Full headers: $headers");
        } else {
          CustomLog.debug(this, "🔐 No token found - cannot authenticate");
          CustomLog.debug(this, "🔐 Headers without auth: $headers");
        }
      } catch (e) {
        CustomLog.error(this, "Error getting authentication token", e);
      }

      // Use Dio directly for multipart upload
      final dio = Dio();
      CustomLog.debug(this, "Making POST request to: $url");
      CustomLog.debug(this, "Request headers: $headers");
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(milliseconds: 30),
          receiveTimeout: const Duration(milliseconds: 30),
        ),
      );

      CustomLog.debug(this, "Response status code: ${response.statusCode}");
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
            GpsDocumentUploadResponse(
              success: true,
              message: response.data,
              data: null,
            ),
          );
        } else {
          return Error(DeserializationError());
        }
      } else {
        return Error(
          ErrorWithMessage(
            message: 'Upload failed with status: ${response.statusCode}',
          ),
        );
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
      // Aadhaar OTP doesn't require authentication token
      final url = ApiUrls.aadhaarSendOtp;
      CustomLog.debug(this, "🔐 GPS Aadhaar Send OTP - URL: $url");
      CustomLog.debug(
        this,
        "🔐 GPS Aadhaar Send OTP - Request: ${request.toJson()}",
      );

      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsAadhaarSendOtpResponse.fromJson(data),
        );
      } else if (result is Error) {
        CustomLog.error(
          this,
          "🔐 GPS Aadhaar Send OTP failed: ${result.type}",
          null,
        );
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
      // Aadhaar OTP verification doesn't require authentication token
      final url = ApiUrls.aadhaarVerifyOtp;
      CustomLog.debug(this, "🔐 GPS Aadhaar Verify OTP - URL: $url");
      CustomLog.debug(
        this,
        "🔐 GPS Aadhaar Verify OTP - Request: ${request.toJson()}",
      );

      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsAadhaarVerifyOtpResponse.fromJson(data),
        );
      } else if (result is Error) {
        CustomLog.error(
          this,
          "🔐 GPS Aadhaar Verify OTP failed: ${result.type}",
          null,
        );
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
      // PAN verification doesn't require authentication token
      final url = ApiUrls.panVerification;
      final xApiKey = ApiUrls.xApiKey;
      final udid = ApiUrls.fetchUDID;
      CustomLog.debug(this, "🔐 GPS PAN Verification - URL: $url");
      CustomLog.debug(
        this,
        "🔐 GPS PAN Verification - Request: ${request.toJson()}",
      );

      // Custom headers for the new PAN verification API
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': xApiKey,
        'X-Application-UDID': udid,
        'Content-Type': 'application/json',
      };

      final result = await _apiService.post(
        url,
        body: request.toJson(),
        customHeaders: customHeaders,
      );

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsPanVerificationResponse.fromJson(data),
        );
      } else if (result is Error) {
        CustomLog.error(
          this,
          "🔐 GPS PAN Verification failed: ${result.type}",
          null,
        );
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
      final queryParams = {'limit': request.limit, 'page': request.page};
      final result = await _apiService.get(url, queryParams: queryParams);

      if (result is Success) {
        // Handle the actual API response format
        final responseData = result.value;
        CustomLog.debug(this, "GPS Fetch Addresses Response: $responseData");

        if (responseData is Map<String, dynamic>) {
          // Check if response has data array (actual API format)
          if (responseData.containsKey('data') &&
              responseData['data'] is List) {
            final addresses = responseData['data'] as List;
            final pageMeta = responseData['pageMeta'] as Map<String, dynamic>?;

            // Convert addresses to GpsAddress objects
            final gpsAddresses =
                addresses.map((addressJson) {
                  return GpsAddress.fromJson(
                    addressJson as Map<String, dynamic>,
                  );
                }).toList();

            CustomLog.debug(
              this,
              "GPS Fetch Addresses - Total addresses: ${gpsAddresses.length}",
            );

            // Create GpsAddressListData
            final meta = GpsAddressListMeta(
              total: gpsAddresses.length,
              page: pageMeta?['page'] as int? ?? 1,
              limit: pageMeta?['pageSize'] as int? ?? 10,
              totalPages: pageMeta?['pageCount'] as int? ?? 1,
            );

            final addressListData = GpsAddressListData(
              rows: gpsAddresses,
              meta: meta,
            );

            final response = GpsAddressListResponse(
              success: true,
              message: 'Addresses fetched successfully',
              data: addressListData,
              statusCode: 200,
            );

            CustomLog.debug(this, "GPS Fetch Addresses Success: $response");
            return Success(response);
          } else if (responseData.containsKey('success') ||
              responseData.containsKey('status')) {
            // Handle wrapped response format
            return await _apiService.getResponseStatus(
              result.value,
              (data) => GpsAddressListResponse.fromJson(data),
            );
          } else {
            // Unknown response format, return empty list
            CustomLog.error(
              this,
              "GPS Fetch Addresses - Unknown response format",
              null,
            );
            return Error(DeserializationError());
          }
        } else {
          CustomLog.error(
            this,
            "GPS Fetch Addresses - Invalid response format",
            null,
          );
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(
          this,
          "GPS Fetch Addresses failed: ${result.type}",
          null,
        );
        return Error(result.type);
      } else {
        CustomLog.error(
          this,
          "GPS Fetch Addresses - Unknown result type",
          null,
        );
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Add GPS Address
  Future<Result<GpsAddAddressResponse>> addGpsAddress(
    GpsAddAddressRequest request,
  ) async {
    try {
      final url = ApiUrls.gpsAddressList;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        // Handle direct response format (address data returned directly)
        final responseData = result.value;
        CustomLog.debug(this, "GPS Add Address Response: $responseData");

        if (responseData is Map<String, dynamic>) {
          // Check if response contains address data directly
          if (responseData.containsKey('preferedAddressId') ||
              responseData.containsKey('customerId')) {
            // This is the address data returned directly from API
            final addressResponse = GpsAddAddressResponse.fromJson(
              responseData,
            );
            CustomLog.debug(this, "GPS Add Address Success: $addressResponse");
            return Success(addressResponse);
          } else if (responseData.containsKey('success') ||
              responseData.containsKey('status')) {
            // This is a wrapped response with success/status fields
            return await _apiService.getResponseStatus(
              result.value,
              (data) => GpsAddAddressResponse.fromJson(data),
            );
          } else {
            // Unknown response format, treat as success with direct data
            final addressResponse = GpsAddAddressResponse.fromJson(
              responseData,
            );
            CustomLog.debug(
              this,
              "GPS Add Address Success (unknown format): $addressResponse",
            );
            return Success(addressResponse);
          }
        } else {
          CustomLog.error(
            this,
            "GPS Add Address - Invalid response format",
            null,
          );
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "GPS Add Address failed: ${result.type}", null);
        return Error(result.type);
      } else {
        CustomLog.error(this, "GPS Add Address - Unknown result type", null);
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Create GPS Order
  Future<Result<void>> createGpsOrder(GpsOrderRequest request) async {
    try {
      CustomLog.debug(this, "GPS Create Order - Request: ${request.toJson()}");

      final result = await _apiService.post(
        ApiUrls.gpsCreateOrder,
        body: request.toJson(),
      );

      if (result is Success) {
        CustomLog.debug(this, "GPS Create Order - Response: ${result.value}");
        return await _apiService.getResponseStatus(
          result.value,
          (data) {}, // For void return
        );
      } else if (result is Error) {
        CustomLog.error(this, "GPS Create Order failed: ${result.type}", null);
        return Error(result.type);
      } else {
        CustomLog.error(this, "GPS Create Order - Unknown result type", null);
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "GPS Create Order - Exception: $e", e);
      return Error(DeserializationError());
    }
  }

  /// Get GPS Order Summary
  Future<Result<GpsOrderSummaryResponse>> getGpsOrderSummary(
    GpsOrderSummaryRequest request,
  ) async {
    try {
      CustomLog.debug(this, "GPS Order Summary - Request: ${request.toJson()}");

      final result = await _apiService.post(
        ApiUrls.gpsOrderSummary,
        body: request.toJson(),
      );

      if (result is Success) {
        CustomLog.debug(this, "GPS Order Summary - Response: ${result.value}");
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsOrderSummaryResponse.fromJson(data),
        );
      } else if (result is Error) {
        CustomLog.error(this, "GPS Order Summary failed: ${result.type}", null);
        return Error(result.type);
      } else {
        CustomLog.error(this, "GPS Order Summary - Unknown result type", null);
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "GPS Order Summary - Exception: $e", e);
      return Error(DeserializationError());
    }
  }

  /// Get GPS Customer Orders List
  Future<Result<GpsOrderListResponse>> getGpsCustomerOrdersList({
    required String customerId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      CustomLog.debug(
        this,
        "GPS Customer Orders List - Request: customerId=$customerId, page=$page, limit=$limit",
      );

      final queryParameters = {
        'customerId': customerId,
        'page': page.toString(),
        'limit': limit.toString(),
        'fleetProductId': "1",
      };

      final result = await _apiService.get(
        ApiUrls.gpsCustomerOrdersList,
        queryParams: queryParameters,
      );

      if (result is Success) {
        log(result.value.toString());
        CustomLog.debug(
          this,
          "GPS Customer Orders List - Response: ${result.value}",
        );
        return await _apiService.getResponseStatus(
          result.value,
          (data) => GpsOrderListResponse.fromJson(data),
        );
      } else if (result is Error) {
        CustomLog.error(
          this,
          "GPS Customer Orders List failed: ${result.type}",
          null,
        );
        return Error(result.type);
      } else {
        CustomLog.error(
          this,
          "GPS Customer Orders List - Unknown result type",
          null,
        );
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "GPS Customer Orders List - Exception: $e", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches users for referral code functionality
  Future<Result<List<KavachUserModel>>> fetchUsers({
    String search = "",
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search.isNotEmpty) 'Search': search,
      };

      // Construct URL with query parameters
      final uri = Uri.parse(
        ApiUrls.getAllUsers,
      ).replace(queryParameters: queryParams);

      CustomLog.debug(this, "GPS Fetch Users - URL: $uri");

      final response = await _apiService.get(uri.toString());

      if (response is Success) {
        CustomLog.debug(this, "Users API raw response: ${response.value}");
        CustomLog.debug(
          this,
          "Users API response type: ${response.value.runtimeType}",
        );

        try {
          // The API response is directly the data structure, not wrapped in success/status
          final userListResponse = KavachUserListResponse.fromJson(
            response.value,
          );
          CustomLog.debug(
            this,
            "Successfully parsed user list response with ${userListResponse.data.length} users",
          );
          return Success(userListResponse.data);
        } catch (e) {
          CustomLog.error(this, "Failed to parse users data", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "GPS Fetch Users - Exception: $e", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches available stock for a specific GPS product
  Future<Result<int>> fetchAvailableStock({required String productId}) async {
    try {
      // For now, use the same endpoint as Kavach but with fleetProductId=1 for GPS
      final response = await _apiService.get(
        '${ApiUrls.kavachAvailableStock}?productId=$productId&teamId=1',
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
          (data) =>
              int.tryParse(data['data']['availableStock'].toString()) ?? 0,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(
        this,
        "Failed to fetch available stock for GPS product",
        e,
      );
      return Error(DeserializationError());
    }
  }

  Future<Result<OrderAddedSuccess>> initiatePayment(
    KavachInitiatePaymentRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        ApiUrls.fleetPayment,
        body: request.toJson(),
      );

      if (response is Success) {
        dynamic data = response.value;

        // Ensure response value is a Map before passing to fromJson
        if (data is Map<String, dynamic>) {
          if (data.containsKey("success") && data["success"] == false) {
            return Error(GenericError());
          }

          // If 'data' field is a string or null, replace it with null to avoid parsing errors
          if (data.containsKey("data") && data["data"] is String) {
            data = {
              ...data,
              "data": null, // prevent String -> Map cast error
            };
          }
          final result = OrderAddedSuccess.fromJson(data);
          CustomLog.debug(this, "Payment initiated successfully");
          return Success(result);
        } else {
          // Unexpected response format
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to initiate payment", e);
      return Error(DeserializationError());
    }
  }

  /// Check GPS Payment/Order Status
  Future<Result<PaymentStatusResponse>> checkPaymentStatus(
    String requestId,
  ) async {
    try {
      final response = await _apiService.post(
        '${ApiUrls.fleetPaymentStatus}/$requestId',
      );

      if (response is Success) {
        final data = response.value;
        if (data is Map<String, dynamic>) {
          final result = PaymentStatusResponse.fromJson(data);
          return Success(result);
        } else {
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to check payment status", e);
      return Error(DeserializationError());
    }
  }
}
