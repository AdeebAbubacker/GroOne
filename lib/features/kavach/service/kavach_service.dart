import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../api_request/kavach_add_vehicle_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_commodity_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_vehicle_document_upload_model.dart';
import '../model/kavach_vehicle_model.dart';

class KavachService {
  final ApiService _apiService;
  KavachService(this._apiService);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) async {
    try {
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/fleet/api/v1/product/list?fleetProductId=2&page=$page&limit=10&search=$search',
      );
      // final response = await _apiService.get(
      //   'https://gro-devapi.letsgro.co/fleet/fleet/api/v1/product/list?fleetProductId=2&page=$page&limit=10&search=$search',
      // );

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
        "${ApiUrls.kavachVehicle}/$customerId",
        forceRefresh: true,
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

  Future<Result<List<KavachAddressModel>>> fetchAddresses(String customerId, {required int addrType}) async {
    try {
      final queryParameters = {
        'customerId': customerId,
        'addrType': addrType.toString(),
      };

      final response = await _apiService.get(
        ApiUrls.kavachAddress,
        forceRefresh: true,
        queryParams: queryParameters
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
        ApiUrls.kavachAddress,
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
        ApiUrls.kavachCreateOrder,
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
      // final statusParam = status != null ? "&status=$status" : "";
      //
      // final response = await _apiService.get(
      //   'https://gro-devapi.letsgro.co/fleet/api/v1/orders/customer-orders/list?customerId=$customerId&page=$page&limit=$limit$statusParam',
      //   forceRefresh: forceRefresh,
      // );
      final queryParameters = {
        'customerId': customerId,
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status.toString(),
      };

      final response = await _apiService.get(
        ApiUrls.kavachOrdersList,
        forceRefresh: forceRefresh,
        queryParams: queryParameters,
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

  Future<Result<List<CommodityModel>>> fetchCommodities() async {
    try {
      final response = await _apiService.get(
        ApiUrls.kavachFetchCommodities,
      );
      if (response is Success) {
        final data = response.value['data'] as List;
        final commodities = data.map((e) => CommodityModel.fromJson(e)).toList();
        return Success(commodities);
      }
      return Error(response is Error ? response.type : GenericError());
    } catch (_) {
      return Error(DeserializationError());
    }
  }

  Future<Result<KavachVehicleDocumentUploadModel>> fetchUploadGstData(File file) async {
    try {
      final result = await _apiService.multipart(ApiUrls.upload, file, pathName: "file");
      if (result is Success) {
        return _apiService.getResponseStatus(
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

  Future<Result<List<String>>> fetchTruckTypeList() async {
    try {
      final response = await _apiService.get(ApiUrls.kavachTruckType);
      if (response is Success) {
        final data = (response.value['data'] as List).cast<String>();
        return Success(data);
      }
      return Error(response is Error ? response.type : GenericError());
    } catch (_) {
      return Error(DeserializationError());
    }
  }

  Future<Result<List<TruckLengthModel>>> fetchTruckLengths(String type) async {
    try {
      final response = await _apiService.get('${ApiUrls.kavachTruckSubType}/$type');
      if (response is Success) {
        final data = (response.value['data'] as List)
            .map((e) => TruckLengthModel.fromJson(e))
            .toList();
        return Success(data);
      }
      return Error(response is Error ? response.type : GenericError());
    } catch (_) {
      return Error(DeserializationError());
    }
  }



}

