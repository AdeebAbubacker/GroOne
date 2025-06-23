import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class CommonDialogView extends StatefulWidget {
  final String? message;
  final String? heading;
  final Color? headingColor;
  final bool? showYesNoButtonButtons;
  final bool? hideCloseButton;
  final bool? yesButtonLoading;
  final String? yesButtonText;
  final String? noButtonText;
  final String? onSingleButtonText;
  final Widget? child;
  final void Function()? onTapSingleButton;
  final void Function()? afterDismiss;
  final GestureTapCallback? onClickYesButton;
  const CommonDialogView({
    super.key,
    this.child,
    this.onClickYesButton,
    this.showYesNoButtonButtons = false,
    this.yesButtonText,
    this.noButtonText,
    this.message,
    this.heading,
    this.onTapSingleButton,
    this.afterDismiss,
    this.onSingleButtonText,
    this.headingColor,
    this.hideCloseButton = false,
    this.yesButtonLoading = false,
  });

  @override
  State<CommonDialogView> createState() => _CommonDialogViewState();
}

class _CommonDialogViewState extends State<CommonDialogView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        if(!widget.hideCloseButton!)...[
          AppIconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icons.close).align(Alignment.topRight),
          10.height,
        ] else...[
          10.height,
        ],


        if(widget.child != null)...[
          widget.child!,
          20.height,
        ],

        if(widget.heading != null)...[
          Text(widget.heading!.capitalize, textAlign: TextAlign.center, style: AppTextStyle.h3.copyWith(color: widget.headingColor ?? Colors.black, fontSize: 25)),
          20.height,
        ],

        if(widget.message != null)...[
          Text(widget.message!, textAlign: TextAlign.center, style: AppTextStyle.bodyGreyColor),
          20.height,
        ],



        if(widget.onTapSingleButton != null)...[
          AppButton(
            buttonHeight: commonButtonHeight2,
            onPressed:widget.onTapSingleButton ?? (){},
            title: widget.onSingleButtonText ?? context.appText.continueText,
          ),
        ],
        

        // Buttons
        if(widget.showYesNoButtonButtons!)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // No Button
            AppButton(
              buttonHeight: commonButtonHeight2,
              style: AppButtonStyle.outline,
              title: widget.noButtonText ?? context.appText.no,
              onPressed: () {
                Navigator.pop(context);
              },
            ).expand(),
            16.width,

            // Yes Button
            AppButton(
              buttonHeight: commonButtonHeight2,
              isLoading: widget.yesButtonLoading,
              onPressed: widget.onClickYesButton ?? (){},
              title: widget.yesButtonText ?? context.appText.yes,
            ).expand(),

          ],
        ),
      ],
    );
  }
}
