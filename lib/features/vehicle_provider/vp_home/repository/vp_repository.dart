import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpHomeRepository {
  final VpHomeService _vpService;
  final UserInformationRepository userRepo;


  VpHomeRepository(this._vpService, this.userRepo);

  Future<Result<VpMyLoadResponse>> getVpMyLoad(String usedId) async {
    try {
      return await _vpService.getVpMyLoad(userID: usedId);
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

  Future<Result<VpLoadAcceptModel>> getLoadAcceptData({
    required String userId,required String loadId}) async {
    try {
      return await _vpService.fetchVpAcceptLoad(loadId: loadId,userId: userId);
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

  Future<Result<ScheduleTripResponse>> scheduleTripResponse({

    required ScheduleTripRequest apiRequest,}) async {
    try {
      return await _vpService.scheduleTripResponse(apiRequest:apiRequest);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VpRecentLoadResponse>> getVpRecentLoadData() async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return await _vpService.getVpRecentLoads(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }




  Future<DirectionResponse?> getGoogleDirectionResponse(String? pickUpLat,String? pickUpLong,String? dropLat,String? dropLong) async {
    try {
      return await _vpService.getDirectionRoute(
        pickupLat: pickUpLat,
        pickupLong: pickUpLong,
        destinationLat: dropLat,
        destinationLong: dropLong
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get direction api response", e);
      return null;
    }
  }



}