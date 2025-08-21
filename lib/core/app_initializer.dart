import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/service/firebase_secondary_service.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {
  final stopwatch = Stopwatch()..start();

  try {
    // Firebase Initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase Initialized in ${stopwatch.elapsedMilliseconds}ms");

    // Request messaging permission early
    await FirebaseMessaging.instance.requestPermission();
    debugPrint("✅ Firebase Messaging Permission Requested");

    // Firebase Secondary App Initialization
    await FirebaseService.initializeSecondaryApp();
    debugPrint("✅ Firebase Secondary App Initialized");

    // Crashlytics - Only in production
    if (!kDebugMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      debugPrint("✅ Crashlytics Initialized");
    }

    // Load Environment Variables
    try {
      await dotenv.load(
        fileName:
            kDebugMode ? "assets/env/.env.dev" : "assets/env/.env.production",
      );
      debugPrint("✅ Environment variables loaded successfully");
    } catch (e) {
      debugPrint("⚠️ Failed to load environment variables: $e");
      // Continue execution even if env file fails to load
    }

    // Dependency Injection
    initLocator();
    debugPrint("✅ Dependency Injection Initialized");

    // Platform-specific initialization
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("📱 APNs Token (iOS): $apnsToken");
    }

    // Get FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("🔐 FCM Token: $fcmToken");

    stopwatch.stop();
    debugPrint(
      "🚀 App Initialization completed in ${stopwatch.elapsedMilliseconds}ms",
    );
  } catch (e, stackTrace) {
    stopwatch.stop();
    debugPrint(
      "❌ App initialization error after ${stopwatch.elapsedMilliseconds}ms: $e",
    );
    debugPrint("Stack trace: $stackTrace");

    // Don't rethrow the error to prevent app crash
    // The app will show an error screen instead
  }
}
