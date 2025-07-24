import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {
  try {
    // Firebase Initialization
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Firebase Initialized");
    await FirebaseMessaging.instance.requestPermission();

    // Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Load Environment Variables
    try {
      await dotenv.load(fileName: kDebugMode ? "assets/env/.env.dev" : "assets/env/.env.prod");
      debugPrint("Environment variables loaded successfully");
    } catch (e) {
      debugPrint("Failed to load environment variables: $e");
      // Continue execution even if env file fails to load
    }

    // Dependency Injection
    initLocator();

    // ✅ Don't request permission again here.
    // 🔐 FCM token logic only — assuming NotificationService.init() already handled permission

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("📱 APNs Token (iOS): $apnsToken");
    }

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("🔐 FCM Token: $fcmToken");
  } catch (e) {
    debugPrint("App initialization error: $e");
    // Don't rethrow the error to prevent app crash
  }
}
