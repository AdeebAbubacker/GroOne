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
        CustomLog.debug(this, "Vehicles API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Check if the response has the expected structure
            if (responseData.containsKey('data') && responseData['data'] is List) {
              final vehicleList = responseData['data'] as List;
              CustomLog.debug(this, "Found ${vehicleList.length} vehicles in response");
              
              final vehicles = vehicleList.map((e) {
                return KavachVehicleModel.fromJson(e);
              }).toList();
              
              CustomLog.debug(this, "Successfully parsed ${vehicles.length} vehicles");
              return Success(vehicles);
            } else {
              CustomLog.error(this, "Invalid vehicles response format - missing data array", null);
              return Success(<KavachVehicleModel>[]);
            }
          } else {
            CustomLog.error(this, "Invalid vehicles response format - expected Map, got ${responseData.runtimeType}", null);
            return Error(DeserializationError());
          }
        } catch (e) {
          CustomLog.error(this, "Failed to parse vehicle data", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicles", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches addresses for a customer
  Future<Result<List<KavachAddressModel>>> fetchAddresses(
      String customerId, {
        int? addrType,
      }) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.kavachAddressList}/$customerId?limit=10&page=1',
        forceRefresh: true,
      );

      if (response is Success) {
        CustomLog.debug(this, "Fetch addresses API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Check if it's a standard success response with nested data
            if (responseData.containsKey('success') && responseData['success'] == true) {
              if (responseData.containsKey('data') && responseData['data'] is List) {
                final allAddresses = (responseData['data'] as List).map((e) => KavachAddressModel.fromJson(e)).toList();
                CustomLog.debug(this, "Successfully parsed ${allAddresses.length} addresses from nested data");
                return Success(allAddresses);
              }
            }
            
            // Check if the response is directly a list of addresses
            if (responseData.containsKey('data') && responseData['data'] is List) {
              final allAddresses = (responseData['data'] as List).map((e) => KavachAddressModel.fromJson(e)).toList();
              CustomLog.debug(this, "Successfully parsed ${allAddresses.length} addresses from direct data");
              return Success(allAddresses);
            }
            
            // Check if it's an error response
            if (responseData.containsKey('success') && responseData['success'] == false) {
              final errorMessage = responseData['message'] ?? 'Failed to fetch addresses';
              CustomLog.error(this, "Fetch addresses failed: $errorMessage", null);
              return Error(ErrorWithMessage(message: errorMessage));
            }
          }
          
          // If responseData is directly a list, try to parse it
          if (responseData is List) {
            final allAddresses = responseData.map((e) => KavachAddressModel.fromJson(e)).toList();
            CustomLog.debug(this, "Successfully parsed ${allAddresses.length} addresses from direct list");
            return Success(allAddresses);
          }
          
          CustomLog.error(this, "Unexpected response format for addresses", null);
          return Error(DeserializationError());
        } catch (e) {
          CustomLog.error(this, "Failed to parse addresses data", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch addresses", e);
      return Error(DeserializationError());
    }
  }



  /// Adds a new address for a customer
  // Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
  //   try {
  //     final response = await _apiService.post(
  //       ApiUrls.kavachAddressList,
  //       body: request.toJson(),
  //     );
  //
  //     if (response is Success) {
  //       return await _apiService.getResponseStatus(
  //         response.value,
  //             (data) => KavachAddressModel.fromJson(data['data']),
  //       );
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (e) {
  //     CustomLog.error(this, "Failed to add address", e);
  //     return Error(DeserializationError());
  //   }
  // }
  /// Adds a new address for a customer
  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    try {
      final response = await _apiService.post(
        ApiUrls.kavachAddressList,
        body: {
          "customerId": request.customerId,
          "addrName": request.addressName,
          "addr": request.addr1,
          "city": request.city,
          "state": request.state,
          "pincode": request.pincode,
          "isDefault": true, // Always true for now
          "addrType": request.addrType.toString(),
          "country": request.country,
          "gstIn": request.gstIn
        },
      );

      if (response is Success) {
        CustomLog.debug(this, "Add address API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Check if the response contains address data (success case)
            if (responseData.containsKey('preferedAddressId') || 
                responseData.containsKey('customerId') ||
                responseData.containsKey('addrName')) {
              CustomLog.debug(this, "Successfully added address with ID: ${responseData['preferedAddressId']}");
              
              // The API response is directly the address data
              final addressModel = KavachAddressModel.fromJson(responseData);
              CustomLog.debug(this, "Successfully parsed address model");
              return Success(addressModel);
            }
            
            // Check if it's a standard success response with nested data
            if (responseData.containsKey('success') && responseData['success'] == true) {
              if (responseData.containsKey('data')) {
                final addressModel = KavachAddressModel.fromJson(responseData['data']);
                CustomLog.debug(this, "Successfully parsed address model from nested data");
                return Success(addressModel);
              }
            }
            
            // Check if it's an error response
            if (responseData.containsKey('success') && responseData['success'] == false) {
              final errorMessage = responseData['message'] ?? 'Failed to add address';
              CustomLog.error(this, "Add address failed: $errorMessage", null);
              return Error(ErrorWithMessage(message: errorMessage));
            }
          }
          
          // If we reach here, assume success and try to parse as address
          CustomLog.debug(this, "Attempting to parse response as address data");
          final addressModel = KavachAddressModel.fromJson(responseData);
          return Success(addressModel);
        } catch (e) {
          CustomLog.error(this, "Failed to parse add address response", e);
          return Error(DeserializationError());
        }
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

  // Future<Result<List<CommodityModel>>> fetchCommodities() async {
  //   try {
  //     final response = await _apiService.get(
  //       ApiUrls.kavachFetchCommodities,
  //     );
  //     if (response is Success) {
  //       return await _apiService.getResponseStatus(
  //         response.value,
  //             (data) => (data['data'] as List).map((e) => CommodityModel.fromJson(e)).toList(),
  //       );
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (_) {
  //     return Error(DeserializationError());
  //   }
  // }

  Future<Result<List<CommodityModel>>> fetchCommodities() async {
    try {
      final response = await _apiService.get(ApiUrls.kavachFetchCommodities);

      if (response is Success) {
        CustomLog.debug(this, "Commodities API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Handle the case where data is nested in a 'data' field
            if (responseData.containsKey('data')) {
              final dataList = responseData['data'];
              if (dataList is List) {
                final commodities = dataList
                    .map((e) => CommodityModel.fromJson(e))
                    .toList();
                CustomLog.debug(this, "Successfully parsed ${commodities.length} commodities");
                return Success(commodities);
              }
            }
            // If no 'data' field, check if the response itself is a list
            if (responseData.containsKey('commodities') && responseData['commodities'] is List) {
              final dataList = responseData['commodities'] as List;
              final commodities = dataList
                  .map((e) => CommodityModel.fromJson(e))
                  .toList();
              CustomLog.debug(this, "Successfully parsed ${commodities.length} commodities from commodities field");
              return Success(commodities);
            }
          } else if (responseData is List) {
            // Handle the case where data is directly a list
            final commodities = responseData
                .map((e) => CommodityModel.fromJson(e))
                .toList();
            CustomLog.debug(this, "Successfully parsed ${commodities.length} commodities from direct list");
            return Success(commodities);
          }
          
          CustomLog.error(this, "Invalid commodities response format", null);
          return Success(<CommodityModel>[]);
        } catch (e) {
          CustomLog.error(this, "Failed to parse commodities data", e);
          return Error(DeserializationError());
        }
      } else {
        CustomLog.error(this, "Commodities API call failed: ${response.runtimeType}", null);
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
        CustomLog.debug(this, "Upload API raw response: ${result.value}");
        
        try {
          final responseData = result.value;
          
          if (responseData is Map<String, dynamic>) {
            CustomLog.debug(this, "Response keys: ${responseData.keys.toList()}");
            CustomLog.debug(this, "Response URL: ${responseData['url']}");
            
            // The API response is directly the document upload data
            final documentResponse = KavachVehicleDocumentUploadModel.fromJson(responseData);
            CustomLog.debug(this, "Successfully parsed document upload response");
            return Success(documentResponse);
          } else {
            CustomLog.error(this, "Invalid upload response format - expected Map, got ${responseData.runtimeType}", null);
            return Error(DeserializationError());
          }
        } catch (e) {
          CustomLog.error(this, "Failed to parse upload response", e);
          return Error(DeserializationError());
        }
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
        CustomLog.debug(this, "Add vehicle API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Check if the response contains vehicle data (success case)
            if (responseData.containsKey('vehicleId') || 
                responseData.containsKey('truckNo') ||
                responseData.containsKey('customerId')) {
              CustomLog.debug(this, "Successfully added vehicle with ID: ${responseData['vehicleId']}");
              return Success(null); // Success case
            }
            
            // Check if it's a standard success response
            if (responseData.containsKey('success') && responseData['success'] == true) {
              CustomLog.debug(this, "Vehicle added successfully");
              return Success(null);
            }
            
            // Check if it's an error response
            if (responseData.containsKey('success') && responseData['success'] == false) {
              final errorMessage = responseData['message'] ?? 'Failed to add vehicle';
              CustomLog.error(this, "Add vehicle failed: $errorMessage", null);
              return Error(ErrorWithMessage(message: errorMessage));
            }
          }
          
          // If we reach here, assume success
          CustomLog.debug(this, "Vehicle added successfully (default case)");
          return Success(null);
        } catch (e) {
          CustomLog.error(this, "Failed to parse add vehicle response", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Add vehicle error", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<String>>> fetchTruckTypeList() async {
    try {
      final response = await _apiService.get(ApiUrls.kavachTruckType);

      if (response is Success) {
        CustomLog.debug(this, "Truck types API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is Map<String, dynamic>) {
            // Handle the case where data is nested in a 'data' field
            if (responseData.containsKey('data')) {
              final dataList = responseData['data'];
              if (dataList is List) {
                final truckTypes = dataList
                    .map((item) => item.toString())
                    .where((item) => item.isNotEmpty)
                    .toList();
                CustomLog.debug(this, "Successfully parsed ${truckTypes.length} truck types");
                return Success(truckTypes);
              }
            }
            // If no 'data' field, check if the response itself is a list
            if (responseData.containsKey('truckTypes') && responseData['truckTypes'] is List) {
              final dataList = responseData['truckTypes'] as List;
              final truckTypes = dataList
                  .map((item) => item.toString())
                  .where((item) => item.isNotEmpty)
                  .toList();
              CustomLog.debug(this, "Successfully parsed ${truckTypes.length} truck types from truckTypes field");
              return Success(truckTypes);
            }
          } else if (responseData is List) {
            // Handle the case where data is directly a list
            final truckTypes = responseData
                .map((item) => item.toString())
                .where((item) => item.isNotEmpty)
                .toList();
            CustomLog.debug(this, "Successfully parsed ${truckTypes.length} truck types from direct list");
            return Success(truckTypes);
          }
          
          CustomLog.error(this, "Invalid truck types response format", null);
          return Success(<String>[]);
        } catch (e) {
          CustomLog.error(this, "Failed to parse truck types data", e);
          return Error(DeserializationError());
        }
      } else {
        CustomLog.error(this, "Truck types API call failed: ${response.runtimeType}", null);
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
        try {
          final data = response.value;
          final truckLengths = (data as List) // 👈 direct list
              .map((e) => TruckLengthModel.fromJson(e))
              .toList();

          return Success(truckLengths);
        } catch (e) {
          CustomLog.error(this, "Error parsing truck lengths", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch truck lengths", e);
      return Error(DeserializationError());
    }
  }


  // Future<Result<List<String>>> fetchTruckTypeList() async {
  //   try {
  //     final response = await _apiService.get(ApiUrls.kavachTruckType);
  //     if (response is Success) {
  //       return await _apiService.getResponseStatus(
  //         response.value,
  //             (data) => (data['data'] as List).cast<String>(),
  //       );
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (_) {
  //     return Error(DeserializationError());
  //   }
  // }
  // Future<Result<List<TruckLengthModel>>> fetchTruckLengths(String type) async {
  //   try {
  //     final response = await _apiService.get('${ApiUrls.kavachTruckSubType}/$type');
  //     if (response is Success) {
  //       return await _apiService.getResponseStatus(
  //         response.value,
  //             (data) => (data['data'] as List).map((e) => TruckLengthModel.fromJson(e)).toList(),
  //       );
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (_) {
  //     return Error(DeserializationError());
  //   }
  // }

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
      CustomLog.debug(this, "Fetching transactions for customer: $customerId");
      
      final result = await _apiService.get(
        ///todo: currently using mock API so it is hardcoded will change it when receive the API for this.
        'https://gro-devapi.letsgro.co/vendor/api/v1/payment/getTransaction',
      );

      if (result is Success) {
        CustomLog.debug(this, "Transaction API raw response: ${result.value}");
        CustomLog.debug(this, "Transaction API response type: ${result.value.runtimeType}");
        
        try {
          final responseData = result.value;
          
          if (responseData is Map<String, dynamic>) {
            CustomLog.debug(this, "Response keys: ${responseData.keys.toList()}");
            
            // Check if Transactions is directly in response
            if (responseData.containsKey('Transactions') && responseData['Transactions'] is List) {
              final txnList = responseData['Transactions'] as List;
              CustomLog.debug(this, "Found Transactions directly in response: ${txnList.length}");
              
              if (txnList.isNotEmpty) {
                try {
                  final transactions = txnList
                      .map((json) {
                        CustomLog.debug(this, "Parsing transaction: $json");
                        return KavachTransactionModel.fromJson(json);
                      })
                      .toList();
                  CustomLog.debug(this, "Successfully parsed ${transactions.length} transactions");
                  return Success(transactions);
                } catch (e) {
                  CustomLog.error(this, "Failed to parse transaction data", e);
                  return Error(DeserializationError());
                }
              } else {
                CustomLog.debug(this, "No transactions found in response");
                return Success(<KavachTransactionModel>[]);
              }
            } else {
              CustomLog.error(this, "Transactions key not found or not a list in response. Available keys: ${responseData.keys.toList()}", null);
              return Error(DeserializationError());
            }
          } else {
            CustomLog.error(this, "Invalid response format - expected Map, got ${responseData.runtimeType}", null);
            return Error(DeserializationError());
          }
        } catch (e) {
          CustomLog.error(this, "Failed to parse transaction response", e);
          return Error(DeserializationError());
        }
      } else {
        CustomLog.error(this, "Transaction API call failed: ${result.runtimeType}", null);
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

      CustomLog.debug(this, "Kavach Fetch Users - URL: $uri");

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
        CustomLog.error(this, "Kavach Fetch Users - API call failed: ${response.runtimeType}", null);
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Kavach Fetch Users - Exception: $e", e);
      return Error(DeserializationError());
    }
  }
}

