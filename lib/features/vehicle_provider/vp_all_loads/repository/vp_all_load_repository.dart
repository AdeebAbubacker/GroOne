import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';
import '../service/vp_all_load_service.dart';

class VpLoadRepository {
  final VpLoadService service;
  final UserInformationRepository userRepo;

  VpLoadRepository(this.service, this.userRepo);

  Future<Result<RecentLoadResponse>> fetchLoads({
    required int type,
    String search = "",
    bool forceRefresh = false,
    int? commodityId,
    int? truckTypeId,
    int? laneId,
    int? page,
  }) async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.fetchLoads(
        limit: 10,
        page: page,
        customerId: customerId, type: type, search: search,forceRefresh: forceRefresh,commodityId:commodityId,truckTypeId:truckTypeId,laneId:laneId   );
  }

  Future<Result<List<LoadStatusResponse>>> fetchLoadStatus() async {
    try {
      return service.fetchVpLoadStatus();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch load Status data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Truck Type Repo
  Future<Result<List<TruckTypeModel>>> getTruckTypeData({String? search}) async {
    try {
      return await service.fetchTruckTypeData(search: search);
    } catch (e) {
      CustomLog.error(this, "Failed to request get truck type data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Preferred Truck Lane Data Repo
  Future<Result<TruckPrefLaneModel>> getPrefTruckLaneData(String? location,{int? page}) async {
    try {
      return await service.fetchTruckPrefLaneData(location,currentPage: page);
    } catch (e) {
      CustomLog.error(this, "Failed to request get preferred truck lane data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Load Commodity data Repo
  Future<Result<List<LoadCommodityListModel>>> getLoadCommodityData({String? search}) async {
    try {
      return await service.fetchLoadCommodityData(search: search);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
