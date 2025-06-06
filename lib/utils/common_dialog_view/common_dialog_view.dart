import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class CommonDialogView extends StatefulWidget {
  final String? message;
  final String? heading;
  final void Function()? onContinue;
  final void Function()? afterDismiss;
  final Widget? child;
  final GestureTapCallback? onClickYesButton;
  final bool? showYesNoButtonButtons;
  final String? yesButtonText;
  final String? noButtonText;
  const CommonDialogView({super.key, this.child, this.onClickYesButton, this.showYesNoButtonButtons = false, this.yesButtonText, this.noButtonText, this.message, this.heading, this.onContinue, this.afterDismiss,});

  @override
  State<CommonDialogView> createState() => _CommonDialogViewState();
}

class _CommonDialogViewState extends State<CommonDialogView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icons.close).align(Alignment.topRight),
        10.height,

        if(widget.child != null)...[
          widget.child!,
          20.height,
        ],

        if(widget.message != null)...[
          Text(widget.message!, textAlign: TextAlign.center, style: AppTextStyle.greenColor20w700),
          20.height,
        ],


        if(widget.heading != null)...[
          Text(widget.heading!, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          20.height,
        ],


        if(widget.onContinue != null)...[
          AppButton(
            onPressed:widget.onContinue ?? (){},
            title: context.appText.continueText,
          ),
          20.height,
        ],
        

        // Buttons
        if(widget.showYesNoButtonButtons!)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // No Button
            AppButton(
              buttonHeight: 40,
              style: AppButtonStyle.outline,
              title: widget.noButtonText ?? context.appText.no,
              onPressed: () {
                Navigator.pop(context);
              },
            ).expand(),
            16.width,

            // Yes Button
            AppButton(
              buttonHeight: 40,
              onPressed: widget.onClickYesButton ?? (){},
              title: widget.yesButtonText ?? context.appText.yes,
            ).expand(),

          ],
        ),
      ],
    );
  }
}
