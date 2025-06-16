import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class AppDialog extends StatefulWidget {
  final Widget child;
  final bool dismissible;
  const AppDialog({super.key, required this.child, this.dismissible = false});

  static void show(BuildContext context, {required Widget child, bool dismissible = false}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AppDialog(
        dismissible: dismissible,
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
    return PopScope(
      canPop: false,
      onPopInvoked : (didPop){
        // logic
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonBottomSheetRadius)),
        contentPadding: EdgeInsets.all(20),
        content: widget.child,
      ),
    );
  }
}
