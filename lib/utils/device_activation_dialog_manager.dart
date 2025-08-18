import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';

/// Singleton class to manage device activation dialogs
/// Prevents multiple dialogs from opening simultaneously
class DeviceActivationDialogManager {
  static final DeviceActivationDialogManager _instance =
      DeviceActivationDialogManager._internal();
  factory DeviceActivationDialogManager() => _instance;
  DeviceActivationDialogManager._internal() {
    _setupAppLifecycleListener();
  }

  bool _isDialogShowing = false;
  BuildContext? _currentContext;
  NavigatorState? _navigator;

  /// Check if a dialog is currently showing
  bool get isDialogShowing => _isDialogShowing;

  /// Check if a new dialog can be shown
  bool get canShowDialog => !_isDialogShowing;

  /// Set up app lifecycle listener to handle dialog state
  void _setupAppLifecycleListener() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.paused.toString()) {
        // App going to background - only reset if dialog is showing
        if (_isDialogShowing) {
          reset();
        }
      } else if (msg == AppLifecycleState.resumed.toString()) {
        // App coming back to foreground - don't reset, just check validity
        checkAndResetIfNeeded();
      }
      return null;
    });
  }

  /// Show device activation dialog if no other dialog is showing
  /// Returns true if dialog was shown, false if already showing
  bool showDeviceActivationDialog(BuildContext context) {
    // Prevent multiple dialogs from opening simultaneously
    if (_isDialogShowing) {
      return false;
    }

    // Check if context is still valid
    if (!context.mounted) {
      return false;
    }

    _isDialogShowing = true;
    _currentContext = context;
    _navigator = Navigator.of(context);

    // Show the dialog
    AppDialog.show(
      context,
      child: CommonDialogView(
        heading: "Device Activation In Progress",
        message:
            "Your GPS device activation is still in progress. Please try again later.",
        onSingleButtonText: "Continue",
        onTapSingleButton: () {
          _closeDialog();
          _navigateToHome(context);
        },
        child: Icon(Icons.device_hub, size: 80, color: AppColors.primaryColor),
      ),
    );

    return true;
  }

  /// Force show device activation dialog (bypasses the one-dialog-at-a-time rule)
  /// Use this only when absolutely necessary
  bool forceShowDeviceActivationDialog(BuildContext context) {
    if (!context.mounted) {
      return false;
    }

    // Force close any existing dialog
    if (_isDialogShowing) {
      forceCloseDialog();
    }

    _isDialogShowing = true;
    _currentContext = context;
    _navigator = Navigator.of(context);

    // Show the dialog
    AppDialog.show(
      context,
      child: CommonDialogView(
        heading: "Device Activation In Progress",
        message:
            "Your GPS device activation is still in progress. Please try again later.",
        onSingleButtonText: "Continue",
        onTapSingleButton: () {
          _closeDialog();
          _navigateToHome(context);
        },
        child: Icon(Icons.device_hub, size: 80, color: AppColors.primaryColor),
      ),
    );

    return true;
  }

  /// Close the current dialog and allow new dialogs to be shown
  void _closeDialog() {
    if (_isDialogShowing) {
      _isDialogShowing = false;
      // Close the dialog from the UI
      if (_navigator != null && _navigator!.mounted) {
        _navigator!.pop();
      }
      _currentContext = null;
      _navigator = null;
    }
  }

  /// Navigate to home screen
  void _navigateToHome(BuildContext context) {
    try {
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRouteName.lpBottomNavigationBar);
      }
    } catch (e) {
      debugPrint('⚠️ Navigation error: $e');
    }
  }

  /// Check if the current context is still valid
  bool isCurrentContextValid() {
    if (_currentContext == null) return false;
    return _currentContext!.mounted;
  }

  /// Check and reset dialog state if context is no longer valid
  void checkAndResetIfNeeded() {
    if (_isDialogShowing && !isCurrentContextValid()) {
      reset();
    }
  }

  /// Handle screen navigation - call this when user navigates to a new screen
  void onScreenNavigation() {
    if (_isDialogShowing) {
      reset();
    }
  }

  /// Get current dialog status for debugging
  Map<String, dynamic> getDebugInfo() {
    return {
      'isDialogShowing': _isDialogShowing,
      'canShowDialog': canShowDialog,
      'hasCurrentContext': _currentContext != null,
      'isContextValid': isCurrentContextValid(),
    };
  }

  /// Get a human-readable status string
  String getStatusString() {
    if (_isDialogShowing) {
      return 'Dialog is currently showing';
    } else {
      return 'Ready to show dialog';
    }
  }

  /// Check if the manager is in a healthy state
  bool get isHealthy {
    // If no dialog is showing, we're healthy
    if (!_isDialogShowing) return true;

    // If dialog is showing, check if context is valid
    return isCurrentContextValid();
  }

  /// Force close dialog (use in emergency cases)
  void forceCloseDialog() {
    if (_navigator != null && _navigator!.mounted) {
      _navigator!.pop();
    }
    _isDialogShowing = false;
    _currentContext = null;
    _navigator = null;
  }

  /// Manually reset dialog state - useful for debugging or emergency situations
  void reset() {
    if (_navigator != null && _navigator!.mounted) {
      _navigator!.pop();
    }
    _isDialogShowing = false;
    _currentContext = null;
    _navigator = null;
  }
}
