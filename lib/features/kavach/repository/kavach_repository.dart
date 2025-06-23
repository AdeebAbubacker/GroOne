import 'dart:convert';
import 'dart:io';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_document_upload_model.dart';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:http/http.dart' as http;
import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../login/model/login_model.dart';
import '../../login/repository/user_information_repository.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../api_request/kavach_add_vehicle_request.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_commodity_model.dart';
import '../model/kavach_order_list_model.dart';
import '../model/kavach_product_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_truck_type_model.dart';
import '../model/kavach_vehicle_model.dart';

class KavachRepository {
  final KavachService _service;
  final UserInformationRepository userInfoRepo;

  KavachRepository(this._service, this.userInfoRepo);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) {
    return _service.fetchProducts(search: search, page: page);
  }

  Future<Result<List<KavachVehicleModel>>> fetchVehicles() async {
    String cId = await userInfoRepo.getUserID()??'';
    return _service.fetchVehicles(cId);
  }

  Future<Result<List<KavachAddressModel>>> fetchAddresses({required int addrType}) async {
    String cId = await userInfoRepo.getUserID()??'';
    return _service.fetchAddresses(cId, addrType: addrType);
  }

  Future<Result<KavachAddressModel>> addAddress(KavachAddAddressApiRequest request) async {
    String cId = await userInfoRepo.getUserID()??'';
    request.customerId = int.tryParse(cId)??0;
    return _service.addAddress(request);
  }

  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) {
    return _service.fetchAvailableStock(productId: productId);
  }

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

  // Future<Result<List<TruckTypeModel>>> fetchTruckTypes() {
  //   return _service.fetchTruckTypes();
  // }

  Future<Result<List<CommodityModel>>> fetchCommodities() {
    return _service.fetchCommodities();
  }

  Future<Result<KavachVehicleDocumentUploadModel>> getUploadGstData(File file) {
    return _service.fetchUploadGstData(file);
  }

  Future<Result<void>> addVehicle(KavachAddVehicleRequest request) async {
    return _service.addVehicle(request);
  }

  Future<Result<List<String>>> fetchTruckTypes() {
    return _service.fetchTruckTypeList();
  }

  Future<Result<List<TruckLengthModel>>> fetchTruckLengths(String type) {
    return _service.fetchTruckLengths(type);
  }


}

