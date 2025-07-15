import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  MapHelper._();

  // Zoom In
  static Future<void> zoomIn(GoogleMapController controller) async {
    final zoom = await controller.getZoomLevel();
    controller.animateCamera(CameraUpdate.zoomTo(zoom + 1));
    _commonHapticFeedback();
  }

  // Zoom Out
  static Future<void> zoomOut(GoogleMapController controller) async {
    final zoom = await controller.getZoomLevel();
    controller.animateCamera(CameraUpdate.zoomTo(zoom - 1));
    _commonHapticFeedback();
  }

  // Animate to a specific location
  static Future<void> animateTo(
    GoogleMapController controller,
    LatLng latLng, {
    double zoom = 15,
  }) async {
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
    _commonHapticFeedback();
  }

  // Get current location
  static Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  // Get address from LatLng
  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.country}';
    } catch (_) {
      return 'No address found';
    }
  }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      // debugPrint("Error fetching LatLng from address: $e");
    }
    return null;
  }


  // Reusable: Get address from latitude and longitude
  static Future<String> getAddressFromLatLngDoubles(
    double lat,
    double lng,
  ) async {
    return await getAddressFromLatLng(LatLng(lat, lng));
  }

  // Haptic feedback
  static void _commonHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  static Future<LatLng?> getLastKnownLocation() async {
    try {
      final pos = await Geolocator.getLastKnownPosition();
      if (pos != null) {
        return LatLng(pos.latitude, pos.longitude);
      }
    } catch (e) {
      // log("Failed to get last known position: $e");
    }
    return null;
  }



}
