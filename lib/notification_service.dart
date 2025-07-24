import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel _highAlertsChannel = AndroidNotificationChannel(
    'high_alerts',
    'High Alert Notifications',
    description: 'Used for important notifications like SOS, Power Cut, etc.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('sos_sound'),
  );

  static final AndroidNotificationChannel _parkingAlertsChannel = AndroidNotificationChannel(
    'parking_alerts',
    'Parking Alert Notifications',
    description: 'Used for parking and spy mode notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('spymode_sound'),
  );

  static final AndroidNotificationChannel _callAlertsChannel = AndroidNotificationChannel(
    'call_alerts',
    'Call Alert Notifications',
    description: 'Used for call and unauthorized parking notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('agora_call'),
  );

  static final AndroidNotificationChannel _powerCutChannel = AndroidNotificationChannel(
    'powercut_alerts',
    'Power Cut Notifications',
    description: 'Used for power cut notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('powercut'),
  );

  late GlobalKey<NavigatorState> navigatorKey;

  Future<void> init(GlobalKey<NavigatorState> key) async {
    navigatorKey = key;

    // Android: Create notification channels
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.createNotificationChannel(_highAlertsChannel);
      await androidImplementation?.createNotificationChannel(_parkingAlertsChannel);
      await androidImplementation?.createNotificationChannel(_callAlertsChannel);
      await androidImplementation?.createNotificationChannel(_powerCutChannel);
    }

    // iOS: Request notification permissions
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Initialization settings for Android and iOS
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Background/terminated notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// iOS (below version 10) local notification tap
  static void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // Optionally handle this case
  }

  /// Called from main() for background/terminated messages
  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await _instance._handleMessage(message, showPopup: false);
  }

  /// Common message handler
  Future<void> _handleMessage(RemoteMessage message, {bool showPopup = true}) async {
    final data = message.data;
    final eventType = data['eventType'] ?? 'unknown';
    final mode = data['mode'] ?? 'normal';

    final notification = message.notification;
    final title = '🚨 ${notification?.title ?? ''}';
    final body = notification?.body ?? 'You have a new notification';

    // Event-based configuration
    final eventConfig = _getEventConfig(eventType, mode);
    final channelId = eventConfig['channelId'] ?? _highAlertsChannel.id;
    final channelName = eventConfig['channelName'] ?? _highAlertsChannel.name;
    final androidSound = eventConfig['sound'] ??RawResourceAndroidNotificationSound('sos_sound');
    final iosSound = eventConfig['iosSound'];

    // Show local notification
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: eventConfig['description'],
          importance: Importance.max,
          priority: Priority.high,
          sound: androidSound,
        ),
        iOS: DarwinNotificationDetails(
          sound: iosSound,
        ),
      ),
    );

    // Show popup if app is in foreground
    if (showPopup && navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.taxi_alert,color: Colors.red,size: 50,),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 6),
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'DISMISS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  /// Event-based sound and channel configuration matching Android implementation
  Map<String, dynamic> _getEventConfig(String eventType, String mode) {
    switch (eventType.toLowerCase()) {
      case 'sos':
        return {
          'channelId': _highAlertsChannel.id,
          'channelName': _highAlertsChannel.name,
          'description': 'SOS emergency alerts',
          'sound': RawResourceAndroidNotificationSound('sos_sound'),
          'iosSound': 'sos_sound.aiff',
        };

      case 'powercut':
      case 'power_cut':
        return {
          'channelId': _powerCutChannel.id,
          'channelName': _powerCutChannel.name,
          'description': 'Power cut alerts',
          'sound': RawResourceAndroidNotificationSound('powercut'),
          'iosSound': 'powercut.aiff',
        };

      case 'unauthorized_parking':
      case 'unauthorised_parking':
        return {
          'channelId': _callAlertsChannel.id,
          'channelName': _callAlertsChannel.name,
          'description': 'Unauthorized parking calls',
          'sound': RawResourceAndroidNotificationSound('agora_call'),
          'iosSound': 'agora_call.aiff',
        };

      case 'parking':
      case 'tow':
        return {
          'channelId': _parkingAlertsChannel.id,
          'channelName': _parkingAlertsChannel.name,
          'description': 'Parking and tow alerts',
          'sound': RawResourceAndroidNotificationSound('spymode_sound'),
          'iosSound': 'spymode_sound.aiff',
        };

      case 'gps_disconnected':
      case 'engine_on':
      default:
      // Check mode for special cases
        if (mode.toLowerCase() == 'owl' ||
            mode.toLowerCase() == 'parking' ||
            mode.toLowerCase() == 'alarm') {
          return {
            'channelId': _parkingAlertsChannel.id,
            'channelName': _parkingAlertsChannel.name,
            'description': 'Spy mode alerts',
            'sound': RawResourceAndroidNotificationSound('spymode_sound'),
            'iosSound': 'spymode_sound.aiff',
          };
        }

        // Default case
        return {
          'channelId': _highAlertsChannel.id,
          'channelName': _highAlertsChannel.name,
          'description': 'General alerts',
          'sound': RawResourceAndroidNotificationSound('sos_sound'),
          'iosSound': 'sos_sound.aiff',
        };
    }
  }
}
