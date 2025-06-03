import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class AppThemeStyle {
  AppThemeStyle._();

    static ThemeData appTheme = ThemeData(
      textTheme: GoogleFonts.ubuntuTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.scaffoldBackgroundColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: true,
    appBarTheme:  const AppBarTheme(shadowColor: AppColors.shadowColor, backgroundColor: AppColors.appBarBackgroundColor, surfaceTintColor: Colors.white),
  );

  static TimePickerThemeData timePickerTheme = TimePickerThemeData(
    hourMinuteColor: AppColors.secondaryColor, // Hour & Minute background
    hourMinuteTextColor: Colors.white, // Hour & Minute text color
    dialHandColor: AppColors.secondaryColor, // Dial hand color
    dialBackgroundColor: Colors.white, // Dial background color
    dayPeriodColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? AppColors.secondaryColor // Selected AM/PM Background
        : Colors.white), // Unselected AM/PM Background
    dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? Colors.white // Selected AM/PM Text Color
        : Colors.black), // Unselected AM/PM Text Color
  );


}