import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/splash/model/app_update_response.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class SplashService {
  final SecuredSharedPreferences _securedSharedPref;
  final ApiService _apiService;

  SplashService(this._securedSharedPref, this._apiService);

  // Check User session with token validation
  Future<Result<bool>> checkIsUserLogin() async {
    try {
      String? userId = await _securedSharedPref.get(
        AppString.sessionKey.userId,
      );
      String? accessToken = await _securedSharedPref.get(
        AppString.sessionKey.accessToken,
      );

      CustomLog.debug(this, "User Id : $userId");
      CustomLog.debug(
        this,
        "Access Token exists : ${accessToken != null && accessToken.isNotEmpty}",
      );

      // Check if both userId and token exist
      if ((userId != null && userId.isNotEmpty) &&
          (accessToken != null && accessToken.isNotEmpty)) {
        return const Success(true);
      } else {
        // Clear invalid data if partial authentication exists
        if (userId != null && userId.isNotEmpty) {
          CustomLog.debug(
            this,
            "Clearing invalid authentication data - userId exists but no token",
          );
          await _securedSharedPref.deleteKey(AppString.sessionKey.userId);
          await _securedSharedPref.deleteKey(AppString.sessionKey.userRole);
          await _securedSharedPref.deleteKey(
            AppString.sessionKey.companyTypeId,
          );
        }
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
      int? userType = await _securedSharedPref.getInt(
        AppString.sessionKey.userRole,
      );
      CustomLog.debug(this, "User Type : $userType");
      if ((userType != null)) {
        return Success(userType);
      } else {
        return Error(UnauthenticatedError());
      }
    } catch (e) {
      CustomLog.error(this, "Check User Type Error", e);
      return Error(GenericError());
    }
  }

  Future<Result<AppUpdateResponse>> checkAppUpdate() async {
    String appVersion = await appVersionInfo();
    String appType = isAndroid ? "ANDROID" : "IOS";
    try {
      final result = await _apiService.post(
        ApiUrls.checkAppUpdate,
        body: {
          "appType": appType,
          "currentVersion": appVersion
        },
      );
      if (result is Success) {
        final data = AppUpdateResponse.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
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
