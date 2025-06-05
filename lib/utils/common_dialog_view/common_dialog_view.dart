import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class CommonDialogView extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onClickYesButton;
  final bool? showYesNoButtonButtons;
  final String? yesButtonText;
  final String? noButtonText;
  const CommonDialogView({super.key,required this.child, this.onClickYesButton, this.showYesNoButtonButtons = false, this.yesButtonText, this.noButtonText,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        child,

        40.height,

        // Buttons
        if(showYesNoButtonButtons!)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // No Button
            AppButton(
              buttonHeight: 40,
              style: AppButtonStyle.outline,
              title: noButtonText ?? context.appText.no,
              onPressed: () {
                Navigator.pop(context);
              },
            ).expand(),
            16.width,

            // Yes Button
            AppButton(
              buttonHeight: 40,
              onPressed: onClickYesButton ?? (){},
              title: yesButtonText ?? context.appText.yes,
            ).expand(),

          ],
        ),
      ],
    );
  }
}
