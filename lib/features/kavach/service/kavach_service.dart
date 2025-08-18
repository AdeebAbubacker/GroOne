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
import '../api_request/kavach_payment_api_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_commodity_model.dart';
import '../model/kavach_invoice_response_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_transaction_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_user_model.dart';
import '../model/kavach_vehicle_document_upload_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_masters_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';

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
        '${ApiUrls.kavachAddressList}/$customerId?limit=20&page=1',
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

  /// Initiates payment for Kavach order
  Future<Result<OrderAddedSuccess>> initiatePayment(KavachInitiatePaymentRequest request) async {
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
    } catch (e, s) {
      CustomLog.error(this, "Failed to initiate payment", e);
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
    int fleetProductId = 2,
  }) async {
    try {
      final statusParam = status != null ? "&status=$status" : "";
      final response = await _apiService.get(
        '${ApiUrls.kavachOrdersList}?customerId=$customerId&page=$page&limit=$limit$statusParam&fleetProductId=$fleetProductId',
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
        'documentType': 'vp_document',
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
      final response = await _apiService.get(ApiUrls.loadTruckType);

      if (response is Success) {
        CustomLog.debug(this, "Truck types API raw response: ${response.value}");
        
        try {
          final responseData = response.value;
          
          if (responseData is List) {
            // Handle the case where data is directly a list of objects
            // Extract unique type names from the objects
            final truckTypes = responseData
                .whereType<Map<String, dynamic>>()
                .map((item) => item['type']?.toString() ?? '')
                .where((type) => type.isNotEmpty)
                .toSet() // Remove duplicates
                .toList();
            CustomLog.debug(this, "Successfully parsed $truckTypes.length unique truck types from direct list");
            return Success(truckTypes);
          } else if (responseData is Map<String, dynamic>) {
            // Handle the case where data is nested in a 'data' field
            if (responseData.containsKey('data')) {
              final dataList = responseData['data'];
              if (dataList is List) {
                final truckTypes = dataList
                    .whereType<Map<String, dynamic>>()
                    .map((item) => item['type']?.toString() ?? '')
                    .where((type) => type.isNotEmpty)
                    .toSet() // Remove duplicates
                    .toList();
                CustomLog.debug(this, "Successfully parsed $truckTypes.length unique truck types");
                return Success(truckTypes);
              }
            }
            // If no 'data' field, check if the response itself is a list
            if (responseData.containsKey('truckTypes') && responseData['truckTypes'] is List) {
              final dataList = responseData['truckTypes'] as List;
              final truckTypes = dataList
                  .whereType<Map<String, dynamic>>()
                  .map((item) => item['type']?.toString() ?? '')
                  .where((type) => type.isNotEmpty)
                  .toSet() // Remove duplicates
                  .toList();
              CustomLog.debug(this, "Successfully parsed $truckTypes.length unique truck types from truckTypes field");
              return Success(truckTypes);
            }
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
      // Fetch all truck types and filter by the selected type
      final response = await _apiService.get(ApiUrls.loadTruckType);

      if (response is Success) {
        try {
          final data = response.value;
          List<dynamic> truckTypesList;
          
          // Handle different response formats
          if (data is List) {
            truckTypesList = data;
          } else if (data is Map<String, dynamic> && data.containsKey('data') && data['data'] is List) {
            truckTypesList = data['data'] as List;
          } else {
            return Error(DeserializationError());
          }
          
          // Filter truck types by the selected type and convert to TruckLengthModel
          final truckLengths = truckTypesList
              .whereType<Map<String, dynamic>>()
              .where((item) => item['type'] == type)
              .map((item) => TruckLengthModel.fromJson(item))
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



  /// Fetch all truck types with complete information (ID, type, subtype)
  Future<Result<List<TruckLengthModel>>> fetchAllTruckTypes() async {
    try {
      // Use the new truck types API
      final response = await _apiService.get(ApiUrls.loadTruckType);

      if (response is Success) {
        try {
          final data = response.value;
          CustomLog.debug(this, "Truck types API raw response: $data");
          CustomLog.debug(this, "Truck types API response type: $data.runtimeType");
          
          List<dynamic> truckTypesList;
          
          // Handle different response formats
          if (data is List) {
            // Direct list response (new API format with complete objects)
            truckTypesList = data;
          } else if (data is Map<String, dynamic>) {
            // Check if data is wrapped in a response object
            if (data.containsKey('data') && data['data'] is List) {
              truckTypesList = data['data'] as List;
            } else {
              CustomLog.error(this, "Invalid response format - no 'data' key found", null);
              return Error(DeserializationError());
            }
          } else {
            CustomLog.error(this, "Invalid response format - expected List or Map, got ${data.runtimeType}", null);
            return Error(DeserializationError());
          }
          
          // Convert API response to TruckLengthModel objects
          // The new API returns objects with id, type, subType fields
          final truckTypes = truckTypesList.map((item) {
            if (item is Map<String, dynamic>) {
              return TruckLengthModel.fromJson(item);
            } else {
              CustomLog.error(this, "Invalid truck type item format: $item", null);
              throw Exception("Invalid truck type item format");
            }
          }).toList();

          CustomLog.debug(this, "Successfully parsed $truckTypes.length truck types");
          return Success(truckTypes);
        } catch (e) {
          CustomLog.error(this, "Error parsing all truck types", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch all truck types", e);
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
      // Custom headers for the new vehicle verification API
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': '5f522b06263423e4cab5eb45d27f2be4',
        'X-Application-UDID': '52e3dcc8-52ef-4f52-8756-3a06996757cd',
        'Content-Type': 'application/json',
      };
      
      final response = await _apiService.post(
        ApiUrls.kavachVehicleVerification,
        body: {
          "vehicle_number": vehicleNumber,
        },
        customHeaders: customHeaders,
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => data['success'] == true,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Vehicle verification failed", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<Map<String, dynamic>>> fetchVehicleData(String vehicleNumber) async {
    try {
      // === Step 1: Hit API-2 (Check if vehicle exists) ===
      print('=== Step 1: Hit API-2 (Check if vehicle exists) ===');
      final url = '${ApiUrls.checkVehicleNumber}/$vehicleNumber';

      final api2Response = await _apiService.get(
        // 'https://gro-devapi.letsgro.co/customer/api/v1/vehicle/check/vehicle-no/$vehicleNumber',
        url,
      );

      final api2Data = api2Response is Success ? api2Response.value['data'] : null;

      if (api2Data != null && api2Data != false) {
        return Success(api2Data);
      }
      // if (api2Response is Success && api2Response.value['data'] != null) {
      //   return Success(api2Response.value['data']);
      // }

      // === Step 2: Fallback to API-1 ===
      print('=== Step 2: Fallback to API-1 ===');
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': '5f522b06263423e4cab5eb45d27f2be4',
        'X-Application-UDID': '52e3dcc8-52ef-4f52-8756-3a06996757cd',
        'Content-Type': 'application/json',
      };

      final api1Response = await _apiService.post(
        // 'https://groone-uat.letsgro.co/vehicle_number/api/v1/send_vehicle_number',
        ApiUrls.kavachVehicleVerification,
        body: {"vehicle_number": vehicleNumber},
        customHeaders: customHeaders,
      );

      if (api1Response is Success && api1Response.value['data'] != null) {
        return Success(api1Response.value['data']);
      }

      return Error(GenericError());
    } catch (e) {
      return Error(GenericError());
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

  Future<Result<KavachInvoiceResponse>> downloadInvoice(String orderId) async {
    final url = ApiUrls.kavachInvoice(orderId);
    final result = await _apiService.get(
      url,
    );

    if (result is Success) {
      try {
        final data = result.value as Map<String, dynamic>;
        final invoice = KavachInvoiceResponse.fromJson(data);
        return Success(invoice);
      } catch (e) {
        return Error(DeserializationError());
      }
    } else if (result is Error) {
      return Error(result.type);
    } else {
      return Error(GenericError());
    }
  }

  Future<Result<Map<String, dynamic>>> checkFleetPaymentStatus(String paymentRequestId) async {
    try {
      final response = await _apiService.post(
        '${ApiUrls.fleetPaymentStatus}/$paymentRequestId',
      );

      if (response is Success) {
        final data = response.value as Map<String, dynamic>;
        if (data['success'] == true && data['findData'] != null) {
          return Success(data['findData']);
        } else {
          return Error(ErrorWithMessage(message: data['message'] ?? "Payment status check failed"));
        }
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}

