import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/service/driver_load_details_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class  DriverLoadsDetailsRepository {
  final DriverLoadDetailsService service;
  final UserInformationRepository userRepo;
  
  final SecuredSharedPreferences securedSharedPreferences;

  DriverLoadsDetailsRepository(this.service, this.userRepo, this.securedSharedPreferences);

  Future<Result<DriverLoadDetailsModel>> fetchDriversLoadById({required String loadId, bool forceRefresh = false}) async {
    try {
      return service.fetchLoadsById(driverId:await userRepo.getUserID() ?? "", loadId: loadId,forceRefresh: forceRefresh);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch loads by ID data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
/// Upload File Repo
  Future<Result<UploadDamageFileModel>> uploadTripDocFileData(File file,String fileType) async {
    try {
      return await service.fetchUploadDamageData(
          file : file,
          userId: await userRepo.getUserID() ?? "",
          fileType: fileType,
          documentType: await userRepo.getUserRole() == 0 ? "driver_document" : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

   /// Gat Damage List Repo
  Future<Result<GetDamageListModel>> getDamageListData(String loadId) async {
    try {
      return await service.fetchDamageList(loadId);
    } catch (e) {
      CustomLog.error(this, "Failed to request damage list data", e);
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
