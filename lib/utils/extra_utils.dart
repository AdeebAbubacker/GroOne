import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import 'app_colors.dart';
import 'app_image.dart';

String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    return 'Invalid number';
  }

  return '+91 ${phoneNumber.substring(0, 3)}xx xxx${phoneNumber.substring(8)}';
}

void showSuccessDialog(BuildContext context,{required String text,required String subheading}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dismiss only with button if needed
    builder: (BuildContext context) {
      return Dialog(backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             20.height,
              Image.asset(AppImage.png.successGif),
              SizedBox(height: 50.h),
              Text(
                text,textAlign: TextAlign.center
,
                style: AppTextStyle.greenColor20w700
              ),
             30.height,
              Text(
                subheading,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
             12.height,

            ],
          ),
        ),
      );
    },
  );
}