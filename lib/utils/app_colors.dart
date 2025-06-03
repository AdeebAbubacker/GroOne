import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color textBlackDetailColor =Color(0xFF090909);
  static const Color textGreyDetailColor =Color(0xFF545759);

  static const Color borderDisableColor=Color(0xFF9D9D9D);
  static const Color lightBlackColor=Color(0xFF515151);
  static const Color veryLightGreyColor=Color(0xFF646464);
  static const Color blackishWhite=Color(0xFFF8F8F8);
  static const Color backgroundColor=Color(0xFFF7F8FA);
  static const Color lightPurpleColor=Color(0xFFE8DAFF);
  static const Color purpleColor=Color(0xFF6929C4);
  static const Color textRed=Color(0xFFA2191F);
  static const Color iconRed=Color(0xFFE31B25);
  static const Color textGreen=Color(0xFF0E6027);
  static const Color boxGreen=Color(0xFFA7F0BB);
  static const Color appRedColor=Color(0xFFF9D1D3);
  static const Color primaryDarkColor=Color(0xFF0369A1);
  static const Color textBlackColor = Color(0xFF2B2B2B);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDarkGreyColor = Color(0xFF575757);
  static const Color orangeTextColor = Color(0xFFEA7144);
  static const textGreyColor=Color(0xFF909090);
  static const dividerColor=Color(0xFFC9C9C9);
  static const buttonDisableColor=Color(0xFFA7A7A7);
  static const backGroundBlue=Color(0xFFF8F9FF);
  static const greenColor=Color(0xFF027A48);
  static final Color disableColor = Color(0xFFB8B8B8);

  // Root Color
  static const Color primaryColor =Color(0xFF003CFF);
  static const Color secondaryColor = Color(0xff4D4D4D);
  static const Color lightPrimaryColor = Color(0xffD6EEFB);
  static const Color lightPrimaryColor2 = Color(0xFFF8F9FF);

  // Text Color
  static const Color primaryTextColor = Color(0xff292D32);
  static const Color greyTextColor = Colors.black38;
  static const Color lightGreyTextColor = Color(0xff606060);
  static const Color textFieldFillColor = Colors.white;
  static const Color searchFillColor = Colors.white;
  static const Color textFieldFocusedFillColor = Color(0xffF1F1FE);
  static const Color extraLightGreyTextColor = Colors.black38;

  // Body & Appbar color
  static const Color scaffoldBackgroundColor = Color(0xfff5f8fa);
  static const Color appBarBackgroundColor = Colors.white;

  // Button Color
  static const Color primaryButtonColor = primaryColor;
  static const Color secondaryButtonColor = Color(0xff222831);
  static const Color deActiveButtonColor = Colors.black26;

  // Border and Shadow Color
  static const Color shadowColor = Color(0xffdfdfdf);
  static const Color borderColor = Color(0xffDBDBDB);
  static const Color focusBorderColor = Color(0xff4D4D4D);
  static const Color lightDividerColor = Colors.black12;
  static const Color darkDividerColor = Color(0xff707070);

  // Shimmer Color
  static final Color shimmerBaseColor = Colors.grey.shade100;
  static const Color shimmerHighlightColor = Colors.white10;

  // Icon Color
  static const Color primaryIconColor = Color(0xff0369A1);
  static const Color iconColor = Color(0xff606060);
  static const Color defaultIconTint = Colors.white;
  static const Color greyIconBackgroundColor = Color(0xffe3e3e8);
  static const Color lightGreyIconColor = Colors.black26;
  static final Color lightGreyIconBackgroundColor = Colors.grey.shade200;
  static const Color greyIconColor = Colors.black38;

  // Activity Color
  static const Color activeGreenColor = CupertinoColors.activeGreen;
  static const Color activeBlueColor = CupertinoColors.activeBlue;
  static const Color activeRedColor = CupertinoColors.systemRed;

  // Others Colors
  static const Color lightGreyColor = Color(0xffF8FAFC);
  static Color extraLightBackgroundGray = CupertinoColors.extraLightBackgroundGray.withOpacity(0.5);
  static const Color darkGreyColor = Color(0xff838383);
  static const Color chipBackgroundColor = Color(0xFFF4F0E9);
  static const Color textColor = Color(0xFF512B15);
  static const Color titleTextColor = Color(0xFF5A6474);
  static const Color blueColor = Color(0xFF0A4DFF);
  static const Color uploadedDocBgColor = Color(0xFFF2F5FF);
  static const Color greyContainerBackgroundColor = Color(0xffF5F5F5);
  static const Color lightBlueIconBackgroundColor = Color(0xffE0EFF7);


  static WidgetStateProperty<Color> materialStateColor(Color color) {
    return WidgetStateProperty.all(color);
  }

  // SVG Colors shortcut
  static ColorFilter svg(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  // Gradient Color
  static List<Color> buttonGradientColor = [
    primaryColor.withAlpha(450),
    primaryColor,
    primaryColor,
  ];
}
