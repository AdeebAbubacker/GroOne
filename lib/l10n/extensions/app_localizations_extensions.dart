import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/%20app_localizations.dart';


extension AppLocalizationsExtention on BuildContext {
  AppLocalizations get appText => AppLocalizations.of(this)!;

}
