import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'app_colors.dart';

class AppSwitchToggle extends StatelessWidget {
  const AppSwitchToggle({super.key, required this.switchBool, required this.onChanged});
final bool switchBool;
final Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: switchBool,
      onToggle: onChanged,
      activeColor: AppColors.primaryColor,
      inactiveColor: AppColors.disableColor,
      height: 22.h,width: 45.w,
      padding: 0,
      toggleSize: 20.0,
      showOnOff: false,
    )
    ;
  }
}
