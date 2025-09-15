import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'constant_variables.dart';

class AppDialog extends StatefulWidget {
  final Widget child;
  final bool dismissible;
  final bool blurBackground;

  const AppDialog({
    super.key,
    required this.child,
    this.dismissible = false,
    this.blurBackground = false,
  });

  static void show(
      BuildContext context, {
        required Widget child,
        bool dismissible = false,
        bool blurBackground = false,
      }) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: AppColors.black.withValues(alpha: 0.2),
      builder: (context) => AppDialog(
        dismissible: dismissible,
        blurBackground: blurBackground,
        child: child,
      ),
    );
  }

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    Widget dialog = AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(commonBottomSheetRadius),
      ),
      contentPadding: EdgeInsets.all(commonSafeAreaPadding),
      content: widget.child,
    );

    return PopScope(
      canPop: widget.dismissible,
      child: widget.blurBackground
          ? BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: dialog,
      )
          : dialog,
    );
  }
}
