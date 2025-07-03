import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class AuthRepository {
  final SecuredSharedPreferences _securedSharedPref;
  final ApiService _apiService;
  AuthRepository(this._securedSharedPref, this._apiService);


  /// Save user data
  Future<Result<bool>> saveUserInfoFromLogin(MobileOtpVerificationModel user) async {
    try {
      final userData = user.data;
      if (userData?.user == null) {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }
      await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData!.user!.id.toString());
      await _securedSharedPref.saveKey(AppString.sessionKey.userRole, userData.user!.role.toString());
      await _securedSharedPref.saveKey(AppString.sessionKey.refreshToken, userData.token);
      CustomLog.debug(this, "Save user from login saved successfully");
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save Resident user info to preferences error", e);
      return Error(GenericError());
    }
  }


  /// Save user data from create account
  Future<Result<bool>> saveUserInfoFromCreateAccount(UserModel user) async {
    try {
      final userData = user.data;
      if (userData == null) {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }
      
      // Save basic user info
      if(userData.customer != null){
        await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.customer!.id.toString());
        await _securedSharedPref.saveKey(AppString.sessionKey.userRole, userData.customer!.roleId.toString());
      }
      if(userData.details != null){
        await _securedSharedPref.saveKey(AppString.sessionKey.companyTypeId, userData.details!.companyTypeId.toString());
      }
      
    
      
     return const Success(true);
    } catch (e) {

      return Error(GenericError());
    }
  }

  /// Check if user has valid authentication token
  Future<bool> hasValidToken() async {
    try {
      String? token = await _securedSharedPref.get(AppString.sessionKey.refreshToken);
      return token != null && token.isNotEmpty;
    } catch (e) {
      CustomLog.error(this, "Error checking token validity", e);
      return false;
    }
  }

  /// Get user authentication status
  Future<Map<String, dynamic>> getAuthStatus() async {
    try {
      String? userId = await _securedSharedPref.get(AppString.sessionKey.userId);
      String? userRole = await _securedSharedPref.get(AppString.sessionKey.userRole);
      bool hasToken = await hasValidToken();
      
      return {
        'hasUserId': userId != null && userId.isNotEmpty,
        'hasUserRole': userRole != null && userRole.isNotEmpty,
        'hasToken': hasToken,
        'isFullyAuthenticated': hasToken && userId != null && userId.isNotEmpty,
      };
    } catch (e) {
      CustomLog.error(this, "Error getting auth status", e);
      return {
        'hasUserId': false,
        'hasUserRole': false,
        'hasToken': false,
        'isFullyAuthenticated': false,
      };
    }
  }

  /// Clear auth & cache
  Future<void> _clearAuthData() async {
    await _securedSharedPref.deleteKey(AppString.sessionKey.userId);
    await _securedSharedPref.deleteKey(AppString.sessionKey.userRole);
    await _securedSharedPref.deleteKey(AppString.sessionKey.refreshToken);
    await _securedSharedPref.deleteKey(AppString.sessionKey.companyTypeId);
    await _securedSharedPref.deleteKey(AppString.sessionKey.blueId);
    await _securedSharedPref.reset();
    await _apiService.clearCache();
    // await _notificationService.clearBadgeCount();
    // await _notificationService.clearFcmToken();
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


}