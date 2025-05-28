import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/service/profile_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileRepository {
  final ProfileService _profileService;

  ProfileRepository(this._profileService);

  // Resend Otp
  Future<Result<ProfileUpdateResponse>> updateProfileData(
    ProfileUpdateRequest request,{required String userId}
  ) async {
    try {
      return await _profileService.updateProfile(request,userID: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
