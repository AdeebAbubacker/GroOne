import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';


class  LpLoadRepository {
  final LpLoadService service;
  final UserInformationRepository userRepo;

  LpLoadRepository(this.service, this.userRepo);

  Future<Result<List<LpLoadItem>>> fetchLoads({
    required int type,
    String search = "",
    bool forceRefresh = false
  }) async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.fetchLoads(customerId: customerId, type: type, search: search,forceRefresh: forceRefresh);
  }

  Future<Result<LpLoadGetByIdResponse>> fetchLoadById({
    required int loadId,
    String search = "",
    bool forceRefresh = false
  }) async {
    return service.fetchLoadsById(loadId: loadId,forceRefresh: forceRefresh);
  }

  Future<Result<LoadMemoData>> fetchMemoDetails({required int loadId, bool forceRefresh = false}) async {
    return service.fetchMemoDetails(loadId: loadId, forceRefresh: forceRefresh);
  }

  Future<Result<LoadTruckTypeListModel>> fetchTruckTypeList() async {
    return service.fetchTruckTypeList();
  }

  Future<Result<LpLoadRouteResponse>> fetchRouteList() async {
    return service.fetchRouteList();
  }

  Future<Result<LpLoadMemoOtpResponse>> sendOtp() async {
    final customerId = await userRepo.getUserID() ?? '';

    return service.sendOtp(customerId: customerId);
  }

  Future<Result<LpLoadMemoOtpResponse>> verifyOtp({required String otp}) async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.verifyOtp(customerId: customerId, otp: otp);
  }

  Future<Result<LpLoadMemoOtpResponse>> applyFilter({required int fromRoute, required int toRoute, required String truckType, required String loadPostedDate}) async {
    return service.applyFilter(fromRoute: fromRoute, toRoute: toRoute, truckType: truckType, loadPostedDate: loadPostedDate);
  }

  Future<Result<LpLoadCreditCheckResponse>> getCreditCheck() async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.getCreditCheck(customerId: customerId);
  }
}
