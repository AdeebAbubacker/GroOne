import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileService {
  final ApiService _apiService;
  ProfileService(this._apiService);

  // fetch update profile
  Future<Result<ProfileUpdateResponse>> fetchUpdateProfileData(ProfileUpdateRequest request, {required userID}) async {
    try {
      final result = await _apiService.put(ApiUrls.getProfile + userID, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => ProfileUpdateResponse.fromJson(data));
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

  // fetch profile upload
  Future<Result<ProfileImageUploadResponse>> fetchProfileUploadData(ProfileImageUploadRequest request, {required String userId}) async {
    try {
      final result = await _apiService.post(ApiUrls.updateProfile+userId, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => ProfileImageUploadResponse.fromJson(data));
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


  // fetch master
  Future<Result<MasterResponse>> fetchGetMasterData({required String userId}) async {
    try {
      final result = await _apiService.get(ApiUrls.getMaster + userId);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => MasterResponse.fromJson(data));
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
