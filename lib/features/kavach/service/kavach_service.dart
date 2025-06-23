import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import 'package:gro_one_app/features/kavach/model/choose_preference_model.dart';
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

  /// Fetches Kavach products with optional search and preference filters
  Future<Result<List<KavachProduct>>> fetchProducts({ String search = "",  int page = 1, 
    ChoosePreferenceModel? preferences,
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
      final uri = Uri.parse(ApiUrls.kavachProductList) .replace(queryParameters: queryParams);

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

  /// Fetches vehicles for a specific customer
  Future<Result<List<KavachVehicleModel>>> fetchVehicles(String customerId) async {
    try {
      final response = await _apiService.get( '${ApiUrls.kavachVehicleDetails}/$customerId', );
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

  /// Fetches addresses for a customer with specified address type
  Future<Result<List<KavachAddressModel>>> fetchAddresses(
    String customerId, 
    {required int addrType}
  ) async {
    try {
      final response = await _apiService.get( '${ApiUrls.kavachAddressList}?customerId=$customerId&addrType=$addrType',
        forceRefresh: true, );

      if (response is Success) {
        final data = response.value;
        final addresses = (data['data'] as List).map((e) => KavachAddressModel.fromJson(e)).toList();
        return Success(addresses);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch addresses", e);
      return Error(DeserializationError());
    }
  }

  /// Adds a new address for a customer
  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    try {
      final response = await _apiService.post(ApiUrls.kavachAddressList,
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
      CustomLog.error(this, "Failed to add address", e);
      return Error(DeserializationError());
    }
  }

  /// Fetches available stock for a specific product
  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) async {
    try {
      final response = await _apiService.get('${ApiUrls.kavachAvailableStock}?productId=$productId&teamId=1', );

      if (response is Success) {
        final data = response.value['data'];
        return Success(int.tryParse(data['availableStock'].toString()) ?? 0);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch available stock", e);
      return Error(DeserializationError());
    }
  }

  /// Creates a new Kavach order
  Future<Result<void>> createOrder(KavachOrderRequest request) async {
    try {
      final response = await _apiService.post(ApiUrls.kavachCreateOrder,
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
    bool forceRefresh = false
  }) async {
    try {
      final statusParam = status != null ? "&status=$status" : "";
      final response = await _apiService.get(
        '${ApiUrls.kavachOrdersList}?customerId=$customerId&page=$page&limit=$limit$statusParam',
        forceRefresh: forceRefresh,
      );

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


 /// Fetches masters data from the API
  Future<Result<MastersModel>> getMasters() async {
    try {
      final result = await _apiService.get(ApiUrls.choosePreference);
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value, 
          (data) => MastersModel.fromJson(data)
        );
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

