import 'dart:async';

import 'package:flutter/material.dart';

/// Enhanced dispose pattern to prevent memory leaks
mixin EnhancedDisposeMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  final List<ChangeNotifier> _notifiers = [];
  final List<OverlayEntry> _overlays = [];

  /// Add a subscription that will be automatically cancelled on dispose
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Add a timer that will be automatically cancelled on dispose
  void addTimer(Timer timer) {
    _timers.add(timer);
  }

  /// Add a notifier that will be automatically disposed on dispose
  void addNotifier(ChangeNotifier notifier) {
    _notifiers.add(notifier);
  }

  /// Add an overlay that will be automatically removed on dispose
  void addOverlay(OverlayEntry overlay) {
    _overlays.add(overlay);
  }

  /// Safe setState that checks if widget is still mounted
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  /// Safe post frame callback that checks if widget is still mounted
  void safePostFrameCallback(VoidCallback callback) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          callback();
        }
      });
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Cancel all timers
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Dispose all notifiers
    for (final notifier in _notifiers) {
      notifier.dispose();
    }
    _notifiers.clear();

    // Remove all overlays
    for (final overlay in _overlays) {
      overlay.remove();
    }
    _overlays.clear();

    super.dispose();
  }
}

/// Safe overlay manager to prevent memory leaks
class SafeOverlayManager {
  static OverlayEntry? _currentOverlay;

  static void showOverlay(BuildContext context, OverlayEntry overlay) {
    _currentOverlay?.remove();
    _currentOverlay = overlay;
    Overlay.of(context).insert(overlay);
  }

  static void hideOverlay() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  static void showCustomDialog(BuildContext context, Widget dialog) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => dialog,
    );
  }
}

/// Safe timer manager
class SafeTimerManager {
  static Timer? _debounceTimer;
  static Timer? _throttleTimer;

  static void debounce(Duration delay, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  static void throttle(Duration delay, VoidCallback callback) {
    if (_throttleTimer?.isActive ?? false) return;
    _throttleTimer = Timer(delay, () {
      callback();
      _throttleTimer = null;
    });
  }

  static void cancelAll() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _debounceTimer = null;
    _throttleTimer = null;
  }
}
