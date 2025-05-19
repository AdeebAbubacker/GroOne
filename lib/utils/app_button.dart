import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final bool? isLoading;

  const AppButton({super.key, this.onPressed, this.isLoading = false, required this.title, this.textStyle,  this.style,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading == true ? (){} : (){
        commonHapticFeedback();
        onPressed?.call();
      },
      style: isLoading == true ? AppButtonStyle.disableButton :  (style ?? AppButtonStyle.primary),
      child: isLoading == true
          ? const CupertinoActivityIndicator()
          : Text(title.capitalize,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textStyle
            ?? (style == AppButtonStyle.outline ? AppTextStyle.buttonPrimaryColorTextColor : AppTextStyle.buttonWhiteTextColor),
      ),
    );
  }
}
