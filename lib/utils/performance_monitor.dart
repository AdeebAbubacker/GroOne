import 'dart:async';

import 'package:flutter/foundation.dart';

/// Performance monitoring utility to track initialization times
class PerformanceMonitor {
  static final Map<String, List<int>> _timers = {};
  static final Map<String, int> _startTimes = {};

  /// Start timing a specific operation
  static void startTimer(String operationName) {
    _startTimes[operationName] = DateTime.now().millisecondsSinceEpoch;
    debugPrint('⏱️ Started timing: $operationName');
  }

  /// Stop timing a specific operation
  static void stopTimer(String operationName) {
    final startTime = _startTimes[operationName];
    if (startTime != null) {
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;

      if (!_timers.containsKey(operationName)) {
        _timers[operationName] = [];
      }
      _timers[operationName]!.add(duration);

      debugPrint('⏱️ $operationName completed in ${duration}ms');
      _startTimes.remove(operationName);
    }
  }

  /// Get performance summary for all tracked operations
  static Map<String, Map<String, dynamic>> getPerformanceSummary() {
    final summary = <String, Map<String, dynamic>>{};

    _timers.forEach((operationName, durations) {
      if (durations.isNotEmpty) {
        final count = durations.length;
        final average = durations.reduce((a, b) => a + b) / count;
        final min = durations.reduce((a, b) => a < b ? a : b);
        final max = durations.reduce((a, b) => a > b ? a : b);

        summary[operationName] = {
          'count': count,
          'average': average.roundToDouble(),
          'min': min,
          'max': max,
        };
      }
    });

    return summary;
  }

  /// Log performance summary to console
  static void logPerformanceSummary() {
    final summary = getPerformanceSummary();

    if (summary.isEmpty) {
      debugPrint('📊 No performance data available');
      return;
    }

    debugPrint('📊 Performance Summary:');
    summary.forEach((operationName, data) {
      debugPrint(
        '  $operationName: {count: ${data['count']}, average: ${data['average']}, min: ${data['min']}, max: ${data['max']}}',
      );
    });

    // Calculate total time
    final totalTime = summary.values
        .map((data) => data['average'] as double)
        .reduce((a, b) => a + b);

    debugPrint('📊 Total Average Time: ${totalTime.round()}ms');
  }

  /// Clear all performance data
  static void clearData() {
    _timers.clear();
    _startTimes.clear();
    debugPrint('🧹 Performance data cleared');
  }

  /// Get specific operation performance data
  static Map<String, dynamic>? getOperationData(String operationName) {
    final durations = _timers[operationName];
    if (durations == null || durations.isEmpty) return null;

    final count = durations.length;
    final average = durations.reduce((a, b) => a + b) / count;
    final min = durations.reduce((a, b) => a < b ? a : b);
    final max = durations.reduce((a, b) => a > b ? a : b);

    return {
      'count': count,
      'average': average.roundToDouble(),
      'min': min,
      'max': max,
    };
  }

  /// Check if an operation is taking too long (performance warning)
  static bool isOperationSlow(String operationName, {int thresholdMs = 1000}) {
    final data = getOperationData(operationName);
    if (data == null) return false;

    return data['average'] > thresholdMs;
  }

  /// Get slow operations (above threshold)
  static List<String> getSlowOperations({int thresholdMs = 1000}) {
    return _timers.keys
        .where(
          (operationName) =>
              isOperationSlow(operationName, thresholdMs: thresholdMs),
        )
        .toList();
  }
}

/// Performance measurement helper
class PerformanceMeasurer {
  static Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    PerformanceMonitor.startTimer(operationName);
    try {
      final result = await operation();
      return result;
    } finally {
      PerformanceMonitor.stopTimer(operationName);
    }
  }

  static T measureSync<T>(String operationName, T Function() operation) {
    PerformanceMonitor.startTimer(operationName);
    try {
      final result = operation();
      return result;
    } finally {
      PerformanceMonitor.stopTimer(operationName);
    }
  }
}

/// Memory usage monitor
class MemoryMonitor {
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      // This is a placeholder - in a real app you might use platform channels
      // to get actual memory usage from the OS
      debugPrint(
        '💾 Memory usage at $context: [Memory info not available in debug mode]',
      );
    }
  }

  static void logMemoryWarning(String context, int thresholdMB) {
    if (kDebugMode) {
      debugPrint(
        '⚠️ Memory warning at $context: Usage may be above ${thresholdMB}MB',
      );
    }
  }
}

/// App lifecycle performance monitor
class AppLifecycleMonitor {
  static final Map<String, Duration> _lifecycleDurations = {};
  static final Map<String, Stopwatch> _lifecycleTimers = {};

  /// Start monitoring a lifecycle event
  static void startLifecycleEvent(String eventName) {
    _lifecycleTimers[eventName] = Stopwatch()..start();
  }

  /// End monitoring a lifecycle event
  static void endLifecycleEvent(String eventName) {
    final timer = _lifecycleTimers[eventName];
    if (timer != null) {
      timer.stop();
      _lifecycleDurations[eventName] = timer.elapsed;
      _lifecycleTimers.remove(eventName);

      if (kDebugMode) {
        debugPrint(
          '🔄 Lifecycle event $eventName took ${timer.elapsedMilliseconds}ms',
        );
      }
    }
  }

  /// Get lifecycle performance summary
  static Map<String, Duration> getLifecycleSummary() {
    return Map.unmodifiable(_lifecycleDurations);
  }

  /// Clear lifecycle metrics
  static void clearLifecycleMetrics() {
    _lifecycleDurations.clear();
    _lifecycleTimers.clear();
  }
}
