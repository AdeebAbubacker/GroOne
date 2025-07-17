import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/service/driver_profile_service.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class DriverProfileRepository {
  final DriverProfileService _profileService;
  final AuthRepository _authRepository;
  final UserInformationRepository _userInformationRepository;
  final SecuredSharedPreferences _securedSharedPref;
  DriverProfileRepository(this._profileService, this._authRepository, this._securedSharedPref, this._userInformationRepository);

  /// Get User Details Repo
  Future<Result<DriverProfileDetailsModel>> getUserDetails() async {
    try {
      return await _profileService.getDriverProfileDetails();
    } catch (e) {

      CustomLog.error(this, "Failed to request get user details data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}
