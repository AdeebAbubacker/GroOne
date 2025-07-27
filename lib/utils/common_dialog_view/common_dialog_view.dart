
import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
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
  final TextStyle? headingTextStyle;
  final TextStyle? messageTextStyle;
  final ButtonStyle? yesButtonTextStyle;
  final Widget? child;
  final void Function()? onTapSingleButton;
  final void Function()? afterDismiss;
  final GestureTapCallback? onClickYesButton;
  final GestureTapCallback? onClickNoButton;
  final CrossAxisAlignment? crossAxisAlignment;
  const CommonDialogView({
    super.key,
    this.child,
    this.onClickYesButton,
    this.onClickNoButton,
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
    this.crossAxisAlignment,
    this.headingTextStyle,
    this.messageTextStyle,
    this.yesButtonTextStyle,
  });

  @override
  State<CommonDialogView> createState() => _CommonDialogViewState();
}

class _CommonDialogViewState extends State<CommonDialogView> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }



  void disposeFunction() => frameCallback(() async {
    if(widget.afterDismiss != null){
      widget.afterDismiss!.call();
    }
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
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
          10.height,
        ],

        if(widget.message != null)...[
          Text(widget.message!, textAlign: TextAlign.center, style:  widget.messageTextStyle ??  AppTextStyle.bodyGreyColor),
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
              onPressed:  widget.onClickNoButton ?? () {
                Navigator.pop(context);
              },
            ).expand(),
            16.width,

            // Yes Button
            AppButton(
              buttonHeight: commonButtonHeight2,
              style: widget.yesButtonTextStyle ?? AppButtonStyle.primary,
              isLoading: widget.yesButtonLoading,
              onPressed: widget.onClickYesButton ?? (){},
              title: widget.yesButtonText ?? context.appText.yes,
            ).expand(),

          ],
        ),
      ],
    ).paddingOnly(bottom: 5, left: 5, right: 5);
  }
}


class MasterCommonDialogView extends StatefulWidget {
  final String? message;
  final String? heading;
  final Color? headingColor;
  final bool? showYesNoButtonButtons;
  final bool? hideCloseButton;
  final bool? yesButtonLoading;
  final String? yesButtonText;
  final String? noButtonText;
  final String? onSingleButtonText;
  final TextStyle? headingTextStyle;
  final TextStyle? messageTextStyle;
  final ButtonStyle? yesButtonTextStyle;
  final Widget? child;
  final void Function()? onTapSingleButton;
  final void Function()? afterDismiss;
  final GestureTapCallback? onClickYesButton;
  final GestureTapCallback? onClickNoButton;
  final CrossAxisAlignment? crossAxisAlignment;

  const MasterCommonDialogView({
    super.key,
    this.child,
    this.onClickYesButton,
    this.onClickNoButton,
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
    this.crossAxisAlignment,
    this.headingTextStyle,
    this.messageTextStyle,
    this.yesButtonTextStyle,
  });

  @override
  State<MasterCommonDialogView> createState() => _MasterCommonDialogViewState();
}

class _MasterCommonDialogViewState extends State<MasterCommonDialogView> {
  @override
  void dispose() {
    frameCallback(() {
      widget.afterDismiss?.call();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (!widget.hideCloseButton!)
            AppIconButton(onPressed: () => Navigator.of(context).pop(), icon: Icons.close)
                .align(Alignment.topRight)
          else
            10.height,

          /// Scrollable content
          if (widget.child != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 10),
                child: widget.child!,
              ),
            ),

          if (widget.heading != null) ...[
            Text(
              widget.heading!.capitalize,
              textAlign: TextAlign.center,
              style: widget.headingTextStyle ??
                  AppTextStyle.h3.copyWith(
                    color: widget.headingColor ?? Colors.black,
                    fontSize: 25,
                  ),
            ),
            10.height,
          ],

          if (widget.message != null) ...[
            Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: widget.messageTextStyle ?? AppTextStyle.bodyGreyColor,
            ),
            20.height,
          ],

          if (widget.onTapSingleButton != null)
            AppButton(
              buttonHeight: commonButtonHeight2,
              onPressed: widget.onTapSingleButton ?? () {},
              title: widget.onSingleButtonText ?? context.appText.continueText,
            ),

          if (widget.showYesNoButtonButtons!) ...[
            20.height,
            Row(
              children: [
                AppButton(
                  buttonHeight: commonButtonHeight2,
                  style: AppButtonStyle.outline,
                  title: widget.noButtonText ?? context.appText.no,
                  onPressed: widget.onClickNoButton ?? () {
                    Navigator.pop(context);
                  },
                ).expand(),
                16.width,
                AppButton(
                  buttonHeight: commonButtonHeight2,
                  style: widget.yesButtonTextStyle ?? AppButtonStyle.primary,
                  isLoading: widget.yesButtonLoading,
                  onPressed: widget.onClickYesButton ?? () {},
                  title: widget.yesButtonText ?? context.appText.yes,
                ).expand(),
              ],
            ),
          ],
          10.height,
        ],
      ).paddingOnly(bottom: 5, left: 5, right: 5),
    );
  }
}
