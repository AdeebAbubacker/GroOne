import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gro_one_app/core/app_config.dart';
import 'package:gro_one_app/core/firebase_options.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/service/firebase_secondary_service.dart';
import 'package:gro_one_app/utils/performance_monitor.dart';

/// --- App Initialization Function ---
Future<void> initializeApp() async {
  final stopwatch = Stopwatch()..start();

  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.startTimer('firebase_initialization');
    PerformanceMonitor.startTimer('dependency_injection');
    PerformanceMonitor.startTimer('environment_loading');
  }

  try {
    if (AppConfig.enableParallelInitialization) {
      // 🚀 PARALLEL INITIALIZATION - Run critical services concurrently
      await _initializeWithParallelOptimization(stopwatch);
    } else {
      // 🔄 SEQUENTIAL INITIALIZATION - Fallback for compatibility
      await _initializeSequentially(stopwatch);
    }

    stopwatch.stop();
    debugPrint(
      "🚀 App Initialization completed in ${stopwatch.elapsedMilliseconds}ms",
    );

    if (AppConfig.enablePerformanceMonitoring) {
      PerformanceMonitor.logPerformanceSummary();
    }
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

/// Initialize app with parallel optimization
Future<void> _initializeWithParallelOptimization(Stopwatch stopwatch) async {
  // Start Firebase initialization (most time-consuming)
  final firebaseFuture = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start environment variables loading
  final envFuture = _loadEnvironmentVariables();

  // Start dependency injection setup
  final diFuture = _initializeDependencyInjection();

  // Wait for Firebase to complete first (required for other services)
  await firebaseFuture;
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.stopTimer('firebase_initialization');
  }
  debugPrint("✅ Firebase Initialized in ${stopwatch.elapsedMilliseconds}ms");

  // 🚀 PARALLEL SECONDARY INITIALIZATIONS
  final secondaryFirebaseFuture = FirebaseService.initializeSecondaryApp();
  final messagingPermissionFuture =
      FirebaseMessaging.instance.requestPermission();

  // Wait for all secondary initializations
  await Future.wait([
    secondaryFirebaseFuture,
    messagingPermissionFuture,
    envFuture,
    diFuture,
  ]);

  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.stopTimer('dependency_injection');
    PerformanceMonitor.stopTimer('environment_loading');
  }

  debugPrint(
    "✅ Secondary services initialized in ${stopwatch.elapsedMilliseconds}ms",
  );

  // 🚀 PARALLEL TOKEN RETRIEVAL
  final fcmTokenFuture = FirebaseMessaging.instance.getToken();
  final apnsTokenFuture =
      Platform.isIOS
          ? FirebaseMessaging.instance.getAPNSToken()
          : Future.value(null);

  // Wait for tokens
  final results = await Future.wait([fcmTokenFuture, apnsTokenFuture]);

  final fcmToken = results[0];
  final apnsToken = results[1];

  debugPrint("🔐 FCM Token: $fcmToken");
  if (Platform.isIOS) {
    debugPrint("📱 APNs Token (iOS): $apnsToken");
  }

  // Crashlytics - Only in production (non-blocking)
  if (!kDebugMode || AppConfig.enableCrashlyticsInDebug) {
    _initializeCrashlytics();
  }
}

/// Initialize app sequentially (fallback)
Future<void> _initializeSequentially(Stopwatch stopwatch) async {
  // Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.stopTimer('firebase_initialization');
  }
  debugPrint("✅ Firebase Initialized in ${stopwatch.elapsedMilliseconds}ms");

  // Request messaging permission
  await FirebaseMessaging.instance.requestPermission();
  debugPrint("✅ Firebase Messaging Permission Requested");

  // Firebase Secondary App Initialization
  await FirebaseService.initializeSecondaryApp();
  debugPrint("✅ Firebase Secondary App Initialized");

  // Load Environment Variables
  await _loadEnvironmentVariables();
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.stopTimer('environment_loading');
  }

  // Dependency Injection
  await _initializeDependencyInjection();
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceMonitor.stopTimer('dependency_injection');
  }

  // Platform-specific initialization
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint("📱 APNs Token (iOS): $apnsToken");
  }

  // Get FCM token
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("🔐 FCM Token: $fcmToken");

  // Crashlytics - Only in production
  if (!kDebugMode || AppConfig.enableCrashlyticsInDebug) {
    _initializeCrashlytics();
  }
}

/// Load environment variables asynchronously
Future<void> _loadEnvironmentVariables() async {
  try {
    await dotenv.load(
      /// uat environment
      // fileName: "assets/env/.env.uat",
      /// dev environment
      fileName: "assets/env/.env.dev",
      /// prod environment
      // fileName: "assets/env/.env.production",
    );
    debugPrint("✅ Environment variables loaded successfully");
  } catch (e) {
    debugPrint("⚠️ Failed to load environment variables: $e");
    // Continue execution even if env file fails to load
  }
}

/// Initialize dependency injection asynchronously
Future<void> _initializeDependencyInjection() async {
  try {
    if (AppConfig.enableLazyServiceRegistration) {
      // Initialize core services first
      initLocator();
      debugPrint("✅ Dependency Injection Initialized (Lazy Mode)");
    } else {
      // Initialize all services immediately
      initLocator();
      debugPrint("✅ Dependency Injection Initialized (Full Mode)");
    }
  } catch (e) {
    debugPrint("❌ Dependency injection failed: $e");
    rethrow;
  }
}

/// Initialize Crashlytics (non-blocking)
void _initializeCrashlytics() {
  try {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    debugPrint("✅ Crashlytics Initialized");
  } catch (e) {
    debugPrint("⚠️ Crashlytics initialization failed: $e");
  }
}
