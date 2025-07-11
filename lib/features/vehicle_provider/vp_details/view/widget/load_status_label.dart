import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LoadStatusLabel extends StatelessWidget {
  final LoadStatus loadStatus;
   const LoadStatusLabel({super.key,  required this.loadStatus});

  @override
  Widget build(BuildContext context) {
    return  Container(
    height: 24,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.activeDarkGreenColor.withValues(alpha: 0.25)
      ),
      child: Text(VpHelper.getLoadStatus(loadStatus),style: AppTextStyle.body.copyWith(
        fontSize: 12,
        color: AppColors.activeDarkGreenColor,
        fontWeight: FontWeight.w400
      ),

      )
    );
  }




}


