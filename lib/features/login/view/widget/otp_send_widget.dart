import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:toastification/toastification.dart';
import 'package:another_flushbar/flushbar.dart';

class CustomToast {
  static void otpSuccessToast({
    required BuildContext context,
    String message = "Otp Sent successfully",
  }) {
    toastification.showCustom(
      context: context,
      autoCloseDuration: const Duration(milliseconds: 3500),
      alignment: Alignment.topCenter,
      builder: (BuildContext context, ToastificationItem holder) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: AppTextStyle.textBlackColor14w400),
              ),
            ],
          ),
        );
      },
    );
  }
}
