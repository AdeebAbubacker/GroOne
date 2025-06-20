import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import '../../../utils/custom_log.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:dio/dio.dart';
import 'package:gro_one_app/features/kavach/model/masters_model.dart';

class KavachService {
  final ApiService _apiService;
  KavachService(this._apiService);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "",  int page = 1, Map<String, String?>? preferences}) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'fleetProductId': '2',
        'page': page.toString(),
        'limit': '10',
        if (search.isNotEmpty) 'search': search,
      };

      // Add preference parameters if provided
      if (preferences != null) {
        if (preferences['make'] != null) {
          queryParams['vehicle_make'] = preferences['make']!;
        }
        if (preferences['model'] != null) {
          queryParams['vehicle_model'] = preferences['model']!;
        }
        if (preferences['tankType'] != null) {
          queryParams['vehicle_tank_type'] = preferences['tankType']!;
        }
        if (preferences['engine'] != null) {
          queryParams['vehicle_engine'] = preferences['engine']!;
        }
        if (preferences['deviceType'] != null) {
          queryParams['vehicle_device_type'] = preferences['deviceType']!;
        }
      }

      // Construct URL with query parameters
      final uri = Uri.parse('https://gro-devapi.letsgro.co/fleet/api/v1/product/list')
          .replace(queryParameters: queryParams);

      final response = await _apiService.get(uri.toString());

      if (response is Success) {
        final data = response.value;
        final rows = data['data']['rows'] as List;
        final products = rows.map((e) => KavachProduct.fromJson(e)).toList();
        return Success(products);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch Kavach products", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<KavachVehicleModel>>> fetchVehicles(String customerId) async {
    try {
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/customer/api/v1/vp-master/vehicle/$customerId',
      );

      if (response is Success) {
        final data = response.value;
        final rows = data['data'] as List;
        final vehicles = rows.map((e) => KavachVehicleModel.fromJson(e)).toList();
        return Success(vehicles);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicles", e);
      return Error(DeserializationError());
    }
  }

  // Future<Result<List<KavachAddressModel>>> fetchAddresses(String customerId, {required int addrType}) async {
  //   try {
  //     final response = await _apiService.get(
  //       'http://gro-devapi.letsgro.co/customer/api/v1/vas?customerId=$customerId&addrType=$addrType',
  //     );
  //     // final response = await _apiService.get(
  //     //   'https://gro-devapi.letsgro.co/customer/api/v1/vas?customerId=189&addrType=$addrType',
  //     // );
  //
  //     if (response is Success) {
  //       final data = response.value;
  //       final addresses = (data['data'] as List)
  //           .map((e) => KavachAddressModel.fromJson(e))
  //           .toList();
  //       return Success(addresses);
  //     } else if (response is Error) {
  //       return Error(response.type);
  //     } else {
  //       return Error(GenericError());
  //     }
  //   } catch (e) {
  //     return Error(DeserializationError());
  //   }
  // }
  Future<Result<List<KavachAddressModel>>> fetchAddresses(String customerId, {required int addrType}) async {
    try {
      final response = await _apiService.get(
        'http://gro-devapi.letsgro.co/customer/api/v1/vas?customerId=$customerId&addrType=$addrType',
        forceRefresh: true,
      );

      if (response is Success) {
        final data = response.value;
        final addresses = (data['data'] as List)
            .map((e) => KavachAddressModel.fromJson(e))
            .toList();
        return Success(addresses);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    try {
      final response = await _apiService.post(
        'https://gro-devapi.letsgro.co/customer/api/v1/vas',
        body: request.toJson(),
      );

      if (response is Success) {
        final data = response.value['data'];
        return Success(KavachAddressModel.fromJson(data));
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) async {
    try {
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/fleet/api/v1/stocks/available-stock?productId=$productId&teamId=1',
      );

      if (response is Success) {
        final data = response.value['data'];
        return Success(int.tryParse(data['availableStock'].toString()) ?? 0);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<void>> createOrder(KavachOrderRequest request) async {
    try {
      final response = await _apiService.post(
        'https://gro-devapi.letsgro.co/fleet/api/v1/orders/create',
        body: request.toJson(),
      );
      if (response is Success) {
        return Success(null);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<KavachOrderListResponse>> fetchCustomerOrders({
    required String customerId,
    int page = 1,
    int limit = 10,
    int? status,
    bool forceRefresh = false
  }) async {
    try {
      final statusParam = status != null ? "&status=$status" : "";
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/fleet/api/v1/orders/customer-orders/list?customerId=$customerId&page=$page&limit=$limit$statusParam',
        forceRefresh: forceRefresh,
      );


      // final response = await _apiService.get(
      //   '${ApiUrls.kavachOrdersList}$statusParam',
      //   queryParams: {
      //     "customerId":customerId,
      //     "page":page,
      //     "limit":limit
      //   },
      //   forceRefresh: forceRefresh,
      // );

      if (response is Success) {
        final data = response.value;
        final ordersResponse = KavachOrderListResponse.fromJson(data);
        return Success(ordersResponse);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch customer orders", e);
      return Error(DeserializationError());
    }
  }


  /// Makes a GET request to fetch masters data from the API
  /// 
  /// This method calls the masters endpoint to retrieve:
  ///models, tank types, device types, engine types
  Future<Result<MastersModel>> getMasters() async {
    try {
      final result = await _apiService.get(ApiUrls.choosePreference);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => MastersModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch masters data", e);
      return Error(DeserializationError());
    }
  }
}

