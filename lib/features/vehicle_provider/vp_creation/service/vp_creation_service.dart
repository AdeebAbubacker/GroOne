import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
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
      final url = ApiUrls.createLpAccount;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {

        return   Success(UserModel.fromJson(result.value));
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

  // Fetch Vp Creation
  Future<Result<TruckTypeModel>> fetchTruckTypeData() async {
    try {
      final url = ApiUrls.truckType;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> TruckTypeModel.fromJson(data));
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

    // Fetch TruckPrefLaneModel
  Future<Result<TruckPrefLaneModel>> fetchTruckPrefLaneData(String? location) async {
    try {
      final url = location?.isNotEmpty == true
    ? "${ApiUrls.truckPrefLane}?search=$location"
    : ApiUrls.truckPrefLane;
      final result = await _apiService.get(url);

      if (result is Success) {
        final truckPrefLane= TruckPrefLaneModel.fromJson(result.value);
        return  Success(truckPrefLane);
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
  Future<Result<UploadRcTruckFileModel>> fetchUploadRcTruckFileData(File files,String? userId) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(url, files,
          fields: {
          "fileType":"upload_rc", "userId":userId??""
          },
          pathName: "file");
      if (result is Success) {

        return   Success(UploadRcTruckFileModel.fromJson(result.value));
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