import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


class ToastMessages{

  /// Error Msg
  static internetError({required String message}) async {
    Flushbar(
      messageText: Text(message, style: AppTextStyle.body),
      messageColor:  Colors.white,
      flushbarPosition: FlushbarPosition.TOP ,
      backgroundColor:   AppColors.scaffoldBackgroundColor,
      isDismissible: false,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius:  5.0, // soften the shadow
          spreadRadius:  1.5, //extend the shadow
        )
      ],
      icon: const Icon(Icons.wifi_off_rounded, size : 25,  color: AppColors.secondaryColor).paddingAll(10).paddingLeft(10),
      duration: const Duration(milliseconds: 3000),
    ).show(navigatorKey.currentState!.context);
  }

  /// success Msg
  static success({required String message}) async {
    Flushbar(
      messageText: Text(message,  style: AppTextStyle.body),
      flushbarPosition: FlushbarPosition.TOP ,
      backgroundColor:   AppColors.scaffoldBackgroundColor,
      isDismissible: false,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius:  5.0, // soften the shadow
          spreadRadius:  1.5, //extend the shadow
        )
      ],
      icon: const Icon(Icons.check_circle_rounded, size : 25, color: Colors.green).paddingAll(10).paddingLeft(5),
      duration: const Duration(milliseconds: 3000),
    ).show(navigatorKey.currentState!.context);
  }

  /// Error Msg
  static error({required String message}) {
    if(message == 'The access token is invalid or has expired') {
      return;
    }
    Flushbar(
      messageText: Text(message, style: AppTextStyle.body),
      flushbarPosition: FlushbarPosition.TOP ,
      backgroundColor:  AppColors.scaffoldBackgroundColor,
      isDismissible: false,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius:  5.0, // soften the shadow
          spreadRadius:  1.5, //extend the shadow
        )
      ],
      icon: const Icon(Icons.error, size : 25, color:  Colors.red).paddingAll(10).paddingLeft(5),
      duration: const Duration(milliseconds: 3500),
    ).show(navigatorKey.currentState!.context);
  }

  /// Error Msg
  static alert({required String message}) {
    Flushbar(
      messageText: Text(message, style: AppTextStyle.body),
      flushbarPosition: FlushbarPosition.TOP ,
      backgroundColor:  AppColors.scaffoldBackgroundColor,
      isDismissible: false,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius:  5.0, // soften the shadow
          spreadRadius:  1.5, //extend the shadow
        )
      ],
      icon: const Icon(Icons.error, size : 25, color:  Colors.orange).paddingAll(10).paddingLeft(5),
      duration: const Duration(milliseconds: 3500),
    ).show(navigatorKey.currentState!.context);
  }

  /// Custom toast
  static custom({required String message}) {
    Flushbar(
      messageText: Text(message, style: AppTextStyle.body),
      flushbarPosition: FlushbarPosition.TOP ,
      backgroundColor:  AppColors.scaffoldBackgroundColor,
      isDismissible: false,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius:  5.0, // soften the shadow
          spreadRadius:  1.5, //extend the shadow
        )
      ],
      icon: const Icon(Icons.warning_rounded, size : 25, color:  AppColors.secondaryColor).paddingAll(10).paddingLeft(5),
      duration: const Duration(milliseconds: 3000),
    ).show(navigatorKey.currentState!.context);
  }

  static updateAvailable({required String message}) {
    Flushbar? flush;

    flush = Flushbar(
      messageText: Text(message, style: AppTextStyle.body),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      isDismissible: true,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5.0,
          spreadRadius: 1.5,
        )
      ],
      icon: const Icon(Icons.system_update, size: 25, color: Colors.blue)
          .paddingAll(10)
          .paddingLeft(5),
      mainButton: IconButton(
        icon: const Icon(Icons.close, color: Colors.black54),
        onPressed: () {
          flush?.dismiss();
        },
      ),
      // optional auto-dismiss:
      duration: const Duration(seconds: 5),
    );

    flush.show(navigatorKey.currentState!.context);
  }

}