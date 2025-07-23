
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {

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
  await dotenv.load(fileName: kDebugMode ? "./assets/env/.env.dev" : "./assets/env/.env.dev");

  // Dependency Injection
  initLocator();
  // 🔐 FCM Token
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("🔔 FCM Token: $token");
}

