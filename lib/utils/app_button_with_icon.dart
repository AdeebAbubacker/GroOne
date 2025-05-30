import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'app_text_style.dart';
import 'common_functions.dart';
import 'constant_variables.dart';

class AppButtonWithIcon extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final IconData iconData;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final bool? isLoading;
  final  bool disableButton;
  const AppButtonWithIcon({
    super.key, this.onPressed, required this.title, this.textStyle, this.style, this.isLoading, this.disableButton=false, required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: !disableButton?isLoading == true ? (){} : (){
        commonHapticFeedback();
        onPressed?.call();
      }:null,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor,    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),),
      label: isLoading == true
          ? const CupertinoActivityIndicator()
          : Text(title.capitalize,
        style: AppTextStyle.whiteColor14w400,
      ),
      icon: Icon(iconData,color: AppColors.white,),);
  }
}