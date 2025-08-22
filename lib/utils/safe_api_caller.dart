import 'dart:async';

import 'package:flutter/foundation.dart';

/// Safe API caller with retry mechanism and error handling
class SafeApiCaller {
  /// Call API with retry mechanism
  static Future<T?> callWithRetry<T>(
    Future<T> Function() apiCall, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;
    final stopwatch = Stopwatch()..start();

    while (attempts < maxRetries) {
      try {
        final result = await apiCall();
        stopwatch.stop();

        if (kDebugMode) {
          debugPrint(
            '✅ API call ${operationName ?? 'completed'} in ${stopwatch.elapsedMilliseconds}ms',
          );
        }

        return result;
      } catch (e) {
        attempts++;
        stopwatch.stop();

        if (kDebugMode) {
          debugPrint(
            '❌ API call ${operationName ?? 'failed'} attempt $attempts/$maxRetries: $e',
          );
        }

        if (attempts >= maxRetries) {
          debugPrint(
            '🚨 API call ${operationName ?? 'failed'} after $maxRetries attempts',
          );
          rethrow;
        }

        // Exponential backoff
        final backoffDelay = delay * attempts;
        await Future.delayed(backoffDelay);
      }
    }

    throw Exception('Max retries exceeded for ${operationName ?? 'API call'}');
  }

  /// Call API with timeout
  static Future<T?> callWithTimeout<T>(
    Future<T> Function() apiCall, {
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    try {
      final result = await apiCall().timeout(timeout);

      if (kDebugMode) {
        debugPrint('✅ API call ${operationName ?? 'completed'} within timeout');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⏰ API call ${operationName ?? 'timed out'}: $e');
      }
      rethrow;
    }
  }

  /// Call API with both retry and timeout
  static Future<T?> callWithRetryAndTimeout<T>(
    Future<T> Function() apiCall, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    return await callWithRetry<T?>(
      () => callWithTimeout<T>(
        apiCall,
        timeout: timeout,
        operationName: operationName,
      ),
      maxRetries: maxRetries,
      delay: delay,
      operationName: operationName,
    );
  }

  /// Safe batch API calls
  static Future<List<T>> callBatch<T>(
    List<Future<T> Function()> apiCalls, {
    int maxConcurrent = 5,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    final results = <T>[];
    final errors = <String>[];

    // Process in batches to avoid overwhelming the server
    for (int i = 0; i < apiCalls.length; i += maxConcurrent) {
      final end =
          (i + maxConcurrent < apiCalls.length)
              ? i + maxConcurrent
              : apiCalls.length;
      final batch = apiCalls.sublist(i, end);

      try {
        final batchResults = await Future.wait(
          batch.map((call) => callWithTimeout(call, timeout: timeout)),
        );
        // Filter out null results and add non-null ones
        for (final result in batchResults) {
          if (result != null) {
            results.add(result);
          }
        }
      } catch (e) {
        errors.add('Batch $i failed: $e');
        if (kDebugMode) {
          debugPrint('❌ Batch $i failed: $e');
        }
      }

      // Small delay between batches
      if (i + maxConcurrent < apiCalls.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (kDebugMode) {
      debugPrint(
        '📊 Batch operation ${operationName ?? 'completed'}: ${results.length}/${apiCalls.length} successful',
      );
      if (errors.isNotEmpty) {
        debugPrint('⚠️ Errors: ${errors.join(', ')}');
      }
    }

    return results;
  }
}

/// API response wrapper for better error handling
class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? error;
  final int? statusCode;
  final Duration responseTime;

  ApiResponse({
    this.data,
    required this.success,
    this.error,
    this.statusCode,
    required this.responseTime,
  });

  factory ApiResponse.success(
    T data, {
    int? statusCode,
    Duration? responseTime,
  }) {
    return ApiResponse(
      data: data,
      success: true,
      statusCode: statusCode,
      responseTime: responseTime ?? Duration.zero,
    );
  }

  factory ApiResponse.error(
    String error, {
    int? statusCode,
    Duration? responseTime,
  }) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
      responseTime: responseTime ?? Duration.zero,
    );
  }

  factory ApiResponse.fromException(
    dynamic exception, {
    Duration? responseTime,
  }) {
    return ApiResponse(
      success: false,
      error: exception.toString(),
      responseTime: responseTime ?? Duration.zero,
    );
  }
}

/// Safe API call result handler
class SafeApiResultHandler {
  /// Handle API response safely
  static T? handleResponse<T>(
    ApiResponse<T> response, {
    T? defaultValue,
    void Function(String error)? onError,
    void Function(T data)? onSuccess,
  }) {
    if (response.success && response.data != null) {
      onSuccess?.call(response.data!);
      return response.data;
    } else {
      final error = response.error ?? 'Unknown error occurred';
      onError?.call(error);

      if (kDebugMode) {
        debugPrint('❌ API error: $error (Status: ${response.statusCode})');
      }

      return defaultValue;
    }
  }

  /// Handle API call with automatic response wrapping
  static Future<ApiResponse<T>> wrapApiCall<T>(
    Future<T> Function() apiCall, {
    String? operationName,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await apiCall().timeout(timeout);
      stopwatch.stop();

      return ApiResponse.success(result, responseTime: stopwatch.elapsed);
    } catch (e) {
      stopwatch.stop();

      return ApiResponse.error(e.toString(), responseTime: stopwatch.elapsed);
    }
  }
}
