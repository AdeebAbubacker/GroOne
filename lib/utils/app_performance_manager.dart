import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Comprehensive app performance and stability manager
class AppPerformanceManager {
  static final AppPerformanceManager _instance =
      AppPerformanceManager._internal();
  factory AppPerformanceManager() => _instance;
  AppPerformanceManager._internal();

  Timer? _memoryCheckTimer;
  Timer? _performanceCheckTimer;
  int _memoryWarningCount = 0;
  int _performanceWarningCount = 0;
  final List<String> _recentErrors = [];
  static const int _maxRecentErrors = 10;

  /// Initialize performance monitoring
  void initialize() {
    if (kDebugMode) {
      _startMemoryMonitoring();
      _startPerformanceMonitoring();
    }
  }

  /// Start memory monitoring
  void _startMemoryMonitoring() {
    _memoryCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkMemoryUsage();
    });
  }

  /// Start performance monitoring
  void _startPerformanceMonitoring() {
    _performanceCheckTimer = Timer.periodic(const Duration(minutes: 1), (
      timer,
    ) {
      _checkPerformanceMetrics();
    });
  }

  /// Check memory usage and warn if high
  void _checkMemoryUsage() {
    // In a real implementation, you would use platform channels
    // to get actual memory usage from the OS
    if (kDebugMode) {
      debugPrint('💾 Memory check performed');
    }
  }

  /// Check performance metrics
  void _checkPerformanceMetrics() {
    if (kDebugMode) {
      debugPrint('📊 Performance check performed');
    }
  }

  /// Log an error for tracking
  void logError(String error, [StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final errorInfo = '$timestamp: $error';

    _recentErrors.add(errorInfo);
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('🚨 Error logged: $errorInfo');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    // Check if we have too many recent errors
    if (_recentErrors.length >= _maxRecentErrors) {
      _handleErrorThresholdReached();
    }
  }

  /// Handle when error threshold is reached
  void _handleErrorThresholdReached() {
    debugPrint('⚠️ High error rate detected. Consider app restart.');
    _recentErrors.clear(); // Reset counter
  }

  /// Get recent errors
  List<String> getRecentErrors() => List.unmodifiable(_recentErrors);

  /// Clear recent errors
  void clearRecentErrors() {
    _recentErrors.clear();
  }

  /// Check if app is in a stable state
  bool get isAppStable => _recentErrors.length < 5;

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    return {
      'recentErrors': _recentErrors.length,
      'isStable': isAppStable,
      'memoryWarnings': _memoryWarningCount,
      'performanceWarnings': _performanceWarningCount,
    };
  }

  /// Dispose resources
  void dispose() {
    _memoryCheckTimer?.cancel();
    _performanceCheckTimer?.cancel();
    _recentErrors.clear();
  }
}

/// Enhanced error boundary for better crash prevention
class EnhancedErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(String error)? errorBuilder;
  final VoidCallback? onError;

  const EnhancedErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<EnhancedErrorBoundary> createState() => _EnhancedErrorBoundaryState();
}

class _EnhancedErrorBoundaryState extends State<EnhancedErrorBoundary> {
  String? _error;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack);
    };
  }

  void _handleError(dynamic error, StackTrace? stackTrace) {
    AppPerformanceManager().logError(error.toString(), stackTrace);

    if (mounted) {
      setState(() {
        _error = error.toString();
      });
    }
    widget.onError?.call();
  }

  @override
  Widget build(BuildContext context) {

    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _buildDefaultErrorWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'Unknown error',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Performance-optimized widget wrapper
class PerformanceOptimizedWidget extends StatefulWidget {
  final Widget child;
  final String? debugName;
  final bool enableRepaintBoundary;
  final bool enableAutomaticKeepAlive;

  const PerformanceOptimizedWidget({
    super.key,
    required this.child,
    this.debugName,
    this.enableRepaintBoundary = true,
    this.enableAutomaticKeepAlive = false,
  });

  @override
  State<PerformanceOptimizedWidget> createState() =>
      _PerformanceOptimizedWidgetState();
}

class _PerformanceOptimizedWidgetState extends State<PerformanceOptimizedWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.enableAutomaticKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget child = widget.child;

    if (widget.enableRepaintBoundary) {
      child = RepaintBoundary(child: child);
    }

    return child;
  }
}
