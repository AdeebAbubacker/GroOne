import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class AuthRepository {
  final SecuredSharedPreferences _securedSharedPref;
  final NotificationService _notificationService;
  AuthRepository(this._securedSharedPref, this._notificationService);

  /// Save user data from login
  Future<Result<bool>> saveUserInfoFromLogin(
    MobileOtpVerificationModel user,
  ) async {
    try {
      final userData = user;
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userId,
        userData.customerId.toString(),
      );
      await _securedSharedPref.saveInt(
        AppString.sessionKey.userRole,
        userData.roleId,
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.accessToken,
        userData.kongToken?.accessToken.toString() ?? '',
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.refreshToken,
        userData.kongToken?.refreshToken.toString() ?? '',
      );

      // Save mobile number - this was missing and causing the GPS login error
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userMobileNumber,
        userData.mobile,
      );

      CustomLog.debug(this, "Save user from login saved successfully");

      // Get the access token from kongToken if available, otherwise use the regular token
      String accessToken = '';
      String refreshToken = '';
      if (userData.kongToken != null &&
          userData.kongToken!.accessToken.isNotEmpty) {
        accessToken = userData.kongToken!.accessToken;
        refreshToken = userData.kongToken!.refreshToken;
        await _securedSharedPref.saveKey(
          AppString.sessionKey.accessToken,
          accessToken,
        );
        await _securedSharedPref.saveKey(
          AppString.sessionKey.refreshToken,
          refreshToken,
        );
      } else {
        CustomLog.error(this, "Save user failed", "No token available");
        return Error(LoginAttemptError());
      }

      // Save user information
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userId,
        userData.customerId.toString(),
      );
      await _securedSharedPref.saveInt(
        AppString.sessionKey.userRole,
        userData.roleId,
      );
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save Resident user info to preferences error", e);
      return Error(GenericError());
    }
  }

  /// Save user data from home
  Future<Result<bool>> saveUserInfoFromHome(ProfileDetailModel user) async {
    try {
      final userData = user.customer;
      if (userData == null) {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }

      // Save customer details basic user info
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userId,
        userData.customerId.toString(),
      );
      await _securedSharedPref.saveInt(
        AppString.sessionKey.companyTypeId,
        userData.companyTypeId,
      );
      await _securedSharedPref.saveInt(
        AppString.sessionKey.userRole,
        userData.roleId,
      );

      // Save mobile number and other user details from profile
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userMobileNumber,
        userData.mobileNumber,
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userFullName,
        userData.customerName,
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userEmail,
        userData.emailId,
      );
      await _securedSharedPref.saveInt(
        AppString.sessionKey.customerSeriesId,
        userData.customerSeriesNo??0,
      );
      if (userData.blueId != null && userData.blueId.toString().isNotEmpty) {
        await _securedSharedPref.saveKey(
          AppString.sessionKey.blueId,
          userData.blueId.toString(),
        );
      }

      // Note: Profile response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(
        this,
        "Save user from home saved successfully (no token in profile response)",
      );
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save Resident user info to preferences error", e);
      return Error(GenericError());
    }
  }

  /// Save user data from driver home
  Future<Result<bool>> saveUserInfoFromDriverHome(
    DriverProfileDetailsModel user,
  ) async {
    try {
      final userData = user.data;
      if (userData == null) {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }

      // Save customer details basic user info
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userId,
        userData.driverId.toString(),
      );
      await _securedSharedPref.saveInt(AppString.sessionKey.userRole, 0);

      // Save mobile number and other user details from driver profile
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userMobileNumber,
        userData.mobile,
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userFullName,
        userData.name,
      );
      await _securedSharedPref.saveKey(
        AppString.sessionKey.userEmail,
        userData.email,
      );

      // Note: Profile response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(
        this,
        "Save user from home saved successfully (no token in profile response)",
      );
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save Resident user info to preferences error", e);
      return Error(GenericError());
    }
  }

  /// Save user data from create account
  Future<Result<bool>> saveUserInfoFromCreateAccount(UserModel user) async {
    try {
      final userData = user;

      // Save basic user info
      if (userData.customer != null) {
        await _securedSharedPref.saveKey(
          AppString.sessionKey.userId,
          userData.customer!.customerId,
        );
        await _securedSharedPref.saveInt(
          AppString.sessionKey.userRole,
          userData.customer!.roleId,
        );
        await _securedSharedPref.saveInt(
          AppString.sessionKey.companyTypeId,
          userData.customer!.companyTypeId,
        );

        // Save mobile number and other user details from create account
        await _securedSharedPref.saveKey(
          AppString.sessionKey.userMobileNumber,
          userData.customer!.mobileNumber,
        );
        await _securedSharedPref.saveKey(
          AppString.sessionKey.userFullName,
          userData.customer!.customerName,
        );
        await _securedSharedPref.saveKey(
          AppString.sessionKey.userEmail,
          userData.customer!.emailId,
        );
        if (userData.customer!.blueId != null &&
            userData.customer!.blueId.toString().isNotEmpty) {
          await _securedSharedPref.saveKey(
            AppString.sessionKey.blueId,
            userData.customer!.blueId.toString(),
          );
        }
      } else {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }

      // Note: Create account response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(
        this,
        "Save user from create account saved successfully (no token in create account response)",
      );
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save user from create account error", e);
      return Error(GenericError());
    }
  }

  /// Check if user has valid authentication token
  Future<bool> hasValidToken() async {
    try {
      String? token = await _securedSharedPref.get(
        AppString.sessionKey.accessToken,
      );
      return token != null && token.isNotEmpty;
    } catch (e) {
      CustomLog.error(this, "Error checking token validity", e);
      return false;
    }
  }

  /// Get user authentication status
  Future<Map<String, dynamic>> getAuthStatus() async {
    try {
      String? userId = await _securedSharedPref.get(
        AppString.sessionKey.userId,
      );
      String? userRole = await _securedSharedPref.get(
        AppString.sessionKey.userRole,
      );
      bool hasToken = await hasValidToken();

      final status = {
        'hasUserId': userId != null && userId.isNotEmpty,
        'hasUserRole': userRole != null && userRole.isNotEmpty,
        'hasToken': hasToken,
        'isFullyAuthenticated': hasToken && userId != null && userId.isNotEmpty,
        'needsReLogin': userId != null && userId.isNotEmpty && !hasToken,
      };

      CustomLog.debug(this, "🔐 Auth Status: $status");
      return status;
    } catch (e) {
      CustomLog.error(this, "Error getting auth status", e);
      return {
        'hasUserId': false,
        'hasUserRole': false,
        'hasToken': false,
        'isFullyAuthenticated': false,
        'needsReLogin': false,
      };
    }
  }

  /// Clear auth & cache
  Future<void> _clearAuthData() async {
    await _securedSharedPref.resetPreservingLanguage();
    await _securedSharedPref.resetPreservingLanguage();
    await _securedSharedPref.saveBoolean(AppString.sessionKey.aadharVerified, false);
    clearAllBusinessDocs();
    await _notificationService.clearBadgeCount();
    await _notificationService.clearFcmToken();
  }

  Future<void> clearAllBusinessDocs() async {
    await _securedSharedPref.deleteKey(AppString.sessionKey.gtsinNumber);
    await _securedSharedPref.deleteKey(AppString.sessionKey.panNumber);
    await _securedSharedPref.deleteKey(AppString.sessionKey.tanNumber);

    await _securedSharedPref.deleteKey(AppString.sessionKey.gstDocUrl);
    await _securedSharedPref.deleteKey(AppString.sessionKey.gstDocID);

    await _securedSharedPref.deleteKey(AppString.sessionKey.panDocUrl);
    await _securedSharedPref.deleteKey(AppString.sessionKey.panDocId);

    await _securedSharedPref.deleteKey(AppString.sessionKey.tanDocUrl);
    await _securedSharedPref.deleteKey(AppString.sessionKey.tanDocID);
  }


  /// Sign out
  Future<Result<bool>> signOut() async {
    try {
      await _clearAuthData();
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "SignOut attempt error", e);
      return Error(GenericError());
    }
  }

  /// Force re-login by clearing token but keeping user data
  Future<Result<bool>> forceReLogin() async {
    try {
      // Clear only the token, keep user data
      await _securedSharedPref.deleteKey(AppString.sessionKey.accessToken);
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Force re-login error", e);
      return Error(GenericError());
    }
  }
}
