import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_choose_preference_model.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../../../data/storage/secured_shared_preferences.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../api_request/kavach_add_vehicle_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_commodity_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_transaction_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_user_model.dart';
import '../model/kavach_vehicle_document_upload_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_masters_model.dart';
import 'package:gro_one_app/utils/app_string.dart';

class KavachService {
  final ApiService _apiService;
  final SecuredSharedPreferences _secureSharedPrefs;
  KavachService(this._apiService, this._secureSharedPrefs);

  /// Fetches Kavach products with optional search and preference filters
  Future<Result<List<KavachProduct>>> fetchProducts({
    String search = "",
    int page = 1,
    KavachChoosePreferenceModel? preferences,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'fleetProductId': '2',
        'page': page.toString(),
        'limit': '10',
        if (search.isNotEmpty) 'search': search,
      };

      // Add preference parameters if provided
      if (preferences != null && preferences.hasPreferences) {
        queryParams.addAll(preferences.toQueryParams());
      }

      // Construct URL with query parameters
      final uri = Uri.parse(ApiUrls.kavachProductList).replace(queryParameters: queryParams);

      final response = await _apiService.get(uri.toString());

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => (data['data']['rows'] as List).map((e) => KavachProduct.fromJson(e)).toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch Kavach products", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches vehicles for a specific customer
  Future<Result<List<KavachVehicleModel>>> fetchVehicles(String customerId) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.kavachVehicleDetails}/$customerId?limit=10&page=1',
      );
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  final vehicleList = data['data'] as List;
                  
                  return vehicleList.map((e) {
                    return KavachVehicleModel.fromJson(e);
                  }).toList();
                } catch (e) {
                  CustomLog.error(this, "Failed to parse vehicle data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicles", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches addresses for a customer with specified address type
  Future<Result<List<KavachAddressModel>>> fetchAddresses(
      String customerId, {
        required int addrType,
      }) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.kavachAddressList}/$customerId?limit=10&page=1',
        forceRefresh: true,
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  final allAddresses = (data['data'] as List).map((e) => KavachAddressModel.fromJson(e)).toList();
                  
                  // Filter addresses based on addrType
                  final filteredAddresses = allAddresses.where((address) => address.addrType == addrType).toList();
                  
                  return filteredAddresses;
                } catch (e) {
                  CustomLog.error(this, "Failed to parse addresses data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch addresses", e);
      return Error(DeserializationError());
    }
  }

  /// Adds a new address for a customer
  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    try {
      final response = await _apiService.post(
        ApiUrls.kavachAddressList,
        body: request.toJson(),
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  // The API response seems to be the direct data object
                  return KavachAddressModel.fromJson(data);
                } catch (e) {
                  CustomLog.error(this, "Failed to parse add address data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to add address", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches available stock for a specific product
  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) async {
    try {
      final response = await _apiService.get('${ApiUrls.kavachAvailableStock}?productId=$productId&teamId=1');

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => int.tryParse(data['data']['availableStock'].toString()) ?? 0,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch available stock", e);
      return Error(DeserializationError());
    }
  }

  /// Creates a new Kavach order
  Future<Result<void>> createOrder(KavachOrderRequest request) async {
    try {
      final response = await _apiService.post(
        ApiUrls.kavachCreateOrder,
        body: request.toJson(),
      );
      if (response is Success) {
        // For void return, getResponseStatus needs a function that returns null or similar.
        // It's still good to pass the response through getResponseStatus to check for success/status flags.
        return await _apiService.getResponseStatus(
          response.value,
              (data) => null,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to create order", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches customer orders with optional filtering and pagination
  Future<Result<KavachOrderListResponse>> fetchCustomerOrders({
    required String customerId,
    int page = 1,
    int limit = 10,
    int? status,
    bool forceRefresh = false,
  }) async {
    try {
      final statusParam = status != null ? "&status=$status" : "";
      final response = await _apiService.get(
        '${ApiUrls.kavachOrdersList}?customerId=$customerId&page=$page&limit=$limit$statusParam',
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => KavachOrderListResponse.fromJson(data),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch customer orders", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<CommodityModel>>> fetchCommodities() async {
    try {
      final response = await _apiService.get(
        ApiUrls.kavachFetchCommodities,
      );
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  // Handle the case where data might be directly a list
                  if (data is List) {
                    return data.map((e) => CommodityModel.fromJson(e)).toList();
                  }
                  // Handle the case where data is nested in a 'data' field
                  if (data is Map<String, dynamic> && data.containsKey('data')) {
                    final dataList = data['data'];
                    if (dataList is List) {
                      return dataList.map((e) => CommodityModel.fromJson(e)).toList();
                    }
                  }
                  // If neither format works, return empty list
                  return <CommodityModel>[];
                } catch (e) {
                  CustomLog.error(this, "Failed to parse commodities data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch commodities", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<KavachVehicleDocumentUploadModel>> fetchUploadGstData(File file) async {
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
        'documentType': 'rc_document',
      };

      final result = await _apiService.multipart(
        url, 
        file, 
        pathName: "file",
        fields: fields,
      );
      
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
              (data) => KavachVehicleDocumentUploadModel.fromJson(data),
        );
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Upload error", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> addVehicle(KavachAddVehicleRequest request) async {
    try {
      final response = await _apiService.post(
        ApiUrls.kavachVehicle,
        body: request.toJson(),
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => null, // For void return
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<List<String>>> fetchTruckTypeList() async {
    try {
      final response = await _apiService.get(ApiUrls.kavachTruckType);
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  // Handle the case where data might be directly a list
                  if (data is List) {
                    return data.cast<String>();
                  }
                  // Handle the case where data is nested in a 'data' field
                  if (data is Map<String, dynamic> && data.containsKey('data')) {
                    final dataList = data['data'];
                    if (dataList is List) {
                      return dataList.cast<String>();
                    }
                  }
                  // If neither format works, return empty list
                  return <String>[];
                } catch (e) {
                  CustomLog.error(this, "Failed to parse truck types data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch truck types", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<TruckLengthModel>>> fetchTruckLengths(String type) async {
    try {
      final response = await _apiService.get('${ApiUrls.kavachTruckSubType}/$type');
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => (data['data'] as List).map((e) => TruckLengthModel.fromJson(e)).toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (_) {
      return Error(DeserializationError());
    }
  }

  /// Fetches masters data from the API
  Future<Result<KavachMastersModel>> getMasters() async {
    try {
      final result = await _apiService.get(ApiUrls.choosePreference);
      if (result is Success) {
        // This function already uses getResponseStatus as requested
        return await _apiService.getResponseStatus(
          result.value,
              (data) => KavachMastersModel.fromJson(data),
        );
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch masters data", e);
      return Error(DeserializationError());
    }
  }

  /// Verifies a vehicle number
  Future<Result<bool>> verifyVehicle(String vehicleNumber, {bool force = true}) async {
    try {
      final response = await _apiService.post(
        ApiUrls.kavachVehicleVerification,
        body: {
          "vehicle_number": vehicleNumber,
          "force": force,
        },
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => data['status'] == true,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Vehicle verification failed", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches transaction data from the API
  Future<Result<List<KavachTransactionModel>>> getTransactions(String customerId) async {
    try {
      final result = await _apiService.get(
        ///todo: currently using mock API so it is hardcoded will change it when receive the API for this.
        'https://gro-devapi.letsgro.co/vendor/api/v1/payment/getTransaction',
      );

      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
              (response) {
            final data = response['data'];
            final txnList = data?['Transactions'] ?? [];
            if (txnList is List && txnList.isNotEmpty) {
              return txnList
                  .map((json) => KavachTransactionModel.fromJson(json))
                  .toList();
            } else {
              return <KavachTransactionModel>[]; // Empty list
            }
          },
        );

      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch transactions", e);
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

      final response = await _apiService.get(uri.toString());

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) {
                try {
                  final userListResponse = KavachUserListResponse.fromJson(data);
                  return userListResponse.data;
                } catch (e) {
                  CustomLog.error(this, "Failed to parse users data", e);
                  throw e;
                }
              },
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch users", e);
      return Error(DeserializationError());
    }
  }
}

