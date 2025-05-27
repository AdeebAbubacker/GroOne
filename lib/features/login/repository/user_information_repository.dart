import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/utils/app_string.dart';

class UserInformationRepository {
  final SecuredSharedPreferences _securedSharedPref;
  UserInformationRepository(this._securedSharedPref);


  Future<String?> getUserID() async {
    return  await _securedSharedPref.get(AppString.sessionKey.userId);
  }

  Future<String?> getUsername() async {
    return  await _securedSharedPref.get(AppString.sessionKey.userFullName);
  }

  Future<String?> getAddress() async {
    return  await _securedSharedPref.get(AppString.sessionKey.userAddress);
  }


  Future<String?> getFcmToken() async {
    return  await _securedSharedPref.get(AppString.sessionKey.fcmToken);
  }

  Future<String?> getUserRole() async {
    return  await _securedSharedPref.get(AppString.sessionKey.userRole);
  }



}