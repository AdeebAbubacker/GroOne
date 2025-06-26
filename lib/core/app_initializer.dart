import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/utils/custom_log.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {

  // Firebase Initialization
  // Firebase
  if(Platform.isIOS){
    await Firebase.initializeApp();
  }else{
    String appName = "Gro One";
    if(kDebugMode){
      appName = "Gro One Dev";
    }
    await Firebase.initializeApp(name: appName, options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Firebase Initialized");
  }

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
