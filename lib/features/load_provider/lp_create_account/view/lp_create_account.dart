import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

import '../../../../utils/app_application_bar.dart';

class LpCreateAccount extends StatelessWidget {
  const LpCreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CommonAppBar(title: context.appText.createAccount),
    );
  }
}
