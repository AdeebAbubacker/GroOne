import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GpsSessionManager {
  static const String _notificationToneUriKey = 'notification_ringtone_uri';
  static const String _notificationEnabledKey = 'gps_notification_enabled';
  static const String _showMarkerLabelKey = 'gps_show_marker_label';
  static const String _showMarkerClusterKey = 'gps_show_marker_cluster';
  static const String _geofenceToggleKey = 'gps_geofence_toggle_map';
  static const String _showGeofenceOnMapKey = 'gps_show_geofence_on_map';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setNotificationToneUri(String uri) async {
    await _prefs?.setString(_notificationToneUriKey, uri);
  }

  static String? getNotificationToneUri() {
    return _prefs?.getString(_notificationToneUriKey);
  }

  static Future<String?> getNotificationToneUriSafe() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getString(_notificationToneUriKey);
  }

  static Future<void> clearNotificationToneUri() async {
    await _prefs?.remove(_notificationToneUriKey);
  }

  // GPS Notification
  static Future<void> setNotificationEnabled(bool isEnabled) async {
    await _prefs?.setBool(_notificationEnabledKey, isEnabled);
  }

  static bool isNotificationEnabled() {
    return _prefs?.getBool(_notificationEnabledKey) ?? true; // default to true
  }

  // Marker Label
  static Future<void> setShowMarkerLabel(bool value) async {
    await _prefs?.setBool(_showMarkerLabelKey, value);
  }

  static bool isShowMarkerLabelEnabled() {
    return _prefs?.getBool(_showMarkerLabelKey) ?? true; // default to true
  }

  // Marker Cluster
  static Future<void> setShowMarkerCluster(bool value) async {
    await _prefs?.setBool(_showMarkerClusterKey, value);
  }

  static bool isShowMarkerClusterEnabled() {
    return _prefs?.getBool(_showMarkerClusterKey) ?? true; // default to true
  }

  // Geofence Display on Map
  static Future<void> setShowGeofenceOnMap(bool value) async {
    await _prefs?.setBool(_showGeofenceOnMapKey, value);
  }

  static bool isShowGeofenceOnMapEnabled() {
    return _prefs?.getBool(_showGeofenceOnMapKey) ?? false; // default to false
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Save toggle state map
  static Future<void> setGeofenceToggleMap(Map<String, bool> map) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final jsonString = jsonEncode(map);
    await prefs.setString(_geofenceToggleKey, jsonString);
  }

  // Load toggle state map
  static Future<Map<String, bool>> getGeofenceToggleMap() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_geofenceToggleKey);
    if (jsonString == null) return {};
    final decoded = jsonDecode(jsonString);
    return Map<String, bool>.from(decoded);
  }
}
