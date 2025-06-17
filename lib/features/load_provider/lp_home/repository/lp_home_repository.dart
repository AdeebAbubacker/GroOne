import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide Result;
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeRepository{
  final LpHomeService _lpHomeService;
  final UserInformationRepository _userInformationRepository;
  LpHomeRepository(this._lpHomeService, this._userInformationRepository);

  Future<Result<ProfileDetailModel>> getUserDetails({required String userId}) async {
    try {
      return await _lpHomeService.getProfileDetails(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpGetLoadModel>> getLoads({required String userId}) async {
    try {
      return await _lpHomeService.getLoads(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<LoadDetailResponse>> getLoadDetails({required String userId}) async {
    try {
      return await _lpHomeService.getLoadDetail(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Commodity data Repo
  Future<Result<LoadCommodityListModel>> getLoadCommodityData() async {
    try {
      return await _lpHomeService.fetchLoadCommodityData();
    } catch (e) {
      CustomLog.error(this, "Failed to request load commodity data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data Repo
  Future<Result<LoadTruckTypeListModel>> getTruckTypeData() async {
    try {
      return await _lpHomeService.fetchTruckTypeData();
    } catch (e) {
      CustomLog.error(this, "Failed to request truck type data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data Repo
  Future<Result<CreateLoadModel>> getCreateLoadData(CreateLoadApiRequest request) async {
    try {
      return await _lpHomeService.fetchCreateLoadData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request create load data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Fetch Rate Discovery data Repo
  Future<Result<RateDiscoveryModel>> getRateDiscoveryData(RateDiscoveryApiRequest request) async {
    try {
      return await _lpHomeService.fetchRateDiscoveryData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request rate discovery data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Recent Route data Repo
  Future<Result<RecentRoutesModel?>> getRecentRouteData() async {
    try {
      return await _lpHomeService.fetchRecentRouteData(await _userInformationRepository.getUserID() ?? "");
    } catch (e) {
      CustomLog.error(this, "Failed to request recent route data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Auto Complete Data Repo
  Future<Result<AutoCompleteModel>> getAutoCompleteData(String input) async {
    try {
      return await _lpHomeService.fetchMapAutoCompleteData(input);
    } catch (e) {
      CustomLog.error(this, "Failed to request auto complete data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Location Verify data Repo
  Future<Result<VerifyLocationModel>> getVerifyLocationData(VerifyLocationApiRequest request) async {
    try {
      return await _lpHomeService.fetchVerifyLocationData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request verify location data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Weight Repo
  Future<Result<LoadWeightModel>> getLoadWeightData() async {
    try {
      return await _lpHomeService.fetchLoadWeightData();
    } catch (e) {
      CustomLog.error(this, "Failed to request get load weight data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}