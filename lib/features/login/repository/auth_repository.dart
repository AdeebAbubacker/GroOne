import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class AuthRepository {
  final SecuredSharedPreferences _securedSharedPref;
  final ApiService _apiService;
  AuthRepository(this._securedSharedPref, this._apiService);



  /// Save user data from login
  Future<Result<bool>> saveUserInfoFromLogin(MobileOtpVerificationModel user) async {
    try {
      final userData = user;
      await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.customerId.toString());
      await _securedSharedPref.saveInt(AppString.sessionKey.userRole, userData.roleId);
      await _securedSharedPref.saveKey(AppString.sessionKey.refreshToken, userData.kongToken?.refreshToken.toString() ?? '',);
      CustomLog.debug(this, "Save user from login saved successfully");

      // Log token information for debugging
      CustomLog.debug(this, "Saving token from login API - Customer ID: ${userData.customerId}, Role: ${userData.roleId}, TempFlag: ${userData.tempFlg}");

      // Print the raw response data for debugging
      print("🔐 ===== LOGIN RESPONSE DEBUG =====");
      print("🔐 Customer ID: ${userData.customerId}");
      print("🔐 Role ID: ${userData.roleId}");
      print("🔐 KongToken: ${userData.kongToken?.toJson()}");

      CustomLog.debug(this, "🔐 Raw login response:");
      CustomLog.debug(this, "🔐 Customer ID: ${userData.customerId}");
      CustomLog.debug(this, "🔐 Role ID: ${userData.roleId}");
      CustomLog.debug(this, "🔐 KongToken: ${userData.kongToken?.toJson()}");

      // Specifically check kongToken.access_token
      if (userData.kongToken != null) {
        print("🔐 KongToken.access_token: '${userData.kongToken!.accessToken}'");
        print("🔐 KongToken.access_token length: ${userData.kongToken!.accessToken.length}");
        print("🔐 KongToken.access_token is empty: ${userData.kongToken!.accessToken.isEmpty}");

        CustomLog.debug(this, "🔐 KongToken.access_token: '${userData.kongToken!.accessToken}'");
        CustomLog.debug(this, "🔐 KongToken.access_token length: ${userData.kongToken!.accessToken.length}");
        CustomLog.debug(this, "🔐 KongToken.access_token is empty: ${userData.kongToken!.accessToken.isEmpty}");
      } else {
        print("🔐 KongToken is null!");
        CustomLog.debug(this, "🔐 KongToken is null!");
      }

      // Get the access token from kongToken if available, otherwise use the regular token
      String accessToken = '';
      print("🔐 Token selection process:");
      print("🔐 KongToken is null: ${userData.kongToken == null}");

      CustomLog.debug(this, "🔐 Token selection process:");
      CustomLog.debug(this, "🔐 KongToken is null: ${userData.kongToken == null}");

      if (userData.kongToken != null) {
        print("🔐 KongToken.accessToken is empty: ${userData.kongToken!.accessToken.isEmpty}");
        print("🔐 KongToken.accessToken length: ${userData.kongToken!.accessToken.length}");
        CustomLog.debug(this, "🔐 KongToken.accessToken is empty: ${userData.kongToken!.accessToken.isEmpty}");
        CustomLog.debug(this, "🔐 KongToken.accessToken length: ${userData.kongToken!.accessToken.length}");
      }
      if (userData.kongToken != null && userData.kongToken!.accessToken.isNotEmpty) {
        accessToken = userData.kongToken!.accessToken;
        print("🔐 SELECTED: access_token from kongToken: '$accessToken'");
        CustomLog.debug(this, "🔐 SELECTED: access_token from kongToken: '$accessToken'");
      } else {
        print("❌ Save user failed: No token available");
        CustomLog.error(this, "Save user failed", "No token available");
        return Error(LoginAttemptError());
      }

      // Save user information
      print("🔐 Storing user data:");
      print("🔐 Customer ID to store: '${userData.customerId}'");
      print("🔐 User Role to store: ${userData.roleId}");
      print("🔐 Access Token to store: '$accessToken'");

      await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.customerId.toString());
      await _securedSharedPref.saveInt(AppString.sessionKey.userRole, userData.roleId);
      await _securedSharedPref.saveKey(AppString.sessionKey.refreshToken, accessToken);

      // Verify token was saved
      String? savedToken = await _securedSharedPref.get(AppString.sessionKey.refreshToken);
      CustomLog.debug(this, "Token saved successfully: ${savedToken != null && savedToken.isNotEmpty ? 'Yes' : 'No'}");
      await _securedSharedPref.saveKey(AppString.sessionKey.refreshToken, accessToken);

      CustomLog.debug(this, "🔐 Login successful - Access Token stored: ${accessToken.isNotEmpty ? 'Yes' : 'No'}");
      CustomLog.debug(this, "🔐 Stored token value: '$accessToken'");
      
      // Verify token was stored by reading it back
      String? storedToken = await _securedSharedPref.get(AppString.sessionKey.refreshToken);
      print("🔐 Verification - Read back stored token: '$storedToken'");
      print("🔐 Verification - Token matches: ${storedToken == accessToken}");

      CustomLog.debug(this, "🔐 Verification - Read back stored token: '$storedToken'");
      CustomLog.debug(this, "🔐 Verification - Token matches: ${storedToken == accessToken}");

      // Additional verification - check if token can be retrieved for API calls
      bool tokenIsValid = await hasValidToken();
      print("🔐 Verification - hasValidToken(): $tokenIsValid");
      CustomLog.debug(this, "🔐 Verification - hasValidToken(): $tokenIsValid");

      print("🔐 ===== LOGIN RESPONSE DEBUG END =====");

      return const Success(true);
    } catch (e) {
      print("❌ Save user error: $e");
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
      await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.customerId.toString());
      await _securedSharedPref.saveInt(AppString.sessionKey.companyTypeId, userData.companyTypeId);
      await _securedSharedPref.saveInt(AppString.sessionKey.userRole, userData.roleId);

      // Note: Profile response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(this, "Save user from home saved successfully (no token in profile response)");
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save Resident user info to preferences error", e);
      return Error(GenericError());
    }
  }

    /// Save user data from driver home
  Future<Result<bool>> saveUserInfoFromDriverHome(DriverProfileDetailsModel user) async {
    try {
      final userData = user.data;
      if (userData == null) {
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }

      // Save customer details basic user info
      await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.driverId.toString());
      await _securedSharedPref.saveInt(AppString.sessionKey.userRole, 0);

      // Note: Profile response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(this, "Save user from home saved successfully (no token in profile response)");
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
      if(userData.customer != null){
        await _securedSharedPref.saveKey(AppString.sessionKey.userId, userData.customer!.customerId);
        await _securedSharedPref.saveInt(AppString.sessionKey.userRole, userData.customer!.roleId);
        await _securedSharedPref.saveInt(AppString.sessionKey.companyTypeId, userData.customer!.companyTypeId);
      }else{
        CustomLog.error(this, "Save user failed", "User data is null");
        return Error(LoginAttemptError());
      }

      // Note: Create account response doesn't include token, so we don't store it here
      // Token should be stored during initial login process
      CustomLog.debug(this, "Save user from create account saved successfully (no token in create account response)");
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Save user from create account error", e);
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

  /// Force re-login by clearing token but keeping user data
  Future<Result<bool>> forceReLogin() async {
    try {
      // Clear only the token, keep user data
      await _securedSharedPref.deleteKey(AppString.sessionKey.refreshToken);
      CustomLog.debug(this, "🔐 Forced re-login - Token cleared, user data preserved");
      return const Success(true);
    } catch (e) {
      CustomLog.error(this, "Force re-login error", e);
      return Error(GenericError());
    }
  }


}