import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  ///----Prabhat---

  static TextStyle textBlackColor20w500 = TextStyle(
    color: AppColors.textBlackColor,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );   static TextStyle veryLightGreyColor14w400 = TextStyle(
    color: AppColors.veryLightGreyColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  ); static TextStyle lightBlackColor14w500 = TextStyle(
    color: AppColors.lightBlackColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle blackColor15w500 = TextStyle(
    color: AppColors.black,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle whiteColor14w400 = TextStyle(
    color: AppColors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );static TextStyle darkDividerColor16w400 = TextStyle(
    color: AppColors.darkDividerColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle textBlackDetailColor16w500 = TextStyle(
    color: AppColors.textBlackDetailColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );static TextStyle textBlackDetailColor15w500 = textBlackDetailColor16w500.copyWith(fontSize: 15.sp);

  static TextStyle textBlackDetailColor14w400 = textBlackDetailColor16w500.copyWith(fontWeight: FontWeight.w400,fontSize: 14.sp);
  static TextStyle textGreyDetailColor14w400 = TextStyle(
    color: AppColors.textGreyDetailColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );static TextStyle textGreyDetailColor12w400 =textGreyDetailColor14w400.copyWith(fontSize: 12.sp);
  static TextStyle greenColor20w700 = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.greenColor,
    fontSize: 20.sp,
  );static TextStyle textGreyDetailColor10w400 =textGreyDetailColor12w400.copyWith(fontSize: 10.sp);
  static TextStyle primaryColor16w900 = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
  );
  static TextStyle primaryColor12w400 = primaryColor16w900.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle primaryColor16w400 = primaryColor12w400.copyWith(
    fontSize: 16.sp,
  );
 static TextStyle primaryColor14w700 = primaryColor16w400.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle blackColor14w400 = TextStyle(
    color: Colors.black,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );  static TextStyle blackColor16w400 =blackColor14w400.copyWith(fontSize: 16.sp);
  static TextStyle primaryColor14w400UnderLine = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );
  static TextStyle textGreyColor14w400 = TextStyle(
    color: AppColors.textGreyColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle primaryColor18w400UnderLine = primaryColor14w400UnderLine
      .copyWith(fontSize: 18.sp);

  static TextStyle primaryColor18w500UnderLine = primaryColor18w400UnderLine
      .copyWith(fontWeight: FontWeight.w500);
  static TextStyle textBlackColor18w500 = textBlackColor20w500.copyWith(
    fontSize: 18.sp,
  ); static TextStyle textBlackColor26w700 = textBlackColor20w500.copyWith(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700
  );
  static TextStyle textBlackColor18w400 = textBlackColor20w500.copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textBlackColor16w400 = textBlackColor20w500.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle textBlackColor12w400 = textBlackColor16w400.copyWith(
    fontSize: 12.sp,
  );
  static TextStyle textBlackColor16w500 = textBlackColor16w400.copyWith(
    fontWeight: FontWeight.w500,
  );
  static TextStyle textBlackColor14w400 = textBlackColor16w400.copyWith(
    fontSize: 14.sp,
  );
  static TextStyle textBlackColor30w500 = textBlackColor20w500.copyWith(
    fontSize: 30.sp,
  );
  static TextStyle textDarkGreyColor14w400 = TextStyle(
    color: AppColors.textDarkGreyColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle textDarkGreyColor14w500 = textDarkGreyColor14w400.copyWith(
    fontWeight: FontWeight.w500,
  );
  static TextStyle textDarkGreyColor12w400 = textDarkGreyColor14w400.copyWith(
    fontSize: 12.h,
  );
  static TextStyle textGreyColor14w300 = textGreyColor14w400.copyWith(
    fontWeight: FontWeight.w300,
  );
  static TextStyle textGreyColor12w400 = textGreyColor14w400.copyWith(
    fontSize: 12.sp,
  );
  static TextStyle textGreyColor10w400 = textGreyColor14w400.copyWith(
    fontSize: 10.sp,
  );
  static TextStyle textBlackColors20w400 = textBlackColor20w500.copyWith(
    fontWeight: FontWeight.w400,
  );

  /// --- Heading ---
  // H1
  static TextStyle h1 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
    fontSize: 35,
  );
  static TextStyle h4PrimaryColor = h4.copyWith(color: AppColors.primaryColor);
  static TextStyle h1w700 = h1.copyWith(fontWeight: FontWeight.w700);
  static TextStyle h1w600 = h1.copyWith(fontWeight: FontWeight.w600);
  static TextStyle h1BlackColor = h1.copyWith(color: Colors.black);
  static TextStyle h1PrimaryColor = h1.copyWith(color: AppColors.primaryColor);

  // H2
  static TextStyle h2 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w700,
    color: AppColors.primaryTextColor,
    fontSize: 28,
  );
  static TextStyle h2PrimaryColor = h2.copyWith(color: AppColors.primaryColor);

  // H3
  static TextStyle h3 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w700,
    color: AppColors.primaryTextColor,
    fontSize: 22,
  );
  static TextStyle h3w600 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
    fontSize: 22,
  );
  static TextStyle h3w500 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
    fontSize: 22,
  );
  static TextStyle h3GreyColor = h3.copyWith(color: AppColors.greyTextColor);
  static TextStyle h3PrimaryColor = h3.copyWith(color: AppColors.primaryColor);

  // H3
  static TextStyle h4 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
    fontSize: 18,
  );
  static TextStyle h4w500 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
    fontSize: 18,
  );
  static TextStyle h4GreyColor = h4.copyWith(color: AppColors.greyTextColor);
  static TextStyle h4WhiteColor = h4.copyWith(color: Colors.white);

  // H3
  static TextStyle h5 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
    fontSize: 15,
  );
  static TextStyle h5w500 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
    fontSize: 15,
  );
  static TextStyle h5GreyColor = h5.copyWith(color: AppColors.greyTextColor);
  static TextStyle h5WhiteColor = h5.copyWith(color: Colors.white);
  static TextStyle h5PrimaryColor = h5.copyWith(color: AppColors.primaryColor);

  // H6
  static TextStyle h6 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
    fontSize: 12,
  );
  static TextStyle h6GreyColor = h6.copyWith(color: AppColors.greyTextColor);
  static TextStyle h6WhiteColor = h6.copyWith(color: Colors.white);
  static TextStyle h6PrimaryColor = h6.copyWith(color: AppColors.primaryColor);

  /// --- Body ---
  static TextStyle body1 = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
    fontSize: 18,
  );
  static TextStyle body1GreyColor = body1.copyWith(
    color: AppColors.greyTextColor,
  );
  static TextStyle body1BlackColor = body1.copyWith(color: Colors.black);
  static TextStyle body1WhiteColor = body1.copyWith(color: Colors.white);
  static TextStyle body1PrimaryColor = body1.copyWith(color: AppColors.primaryColor);
  // Body 2
  static TextStyle body2 = GoogleFonts.ubuntu(
    color: AppColors.primaryTextColor,
    fontSize: 16,
  );
  static TextStyle body2GreyColor = body2.copyWith(
    color: AppColors.greyTextColor,
  );
  static TextStyle body2BlackColor = body2.copyWith(color: Colors.black);
  static TextStyle body2WhiteColor = body2.copyWith(color: Colors.white);
  static TextStyle body2PrimaryColor = body2.copyWith(
    color: AppColors.primaryColor,
  );

  // Body 3
  static TextStyle body3 = GoogleFonts.ubuntu(
    color: AppColors.primaryTextColor,
    fontSize: 13,
  );
  static TextStyle body3GreyColor = body3.copyWith(
    color: AppColors.greyTextColor,
  );
  static TextStyle body3WhiteColor = body3.copyWith(color: Colors.white);

  // Body 3
  static TextStyle body4 = GoogleFonts.ubuntu(
    color: AppColors.primaryTextColor,
    fontSize: 11,
  );
  static TextStyle body4GreyColor = body4.copyWith(
    color: AppColors.greyTextColor,
  );
  static TextStyle body4WhiteColor = body4.copyWith(color: Colors.white);

  // Body
  static TextStyle body = GoogleFonts.ubuntu(
    color: AppColors.primaryTextColor,
    fontSize: 14,
  );
  static TextStyle bodyGreyColor = body.copyWith(
    color: AppColors.greyTextColor,
  );
  static TextStyle bodyWhiteColor = body.copyWith(color: Colors.white);

  /// --- Button ---
  // Primary
  static final TextStyle _button = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontSize: 16,
  );
  static TextStyle button = _button.copyWith(
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontSize: 16,
    inherit: true,
  );
  static TextStyle buttonWhiteTextColor = button.copyWith(color: Colors.white);
  static TextStyle buttonBlackTextColor = button.copyWith(
    color: AppColors.primaryTextColor,
  );
  static TextStyle buttonPrimaryColorTextColor = button.copyWith(
    color: AppColors.primaryColor,
  );

  // Secondary
  static TextStyle secondaryButton = button.copyWith(
    color: AppColors.primaryTextColor,
  );

  /// Appbar
  static TextStyle appBar = GoogleFonts.ubuntu(
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 18,
  );

  /// Text Field & Dropdown
  static TextStyle textFiled = GoogleFonts.ubuntu(
    color: AppColors.primaryTextColor,
    fontSize: 16,
  );
  static TextStyle textFieldHint = GoogleFonts.ubuntu(
    color: AppColors.greyTextColor,
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );
}
