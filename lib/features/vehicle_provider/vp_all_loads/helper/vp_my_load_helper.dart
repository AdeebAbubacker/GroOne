import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class VpMyLoadHelper {
  VpMyLoadHelper._();

  // Showing Status View
  static Widget loadStatusWidget(String status) {
    debugPrint("Status : $status");
    Widget ui({required Color backgroundColor, required Color textColor}) {
      return Container(
        decoration: commonContainerDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          status.capitalize,
          style: AppTextStyle.body.copyWith(color: textColor),
        ).paddingSymmetric(horizontal: 10, vertical: 3),
      );
    }

    switch (status) {
      case "accepted":
        return ui(textColor: Color(0xff9C27B0), backgroundColor: Color(0xffe1bfe6));
      case "assigned":
        return ui(textColor: Color(0xff018800), backgroundColor: Color(0xffe6f3e5));
      case "loading":
        return ui(textColor: Color(0xffFF9800), backgroundColor: Color(0xffffeacc));
      case "unloading":
        return ui(textColor: Color(0xff009688), backgroundColor: Color(0xffcceae7));
      case "inTransit":
        return ui(textColor: Color(0xffFF5722), backgroundColor: Color(0xffffddd3));
      case "POD Dispatch":
        return ui(textColor: Colors.white, backgroundColor: Color(0xff42A5F5));
      default:
        return Container();
    }
  }

  // Showing Status Button
  static Widget loadStatusButtonWidget({required String status, bool isLoading = false, required void Function() onPressed}) {
    debugPrint("Status : $status");
    switch (status) {
      case "accepted":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Assign Driver",
        );
      case "assigned":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Start Trip",
        );
      case "loading":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: status.capitalize,
        );
      case "unloading":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: status.capitalize,
        );
      case "inTransit":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: status.capitalize,
        );
      case "POD Dispatch":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "POD Dispatch Detail",
        );
      default:
        return Container();
    }
  }
}
