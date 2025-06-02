import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import '../../../utils/custom_log.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_vehicle_model.dart';

class KavachService {
  final ApiService _apiService;

  KavachService(this._apiService);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) async {
    try {
      final response = await _apiService.get(
        'http://gro-devapi.letsgro.co/fleet/api/v1/product/list?fleetProductId=2&page=$page&limit=10&search=$search',
      );

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
        'http://gro-devapi.letsgro.co/customer/api/v1/vp-master/vehicle/$customerId',
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

  Future<Result<List<KavachAddressModel>>> fetchAddresses(String customerId, {int addrType = 1}) async {
    try {
      // final response = await _apiService.get(
      //   'http://gro-devapi.letsgro.co/customer/api/v1/vas?customerId=$customerId&addrType=$addrType',
      // );
      final response = await _apiService.get(
        'http://gro-devapi.letsgro.co/customer/api/v1/vas?customerId=189&addrType=$addrType',
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


}

