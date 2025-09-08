import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/utils/app_string.dart';

class UserInformationRepository {
  final SecuredSharedPreferences _securedSharedPref;
  UserInformationRepository(this._securedSharedPref);

  Future<String?> getUserID() async {
    return await _securedSharedPref.get(AppString.sessionKey.userId);
  }

  Future<String?> getUsername() async {
    return await _securedSharedPref.get(AppString.sessionKey.userFullName);
  }

  Future<String?> getUserMobileNumber() async {
    return await _securedSharedPref.get(AppString.sessionKey.userMobileNumber);
  }

  Future<String?> getUserEmail() async {
    return await _securedSharedPref.get(AppString.sessionKey.userEmail);
  }

  Future<String?> getAddress() async {
    return await _securedSharedPref.get(AppString.sessionKey.userAddress);
  }

  Future<String?> getFcmToken() async {
    return await _securedSharedPref.get(AppString.sessionKey.fcmToken);
  }

  Future<int?> getUserRole() async {
    return await _securedSharedPref.getInt(AppString.sessionKey.userRole);
  }

  Future<String?> getCustomerTypeID() async {
    return await _securedSharedPref.get(AppString.sessionKey.companyTypeId);
  }

  Future<String?> getBlueID() async {
    return await _securedSharedPref.get(AppString.sessionKey.blueId);
  }

  Future<int?> getCustomerSeriesId() async {
    return await _securedSharedPref.getInt(
      AppString.sessionKey.customerSeriesId,
    );
  }

  /// Save GPS token to secure storage
  Future<void> saveGpsToken(String token) async {
    await _securedSharedPref.saveKey(AppString.sessionKey.gpsToken, token);
  }

  /// Get GPS token from secure storage
  Future<String?> getGpsToken() async {
    return await _securedSharedPref.get(AppString.sessionKey.gpsToken);
  }
}
