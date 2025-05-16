import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {

 // await FlutterLocalization.instance.();

  // Firebase Initialization
  String appName = "Gro_One_App";
  if (kDebugMode) {
    appName = "Gro_One_App_Dev";
  }
 // await Firebase.initializeApp(name: appName, options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  // Load Environment Variables
  await dotenv.load(fileName: kDebugMode ? "./assets/env/.env.dev" : "./assets/env/.env.dev");

  // Dependency Injection
  initLocator();
}
