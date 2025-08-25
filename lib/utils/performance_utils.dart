import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance utilities to help optimize app performance
class PerformanceUtils {
  /// Debounce function to limit how often a function can be called
  static Timer? debounce(
    Duration delay,
    VoidCallback callback, {
    Timer? existingTimer,
  }) {
    existingTimer?.cancel();
    return Timer(delay, callback);
  }

  /// Throttle function to limit function execution rate
  static Timer? throttle(
    Duration delay,
    VoidCallback callback, {
    Timer? existingTimer,
    bool Function()? shouldExecute,
  }) {
    if (shouldExecute?.call() ?? true) {
      existingTimer?.cancel();
      return Timer(delay, callback);
    }
    return existingTimer;
  }

  /// Run heavy computation in background isolate
  static Future<T> computeInBackground<T>(
    Future<T> Function() computation,
  ) async {
    if (kDebugMode) {
      // In debug mode, run synchronously for easier debugging
      return await computation();
    }

    try {
      return await compute(_isolateComputation, computation);
    } catch (e) {
      // Fallback to main thread if isolate fails
      return await computation();
    }
  }

  /// Helper function for isolate computation
  static Future<T> _isolateComputation<T>(
    Future<T> Function() computation,
  ) async {
    return await computation();
  }

  /// Batch process items to avoid blocking main thread
  static Future<List<T>> batchProcess<T, R>(
    List<T> items,
    Future<R> Function(T) processor, {
    int batchSize = 10,
    Duration delayBetweenBatches = const Duration(milliseconds: 1),
  }) async {
    final results = <R>[];

    for (int i = 0; i < items.length; i += batchSize) {
      final end = (i + batchSize < items.length) ? i + batchSize : items.length;
      final batch = items.sublist(i, end);

      // Process batch
      final batchResults = await Future.wait(batch.map(processor));
      results.addAll(batchResults);

      // Yield control back to main thread between batches
      if (i + batchSize < items.length) {
        await Future.delayed(delayBetweenBatches);
      }
    }

    return results.cast<T>();
  }

  /// Safe post frame callback that checks if widget is still mounted
  static void safePostFrameCallback(
    BuildContext context,
    VoidCallback callback,
  ) {
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          callback();
        }
      });
    }
  }

  /// Safe microtask that checks if widget is still mounted
  static void safeMicrotask(BuildContext context, VoidCallback callback) {
    if (context.mounted) {
      Future.microtask(() {
        if (context.mounted) {
          callback();
        }
      });
    }
  }

  /// Optimized list builder that only rebuilds when necessary
  static Widget optimizedListBuilder<T>({
    required List<T> items,
    required Widget Function(BuildContext, T, int) itemBuilder,
    Widget? separator,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.separated(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: items.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      separatorBuilder:
          (context, index) => separator ?? const SizedBox.shrink(),
      itemBuilder:
          (context, index) => itemBuilder(context, items[index], index),
    );
  }

  /// Memory-efficient image cache manager
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Optimized text style cache
  static final Map<String, TextStyle> _textStyleCache = {};

  static TextStyle getCachedTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    String? fontFamily,
  }) {
    final key = '${fontSize}_${fontWeight.index}_${color?.value}_$fontFamily';

    if (_textStyleCache.containsKey(key)) {
      return _textStyleCache[key]!;
    }

    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
    );

    _textStyleCache[key] = style;
    return style;
  }

  /// Clear text style cache
  static void clearTextStyleCache() {
    _textStyleCache.clear();
  }

  /// Performance monitoring helper
  static void measurePerformance(String operationName, VoidCallback operation) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      operation();
      stopwatch.stop();
      debugPrint('⏱️ $operationName took ${stopwatch.elapsedMilliseconds}ms');
    } else {
      operation();
    }
  }

  /// Async performance monitoring helper
  static Future<void> measureAsyncPerformance(
    String operationName,
    Future<void> Function() operation,
  ) async {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      await operation();
      stopwatch.stop();
      debugPrint('⏱️ $operationName took ${stopwatch.elapsedMilliseconds}ms');
    } else {
      await operation();
    }
  }
}

/// Optimized future builder that caches results
class CachedFutureBuilder<T> extends StatefulWidget {
  final Future<T> Function() futureBuilder;
  final Widget Function(BuildContext, T) builder;
  final Widget? loading;
  final Widget? error;
  final Duration cacheDuration;

  const CachedFutureBuilder({
    super.key,
    required this.futureBuilder,
    required this.builder,
    this.loading,
    this.error,
    this.cacheDuration = const Duration(minutes: 5),
  });

  @override
  State<CachedFutureBuilder<T>> createState() => _CachedFutureBuilderState<T>();
}

class _CachedFutureBuilderState<T> extends State<CachedFutureBuilder<T>> {
  T? _cachedData;
  DateTime? _cacheTime;
  bool _isLoading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Check if we have valid cached data
    if (_cachedData != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < widget.cacheDuration) {
        return; // Use cached data
      }
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await widget.futureBuilder();
      if (mounted) {
        setState(() {
          _cachedData = data;
          _cacheTime = DateTime.now();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loading ?? const CircularProgressIndicator();
    }

    if (_error != null) {
      return widget.error ?? Text('Error: ${_error.toString()}');
    }

    if (_cachedData != null) {
      return widget.builder(context, _cachedData!);
    }

    return const SizedBox.shrink();
  }
}

/// Optimized list view that only rebuilds visible items
class OptimizedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget? separator;
  final ScrollController? controller;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separator,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  State<OptimizedListView<T>> createState() => _OptimizedListViewState<T>();
}

class _OptimizedListViewState<T> extends State<OptimizedListView<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.controller,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: widget.items.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      separatorBuilder:
          (context, index) => widget.separator ?? const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return RepaintBoundary(child: widget.itemBuilder(context, item, index));
      },
    );
  }
}

/// Optimized grid view for better performance
class OptimizedGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollController? controller;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const OptimizedGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: items.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final item = items[index];
        return RepaintBoundary(child: itemBuilder(context, item, index));
      },
    );
  }
}

/// Memory-efficient image widget with caching
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error);
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}
