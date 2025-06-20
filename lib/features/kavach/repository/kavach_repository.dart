import 'dart:convert';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:http/http.dart' as http;
import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../login/model/login_model.dart';
import '../../login/repository/user_information_repository.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_product_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/masters_model.dart';
import 'package:gro_one_app/data/ui_state/status.dart';

class KavachRepository {
  final KavachService _service;
  final UserInformationRepository userInfoRepo;

  KavachRepository(this._service, this.userInfoRepo);

// for getting the kavach products
  Future<Result<List<KavachProduct>>> fetchProducts({ String search = "",  int page = 1, Map<String, String?>? preferences,}) {
    return _service.fetchProducts(
      search: search, 
      page: page,
      preferences: preferences,
    );
  }

 // for getting the kavach vehicles
  Future<Result<List<KavachVehicleModel>>> fetchVehicles() async {
    String cId = await userInfoRepo.getUserID()??'';
    return _service.fetchVehicles(cId);
  }

  // for getting the kavach addresses
  Future<Result<List<KavachAddressModel>>> fetchAddresses({required int addrType}) async {
    String cId = await userInfoRepo.getUserID()??'';
    return _service.fetchAddresses(cId, addrType: addrType);
  }

  // for adding the kavach address
  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    String cId = await userInfoRepo.getUserID()??'';
    request.customerId = int.tryParse(cId)??0;
    return _service.addAddress(request);
  }

  // for getting the kavach available stock
  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) {
    return _service.fetchAvailableStock(productId: productId);
  }

  // for creating the kavach order
  Future<Result<void>> createOrder(KavachOrderRequest request) async {
    return _service.createOrder(request);
  }

  // Future<Result<KavachOrderListResponse>> fetchCustomerOrders({
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   String cId = await userInfoRepo.getUserID()??'';
  //   return _service.fetchCustomerOrders(customerId: cId, page: page, limit: limit);
  // }
 
  // for getting the kavach customer orders
  Future<Result<KavachOrderListResponse>> fetchCustomerOrders({
    int page = 1,
    int limit = 10,
    int? status,
    bool forceRefresh = false
  }) async {
    String cId = await userInfoRepo.getUserID() ?? '';
    return _service.fetchCustomerOrders(
      customerId: cId,
      page: page,
      limit: limit,
      status: status,
      forceRefresh: forceRefresh
    );
  }


  
  /// This method calls the service to fetch masters data and returns the result directly.
  Future<Result<MastersModel>> getMasters() async {
    try {
      return await _service.getMasters();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch masters data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}

