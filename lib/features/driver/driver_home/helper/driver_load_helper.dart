import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DriverLoadHelper {
  DriverLoadHelper._();

  static Widget loadStatusWidget(int statusId) {
    Widget ui({required String text, required Color textColor, required Color backgroundColor}) {
      return Container(
        decoration: commonContainerDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: AppTextStyle.body.copyWith(color: textColor),
        ).paddingSymmetric(horizontal: 10, vertical: 3),
      );
    }

    switch (statusId) {
      case 1:
        return ui(text: "KYC Pending", textColor: Colors.white, backgroundColor: Colors.grey);
      case 2:
        return ui(text: "Matching", textColor: Color(0xff3F51B5), backgroundColor: Color(0xffd1d9ff));
      case 3:
        return ui(text: "Confirmed", textColor: Color(0xff9C27B0), backgroundColor: Color(0xffe1bfe6));
      case 4:
        return ui(text: "Assigned", textColor: Color(0xff018800), backgroundColor: Color(0xffe6f3e5));
      case 5:
        return ui(text: "Loading", textColor: Color(0xffFF9800), backgroundColor: Color(0xffffeacc));
      case 6:
        return ui(text: "In Transit", textColor: Color(0xffFF5722), backgroundColor: Color(0xffffddd3));
      case 7:
        return ui(text: "Unloading", textColor: Color(0xff009688), backgroundColor: Color(0xffcceae7));
      case 8:
        return ui(text: "Completed", textColor: Colors.white, backgroundColor: Color(0xff018800));
      default:
        return Container();
    }
  }

  static Widget loadStatusButtonWidget({
    required int statusId,
    bool isLoading = false,
    required void Function() onPressed,
  }) {
    switch (statusId) {
      case 3:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Assign Driver",
        );
      case 4:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Start Trip",
        );
      case 5:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Loading",
        );
      case 6:
        return SlideAction(
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor: AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon)
              .cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: "Swipe to unload",
          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: () {},
        );
      case 7:
        return SlideAction(
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor: AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon)
              .cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: "Swipe to complete unloading",
          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: () {},
        );
      case 8:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "View Detail",
        );
      default:
        return Container();
    }
  }
}
