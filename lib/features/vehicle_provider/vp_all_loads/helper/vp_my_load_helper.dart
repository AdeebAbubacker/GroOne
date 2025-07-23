import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class VpMyLoadHelper {
  VpMyLoadHelper._();

  // Showing Status View
  static Widget loadStatusWidget(String status) {


    Widget ui({required String text ,required Color textColor, required Color backgroundColor}) {
      return Container(
        decoration: commonContainerDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text.capitalize,
          style: AppTextStyle.body.copyWith(color: textColor),
        ).paddingSymmetric(horizontal: 10, vertical: 3),
      );
    }

    switch (status) {
      case "Confirmed":
        return ui(text : status, textColor: Color(0xff9C27B0), backgroundColor: Color(0xffe1bfe6));
      case "Assigned":
        return ui(text: status,textColor: Color(0xff018800), backgroundColor: Color(0xffe6f3e5));
      case "Loading":
        return ui(text: status, textColor: Color(0xffFF9800), backgroundColor: Color(0xffffeacc));
      case "Unloading":
        return ui(text: status,textColor: Color(0xff009688), backgroundColor: Color(0xffcceae7));
      case "In Transit":
        return ui(text: status ,textColor: Color(0xffFF5722), backgroundColor: Color(0xffffddd3));
      case "POD Dispatch":
        return ui(text: status,textColor: Colors.white, backgroundColor: Color(0xff42A5F5));
      case "Completed":
        return ui(text: status, textColor: Colors.white, backgroundColor: Color(0xff018800));
      default:
        return Container();
    }
  }

  // Showing Status Button
  static Widget loadStatusButtonWidget({

    required String status, bool isLoading = false, required void Function() onPressed,required BuildContext context,bool? enable=true}) {
    print("button enabled status ${enable}");
    switch (status) {
      case "Confirmed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title:context.appText.assignDriver,
        );
      case "Assigned":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title:context.appText.startTrip ,
        );
      case "Loading":
        return  SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteLoading,
          textStyle: AppTextStyle.button.copyWith(
              color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
          onSubmit: (){
            onPressed.call();
            return;
          },
        );

      case "Unloading":
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToCompleteUnLoading,

          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: (){
            onPressed.call();
            return;
          },
        );
      case "In Transit":
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  AppColors.lightPrimaryColor3,
          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: context.appText.swipeToUnLoad,
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
          title: context.appText.podDispatchedDetails,
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


}


