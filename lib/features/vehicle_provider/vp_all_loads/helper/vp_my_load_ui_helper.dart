import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_progress_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class VpMyLoadUIHelper {
  VpMyLoadUIHelper._();

  // Showing Status View
  static Widget loadStatusWidget(String status, BuildContext context) {

    Widget ui({required String text ,required Color textColor, required Color backgroundColor}) {
      return Container(
        decoration: commonContainerDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: FittedBox(
          child: Text(
            text.capitalize,
            style: AppTextStyle.body.copyWith(color: textColor),
          ).paddingSymmetric(horizontal: 10, vertical: 3),
        ),
      );
    }

    switch (status) {
      case "Confirmed":
        return ui(text : context.appText.confirmed, textColor: Color(0xff9C27B0), backgroundColor: Color(0xffe1bfe6));
      case "Assigned":
        return ui(text: context.appText.assigned, textColor: Color(0xff018800), backgroundColor: Color(0xffe6f3e5));
      case "Loading":
        return ui(text: context.appText.loading, textColor: Color(0xffFF9800), backgroundColor: Color(0xffffeacc));
      case "Unloading":
        return ui(text: context.appText.unloading,textColor: Color(0xff009688), backgroundColor: Color(0xffcceae7));
      case "In Transit":
        return ui(text: context.appText.inTransit ,textColor: Color(0xffFF5722), backgroundColor: Color(0xffffddd3));
      case "POD Dispatch":
        return ui(text: context.appText.podDispatch, textColor: Colors.white, backgroundColor: Color(0xff42A5F5));
      case "Completed":
        return ui(text: context.appText.completed, textColor: Colors.white, backgroundColor: Color(0xff018800));
      case "loadOnHold":
        return ui(text: context.appText.unloadingHeld, textColor: Colors.white, backgroundColor: AppColors.iconRed);
      default:
        return Container();
    }
  }

  // Showing Status Button
  static Widget loadStatusButtonWidget({required BuildContext context, required String status, bool isLoading = false, required void Function() onPressed}) {
    switch (status) {
      case "Confirmed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.confirmed,
        );
      case "Assigned":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.startTrip,
        );
      case "Loading":
        return _swipeButtonWidget(context: context, status: 'Loading', onPressed: onPressed);
      case "Unloading":
        return _swipeButtonWidget(context: context, status: 'Unloading', onPressed: onPressed);
      case "In Transit":
        return SlideAction(
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteUnloading,
          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: (){
            onPressed.call();
          },
        );
      case "POD Dispatch":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "POD Dispatch Detail",
        );
      case "Completed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.view,
        );
      default:
        return Container();
    }
  }


  // Sim Tracking Status View
  static Widget simTrackingWidget({required BuildContext context, required String status, int driverConsent = 0}) {
    Widget ui({required String text ,required Color textColor}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(text, textAlign: TextAlign.center ,style: AppTextStyle.h5.copyWith(color: textColor)),
          commonDivider()
        ],
      );
    }
    switch (status) {
      case "Loading":
      case "Unloading":
      if (driverConsent == 1){
        return ui(text: context.appText.driverConsentGiven, textColor: AppColors.activeGreenColor);
      } else if (driverConsent == 0){
        return ui(text: context.appText.noSimTrackingConsentFromDriver, textColor: AppColors.activeRedColor);
      } else {
        return Container();
      }
      default:
        return Container();
    }
  }


  // Swipe button View
  static Widget _swipeButtonWidget({required BuildContext context, required String status, int driverConsent = 0, required void Function() onPressed}) {
    switch (status) {
      case "Loading":
      case "Unloading":
      if (driverConsent == 1){
        return SlideAction(
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteUnloading,
          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: (){
            onPressed.call();
            return;
          },
        );
      } else if (driverConsent == 0){
        return IgnorePointer(
          ignoring: true,
          child: SlideAction(
            borderRadius: commonButtonRadius,
            elevation: 0,
            height: commonButtonHeight2,
            innerColor: Colors.transparent,
            outerColor:  AppColors.greyIconBackgroundColor,
            sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon, colorFilter: AppColors.svg(AppColors.greyIconColor)).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
            sliderRotate: false,
            sliderButtonYOffset: -30,
            text: context.appText.swipeToCompleteLoading,
            textStyle: AppTextStyle.button.copyWith(color: AppColors.greyTextColor),
            onSubmit: (){
              return;
            },
          ),
        );;
      } else {
        return Container();
      }
      default:
        return Container();
    }
  }


  // Progress Tracking Status View
  static Widget progressTrackingWidget({required String status, double progress = 0.0}) {
    Widget ui() {
      return Column(
        children: [
          AppProgressBar(progress: progress),
          5.height,
          commonDivider(),
        ],
      );
    }
    switch (status) {
      case "Loading":
        return ui();
      case "In Transit":
        return ui();
      case "Unloading":
        return ui();
      default:
        return Container();
    }
  }



}


