import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_alerts',
    'High Alert Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert_sound'),
  );

  late GlobalKey<NavigatorState> navigatorKey;

  Future<void> init(GlobalKey<NavigatorState> key) async {
    navigatorKey = key;

    // Create notification channel (Android)
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }

    // Initialize settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Notification tap handling (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Called from main() for background/terminated messages
  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await _instance._handleMessage(message, showPopup: false);
  }

  /// Common message handler
  Future<void> _handleMessage(RemoteMessage message, {bool showPopup = true}) async {
    final data = message.data;
    final eventType = data['eventType'] ?? 'unknown';

    // 🔽 Read title and body from the RemoteMessage
    final notification = message.notification;
    final title ='🚨 Alert ${notification?.title}';
    final body = notification?.body ?? 'You have a new notification';

    // 🔽 Optional: Choose custom sound based on eventType
    final eventConfig = _getEventConfig(eventType);
    final sound = eventConfig['sound'] ?? RawResourceAndroidNotificationSound('alert_sound');

    // 🔔 Show local notification
    _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          sound: sound,
        ),
      ),
    );

    // 💬 Show popup only in foreground
    if (showPopup && navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  /// Optional: Use eventType to assign custom sound
  Map<String, dynamic> _getEventConfig(String eventType) {
    switch (eventType) {
      case 'sos':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      case 'unauthorized_parking':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      case 'power_cut':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      case 'battery_low':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      case 'gps_disconnected':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      case 'engine_on':
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
      default:
        return {
          'sound': RawResourceAndroidNotificationSound('alert_sound'),
        };
    }
  }
}
