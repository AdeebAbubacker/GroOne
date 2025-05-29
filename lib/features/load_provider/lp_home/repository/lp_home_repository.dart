import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeRepository{
  final LpHomeService _lpHomeService;
  LpHomeRepository(this._lpHomeService);

  Future<Result<ProfileDetailResponse>> getUserDetails({required String userId}) async {
    try {
      return await _lpHomeService.getProfileDetails(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  } Future<Result<GetLoadResponse>> getLoads({required String userId}) async {
    try {
      return await _lpHomeService.getLoads(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }Future<Result<LoadDetailResponse>> getLoadDetails({required String userId}) async {
    try {
      return await _lpHomeService.getLoadDetail(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Commodity data
  Future<Result<LoadCommodityListModel>> getLoadCommodityData() async {
    try {
      return await _lpHomeService.fetchLoadCommodityData();
    } catch (e) {
      CustomLog.error(this, "Failed to request load commodity data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data
  Future<Result<LoadTruckTypeListModel>> getTruckTypeData() async {
    try {
      return await _lpHomeService.fetchTruckTypeData();
    } catch (e) {
      CustomLog.error(this, "Failed to request truck type data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type data
  Future<Result<CreateLoadModel>> getCreateLoadData(CreateLoadApiRequest request) async {
    try {
      return await _lpHomeService.fetchCreateLoadData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request create load data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}