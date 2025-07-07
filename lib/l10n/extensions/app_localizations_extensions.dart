import 'package:flutter/material.dart';

import '../app_localizations.dart';

extension AppLocalizationsExtention on BuildContext {
  AppLocalizations get appText => AppLocalizations.of(this)!;
}