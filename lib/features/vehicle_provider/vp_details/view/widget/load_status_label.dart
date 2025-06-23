import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LoadStatusLabel extends StatelessWidget {
 final String statusType;
  const LoadStatusLabel({super.key,required this.statusType});

  @override
  Widget build(BuildContext context) {
    return  Container(
    height: 24,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.activeDarkGreenColor.withValues(alpha: 0.25)
      ),
      child: Text("Confirmed",style: AppTextStyle.body.copyWith(
        fontSize: 12.sp,
        color: AppColors.activeDarkGreenColor,
        fontWeight: FontWeight.w400
      ),

      )
    );
  }
}
