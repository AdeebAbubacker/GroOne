import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/lp_get_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide LocationResult;
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';

class LpHomeRepository{
  final LpHomeService _lpHomeService;
  final UserInformationRepository _userInformationRepository;
  LpHomeRepository(this._lpHomeService, this._userInformationRepository);


  Future<Result<LpLoadResponse>> getLoads() async {
    try {
      return await _lpHomeService.getLoads(id: await _userInformationRepository.getUserID() ?? "");
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<LoadDetailResponse>> getLoadDetails({required String userId}) async {
    try {
      return await _lpHomeService.getLoadDetail(id: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Commodity data Repo
  Future<Result<List<LoadCommodityListModel>>> getLoadCommodityData() async {
    try {
      return await _lpHomeService.fetchLoadCommodityData();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data Repo
  Future<Result<List<LoadTruckTypeListModel>>> getTruckTypeData() async {
    try {
      return await _lpHomeService.fetchTruckTypeData();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data Repo
  Future<Result<CreateLoadModel>> getCreateLoadData(CreateLoadApiRequest request) async {
    try {
      String? userId = await _userInformationRepository.getUserID();
      return await _lpHomeService.fetchCreateLoadData(request.copyWith(customerId: userId));
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Fetch Rate Discovery data Repo
  Future<Result<RateDiscoveryModel>> getRateDiscoveryData(RateDiscoveryApiRequest request) async {
    try {
      return await _lpHomeService.fetchRateDiscoveryData(request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Recent Route data Repo
  Future<Result<RecentRoutesModel>> getRecentRouteData(String? search, int? currentPage) async {
    try {
      return await _lpHomeService.fetchRecentRouteData(await _userInformationRepository.getUserID() ?? "", search: search,currentPage: currentPage);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Auto Complete Data Repo
  Future<Result<AutoCompleteModel>> getAutoCompleteData(String input) async {
    try {
      return await _lpHomeService.fetchMapAutoCompleteData(input);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Location Verify data Repo
  Future<Result<VerifyLocationModel>> getVerifyLocationData(VerifyLocationApiRequest request) async {
    try {
      return await _lpHomeService.fetchVerifyLocationData(request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Weight Repo
  Future<Result<List<LoadWeightModel>>> getLoadWeightData() async {
    try {
      return await _lpHomeService.fetchLoadWeightData();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// setBluId
  Future<Result<void>> setBluIDFlag() async {
    try {
      String userId = await _userInformationRepository.getUserID() ?? '';
      return await _lpHomeService.setBluIDFlag(userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}