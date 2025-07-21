import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'widgets/app_share_widget.dart';

/// A helper class that provides easy-to-use methods for sharing content
class AppShareHelper {
  /// Share simple text content
  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
        ),
      );
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  /// Share location information
  static Future<void> shareLocation({
    required String vehicleNumber,
    required String location,
    DateTime? lastUpdate,
    String? subject,
  }) async {
    try {
      final String formattedDate = _formatDateTime(lastUpdate);
      final String cleanLocation = location.replaceAll(' ', '');
      
      final String shareText = '''
Vehicle Name - $vehicleNumber
Location - $location
Date - $formattedDate
Map - https://www.google.com/maps/search/?api=1&query=$cleanLocation
Sent via gro fleet
''';
      
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: subject ?? 'Vehicle Location',
        ),
      );
    } catch (e) {
      debugPrint('Error sharing location: $e');
    }
  }

  /// Share live location link
  static Future<void> shareLiveLocation({
    required String token,
    String? whiteLabelUrl,
    String? subject,
  }) async {
    try {
      final String shareText = _generateLiveShareLink(token, whiteLabelUrl);
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: subject ?? 'Vehicle Live Location',
        ),
      );
    } catch (e) {
      debugPrint('Error sharing live location: $e');
    }
  }

  /// Show the share widget for vehicle location sharing
  static void showVehicleShareWidget({
    required BuildContext context,
    required String vehicleNumber,
    String? location,
    DateTime? lastUpdate,
    int? deviceId,
    String? token,
    Function(String token, int deviceId, String vehicleNumber, bool isLiveLocation, int hours)? onLiveLocationShare,
    Function(String vehicleNumber, String location, DateTime? lastUpdate)? onCurrentLocationShare,
    bool showLiveLocationOption = true,
    bool showCurrentLocationOption = true,
    int? maxHours = 24,
  }) {
    context.showShareWidget(
      title: 'Share Vehicle Location',
      vehicleNumber: vehicleNumber,
      location: location,
      lastUpdate: lastUpdate,
      deviceId: deviceId,
      token: token,
      onLiveLocationShare: onLiveLocationShare,
      onCurrentLocationShare: onCurrentLocationShare,
      showLiveLocationOption: showLiveLocationOption,
      showCurrentLocationOption: showCurrentLocationOption,
      maxHours: maxHours,
    );
  }

  /// Show the share widget for custom content
  static void showCustomShareWidget({
    required BuildContext context,
    required String shareText,
    String title = 'Share',
    String? subject,
  }) {
    context.showShareWidget(
      title: title,
      customShareText: shareText,
      customShareSubject: subject,
      showLiveLocationOption: false,
      showCurrentLocationOption: false,
    );
  }

  /// Show the share widget for live location only
  static void showLiveLocationShareWidget({
    required BuildContext context,
    required String vehicleNumber,
    int? deviceId,
    String? token,
    Function(String token, int deviceId, String vehicleNumber, bool isLiveLocation, int hours)? onLiveLocationShare,
    int? maxHours = 24,
  }) {
    context.showShareWidget(
      title: 'Share Live Location',
      vehicleNumber: vehicleNumber,
      deviceId: deviceId,
      token: token,
      onLiveLocationShare: onLiveLocationShare,
      showLiveLocationOption: true,
      showCurrentLocationOption: false,
      maxHours: maxHours,
    );
  }

  /// Show the share widget for current location only
  static void showCurrentLocationShareWidget({
    required BuildContext context,
    required String vehicleNumber,
    String? location,
    DateTime? lastUpdate,
    Function(String vehicleNumber, String location, DateTime? lastUpdate)? onCurrentLocationShare,
  }) {
    context.showShareWidget(
      title: 'Share Current Location',
      vehicleNumber: vehicleNumber,
      location: location,
      lastUpdate: lastUpdate,
      onCurrentLocationShare: onCurrentLocationShare,
      showLiveLocationOption: false,
      showCurrentLocationOption: true,
    );
  }

  /// Generate live share link
  static String _generateLiveShareLink(String token, String? whiteLabelUrl) {
    final String url = whiteLabelUrl ?? "https://track.letsgro.co";
    return "$url/v1/auth/live?token=$token";
  }

  /// Format date time
  static String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  }
} 