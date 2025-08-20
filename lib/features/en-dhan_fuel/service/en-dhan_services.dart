import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/endhan_transaction_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/pincode_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/vehicle_verification_response.dart';
import 'package:gro_one_app/features/kavach/model/kavach_user_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class EnDhanService {
  final ApiService _apiService;
  final SecuredSharedPreferences _secureSharedPrefs;

  EnDhanService(this._apiService, this._secureSharedPrefs);

  /// Check KYC Documents Existence
  Future<Result<EnDhanKycCheckModel>> checkKycDocuments(String customerId) async {
    try {
      final url = ApiUrls.enDhanKycCheck(customerId);
      final result = await _apiService.get(url);

      if (result is Success) {
        // Handle the response directly instead of using getResponseStatus
        // because "Document not found" is a valid response, not an error
        try {
          final response = EnDhanKycCheckModel.fromJson(result.value);
          CustomLog.debug(
            this,
            "KYC Check Response: success=${response.success}, message=${response.message}, data=${response.data}",
          );
          

          
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing KYC check response", e);
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

  /// Upload KYC Documents
  Future<Result<EnDhanKycModel>> uploadKycDocuments(
    EnDhanKycApiRequest request,
    String customerId,
  ) async {
    try {
      final url = ApiUrls.endhanSubmitKyc;

      // Add customerId to the request body
      final requestBody = request.toJson(includeFromFleet: false);
      // requestBody['customerId'] = customerId;

      final result = await _apiService.post(url+customerId, body: requestBody);
      if (result is Success) {
        final value = result.value;

        // If API returned only message, treat it as success
        if (value is Map && value.containsKey('message') && !value.containsKey('success')) {
          return Success(EnDhanKycModel(
            success: true,
            message: value['message'],
            data: null,
          ));
        }

        return await _apiService.getResponseStatus(
          value,
              (data) => EnDhanKycModel.fromJson(data),
        );
      }

      else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Create Customer
  Future<Result<EnDhanCustomerCreationResponse>> createCustomer(
    EnDhanCustomerCreationApiRequest request,
  ) async {
    try {
      final url = ApiUrls.enDhanCreateCustomer;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        CustomLog.debug(this, "Customer creation response: ${result.value}");

        // Check if response is a Map and handle success/failure properly
        if (result.value is Map<String, dynamic>) {
          final responseMap = result.value as Map<String, dynamic>;
          CustomLog.debug(
            this,
            "Checking response: success=${responseMap['success']}, message=${responseMap['message']}, data=${responseMap['data']}",
          );

          // If success is false, return error with the message
          if (responseMap['success'] == false) {
            final errorMessage =
                responseMap['message'] ?? 'Customer creation failed';
            CustomLog.debug(
              this,
              "API returned success: false with message: $errorMessage",
            );
            return Error(ErrorWithMessage(message: errorMessage));
          }

          // If success is true, check for error messages in data
          if (responseMap['success'] == true) {
            final data = responseMap['data'];

            // If data is a string, it's an error message
            if (data is String && data.isNotEmpty) {
              CustomLog.debug(this, "Found error message in data: $data");
              return Error(ErrorWithMessage(message: data));
            }

            // If data is a Map but not empty, check for error indicators
            if (data is Map<String, dynamic> && data.isNotEmpty) {
              final dataString = data.toString().toLowerCase();
              if (dataString.contains('error') ||
                  dataString.contains('already exists') ||
                  dataString.contains('please enter different')) {
                CustomLog.debug(
                  this,
                  "Found error in response data map, returning error",
                );
                return Error(ErrorWithMessage(message: data.toString()));
              }
            }
          }
        }

        // Handle the response directly instead of using getResponseStatus
        try {
          final response = EnDhanCustomerCreationResponse.fromJson(
            result.value,
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing customer creation response", e);
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

  /// Fetch States
  Future<Result<EnDhanStateResponse>> fetchStates() async {
    try {
      final url = ApiUrls.enDhanStates;
      final result = await _apiService.get(url);

      if (result is Success) {
        // Check if the response is successful
        if (result.value['success'] == true) {
          final response = EnDhanStateResponse.fromJson(result.value);
          return Success(response);
        } else {
          return Error(
            ErrorWithMessage(
              message: result.value['message'] ?? 'Failed to fetch states',
            ),
          );
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

  /// Fetch Districts by State ID
  Future<Result<EnDhanDistrictResponse>> fetchDistricts(int stateId) async {
    try {
      final url = '${ApiUrls.enDhanDistricts}$stateId';
      final result = await _apiService.get(url);

      if (result is Success) {
        // Check if the response is successful
        if (result.value['success'] == true) {
          final response = EnDhanDistrictResponse.fromJson(result.value);
          return Success(response);
        } else {
          return Error(
            ErrorWithMessage(
              message: result.value['message'] ?? 'Failed to fetch districts',
            ),
          );
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

  /// Fetch Zonal Offices
  Future<Result<EnDhanZonalResponse>> fetchZonalOffices() async {
    try {
      final url = ApiUrls.enDhanZonal;
      final result = await _apiService.get(url);

      if (result is Success) {
        // Check if the response is successful
        if (result.value['success'] == true) {
          return Success(EnDhanZonalResponse.fromJson(result.value));
        } else {
          return Error(
            ErrorWithMessage(
              message:
                  result.value['message'] ?? 'Failed to fetch zonal offices',
            ),
          );
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

  /// Fetch Regional Offices by Zone ID
  Future<Result<EnDhanRegionalResponse>> fetchRegionalOffices(
    int zoneId,
  ) async {
    try {
      final url = '${ApiUrls.enDhanRegional}$zoneId';
      final result = await _apiService.get(url);

      if (result is Success) {
        // Check if the response is successful
        if (result.value['success'] == true) {
          final response = EnDhanRegionalResponse.fromJson(result.value);
          return Success(response);
        } else {
          return Error(
            ErrorWithMessage(
              message:
                  result.value['message'] ?? 'Failed to fetch regional offices',
            ),
          );
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

  /// Fetch Vehicle Types
  Future<Result<EnDhanVehicleTypeResponse>> fetchVehicleTypes() async {
    try {
      final url = ApiUrls.enDhanVehicleTypes;
      final result = await _apiService.get(url);

      if (result is Success) {

        // Check if the response is successful
        if (result.value['success'] == true) {
          return Success(EnDhanVehicleTypeResponse.fromJson(result.value));
        } else {
          return Error(
            ErrorWithMessage(
              message:
                  result.value['message'] ?? 'Failed to fetch vehicle types',
            ),
          );
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

  /// Upload Document
  Future<Result<DocumentUploadResponse>> uploadDocument(File file) async {
    try {
      // Get user ID from secure storage
      final userId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
      if (userId == null || userId.isEmpty) {
        CustomLog.error(this, "User ID not found in secure storage", null);
        return Error(ErrorWithMessage(message: 'User ID not found'));
      }

      final url = ApiUrls.documentUpload;
      
      // Prepare form fields with required parameters
      final fields = {
        'userId': userId,
        'fileType': 'rc_book',
        'documentType': 'vp_document',
      };

      final result = await _apiService.multipart(
        url, 
        file, 
        pathName: "file",
        fields: fields,
      );

      if (result is Success) {
        CustomLog.debug(this, "Upload API Response: ${result.value}");
        CustomLog.debug(this, "Upload API Response Type: ${result.value.runtimeType}");
        
        try {
          // Parse the response directly since the API returns the data structure directly
          final responseData = result.value;
          
          if (responseData is Map<String, dynamic>) {
            CustomLog.debug(this, "Response keys: ${responseData.keys.toList()}");
            CustomLog.debug(this, "Response URL: ${responseData['url']}");
            
            // The API response is directly the document upload data
            final documentResponse = DocumentUploadResponse.fromJson(responseData);
            CustomLog.debug(this, "Successfully parsed document upload response");
            CustomLog.debug(this, "Document response success: ${documentResponse.success}");
            CustomLog.debug(this, "Document response data URL: ${documentResponse.data?.url}");
            return Success(documentResponse);
          } else {
            CustomLog.error(this, "Invalid upload response format - expected Map, got ${responseData.runtimeType}", null);
            return Error(DeserializationError());
          }
        } catch (e) {
          CustomLog.error(this, "Failed to parse upload response", e);
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

  /// Upload KYC Documents Multipart
  Future<Result<EnDhanKycModel>> uploadKycDocumentsMultipart(
    EnDhanKycMultipartApiRequest request,
    String customerId,
  ) async {
    try {
      final url = ApiUrls.enDhanKycUpload;

      // Get form fields (string data)
      final fields = {};
      
      // Add customerId to the form fields
      fields['customerId'] = customerId;

      // Get files for multipart upload
      final files = request.getFiles();

      CustomLog.debug(
        this,
        "Sending KYC upload via custom multipart with ${fields.length} fields and ${files.length} files",
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
        "Sending KYC upload via custom multipart with ${formData.fields.length} fields and ${formData.files.length} files",
      );

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
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      CustomLog.debug(
        this,
        "KYC upload response: ${response.statusCode} - ${response.data}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          if (response.data is Map<String, dynamic>) {
            final responseData = response.data as Map<String, dynamic>;
            if (responseData['success'] == true) {
              return Success(EnDhanKycModel.fromJson(responseData));
            } else {
              return Error(
                ErrorWithMessage(
                  message: responseData['message'] ?? 'Upload failed',
                ),
              );
            }
          } else if (response.data is String) {
            // If the API returns a simple success message as string
            return Success(
              EnDhanKycModel(success: true, message: response.data, data: null),
            );
          } else {
            return Error(ErrorWithMessage(message: 'Invalid response format'));
          }
        } catch (e) {
          CustomLog.error(this, "Error parsing response", e);
          return Error(DeserializationError());
        }
      } else {
        // Log detailed error information
        CustomLog.error(
          this,
          "Server error ${response.statusCode}: ${response.data}",
          null,
        );
        CustomLog.error(this, "Response headers: ${response.headers}", null);

        String errorMessage =
            'Upload failed with status code: ${response.statusCode}';
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'] ?? errorMessage;
          } else if (response.data is String) {
            errorMessage = response.data;
          }
        }

        return Error(ErrorWithMessage(message: errorMessage));
      }
    } on DioError catch (dioError) {
      CustomLog.error(
        this,
        "DioError response: ${dioError.response?.data}",
        dioError,
      );
      return Error(
        ErrorWithMessage(
          message: dioError.response?.data?['message'] ?? 'Network error',
        ),
      );
    } catch (e) {
      CustomLog.error(this, "Unexpected error during KYC upload", e);
      return Error(GenericError());
    }
  }

  /// Fetch Card Balance
  Future<Result<EnDhanCardBalanceResponse>> fetchCardBalance() async {
    try {
      // Get customer ID from secure storage
      final customerId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
      if (customerId == null || customerId.isEmpty) {
        return Error(ErrorWithMessage(message: 'Customer ID not found'));
      }
      
      final url = ApiUrls.enDhanCardBalance(customerId);
      CustomLog.debug(this, "Fetching card balance from: $url");

      final result = await _apiService.get(url);

      if (result is Success) {
        CustomLog.debug(this, "Card balance API raw response: ${result.value}");

        try {
          final response = EnDhanCardBalanceResponse.fromJson(result.value);
          CustomLog.debug(this, "Parsed card balance response: $response");

          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing card balance response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error fetching card balance", e);
      return Error(GenericError());
    }
  }

  /// Fetch Cards List
  Future<Result<EnDhanCardListModel>> fetchCards({String? searchTerm}) async {
    try {
      // Get customer ID from secure storage
      final customerId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
      if (customerId == null || customerId.isEmpty) {
        return Error(ErrorWithMessage(message: 'Customer ID not found'));
      }
      
      String url = ApiUrls.enDhanCards(customerId);
      if (searchTerm != null && searchTerm.isNotEmpty) {
        url += '?searchTerm=$searchTerm';
      }

      CustomLog.debug(this, "Fetching cards from: $url");

      // Test if the API service is working by making a simple call first


      final result = await _apiService.get(url);

      if (result is Success) {
        CustomLog.debug(this, "Cards API raw response: ${result.value}");
        CustomLog.debug(
          this,
          "Cards API response type: ${result.value.runtimeType}",
        );

        if (result.value is Map<String, dynamic>) {
          final responseMap = result.value as Map<String, dynamic>;
          CustomLog.debug(
            this,
            "Cards API response keys: ${responseMap.keys.toList()}",
          );

          // Log each key-value pair for debugging
          responseMap.forEach((key, value) {
            CustomLog.debug(this,'🔍 Key: $key, Value: $value, Type: ${value.runtimeType}');
          });

          if (responseMap.containsKey('data')) {
            CustomLog.debug(
              this,
              "Cards API data type: ${responseMap['data'].runtimeType}",
            );
            CustomLog.debug(
              this,
              "Cards API data value: ${responseMap['data']}",
            );
          }
        }

        try {
          final cardListModel = EnDhanCardListModel.fromJson(result.value);

          CustomLog.debug(this, "Parsed card list model: $cardListModel");

          // Check if data contains an error message even though success is true
          if (result.value is Map<String, dynamic>) {
            final responseMap = result.value as Map<String, dynamic>;
            if (responseMap['data'] is String &&
                responseMap['data'].toString().toLowerCase().contains(
                  'error',
                )) {
              return Error(ErrorWithMessage(message: responseMap['data']));
            }
            if (responseMap['data'] is String &&
                responseMap['data'].toString().toLowerCase().contains(
                  'already exists',
                )) {
              return Error(ErrorWithMessage(message: responseMap['data']));
            }
            if (responseMap['data'] is String &&
                responseMap['data'].toString().toLowerCase().contains(
                  'please enter different',
                )) {
              return Error(ErrorWithMessage(message: responseMap['data']));
            }
          }

          // Check if we got any cards
          if (cardListModel.data == null ||
              cardListModel.data!.document == null ||
              cardListModel.data!.document!.isEmpty) {
            CustomLog.debug(this, "No cards found in response");
            return Success(cardListModel); // Return empty list, not error
          }


          CustomLog.debug(
            this,
            "Successfully parsed ${cardListModel.data!.document!.length} cards",
          );
          return Success(cardListModel);
        } catch (e) {
          CustomLog.error(this, "Error parsing cards response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error fetching cards", e);
      return Error(GenericError());
    }
  }

  // ==================== Aadhaar Verification ====================

  /// Send Aadhaar OTP
  Future<Result<AadhaarSendOtpResponse>> sendAadhaarOtp(
    AadhaarSendOtpRequest request,
  ) async {
    try {
      final url = ApiUrls.aadhaarSendOtp;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        try {
          final response = AadhaarSendOtpResponse.fromJson(result.value);
          CustomLog.debug(
            this,
            "Aadhaar OTP Response: success=${response.success}, message=${response.message}, requestId=${response.requestId}",
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing Aadhaar OTP response", e);
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

  /// Verify Aadhaar OTP
  Future<Result<AadhaarVerifyOtpResponse>> verifyAadhaarOtp(
    AadhaarVerifyOtpRequest request,
  ) async {
    try {
      final url = ApiUrls.aadhaarVerifyOtp;
      final result = await _apiService.post(url, body: request.toJson());

      if (result is Success) {
        try {
          final response = AadhaarVerifyOtpResponse.fromJson(result.value);
          CustomLog.debug(
            this,
            "Aadhaar Verify OTP Response: success=${response.success}, message=${response.message}, isVerified=${response.isVerified}",
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing Aadhaar verify OTP response", e);
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

  /// Verify PAN
  Future<Result<PanVerificationResponse>> verifyPan(
    PanVerificationRequest request,
  ) async {
    try {
      final url = ApiUrls.panVerification;
      
      // Custom headers for the new PAN verification API
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': '5f522b06263423e4cab5eb45d27f2be4',
        'X-Application-UDID': '52e3dcc8-52ef-4f52-8756-3a06996757cd',
        'Content-Type': 'application/json',
      };
      
      final result = await _apiService.post(url, body: request.toJson(), customHeaders: customHeaders);

      if (result is Success) {
        try {
          final response = PanVerificationResponse.fromJson(result.value);
          CustomLog.debug(
            this,
            "PAN Verification Response: success=${response.success}, message=${response.message}, isVerified=${response.isVerified}",
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing PAN verification response", e);
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

  /// Verify Vehicle
  Future<Result<VehicleVerificationResponse>> verifyVehicle(
    VehicleVerificationRequest request,
  ) async {
    try {
      final url = 'https://groone-uat.letsgro.co/vehicle_number/api/v1/send_vehicle_number';
      final requestBody = request.toJson();
      
      // Custom headers for the new vehicle verification API
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': '5f522b06263423e4cab5eb45d27f2be4',
        'X-Application-UDID': '52e3dcc8-52ef-4f52-8756-3a06996757cd',
        'Content-Type': 'application/json',
      };
      
      CustomLog.debug(
        this,
        "Vehicle Verification Request: URL=$url, Body=$requestBody",
      );
      
      final result = await _apiService.post(url, body: requestBody, customHeaders: customHeaders);

      if (result is Success) {
        CustomLog.debug(
          this,
          "Vehicle Verification Raw Response: ${result.value}",
        );
        
        try {
          final response = VehicleVerificationResponse.fromJson(result.value);
          CustomLog.debug(
            this,
            "Vehicle Verification Response: success=${response.success}, message=${response.message}",
          );
          return Success(response);
        } catch (e) {
          CustomLog.error(this, "Error parsing vehicle verification response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Vehicle Verification API Error", result.type);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
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
      final uri = Uri.parse(ApiUrls.getAllUsers).replace(queryParameters: queryParams);

      CustomLog.debug(this, "EnDhan Fetch Users - URL: $uri");

      final response = await _apiService.get(uri.toString());

      if (response is Success) {
        CustomLog.debug(this, "Users API raw response: ${response.value}");
        CustomLog.debug(this, "Users API response type: ${response.value.runtimeType}");
        
        try {
          // The API response is directly the data structure, not wrapped in success/status
          final userListResponse = KavachUserListResponse.fromJson(response.value);
          CustomLog.debug(this, "Successfully parsed user list response with ${userListResponse.data.length} users");
          return Success(userListResponse.data);
        } catch (e) {
          CustomLog.error(this, "Failed to parse users data", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "EnDhan Fetch Users - Exception: $e", e);
      return Error(DeserializationError());
    }
  }

  /// Get Transactions
  Future<Result<EndhanTransactionResponse>> getTransactions({
    required String customerId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final request = EndhanTransactionRequest(
        customerId: customerId,
        fromDate: fromDate,
        toDate: toDate,
      );

      CustomLog.debug(this, "En-Dhan Transaction Request: ${request.toJson()}");

      final result = await _apiService.post(
        ApiUrls.enDhanTransaction,
        body: request.toJson(),
      );

      if (result is Success) {
        try {
          final data = result.value as Map<String, dynamic>;
          CustomLog.debug(this, "API Response: $data");
          final transactionResponse = EndhanTransactionResponse.fromJson(data);
          
          if (transactionResponse.success) {
            CustomLog.debug(this, "En-Dhan Transaction Response: ${transactionResponse.transactions?.length} transactions");
            return Success(transactionResponse);
          } else {
            return Error(ErrorWithMessage(message: transactionResponse.message));
          }
        } catch (parseError) {
          CustomLog.error(this, "Error parsing transaction response", parseError);
          return Error(ErrorWithMessage(message: 'Error parsing response data'));
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(ErrorWithMessage(message: 'Failed to fetch transactions'));
      }
    } catch (e) {
      final errorMessage = e?.toString() ?? 'Unknown error occurred';
      CustomLog.error(this, "Error fetching En-Dhan transactions", e);
      return Error(ErrorWithMessage(message: errorMessage));
    }
  }

  /// Get Pincode Details
  Future<Result<PincodeResponse>> getPincode(String pincode) async {
    try {
      final url = ApiUrls.enDhanGetPincode(pincode);
      CustomLog.debug(this, "Pincode API URL: $url");

      final result = await _apiService.get(url);

      if (result is Success) {
        try {
          final data = result.value as Map<String, dynamic>;
          CustomLog.debug(this, "Pincode API Response: $data");
          final pincodeResponse = PincodeResponse.fromJson(data);
          
          if (pincodeResponse.success) {
            CustomLog.debug(this, "Pincode Response: ${pincodeResponse.data?.district?.name}");
            return Success(pincodeResponse);
          } else {
            return Error(ErrorWithMessage(message: pincodeResponse.message));
          }
        } catch (parseError) {
          CustomLog.error(this, "Error parsing pincode response", parseError);
          return Error(ErrorWithMessage(message: 'Error parsing pincode response data'));
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(ErrorWithMessage(message: 'Failed to fetch pincode details'));
      }
    } catch (e) {
      final errorMessage = e?.toString() ?? 'Unknown error occurred';
      CustomLog.error(this, "Error fetching pincode details", e);
      return Error(ErrorWithMessage(message: errorMessage));
    }
  }

  /// Check Endhan Server Status
  Future<Result<Map<String, dynamic>>> checkEndhanServerStatus() async {
    try {
      final url = ApiUrls.enDhanServerStatus;
      final result = await _apiService.get(url);

      if (result is Success) {
        if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;
          CustomLog.debug(this, "Server Status Response: $response");
          return Success(response);
        } else {
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error checking server status", e);
      return Error(GenericError());
    }
  }

}
