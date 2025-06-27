import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class  LpLoadRepository {
  final LpLoadService service;
  final UserInformationRepository userRepo;

  LpLoadRepository(this.service, this.userRepo);

  Future<Result<List<LpLoadItem>>> fetchLoads({required LoadListApiRequest request, bool forceRefresh = false}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.fetchLoads(request: request.copyWith(customerId: customerId), forceRefresh: forceRefresh);
    } catch (e) {
      CustomLog.error(this, "Failed to get fetch loads data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadGetByIdResponse>> fetchLoadById({required int loadId, bool forceRefresh = false}) async {
    try {
      return service.fetchLoadsById(loadId: loadId,forceRefresh: forceRefresh);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch loads by ID data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LoadMemoData>> fetchMemoDetails({required int loadId, bool forceRefresh = false}) async {
    try {
      return service.fetchMemoDetails(loadId: loadId, forceRefresh: forceRefresh);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch memo details data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LoadTruckTypeListModel>> fetchTruckTypeList() async {
    try {
      return service.fetchTruckTypeList();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch truck list data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadRouteResponse>> fetchRouteList() async {
    try {
      return service.fetchRouteList();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch route list data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoOtpResponse>> sendOtp() async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.sendOtp(customerId: customerId);

    } catch (e) {
      CustomLog.error(this, "Failed to send OTP data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoOtpResponse>> verifyOtp({required String otp}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.verifyOtp(customerId: customerId, otp: otp);
    } catch (e) {
      CustomLog.error(this, "Failed to get verify OTP data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoOtpResponse>> applyFilter({required int fromRoute, required int toRoute, required String truckType, required String loadPostedDate}) async {
    try {
      return service.applyFilter(fromRoute: fromRoute, toRoute: toRoute, truckType: truckType, loadPostedDate: loadPostedDate);
    } catch (e) {
      CustomLog.error(this, "Failed to get apply filter data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadCreditCheckResponse>> getCreditCheck() async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.getCreditCheck(customerId: customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to get credit check data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadCreditUpdateResponse>> updateCreditCheck({required String creditLimit, required String creditUsed}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.updateCreditCheck(creditLimit: creditLimit, creditUsed: creditUsed, customerId: customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to get credit check data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
