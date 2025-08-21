import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global error boundary widget that catches and handles errors gracefully
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final VoidCallback? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    // Set up global error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error for debugging
      debugPrint('🚨 Error caught by ErrorBoundary: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');

      // Call error callback if provided
      onError?.call();
    };

    return child;
  }
}

/// Safe navigation helper to prevent navigation errors
class SafeNavigation {
  static void push(BuildContext context, Route route) {
    try {
      if (context.mounted) {
        Navigator.push(context, route);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      _showNavigationError(context, e.toString());
    }
  }

  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    try {
      if (context.mounted) {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      _showNavigationError(context, e.toString());
    }
  }

  static void pop(BuildContext context, [Object? result]) {
    try {
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      _showNavigationError(context, e.toString());
    }
  }

  static void _showNavigationError(BuildContext context, String error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

/// Safe async operation handler
class SafeAsyncHandler {
  static Future<T?> safeAsyncCall<T>(
    Future<T> Function() operation, {
    T? defaultValue,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation().timeout(timeout);
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint(
          '✅ Async operation ${operationName ?? 'completed'} in ${stopwatch.elapsedMilliseconds}ms',
        );
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
        '❌ Async operation ${operationName ?? 'failed'} after ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      return defaultValue;
    }
  }

  static Future<void> safeAsyncVoidCall(
    Future<void> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    await safeAsyncCall(
      operation,
      timeout: timeout,
      operationName: operationName,
    );
  }
}
