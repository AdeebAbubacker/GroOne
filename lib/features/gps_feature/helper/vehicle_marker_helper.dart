import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'vehicle_icon_helper.dart';

/// Helper class to create custom vehicle markers with emoji icons
class VehicleMarkerHelper {
  /// Create a custom vehicle marker with emoji icon
  static Future<Marker> createCustomVehicleMarker({
    required String vehicleId,
    required LatLng position,
    required String title,
    required VoidCallback onTap,
    String? vehicleCategory,
    String? status,
    DateTime? lastUpdate,
    bool isExpired = false,
  }) async {
    // Create custom bitmap with emoji
    final BitmapDescriptor icon = await _createEmojiBitmapDescriptor(
      vehicleCategory,
      status,
      lastUpdate,
      isExpired,
    );

    return Marker(
      markerId: MarkerId(vehicleId),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(
        title: title,
        snippet: VehicleIconHelper.getVehicleStatusText(status),
      ),
      onTap: onTap,
    );
  }

  /// Create a custom marker with vehicle type indicator
  static Future<Marker> createCustomVehicleMarkerWithType({
    required String vehicleId,
    required LatLng position,
    required String title,
    required VoidCallback onTap,
    String? vehicleCategory,
    String? status,
    DateTime? lastUpdate,
    bool isExpired = false,
  }) async {
    // Create custom bitmap with emoji
    final BitmapDescriptor icon = await _createEmojiBitmapDescriptor(
      vehicleCategory,
      status,
      lastUpdate,
      isExpired,
    );

    // Add vehicle type to info window
    final vehicleType = VehicleIconHelper.getVehicleType(vehicleCategory);
    final vehicleTypeName = VehicleIconHelper.getVehicleTypeDisplayName(
      vehicleType,
    );
    final statusText = VehicleIconHelper.getVehicleStatusText(status);

    return Marker(
      markerId: MarkerId(vehicleId),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(
        title: title,
        snippet: '$vehicleTypeName - $statusText',
      ),
      onTap: onTap,
    );
  }

  /// Create a custom marker with vehicle emoji
  static Future<Marker> createCustomVehicleMarkerWithEmoji({
    required String vehicleId,
    required LatLng position,
    required String title,
    required VoidCallback onTap,
    String? vehicleCategory,
    String? status,
    DateTime? lastUpdate,
    bool isExpired = false,
  }) async {
    // Create custom bitmap with emoji
    final BitmapDescriptor icon = await _createEmojiBitmapDescriptor(
      vehicleCategory,
      status,
      lastUpdate,
      isExpired,
    );

    // Add vehicle type to info window
    final vehicleType = VehicleIconHelper.getVehicleType(vehicleCategory);
    final vehicleTypeName = VehicleIconHelper.getVehicleTypeDisplayName(
      vehicleType,
    );
    final statusText = VehicleIconHelper.getVehicleStatusText(status);

    return Marker(
      markerId: MarkerId(vehicleId),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(
        title: title,
        snippet: '$vehicleTypeName - $statusText',
      ),
      onTap: onTap,
    );
  }

  /// Create bitmap descriptor with vehicle emoji
  static Future<BitmapDescriptor> _createEmojiBitmapDescriptor(
    String? vehicleCategory,
    String? status,
    DateTime? lastUpdate,
    bool isExpired,
  ) async {
    try {
      const double size = 120.0; // Much larger size for better visibility
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      // Get vehicle emoji
      final vehicleEmoji = getVehicleTypeEmoji(vehicleCategory);

      // Draw emoji directly without any background circle
      final textPainter = TextPainter(
        text: TextSpan(
          text: vehicleEmoji,
          style: const TextStyle(fontSize: 80), // Large emoji
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
      );

      // Convert to image
      final ui.Picture picture = pictureRecorder.endRecording();
      final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('Error creating emoji bitmap: $e');
    }

    // Fallback to colored marker
    return getMarkerIcon(vehicleCategory, status, lastUpdate, isExpired);
  }

  /// Get marker color based on vehicle state
  static Color getMarkerColor(
    String? status,
    DateTime? lastUpdate,
    bool isExpired,
  ) {
    if (isExpired || VehicleIconHelper.isVehicleExpired(lastUpdate)) {
      return Colors.red;
    }

    final deviceState = VehicleIconHelper.getDeviceState(status);

    switch (deviceState) {
      case VehicleIconHelper.DEVICE_STATE_ON:
        return VehicleIconHelper.ONLINE_COLOR;
      case VehicleIconHelper.DEVICE_STATE_OFF:
        return VehicleIconHelper.OFFLINE_COLOR;
      case VehicleIconHelper.DEVICE_STATE_IDLE:
        return VehicleIconHelper.IDLE_COLOR;
      case VehicleIconHelper.DEVICE_STATE_OFFLINE:
      default:
        return VehicleIconHelper.INACTIVE_COLOR;
    }
  }

  /// Get marker icon based on vehicle type and state
  static BitmapDescriptor getMarkerIcon(
    String? vehicleCategory,
    String? status,
    DateTime? lastUpdate,
    bool isExpired,
  ) {
    if (isExpired || VehicleIconHelper.isVehicleExpired(lastUpdate)) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }

    final deviceState = VehicleIconHelper.getDeviceState(status);

    switch (deviceState) {
      case VehicleIconHelper.DEVICE_STATE_ON:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case VehicleIconHelper.DEVICE_STATE_OFF:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case VehicleIconHelper.DEVICE_STATE_IDLE:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      case VehicleIconHelper.DEVICE_STATE_OFFLINE:
      default:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        );
    }
  }

  /// Get vehicle type emoji for display
  static String getVehicleTypeEmoji(String? vehicleCategory) {
    final vehicleType = VehicleIconHelper.getVehicleType(vehicleCategory);

    switch (vehicleType) {
      case VehicleIconHelper.VEHICLE_CAR:
        return '🚗';
      case VehicleIconHelper.VEHICLE_TRUCK:
        return '🚛';
      case VehicleIconHelper.VEHICLE_BIKE:
        return '🏍️';
      case VehicleIconHelper.PERSONAL:
        return '📍';
      case VehicleIconHelper.BUS:
        return '🚌';
      case VehicleIconHelper.TRAIN:
        return '🚆';
      case VehicleIconHelper.E_RICKSHAW:
        return '🛺';
      case VehicleIconHelper.AMBULANCE:
        return '🚑';
      case VehicleIconHelper.TANKER:
        return '⛽';
      case VehicleIconHelper.TRACTOR:
        return '🚜';
      case VehicleIconHelper.CRANE:
        return '🏗️';
      default:
        return '🚗';
    }
  }

  /// Create a custom vehicle icon widget for use in overlays
  static Widget createVehicleIconWidget({
    required String? vehicleCategory,
    required String? status,
    required DateTime? lastUpdate,
    bool isExpired = false,
    double size = 120.0, // Much larger default size
  }) {
    final vehicleTypeEmoji = getVehicleTypeEmoji(vehicleCategory);

    return Container(
      width: size,
      height: size,
      child: Center(
        child: Text(vehicleTypeEmoji, style: TextStyle(fontSize: size * 0.6)),
      ),
    );
  }
}
