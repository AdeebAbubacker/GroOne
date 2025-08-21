import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final bool? isLoading;
  final double? buttonHeight;
  final Widget? richTextWidget;


  const AppButton({super.key,
  final Widget? icon;

  const AppButton({
    super.key,
    this.title,
    this.textStyle,
    this.style,
    this.buttonHeight,
    this.richTextWidget,
    this.icon,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading == true
            ? () {}
            : () {
          commonHapticFeedback();
          if(onPressed!=null){
            onPressed?.call();
          }

        },
        style: isLoading == true
            ? AppButtonStyle.disableButton
            : (style ?? AppButtonStyle.primary),
        child: isLoading == true
            ? const CupertinoActivityIndicator(color: Colors.white)
            : richTextWidget ??
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ??
                        (style == AppButtonStyle.outline
                            ? AppTextStyle.buttonPrimaryColorTextColor
                            : AppTextStyle.buttonWhiteTextColor),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
