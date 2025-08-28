import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_logout_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/service/driver_profile_service.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/model/delete_account_response.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class DriverProfileRepository {
  final DriverProfileService _profileService;
  final AuthRepository _authRepository;
  final UserInformationRepository _userInformationRepository;
  DriverProfileRepository(this._profileService, this._authRepository, this._userInformationRepository);

  /// Get User Details Repo
  Future<Result<DriverProfileDetailsModel>> getUserDetails() async {
    try {
      return await _profileService.getDriverProfileDetails();
    } catch (e) {

      CustomLog.error(this, "Failed to request get user details data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

    /// LogOut Repo
  Future<Result<DriverlogoutModel>> getLogOutData() async {
    try {
      return await _profileService.fetchLogOutData();
    } catch (e) {
      CustomLog.error(this, "Failed to request logout data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
  
    /// Deleet Account
  Future<Result<DeleteAccountModel>> deleteAccount() async {
    try {
      return await _profileService.deleteAccount();
    } catch (e) {
      CustomLog.error(this, "Failed to request logout data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Sign Out
  Future<Result<bool>> signOut() async {
    try {
      await _authRepository.signOut(); // Your logout logic here
      return Success(true);
    } catch (e) {
      return Error(GenericError());
    }
  }
  /// Get Show Blue
  Future<String?> getUserId() async {
    return await _userInformationRepository.getUserID();
  }

}


