import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';



class VpDetailsService{
  final ApiService _apiService;
  const VpDetailsService(this._apiService);


   Future<Result<LoadDetailModel>> fetchLoadDetails(String? loadId) async {
    try {
      final url =  "${ApiUrls.getLoadById}$loadId";
      final result = await _apiService.get(url);
      if (result is Success) {
        final loadDetailsResponse=LoadDetailModel.fromJson(result.value);
        return Success(loadDetailsResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e){

      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  Future<Result<VpLoadAcceptModel>> changeLoadStatus({required String? userId,required String loadId,required int? loadStatus}) async {
    try {
      final result = await _apiService.put(
        queryParams: {
          "loadStatus":loadStatus
        },
          '${ApiUrls.vpAcceptLoad}$userId/$loadId');
      if (result is Success) {
       final changeLoadStatusResponse= VpLoadAcceptModel.fromJson(result.value);
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


  /// Submit Damage Service
  Future<Result<DamageModel>> submitDamage(DamageApiRequest request) async {
    try {
      final url = ApiUrls.damage;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data= DamageModel.fromJson(result.value);
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


  /// Upload Gst File Repo Service
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




}