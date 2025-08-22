import 'package:flutter/foundation.dart';

/// App configuration for performance optimizations and feature flags
class AppConfig {
  // Performance optimization flags
  static const bool enableParallelInitialization = true;
  static const bool enableLazyGpsInitialization = true;
  static const bool enablePerformanceMonitoring = true;

  // Firebase optimization flags
  static const bool enableFirebaseOptimizations = true;
  static const bool enableCrashlyticsInDebug = false;

  // Dependency injection optimization flags
  static const bool enableLazyServiceRegistration = true;
  static const bool enableDeferredGpsServices = true;

  // Network optimization flags
  static const bool enableNetworkOptimizations = true;
  static const int networkTimeoutMs = 10000;

  // Debug flags
  static const bool enableDebugLogging = kDebugMode;
  static const bool enablePerformanceLogging = kDebugMode;

  // Feature flags
  static const bool enableGpsFeatures = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;

  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'parallelInitialization': enableParallelInitialization,
      'lazyGpsInitialization': enableLazyGpsInitialization,
      'performanceMonitoring': enablePerformanceMonitoring,
      'firebaseOptimizations': enableFirebaseOptimizations,
      'lazyServiceRegistration': enableLazyServiceRegistration,
      'deferredGpsServices': enableDeferredGpsServices,
      'networkOptimizations': enableNetworkOptimizations,
      'debugLogging': enableDebugLogging,
      'performanceLogging': enablePerformanceLogging,
      'gpsFeatures': enableGpsFeatures,
      'pushNotifications': enablePushNotifications,
      'analytics': enableAnalytics,
    };
  }

  /// Check if performance optimizations are enabled
  static bool get arePerformanceOptimizationsEnabled {
    return enableParallelInitialization &&
        enableLazyGpsInitialization &&
        enableLazyServiceRegistration;
  }

  /// Check if debug features are enabled
  static bool get areDebugFeaturesEnabled {
    return kDebugMode && enableDebugLogging;
  }

  /// Get network timeout duration
  static Duration get networkTimeout {
    return Duration(milliseconds: networkTimeoutMs);
  }
}
