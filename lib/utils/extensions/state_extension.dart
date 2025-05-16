import 'package:flutter/widgets.dart';

extension PostFrameCallback on State {

  void addPostFrameCallback(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

}