import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileService {
  final ApiService _apiService;
  final SecuredSharedPreferences _securedSharedPref;
  final UserInformationRepository _userInformationRepository;
  ProfileService(this._apiService, this._securedSharedPref, this._userInformationRepository);

  /// Fetch Profile Details
  Future<Result<ProfileDetailModel>> getProfileDetails() async {
    try {
      final url = ApiUrls.getProfile+ (await _userInformationRepository.getUserID() ?? "");
      final result = await _apiService.get(url);
      if (result is Success) {
        dynamic data = await _apiService.getResponseStatus(result.value, (data)=> ProfileDetailModel.fromJson(data));
        // Save Blue Id
        if (data is Success<ProfileDetailModel>) {
          final customer = data.value.data?.customer;
          final newBlueId = customer?.blueId;
          final storedBlueId = await _userInformationRepository.getBlueID();
          debugPrint("Service Blue Id : $newBlueId");
          if (newBlueId != null && newBlueId.isNotEmpty) {
            // Save Blue ID and popup flag if not stored before
            if (storedBlueId == null || storedBlueId.isEmpty) {
              debugPrint("🎉 First time Blue ID saved: $newBlueId");
              await _securedSharedPref.saveKey(AppString.sessionKey.blueId, newBlueId);
              await _securedSharedPref.saveBoolean(AppString.sessionKey.hasBlueIdPopupShown, true);

            }
          } else {
            // Clear Blue ID and popup flag if blueId is null
            debugPrint("🧹 Blue ID cleared");
            await _securedSharedPref.deleteKey(AppString.sessionKey.blueId);
            await _securedSharedPref.deleteKey(AppString.sessionKey.hasBlueIdPopupShown);
          }

          return Success(data.value);
        }
        if (data is Error) {
          return Error(data.type);
        }
        return Error(GenericError());
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


  // Log out
  Future<Result<LogOutModel>> fetchLogOutData() async {
    try {
      final url = ApiUrls.logout;
      final result = await _apiService.post(url, body: {"customerId" : (await _userInformationRepository.getUserID() ?? "")});
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LogOutModel.fromJson(data));
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
