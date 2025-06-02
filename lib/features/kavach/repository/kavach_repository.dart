import 'dart:convert';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:http/http.dart' as http;
import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../login/model/login_model.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_product_model.dart';
import '../model/kavach_vehicle_model.dart';

class KavachRepository {
  final KavachService _service;

  KavachRepository(this._service);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) {
    return _service.fetchProducts(search: search, page: page);
  }

  Future<Result<List<KavachVehicleModel>>> fetchVehicles(String customerId) {
    return _service.fetchVehicles(customerId);
  }

  Future<Result<List<KavachAddressModel>>> fetchAddresses(String customerId, {int addrType = 1}) {
    return _service.fetchAddresses(customerId, addrType: addrType);
  }

}

