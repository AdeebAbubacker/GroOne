
import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class DriverLoadDetailsService {
  final ApiService _apiService;
  DriverLoadDetailsService(this._apiService);


  Future<Result<DriverLoadDetailsModel>> fetchLoadsById({
    required String loadId,
    required String driverId,
    bool forceRefresh = false
  }) async {

    try {
      final url = ApiUrls.driverLoadById;
      final response = await _apiService.get(
       "$url$driverId/$loadId",
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value;
        final loads = DriverLoadDetailsModel.fromJson(data);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } 
    catch (e) {
      return Error(DeserializationError());
    }
  }

  /// Upload File Service
  Future<Result<UploadDamageFileModel>> fetchUploadDamageData({required File file, required String fileType,required String userId, required String documentType}) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: {
          "userId" : userId,
          "fileType" : fileType,
          "documentType" : documentType,
        },
      );
      if (result is Success) {
        final data = UploadDamageFileModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }




    /// Get Damage List Service
  Future<Result<GetDamageListModel>> fetchDamageList(String loadId) async {
    try {
      final url = ApiUrls.damage;
      final result = await _apiService.get(url, queryParams: {"loadId" : loadId});
      if (result is Success) {
        final data= GetDamageListModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
  Future<Result<VpLoadAcceptModel>> changeLoadStatus({
  required String? userId,
  required String loadId,
  required int? loadStatus,
}) async {
  try {
 final statusUpdateUrl=ApiUrls.updateLoadStatus;
      final result = await _apiService.put(
        queryParams: {
          "loadStatus":loadStatus
        },
          '$statusUpdateUrl/$userId/$loadId');
    if (result is Success) {
 
      final changeLoadStatusResponse = VpLoadAcceptModel.fromJson(result.value);
      return Success(changeLoadStatusResponse);
   
    } else if (result is Error) {
      return Error(result.type);
    } else {
      return Error(GenericError());
    }
  } catch (e) {
    CustomLog.error(this, AppString.error.deserializationError, e);
    return Error(DeserializationError());
  }
}


}

