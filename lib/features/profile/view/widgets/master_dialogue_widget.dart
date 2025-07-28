
import 'package:flutter/material.dart';

class MasterDialogueWidget extends StatelessWidget {
  final Widget child;
  final bool dismissible;

  const MasterDialogueWidget({
    super.key,
    required this.child,
    this.dismissible = false,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool dismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => MasterDialogueWidget(
        dismissible: dismissible,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => dismissible,
      child: Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 24,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minWidth: 280,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
