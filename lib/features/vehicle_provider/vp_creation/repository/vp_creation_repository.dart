import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/VpCompanyTypeModel.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/service/vp_creation_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpCreationRepository {
  final VpCreationService _vpCreationService;
  final AuthRepository _authRepository;
  VpCreationRepository(this._vpCreationService, this._authRepository);

  /// Vp Create Account Repo
  Future<Result<UserModel?>> requestVpCreation(VpCreationApiRequest request, {required String id}) async {
    try {
      Result<dynamic> result =  await _vpCreationService.fetchVpCreationData(request ,id: id);
      if (result is Success<UserModel?>) {
        if(result.value != null){
          Result saveUserResult = await _authRepository.saveUserInfoFromCreateAccount(result.value!);
          if(saveUserResult is Success){
            return result;
          }
          if(saveUserResult is Error){
            return Error(saveUserResult.type);
          }
        }
      }
      if(result is Error){
        return Error(result.type);
      }
      return Error(GenericError());
    } catch (e) {
      CustomLog.error(this, "Failed to request vp creation", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Truck Type Repo
  Future<Result<List<TruckTypeModel>>> getTruckTypeData() async {
    try {
      return await _vpCreationService.fetchTruckTypeData();
    } catch (e) {
      CustomLog.error(this, "Failed to request get truck type data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Preferred Truck Lane Data Repo
  Future<Result<TruckPrefLaneModel>> getPrefTruckLaneData(String? location,{int? page}) async {
    try {
      return await _vpCreationService.fetchTruckPrefLaneData(location,currentPage: page);
    } catch (e) {
      CustomLog.error(this, "Failed to request get preferred truck lane data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Company Type
  Future<Result<List<VpCompanyTypeModel>>> getCompanyTypeData() async {
    try {
      return await _vpCreationService.fetchGetCompanyTypeData();
    } catch (e) {
      CustomLog.error(this, "Failed to request company type data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload rc truck document repo
  Future<Result<UploadRcTruckFileModel>> getUploadRcTruckData(File file, userId) async {
    try {
      return await _vpCreationService.fetchUploadRcTruckFileData(file, userId);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload rc truck data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Sign Out Repo
  Future<Result<bool>> signOut() async {
    try {
      await _authRepository.signOut(); // Your logout logic here
      return Success(true);
    } catch (e) {
      return Error(GenericError());
    }
  }

}