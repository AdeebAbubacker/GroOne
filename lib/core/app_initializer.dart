import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/service/firebase_secondary_service.dart';

import '../features/gps_feature/helper/gps_session_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// --- App Initialization Function ---
Future<void> initializeApp() async {
  // Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Firebase Initialized");

  // Firebase Secondary App Initialization
  await FirebaseService.initializeSecondaryApp();
  debugPrint("Firebase Secondary App Initialized");

  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await requestAndroidNotificationPermission();

  // Local Notifications Setup
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _handleFirebaseMessage(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Load Environment Variables
  await dotenv.load(
    fileName: kDebugMode ? "./assets/env/.env.dev" : "./assets/env/.env.dev",
  );

  // Dependency Injection
  initLocator();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  await _handleFirebaseMessage(message);
}

Future<void> _handleFirebaseMessage(RemoteMessage message) async {
  final uri = await GpsSessionManager.getNotificationToneUriSafe();

  final androidDetails = AndroidNotificationDetails(
    uri != null ? 'channel_id_${uri.hashCode}' : 'default_channel_id',
    'Custom Notifications',
    channelDescription: 'User selected tones',
    importance: Importance.max,
    priority: Priority.high,
    sound: uri != null ? UriAndroidNotificationSound(uri) : null,
  );

  final notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: const DarwinNotificationDetails(),
  );

  try {
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "New Alert",
      message.notification?.body ?? "",
      notificationDetails,
    );
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(
      e,
      stack,
      reason: 'Error showing notification',
    );
  }
}

Future<void> requestAndroidNotificationPermission() async {
  if (Platform.isAndroid) {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("✅ Notification permission granted");
    } else {
      debugPrint("❌ Notification permission denied");
    }
  }
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
