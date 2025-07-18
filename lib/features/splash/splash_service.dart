import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class SplashService {
  final SecuredSharedPreferences _securedSharedPref;
  SplashService(this._securedSharedPref);

  // Check User session
  Future<Result<bool>> checkIsUserLogin() async {
    try {
      String? userId = await _securedSharedPref.get(AppString.sessionKey.userId);
      CustomLog.debug(this, "User Id : $userId");
      if((userId != null && userId.isNotEmpty)){
        return const Success(true);
      }else{
        return Error(UnauthenticatedError());
      }
    } catch (e) {
      CustomLog.error(this, "Check User Login Error", e);
      return Error(GenericError());
    }
  }

  // Check User type session
  Future<Result<int>> checkUserRole() async {
    try {
      int? userType = await _securedSharedPref.getInt(AppString.sessionKey.userRole);
      CustomLog.debug(this, "User Type : $userType");
      if((userType != null)){
        return Success(userType);
      }else{
        return Error(UnauthenticatedError());
      }
    } catch (e) {
      CustomLog.error(this, "Check User Type Error", e);
      return Error(GenericError());
    }
  }

  /// Get Fcm Token
  // Future<Result<bool>> getFcmToken () async {
  //   try {
  //     await _notificationService.getFcmToken();
  //     return const Success(true);
  //   } catch (e) {
  //     CustomLog.error(this, "Get Fcm Token Error", e);
  //     return Error(ErrorWithMessage(message: e.toString()));
  //   }
  // }


}