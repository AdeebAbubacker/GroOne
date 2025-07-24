import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class RingtonePicker {
  static const MethodChannel _channel = MethodChannel('custom_ringtone_picker');

  static Future<String?> pickRingtone() async {
    try {
      final String? uri = await _channel.invokeMethod('pickRingtone');
      return uri;
    } on PlatformException catch (e) {
      debugPrint("Failed to pick ringtone: ${e.message}");
      return null;
    }
  }
}
