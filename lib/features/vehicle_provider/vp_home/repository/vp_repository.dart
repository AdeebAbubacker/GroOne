import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpHomeRepository {
  final VpHomeService _vpService;

  VpHomeRepository(this._vpService);

  Future<Result<VpMyLoadResponse>> getVpMyLoad() async {
    try {
      return await _vpService.getVpMyLoad();
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VehicleListResponse>> getVehicleDetails({
    required String userId,
  }) async {
    try {
      return await _vpService.getVehicleDetails(userId: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<DriverListResponse>> getDriverDetails({
    required String userId,
  }) async {
    try {
      return await _vpService.getDriverDetails(userId: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<DriverListResponse>> scheduleTripResponse({

    required ScheduleTripRequest apiRequest,}) async {
    try {
      return await _vpService.scheduleTripResponse(apiRequest:apiRequest);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
