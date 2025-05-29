import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/log_out_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/log_out_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpCreationService {
  final ApiService _apiService;
  VpCreationService(this._apiService);

  // Fetch Vp Creation
  Future<Result<UserModel?>> fetchVpCreationData(VpCreationApiRequest request,{required String id}) async {
    try {
      final url = ApiUrls.createVpAccount+id;
      final result = await _apiService.put(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> UserModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
  // Log out
  Future<Result<LogOutResponse>> logOut(LogOutRequest request) async {
    try {
      final url = ApiUrls.logOut;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LogOutResponse.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  // Fetch Upload Rc Truck File
  Future<Result<UploadRcTruckFileModel>> fetchUploadRcTruckFileData(File files) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(url, files, pathName: "file");
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> UploadRcTruckFileModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }



}