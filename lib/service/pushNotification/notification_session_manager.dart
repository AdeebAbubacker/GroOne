import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';

class NotificationSessionManager {
  static final NotificationSessionManager _instance =
      NotificationSessionManager._internal();
  factory NotificationSessionManager() => _instance;
  NotificationSessionManager._internal();

  late SecuredSharedPreferences _secureSharedPrefs;

  // Session keys
  static const String _powerCutDeviceName = 'power_cut_device_name';
  static const String _spyModeDeviceName = 'spy_mode_device_name';
  static const String _sosDeviceName = 'sos_device_name';
  static const String _lastNotificationDeviceName =
      'last_notification_device_name';
  static const String _currentNotificationSound = 'current_notification_sound';
  static const String _notificationEventType = 'notification_event_type';
  static const String _isNotificationToneSilent = 'is_notification_tone_silent';
  static const String _notificationChoice = 'notification_choice';
  // static const String _adarkycWebViewCompleted = 'kyc_webview_completed';
  void initialize(SecuredSharedPreferences secureSharedPrefs) {
    _secureSharedPrefs = secureSharedPrefs;
  }

  // Device name management
  void savePowerCutDeviceName(String deviceName) async {
    await _secureSharedPrefs.saveKey(_powerCutDeviceName, deviceName);
  }

  Future<String> getPowerCutDeviceName() async {
    return await _secureSharedPrefs.get(_powerCutDeviceName) ?? '';
  }

  void saveSpyModeDeviceName(String deviceName) async {
    await _secureSharedPrefs.saveKey(_spyModeDeviceName, deviceName);
  }

  Future<String> getSpyModeDeviceName() async {
    return await _secureSharedPrefs.get(_spyModeDeviceName) ?? '';
  }

  void saveSOSDeviceName(String deviceName) async {
    await _secureSharedPrefs.saveKey(_sosDeviceName, deviceName);
  }

  Future<String> getSOSDeviceName() async {
    return await _secureSharedPrefs.get(_sosDeviceName) ?? '';
  }

  void saveLastNotificationDeviceName(String deviceName) async {
    await _secureSharedPrefs.saveKey(_lastNotificationDeviceName, deviceName);
  }

  Future<String> getLastNotificationDeviceName() async {
    return await _secureSharedPrefs.get(_lastNotificationDeviceName) ?? '';
  }

  // Notification sound management
  void setCurrentNotificationSound(String soundUri) async {
    await _secureSharedPrefs.saveKey(_currentNotificationSound, soundUri);
  }

  Future<String> getCurrentNotificationSound() async {
    return await _secureSharedPrefs.get(_currentNotificationSound) ?? '';
  }

  // Notification type management
  void setNewNotificationType(String eventType) async {
    await _secureSharedPrefs.saveKey(_notificationEventType, eventType);
  }

  Future<String> getNewNotificationType() async {
    return await _secureSharedPrefs.get(_notificationEventType) ?? '';
  }

  // Silent notification management
  void setNotificationToneSilent(bool isSilent) async {
    await _secureSharedPrefs.saveBoolean(_isNotificationToneSilent, isSilent);
  }

  Future<bool> isNotificationToneSilent() async {
    return await _secureSharedPrefs.getBooleans(_isNotificationToneSilent);
  }

  // Notification choice management
  void setNotificationChoice(bool choice) async {
    await _secureSharedPrefs.saveBoolean(_notificationChoice, choice);
  }

  Future<bool> getNotificationChoice() async {
    return await _secureSharedPrefs.getBooleans(_notificationChoice);
  }
 
//  Future<void> setKycWebViewCompleted(bool value) async {
//   await _secureSharedPrefs.saveBoolean(_adarkycWebViewCompleted, value);
// }

//   Future<bool> isKycWebViewCompleted() async {
//     return await _secureSharedPrefs.getBooleans(_adarkycWebViewCompleted);
//   }

//   Future<void> clearAdarVerification() async {
//   await _secureSharedPrefs.deleteKey(_adarkycWebViewCompleted);
// }
  // Clear all notification session data
  void clearNotificationSession() async {
    await _secureSharedPrefs.deleteKey(_powerCutDeviceName);
    await _secureSharedPrefs.deleteKey(_spyModeDeviceName);
    await _secureSharedPrefs.deleteKey(_sosDeviceName);
    await _secureSharedPrefs.deleteKey(_lastNotificationDeviceName);
    await _secureSharedPrefs.deleteKey(_currentNotificationSound);
    await _secureSharedPrefs.deleteKey(_notificationEventType);
    await _secureSharedPrefs.deleteKey(_isNotificationToneSilent);
    await _secureSharedPrefs.deleteKey(_notificationChoice);
  }
}
