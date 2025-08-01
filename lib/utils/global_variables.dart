import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'app_global_variables.dart';

String buildNumber = "buildNumber";

BuildContext get appContext {
  final ctx = navigatorKey.currentContext;
  if (ctx == null) {
    throw Exception("appContext is not available yet");
  }
  return ctx;
}

final isIOS = Platform.isIOS;
final isAndroid = Platform.isAndroid;
