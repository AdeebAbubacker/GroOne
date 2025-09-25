import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gro_one_app/utils/app_string.dart';

class SecuredSharedPreferences {
  final FlutterSecureStorage _secureStorage;
  SecuredSharedPreferences(this._secureStorage);

  Future<void> saveKey(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      print("Decryption failed for key=$key. Error: $e");
      await _secureStorage.delete(key: key); // clear corrupted value
      return null;
    }
  }

  // Future<String?> get(String key) async {
  //   return await _secureStorage.read(key: key);
  // }

  Future<void> deleteKey(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> reset() async {
    _secureStorage.deleteAll();
  }

  Future<void> resetPreservingLanguage() async {
    final langCode = await get(AppString.sessionKey.selectedLanguage);
    final firstPostedLoad = await get(AppString.sessionKey.firstPostedLoadId);
    await _secureStorage.deleteAll();
    if (langCode != null) {
      await saveKey(AppString.sessionKey.selectedLanguage, langCode);
    }
    if (firstPostedLoad != null) {
      await saveKey(AppString.sessionKey.selectedLanguage, firstPostedLoad);
    }
  }


  Future<void> saveInt(String key, int value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> saveBoolean(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<int?> getInt(String key) async {
    try {
      String? value = await _secureStorage.read(key: key);
      if (value != null) {
        return int.tryParse(value);
      }
    } catch (e) {
      print("Decryption failed for int key=$key. Error: $e");
      await _secureStorage.delete(key: key);
    }
    return null;
  }

  Future<bool> getBooleans(String key) async {
    try {
      String? value = await _secureStorage.read(key: key);
      if (value != null) {
        return value == true.toString();
      }
    } catch (e) {
      print("Decryption failed for bool key=$key. Error: $e");
      await _secureStorage.delete(key: key);
    }
    return false;
  }

// Future<int?> getInt(String key) async {
//   String? value = await _secureStorage.read(key: key);
//   if (value != null) {
//     return int.tryParse(value);
//   }
//   return null;
// }

// Future<bool> getBooleans(String key) async {
//   String? value = await _secureStorage.read(key: key);
//   if (value != null) {
//     return true.toString() == value;
//   }
//   return false;
// }

}
