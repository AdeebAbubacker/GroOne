import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_choose_preference_model.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../api_request/kavach_add_vehicle_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_commodity_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_transaction_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_vehicle_document_upload_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_masters_model.dart';

class KavachService {
  final ApiService _apiService;
  KavachService(this._apiService);

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
        '${ApiUrls.kavachVehicleDetails}/$customerId',
      );
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => (data['data'] as List).map((e) => KavachVehicleModel.fromJson(e)).toList(),
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
  // Future<Result<List<KavachAddressModel>>> fetchAddresses(
  //     String customerId, {
  //       required int addrType,
  //     }) async {
  //   try {
  //     // final response = await _apiService.get(
  //     //   '${ApiUrls.kavachAddressList}?customerId=$customerId&addrType=$addrType',
  //     //   forceRefresh: true,
  //     // );
  //     final response = await _apiService.get(
  //       'https://gro-devapi.letsgro.co/customer/api/v1/address/$customerId',
  //       forceRefresh: true,
  //     );
  //
  //
  //     if (response is Success) {
  //       // return await _apiService.getResponseStatus(
  //       //   response.value,
  //       //       (data) => (data['data'] as List).map((e) => KavachAddressModel.fromJson(e)).toList(),
  //       // );
  //       return await _apiService.getResponseStatus(
  //         response.value,
  //             (data) => (data['data'] as List)
  //             .map((e) => KavachAddressModel.fromJson(e))
  //             .toList(),
  //       );
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (e) {
  //     CustomLog.error(this, "Failed to fetch addresses", e);
  //     return Error(DeserializationError());
  //   }
  // }
  Future<Result<List<KavachAddressModel>>> fetchAddresses(
      String customerId, {
        required int addrType,
      }) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.kavachAddressList}/$customerId',
        forceRefresh: true,
      );

      if (response is Success) {
        try {
          // Directly parse data since API has no success/status field
          final data = response.value;

          final addresses = (data['data'] as List)
              .map((e) => KavachAddressModel.fromJson(e))
              .toList();

          final filteredAddresses = addresses
              .where((address) => address.addrType == addrType)
              .toList();

          return Success(filteredAddresses);
        } catch (e) {
          CustomLog.error(this, "Error parsing address data", e);
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
        // Directly parse response since API has no success field
        final data = response.value;

        final address = KavachAddressModel.fromJson(data);
        return Success(address);
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
        try {
          final data = response.value; // Direct response is a List
          final commodities = (data as List) // 👈 No ['data'] here
              .map((e) => CommodityModel.fromJson(e))
              .toList();

          return Success(commodities);
        } catch (e) {
          CustomLog.error(this, "Error parsing commodities", e);
          return Error(DeserializationError());
        }
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
      final result = await _apiService.multipart(ApiUrls.upload, file, pathName: "file");
      if (result is Success) {
        // This function already uses getResponseStatus as requested
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
        try {
          final data = response.value;
          final truckTypes = (data as List).cast<String>(); // 👈 fixed
          return Success(truckTypes);
        } catch (e) {
          CustomLog.error(this, "Error parsing truck types", e);
          return Error(DeserializationError());
        }
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


}

