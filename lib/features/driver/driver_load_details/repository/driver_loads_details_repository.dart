import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/service/driver_load_details_service.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/consignee_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/initiate_payment_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_consignee_add_success_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_create_order_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_feedback_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_verify_advance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
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
          fileType: 'd',
          documentType: await userRepo.getUserRole() == 0 ? "Driver_DOCUMENT" : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
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
 
}
