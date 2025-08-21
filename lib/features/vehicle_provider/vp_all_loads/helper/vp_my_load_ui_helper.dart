import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
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

  static Widget loadStatusWidget(
    String status,
    BuildContext context, {
    String? statusBgColor,
    String? statusTxtColor,
    bool loadOnHold = false,
  }) {
    Color backgroundColor =
        loadOnHold ? AppColors.iconRed : VpHelper.getColor(statusBgColor ?? '');

    Color textColor =
        loadOnHold ? Colors.white : VpHelper.getColor(statusTxtColor ?? '');

    return Container(
      decoration: commonContainerDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: FittedBox(
        child: Text(
          status.capitalize,
          style: AppTextStyle.body.copyWith(color: textColor),
        ).paddingSymmetric(horizontal: 10, vertical: 3),
      ),
    );
  }

  // Showing Status Button
  static Widget loadStatusButtonWidget({
    required String status,
    bool isLoading = false,
    required void Function() onPressed,
    required BuildContext context,
    bool? enable = true,
    bool? isIntoRangePrice,
    bool? isPodAdded,
  }) {
    if (isIntoRangePrice ?? false) {
      return AppButton(
        buttonHeight: commonButtonHeight2,
        onPressed: isLoading ? () {} : onPressed,
        isLoading: isLoading,
        title: context.appText.adminContact,
      );
    }
    switch (status) {
      case "Confirmed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.assignDriver,
        );
      case "Assigned":
        return AppButton(

          buttonHeight: commonButtonHeight2,
          onPressed:  (enable??false) ?  isLoading ? () {} : onPressed:null,
          isLoading: isLoading,
          title: context.appText.startTrip,
        );
      case "Loading":
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:
              (enable ?? false)
                  ? AppColors.lightPrimaryColor3
                  : Color(0xffE9E9E9),
          sliderButtonIcon: SvgPicture.asset(
            AppIcons.svg.swipeButtonIcon,
            color: (enable ?? false) ? null : Color(0xff6C6C6C),
          ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,

          alignment: Alignment.center,

          textStyle: AppTextStyle.button.copyWith(
            color:
                (enable ?? false) ? AppColors.primaryColor : Color(0xff6C6C6C),
          ),
          onSubmit: () {
            onPressed.call();
            return;
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              context.appText.swipeToCompleteLoading,
              style: AppTextStyle.button.copyWith(
                fontSize: 15,
                color:
                    (enable ?? false)
                        ? AppColors.primaryColor
                        : Color(0xff6C6C6C),
              ),
            ),
          ).paddingLeft(12),
        );

      case "Unloading":
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:
              (enable ?? false)
                  ? AppColors.lightPrimaryColor3
                  : Color(0xffE9E9E9),
          sliderButtonIcon: SvgPicture.asset(
            AppIcons.svg.swipeButtonIcon,
            color: (enable ?? false) ? null : Color(0xff6C6C6C),
          ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,

          child: Align(
            alignment: Alignment.center,
            child: Text(
              context.appText.swipeToCompleteUnLoading,
              style: AppTextStyle.button.copyWith(
                fontSize: 15,
                color:
                    (enable ?? false)
                        ? AppColors.primaryColor
                        : Color(0xff6C6C6C),
              ),
            ),
          ).paddingLeft(12),

          onSubmit: () {
            onPressed.call();
            return;
          },
        );
      case "In Transit":
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor: AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(
            AppIcons.svg.swipeButtonIcon,
          ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToUnLoad,
          textStyle: AppTextStyle.button.copyWith(
            color: AppColors.primaryColor,
          ),
          onSubmit: () {
            onPressed.call();
          },
        );
      case "POD Dispatch":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title:  (isPodAdded??false )   ? context.appText.swipeToCompleteTrip  : context.appText.podDispatchedDetails,
        );
      case "Completed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.viewDetails,
        );
      default:
        return Container();
    }
  }

  // Sim Tracking Status View
  static Widget simTrackingWidget({
    required BuildContext context,
    required String status,
    int driverConsent = 0,
  }) {
    Widget ui({required String text, required Color textColor}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.h5.copyWith(color: textColor),
          ),
          commonDivider(),
        ],
      );
    }

    switch (status) {
      case "Loading":
      case "Unloading":
        if (driverConsent == 1) {
          return ui(
            text: context.appText.driverConsentGiven,
            textColor: AppColors.activeGreenColor,
          );
        } else if (driverConsent == 0) {
          return ui(
            text: context.appText.noSimTrackingConsentFromDriver,
            textColor: AppColors.activeRedColor,
          );
        } else {
          return Container();
        }
      default:
        return Container();
    }
  }

  // Progress Tracking Status View
  static Widget progressTrackingWidget({
    required String status,
    double progress = 0.0,
  }) {
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
