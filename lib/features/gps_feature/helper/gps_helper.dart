import 'package:permission_handler/permission_handler.dart';

class GpsHelper {
  static Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }

    return false;
  }
}