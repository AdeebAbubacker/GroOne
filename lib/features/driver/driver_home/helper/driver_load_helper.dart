import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DriverLoadHelper {
  DriverLoadHelper._();
  
  /// Load Status Details
  static LoadStatus getLoadStatus(int? status) {
    return switch (status) {
      3 => LoadStatus.accepted,
      4 => LoadStatus.assigned,
      5 => LoadStatus.loading,
      6 => LoadStatus.inTransit,
      7 => LoadStatus.unloading,
      8 => LoadStatus.podDispatched,
      9 => LoadStatus.completed,
      null || int() => LoadStatus.matching,
    };
  }
  
  /// Eliptical load Status
  static Widget loadStatusWidget(
    String status,
    BuildContext context, {
    String? statusBgColor,
    String? statusTxtColor,
    bool loadOnHold = false,
  }) {
    Color backgroundColor =
        loadOnHold
            ? AppColors.iconRed
            : DriverLoadHelper.getColor(statusBgColor ?? '');

    Color textColor =
        loadOnHold
            ? AppColors.white
            : DriverLoadHelper.getColor(statusTxtColor ?? '');

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
  
  /// Get color from load Status 
  static Color getColor(String colorString) {
    if (colorString.startsWith('#')) {
      final hex = colorString.replaceFirst('#', '');
      final fullHex = hex.length == 6 ? 'FF$hex' : hex;
      return Color(int.parse(fullHex, radix: 16));
    } else if (colorString.startsWith('rgba')) {
      final regex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+),?\s*([.\d]*)\)');
      final match = regex.firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        final a =
            match.group(4)?.isNotEmpty == true
                ? (double.parse(match.group(4)!) * 255).round()
                : 255;
        return Color.fromARGB(a, r, g, b);
      }
    }

    // Fallback color (e.g. transparent or default)
    return Colors.transparent;
  }
  
  ///  Get Current Status TExt
  static String getBottomButtonTitle(
    int statusId,
    PodDispatchModel? podDispatched,
    bool isLpAgreed,
    bool isPodSkipped,
  ) {
    BuildContext context = navigatorKey.currentState!.context;
    switch (statusId) {
        case 4:
        return isLpAgreed
            ? context.appText.swipeToStart
            : context.appText.waitingForLpToConfirmed;
      case 5:
          return context.appText.swipeToCompleteLoading;

      case 6:
        return context.appText.swipeToStartUnLoading;
      case 7:
        return context.appText.swipeToCompleteUnLoading;
      case 8:
        return (podDispatched != null || isPodSkipped == true)
            ? context.appText.swipeToCompleteTrip
            : context.appText.podDispatchedDetails;

      default:
        return context.appText.swipeToStart;
    }
  }
  
  /// Load Status button home
  static Widget homeloadStatusButtonWidget({
    required BuildContext context,
    required int statusId,
    bool isLoading = false,
    required VoidCallback onPressed,
    bool? enable = true,
    bool isLpagreed = true,
  }) {
    switch (statusId) {
      case 4:
        if (!isLpagreed) {
          // 🟡 Memo not signed → Show View Detail button
          return AppButton(
            enable: isLpagreed,
            buttonHeight: commonButtonHeight2,
            onPressed: isLoading ? () {} : onPressed,
            isLoading: isLoading,
            title:  isLpagreed ? context.appText.startTrip :context.appText.waitingForLpToConfirmed,
          );
        } else {          
          return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.startTrip,
        );  
        }

      case 5:
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:
              (enable ?? false)
                  ? AppColors.lightPrimaryColor3
                  : AppColors.lightGreyE9,

          sliderButtonIcon: SvgPicture.asset(
              AppIcons.svg.swipeButtonIcon,
              colorFilter: (enable ?? false)
              ? null
              : AppColors.svg(AppColors.mediumDarkGrey)
            ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteLoading,
          textStyle: AppTextStyle.button.copyWith(
            color:
                (enable ?? false) ? AppColors.primaryColor : AppColors.mediumDarkGrey,
          ),
          onSubmit:
              isLoading
                  ? () async {}
                  : () async {
                    onPressed();
                  },
        );

      case 6:
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:
              (enable ?? false)
                  ? AppColors.lightPrimaryColor3
                  : AppColors.lightGreyE9,

          sliderButtonIcon: SvgPicture.asset(
              AppIcons.svg.swipeButtonIcon,
              colorFilter: (enable ?? false)
              ? null
              : AppColors.svg(AppColors.mediumDarkGrey)
            ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToUnLoad,
          textStyle: AppTextStyle.button.copyWith(
            color:
                (enable ?? false) ? AppColors.primaryColor : AppColors.mediumDarkGrey,
          ),
          onSubmit:
              isLoading
                  ? () async {}
                  : () async {
                    onPressed();
                  },
        );
      case 7:
        return SlideAction(
          enabled: enable ?? true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:
              (enable ?? false)
                  ? AppColors.lightPrimaryColor3
                  : AppColors.lightGreyE9,

          sliderButtonIcon: SvgPicture.asset(
              AppIcons.svg.swipeButtonIcon,
              colorFilter: (enable ?? false)
              ? null
              : AppColors.svg(AppColors.mediumDarkGrey)
            ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteUnLoading,
          textStyle: AppTextStyle.button.copyWith(
            color:
                (enable ?? false) ? AppColors.primaryColor : AppColors.mediumDarkGrey,
          ),
          onSubmit:
              isLoading
                  ? () async {}
                  : () async {
                    onPressed();
                  },
        );
      case 8:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: context.appText.podDispatchedDetails,
        );
      case 9:
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
}

/// Get Current Status Details
String getSwipeDriverButtonTitle(
  LoadStatus status,
  PodDispatchModel? podDispatched,
) {
  BuildContext context = navigatorKey.currentState!.context;
  switch (status) {
    case LoadStatus.loading:
      return context.appText.swipeToCompleteLoading;
    case LoadStatus.inTransit:
      return context.appText.swipeToStartUnLoading;
    case LoadStatus.unloading:
      return context.appText.swipeToCompleteUnLoading;
    case LoadStatus.podDispatched:
      return podDispatched == null
          ? context.appText.podDispatchedDetails
          : context.appText.swipeToCompleteTrip;
    default:
      return context.appText.swipeToStart;
  }
}
