import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  

static  String getBottomButtonTitle(int statusId){
  BuildContext context=navigatorKey.currentState!.context;
  switch(statusId){
    case 4:
      return context.appText.swipeToStart; 
      case 5:
      
     return context.appText.swipeToCompleteLoading;
      
      case 6:
      return  context.appText.swipeToStartUnLoading;
       case 7:
      return context.appText.podDispatchDetail;
      case 8:
      return context.appText.swipeToCompleteUnLoading;
    default:
      return context.appText.swipeToStart;
  }
}


  static Widget loadStatusButtonWidget({
    required int statusId,
    bool isLoading = false,
    required VoidCallback onPressed,
    bool? enable=true
  }) {
    switch (statusId) {
      case 4:
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Start Trip",
        );
     

     case 5:
        return 
        
        SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
           text: "Swipe to Complete Loading",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
    ? () async {}
    : () async {
        onPressed();
      },

        );

        case 6:
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text:  "Swipe to unload",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
    ? () async {}
    : () async {
        onPressed();
      },

        );
      case 7:
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: "Swipe to complete trip",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
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
          title: "View Detail",
        );
      default:
        return Container();
    }
  }

    static Widget homeloadStatusButtonWidget({
    required BuildContext context,
    required int statusId,
    bool isLoading = false,
    required VoidCallback onPressed,
    bool? enable=true,
    bool isMemoSigned = false,
  }) {
    switch (statusId) {
      case 4:
      if (!isMemoSigned) {
        // 🟡 Memo not signed → Show View Detail button
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Start Trip",
        );
      } else{
            
      return SlideAction(
          enabled: true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
           text: "Swipe to Start Trip",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
    ? () async {}
    : () async {
        onPressed();
      },

        );
  }
     

     case 5:
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
           text: "Swipe to Complete Loading",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
    ? () async {}
    : () async {
        onPressed();
      },

        );

        case 6:
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text:  "Swipe to Unload",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
    ? () async {}
    : () async {
        onPressed();
      },

        );
      case 7:
        return SlideAction(
          enabled: enable??true,
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
                  outerColor:  (enable??false) ?  AppColors.lightPrimaryColor3:Color(0xffE9E9E9) ,

          sliderButtonIcon: SvgPicture.asset(AppIcons.svg.swipeButtonIcon,color: (enable??false) ? null:Color(0xff6C6C6C),).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),

          sliderRotate: false,
          sliderButtonYOffset: -30,
          text: "Swipe to complete unloading",
          textStyle: AppTextStyle.button.copyWith(
         color:(enable??false) ?  AppColors.primaryColor :Color(0xff6C6C6C)),
         onSubmit: isLoading
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
          title: "View Detail",
        );
      default:
        return Container();
    }
  }


   static Widget driverStatusWidget(String? status) {
    Widget buildUI({
      required String text,
      required Color textColor,
      required Color backgroundColor,
    }) {
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

    switch (status) {
      case "4":
        return buildUI(
          text: "Assigned",
          textColor: Colors.blue.shade900,
          backgroundColor: Colors.blue.shade100,
        );
      case "5":
        return buildUI(
          text: "Loading",
          textColor: Colors.orange.shade800,
          backgroundColor: Colors.orange.shade100,
        );
      case "6":
        return buildUI(
          text: "In Transit",
          textColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.shade100,
        );
      case "7":
        return buildUI(
          text: "Unloading",
          textColor: Colors.teal,
          backgroundColor: Colors.teal.shade100,
        );
      case "8":
        return buildUI(
          text: "pod Dispatch",
          textColor: Colors.white,
          backgroundColor: Color(0xff42A5F5),
        );
      case "9":
        return buildUI(
          text: "Completed",
          textColor: Colors.green,
          backgroundColor: Colors.green.shade100,
        );  
      default:
        return buildUI(
          text: "Unknown",
          textColor: Colors.black54,
          backgroundColor: Colors.grey.shade300,
        );
    }
  }
}
