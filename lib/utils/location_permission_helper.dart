import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper class for managing location permissions and MyLocation layer
class LocationPermissionHelper {
  static bool _hasLocationPermission = false;
  static bool _isLocationServiceEnabled = false;

  /// Check if location permissions are granted
  static Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      _hasLocationPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      return _hasLocationPermission;
    } catch (e) {
      return false;
    }
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      return _isLocationServiceEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Request location permissions
  static Future<bool> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      _hasLocationPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      return _hasLocationPermission;
    } catch (e) {
      return false;
    }
  }

  /// Check if MyLocation layer can be enabled
  static Future<bool> canEnableMyLocation() async {
    final hasPermission = await hasLocationPermission();
    final isServiceEnabled = await isLocationServiceEnabled();
    return hasPermission && isServiceEnabled;
  }

  /// Check if MyLocation should be enabled based on permissions
  static Future<bool> shouldEnableMyLocation() async {
    return await canEnableMyLocation();
  }

  /// Get current location if permissions are granted
  static Future<LatLng?> getCurrentLocationIfPermitted() async {
    try {
      if (await canEnableMyLocation()) {
        final position = await Geolocator.getCurrentPosition();
        return LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      // Silently fail if location cannot be obtained
    }
    return null;
  }
}
