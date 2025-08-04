import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_home/service/driver_load_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';

class DriverLoadRepository {
  final DriverLoadService service;
  final UserInformationRepository userRepo;

  DriverLoadRepository(this.service, this.userRepo);

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
    int? loadStatus,
    int? laneId,
    String search = "",
    int? truckTypeId,
    int? commodityTypeId,
    bool forceRefresh = false
  }) async {
    try{
    final customerId = await userRepo.getUserID() ?? '';
    return service.fetchDriverLoads(
      driverId: customerId,
      status: loadStatus ?? 3, 
      search: search,
      laneId: laneId,
      truckTypeId: truckTypeId,
      commodityTypeId: commodityTypeId, 
      forceRefresh: forceRefresh)
      ;
 
    }catch (e) {
      CustomLog.error(this, "Failed to fetch loads by ID data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
 }

   Future<Result<VpLoadAcceptModel>> changeLoadStatus({
    required String customerId,required String loadId,required int? loadStatus}) async {
    try {
      return await service.changeLoadStatus(
          loadStatus: loadStatus,
          loadId: loadId,
          userId: customerId,
          );
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  } 
}
