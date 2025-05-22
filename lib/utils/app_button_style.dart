import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/global_variables.dart';

class AppButtonStyle {
  AppButtonStyle._();

  /// Primary
  static ButtonStyle primary = ElevatedButton.styleFrom(
    enableFeedback: true,
    elevation: 3.0,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: AppColors.primaryColor,
    shadowColor: Colors.transparent,
    surfaceTintColor:AppColors.primaryColor,
    textStyle: AppTextStyle.button,
    fixedSize: Size(MediaQuery.of(appContext).size.width, commonButtonHeight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),
  );

  /// Disable
  static ButtonStyle disableButton = primary.copyWith(
    backgroundColor: WidgetStateProperty.all(AppColors.deActiveButtonColor),
    elevation: WidgetStateProperty.all(0),
  );

  /// Edit
  static ButtonStyle primaryTextButton = primary.copyWith(
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      fixedSize: WidgetStateProperty.all(const Size(80, 25)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)))
  );

  /// Secondary
  static ButtonStyle secondary = ElevatedButton.styleFrom(
      enableFeedback: true,
      splashFactory: NoSplash.splashFactory,
      surfaceTintColor: Colors.white,
      textStyle: AppTextStyle.buttonWhiteTextColor,
      elevation: 0.0,
      backgroundColor: AppColors.secondaryColor,
      fixedSize: Size(MediaQuery.of(appContext).size.width, commonButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),
  );

  static ButtonStyle outline = OutlinedButton.styleFrom(
      enableFeedback: true,
      splashFactory: NoSplash.splashFactory,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0.0,
      fixedSize: Size(MediaQuery.of(appContext).size.width, commonButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),
      side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
  );

  static ButtonStyle logout = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.white,
    side: const BorderSide(color: Colors.red, width: 1),
    fixedSize: Size(MediaQuery.of(appContext).size.width, commonButtonHeight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),

  );

  /// Icon Button
  static ButtonStyle primaryIconButtonStyle = IconButton.styleFrom(
    enableFeedback: true,
    surfaceTintColor: AppColors.lightGreyColor,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: AppColors.lightGreyIconBackgroundColor,
    fixedSize: Size(50, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    side: const BorderSide(color: AppColors.borderColor, width: 1),
  );

  static ButtonStyle circularIconButtonStyle = IconButton.styleFrom(
    enableFeedback: true,
    surfaceTintColor: AppColors.lightGreyColor,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: AppColors.lightGreyIconBackgroundColor,
    fixedSize: Size(40, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    side: const BorderSide(color: AppColors.borderColor, width: 1),
  );

  static ButtonStyle circularPrimaryColorIconButtonStyle = IconButton.styleFrom(
    enableFeedback: true,
    surfaceTintColor: AppColors.primaryColor,
    splashFactory: NoSplash.splashFactory,
    backgroundColor:  AppColors.primaryColor,
    fixedSize: Size(40, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    side: const BorderSide(color: AppColors.borderColor, width: 1),
  );

  static ButtonStyle primaryIconButtonStyleWithWhiteBackground = IconButton.styleFrom(
    enableFeedback: true,
    surfaceTintColor: AppColors.lightGreyColor,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    side: const BorderSide(color: AppColors.primaryColor, width: 1),
  );

  /// Active Icon Button
  static ButtonStyle activeIconButtonStyle = IconButton.styleFrom(
    enableFeedback: true,
    surfaceTintColor: AppColors.lightGreyColor,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: AppColors.lightPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    side: const BorderSide(color: AppColors.primaryColor, width: 1),
  );


  /// Text Button Style
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    enableFeedback: true,
    splashFactory: NoSplash.splashFactory,
    surfaceTintColor: Colors.white,
    backgroundColor: AppColors.secondaryColor,
    textStyle: AppTextStyle.h6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  );

  static ButtonStyle textButtonStyle2 = TextButton.styleFrom(
    enableFeedback: true,
    splashFactory: NoSplash.splashFactory,
    surfaceTintColor: Colors.white,
    backgroundColor: AppColors.secondaryButtonColor,
    fixedSize: const Size(160, commonTextButtonHeight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonButtonRadius)),
  );
}
