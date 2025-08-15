import 'dart:convert';
import 'dart:io';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_document_upload_model.dart';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:gro_one_app/features/kavach/model/kavach_choose_preference_model.dart';
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
import '../model/kavach_transaction_model.dart';
import '../model/kavach_truck_length_model.dart';
import '../model/kavach_truck_type_model.dart';
import '../model/kavach_user_model.dart';
import '../model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_masters_model.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';

class KavachRepository {
  final KavachService _service;
  final UserInformationRepository userInfoRepo;

  KavachRepository(this._service, this.userInfoRepo);

  /// Fetches Kavach products with optional search and preference filters
  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1,  KavachChoosePreferenceModel? preferences, }) async {
    try {
      return await _service.fetchProducts(
        search: search,
        page: page,
        preferences: preferences,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch products in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

 // for getting the kavach vehicles
  Future<Result<List<KavachVehicleModel>>> fetchVehicles() async {
    try {
      final customerId = await userInfoRepo.getUserID() ?? '';
      if (customerId.isEmpty) {
        return Error(ErrorWithMessage(message: "Customer ID not found"));
      }
      return await _service.fetchVehicles(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicles in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetches addresses for the current user
  Future<Result<List<KavachAddressModel>>> fetchAddresses() async {
    try {
      final customerId = await userInfoRepo.getUserID() ?? '';
      if (customerId.isEmpty) {
        return Error(ErrorWithMessage(message: "Customer ID not found"));
      }
      return await _service.fetchAddresses(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch addresses in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Adds a new address for the current user
  Future<Result<KavachAddressModel>> addAddress(
    KavachAddAddressApiRequest request
  ) async {
    try {
      final customerId = await userInfoRepo.getUserID() ?? '';
      if (customerId.isEmpty) {
        return Error(ErrorWithMessage(message: "Customer ID not found"));
      }
      // Set the customer ID in the request as string
      request.customerId = customerId;

      return await _service.addAddress(request);
    } catch (e) {
      CustomLog.error(this, "Failed to add address in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetches available stock for a specific product
  Future<Result<int>> fetchAvailableStock({
    required String productId,
  }) async {
    try {
      return await _service.fetchAvailableStock(productId: productId);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch available stock in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Creates a new Kavach order
  Future<Result<void>> createOrder(KavachOrderRequest request) async {
    try {
      return await _service.createOrder(request);
    } catch (e) {
      CustomLog.error(this, "Failed to create order in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Initiates payment for Kavach order
  Future<Result<OrderAddedSuccess>> initiatePayment(KavachInitiatePaymentRequest request) async {
    try {
      return await _service.initiatePayment(request);
    } catch (e) {
      CustomLog.error(this, "Failed to initiate payment in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetches customer orders for the current user with optional filtering
  Future<Result<KavachOrderListResponse>> fetchCustomerOrders({ int page = 1, int limit = 10, int? status, bool forceRefresh = false,int fleetProductId = 2, }) async {
    try {
      final customerId = await userInfoRepo.getUserID() ?? '';
      if (customerId.isEmpty) {
        return Error(ErrorWithMessage(message: "Customer ID not found"));
      }
      return await _service.fetchCustomerOrders(
        customerId: customerId,
        page: page,
        limit: limit,
        status: status,
        forceRefresh: forceRefresh,
        fleetProductId: fleetProductId,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch customer orders in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<CommodityModel>>> fetchCommodities() async {
    try {
      return await _service.fetchCommodities();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch commodities in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<KavachVehicleDocumentUploadModel>> getUploadGstData(File file) async {
    try {
      return await _service.fetchUploadGstData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch GST upload data in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> addVehicle(KavachAddVehicleRequest request) async {
    try {
      final customerId = await userInfoRepo.getUserID() ?? '';
      CustomLog.debug(this, "Add Vehicle - Customer ID: '$customerId'");
      
      if (customerId.isEmpty) {
        CustomLog.error(this, "Add Vehicle - Customer ID is empty", "Customer ID not found");
        return Error(ErrorWithMessage(message: "Customer ID not found"));
      }
      
      // Create a new request with the correct customer ID
      final updatedRequest = KavachAddVehicleRequest(
        customerId: customerId,
        vehicleNumber: request.vehicleNumber,
        vehicleTypeId: request.vehicleTypeId,
        rcNumber: request.rcNumber,
        rcDocLink: request.rcDocLink,
        truckMakeAndModel: request.truckMakeAndModel,
        truckType: request.truckType,
        truckLength: request.truckLength,
        capacity: request.capacity,
        acceptableCommodities: request.acceptableCommodities,
        vehicleStatus: request.vehicleStatus,
      );
      
      CustomLog.debug(this, "Add Vehicle - Request with customer ID: ${updatedRequest.toJson()}");
      return await _service.addVehicle(updatedRequest);
    } catch (e) {
      CustomLog.error(this, "Failed to add vehicle in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<String>>> fetchTruckTypes() async {
    try {
      return await _service.fetchTruckTypeList();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch truck types in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<TruckLengthModel>>> fetchTruckLengths(String type) async {
    try {
      return await _service.fetchTruckLengths(type);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch truck lengths in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<TruckLengthModel>>> fetchAllTruckTypes() async {
    try {
      return await _service.fetchAllTruckTypes();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch all truck types in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Fetches masters data for vehicle preferences
  Future<Result<KavachMastersModel>> getMasters() async {
    try {
      return await _service.getMasters();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch masters data in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verifies vehicle number
  Future<Result<bool>> verifyVehicle(String vehicleNumber, {bool force = true}) async {
    try {
      return await _service.verifyVehicle(vehicleNumber, force: force);
    } catch (e) {
      CustomLog.error(this, "Failed to verify vehicle in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Fetches users for referral code functionality
  Future<Result<List<KavachUserModel>>> fetchUsers({
    String search = "",
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _service.fetchUsers(
        search: search,
        page: page,
        limit: limit,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch users in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> fetchVehicleData(String vehicleNumber) async {
    try {
      return await _service.fetchVehicleData(vehicleNumber);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicle data in repository", e);
      return Error(GenericError());
    }
  }

}

