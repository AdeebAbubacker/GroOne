import 'package:flutter/material.dart';
import '../app_localizations.dart';
import 'package:gro_one_app/l10n/app_localizations.dart';

extension AppLocalizationsExtention on BuildContext {
  AppLocalizations get appText => AppLocalizations.of(this)!;
}
