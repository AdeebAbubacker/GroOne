import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileRepository {
  final ProfileService _profileService;
  ProfileRepository(this._profileService);

  // Resend Otp
  Future<Result<ProfileUpdateResponse>> updateProfileData(ProfileUpdateRequest request, {required String userId}) async {
    try {
      return await _profileService.fetchUpdateProfileData(request,userID: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request update profile data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  // get master
  Future<Result<MasterResponse>> getMaster({required String userId}
  ) async {
    try {
      return await _profileService.fetchGetMasterData(userId: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request get master data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  // Upload Profile
  Future<Result<ProfileImageUploadResponse>> uploadProfile(ProfileImageUploadRequest request, {required String userId}) async {
    try {
      return await _profileService.fetchProfileUploadData(request,userId:userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request upload profile data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}
