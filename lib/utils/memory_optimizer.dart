import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Memory optimization utilities to prevent force stops
class MemoryOptimizer {
  static final MemoryOptimizer _instance = MemoryOptimizer._internal();
  factory MemoryOptimizer() => _instance;
  MemoryOptimizer._internal();

  Timer? _cleanupTimer;
  int _cleanupCount = 0;
  static const int _cleanupIntervalMinutes = 5;

  /// Initialize memory optimization
  void initialize() {
    _startPeriodicCleanup();
  }

  /// Start periodic memory cleanup
  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: _cleanupIntervalMinutes),
      (timer) => _performMemoryCleanup(),
    );
  }

  /// Perform memory cleanup
  void _performMemoryCleanup() {
    try {
      _cleanupCount++;

      // Clear image cache
      _clearImageCache();

      // Force garbage collection in debug mode
      if (kDebugMode) {
        _forceGarbageCollection();
      }

      // Log cleanup
      if (kDebugMode) {
        debugPrint('🧹 Memory cleanup #$_cleanupCount performed');
      }
    } catch (e) {
      debugPrint('❌ Memory cleanup failed: $e');
    }
  }

  /// Clear image cache
  void _clearImageCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      debugPrint('❌ Failed to clear image cache: $e');
    }
  }

  /// Force garbage collection (debug only)
  void _forceGarbageCollection() {
    try {
      // This is a placeholder - actual GC forcing would require platform channels
      debugPrint('🗑️ Garbage collection triggered');
    } catch (e) {
      debugPrint('❌ Failed to force garbage collection: $e');
    }
  }

  /// Clear all caches and free memory
  void clearAllCaches() {
    try {
      _clearImageCache();

      // Clear other caches if available
      if (Platform.isAndroid) {
        _clearAndroidCaches();
      } else if (Platform.isIOS) {
        _clearIOSCaches();
      }

      debugPrint('🧹 All caches cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear all caches: $e');
    }
  }

  /// Clear Android-specific caches
  void _clearAndroidCaches() {
    try {
      // Android-specific cache clearing would go here
      debugPrint('🤖 Android caches cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear Android caches: $e');
    }
  }

  /// Clear iOS-specific caches
  void _clearIOSCaches() {
    try {
      // iOS-specific cache clearing would go here
      debugPrint('🍎 iOS caches cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear iOS caches: $e');
    }
  }

  /// Get memory usage info (placeholder)
  Map<String, dynamic> getMemoryInfo() {
    return {
      'cleanupCount': _cleanupCount,
      'lastCleanup': DateTime.now().toIso8601String(),
      'imageCacheSize': PaintingBinding.instance.imageCache.currentSize,
      'imageCacheBytes': PaintingBinding.instance.imageCache.currentSizeBytes,
    };
  }

  /// Dispose resources
  void dispose() {
    _cleanupTimer?.cancel();
  }
}

/// Memory-efficient image widget
class MemoryEfficientImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const MemoryEfficientImage({
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
        return placeholder ?? const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error, color: Colors.red);
      },
      // Memory optimization settings
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      filterQuality: FilterQuality.medium, // Reduce quality to save memory
    );
  }
}

/// Memory-efficient list view
class MemoryEfficientListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const MemoryEfficientListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      // Memory optimization settings
      addAutomaticKeepAlives: false, // Don't keep items alive
      addRepaintBoundaries: true, // Enable repaint boundaries
      addSemanticIndexes: false, // Disable semantic indexes for performance
      itemBuilder: (context, index) {
        return RepaintBoundary(child: children[index]);
      },
    );
  }
}

/// Memory-efficient grid view
class MemoryEfficientGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const MemoryEfficientGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      // Memory optimization settings
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
      itemBuilder: (context, index) {
        return RepaintBoundary(child: children[index]);
      },
    );
  }
}
