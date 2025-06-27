import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _isFirstTimeLoadKey = 'isFirstTimeLoad';

  /// Set isFirstTimeLoad flag
  static Future<void> setIsFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeLoadKey, value);
  }

  /// Get isFirstTime flag
  static Future<bool> getIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeLoadKey) ?? false;
  }


  /// Clear all preferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
