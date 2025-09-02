import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final bool? isLoading;
  final double? buttonHeight;
  final Widget? richTextWidget;
  final Widget? icon; // ✅ added this

  final bool? enable;

  const AppButton({
    super.key,
    this.title,
    this.textStyle,
    this.style,
    this.buttonHeight,
    this.richTextWidget,
    this.icon, // ✅ added this
    this.isLoading = false,
    this.enable = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed:   isLoading == true || enable==false
            ? null // better UX: disabled state
            : () {
          commonHapticFeedback();
          onPressed?.call();
        },
        style:

        isLoading == true || !(enable??true)
            ? AppButtonStyle.disableButton.copyWith(
        )
            : (style ?? AppButtonStyle.primary),
        child: isLoading == true && enable==true
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
                            ? AppTextStyle.buttonPrimaryColorTextColor.copyWith()
                            : AppTextStyle.buttonWhiteTextColor.copyWith(
                          color: (enable??false) ? Colors.white:AppColors.disableColor
                        )),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
