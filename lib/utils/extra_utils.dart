import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/customButton.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import 'app_colors.dart';
import 'app_image.dart';

String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    return 'Invalid number';
  }

  return '+91 ${phoneNumber.substring(0, 3)}xx xx${phoneNumber.substring(7, 10)}';
}

Widget customCheckbox({
  required BuildContext context,
  required,
  required String text,
  required Function() onTap,
  required bool selected,
}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 17.h,
          width: 17.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.primaryColor, width: 1.5),
          ),
          child:
              selected
                  ? Center(child: Icon(Icons.check, size: 13.h))
                  : const SizedBox(),
        ),
      ),
      5.width,
      Text(text, style: AppTextStyle.textBlackColor12w400),
    ],
  );
}

void showSuccessDialog(
  BuildContext context, {
  required String text,
  required String subheading,
  GestureTapCallback? onTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dismiss only with button if needed
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero, // Optional: remove default padding
          content: SizedBox(
            width: 500.w,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: InkWell(
                onTap: onTap ?? () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.height,
                    Image.asset(AppImage.png.successGif),
                    SizedBox(height: 50.h),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.greenColor20w700,
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
            ),
          ),
        ),
      );
    },
  );
}

headingText({required String text, TextStyle? appStyle}) {
  return Text(text, style: appStyle ?? AppTextStyle.textBlackDetailColor16w500);
}

dividerWidget() {
  return Divider(color: AppColors.dividerColor, thickness: 0.5);
}

profileWidget({
  required String imageString,
  required String text,
  required GestureTapCallback onTap,
  bool showArrow = true,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 22.h),
      child: Row(
        children: [
          Image.asset(imageString, height: 20.h, width: 20.w),
          10.width,
          Text(
            text,
            style:
                showArrow
                    ? AppTextStyle.blackColor14w400
                    : AppTextStyle.blackColor14w400.copyWith(color: Colors.red),
          ),
          Expanded(child: SizedBox.shrink()),
          showArrow
              ? Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black)
              : const SizedBox(),
        ],
      ),
    ),
  );
}

tabWidget({
  required String text,
  bool selected = false,
  required GestureTapCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
      decoration: BoxDecoration(
        color:
            selected
                ? AppColors.primaryColor
                : AppColors.greyIconBackgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        text,
        style: AppTextStyle.whiteColor14w400.copyWith(
          color: selected ? AppColors.white : AppColors.black,
        ),
      ),
    ),
  );
}

normalButton({
  required String buttonText,
  double? buttonWidth,
  required GestureTapCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 32.h,
      width: buttonWidth ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor, width: 0.8),
      ),
      child: Center(
        child: Text(buttonText, style: AppTextStyle.primaryColor16w400),
      ),
    ),
  );
}

showCustomDialogue({
  required BuildContext context,
  required Widget child,
  Widget? child2,
  GestureTapCallback? onClickButton,
  required String buttonText,
  bool disableButton = false,
}) {
  return Dialog(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          30.height,
          AppButton(
            disableButton: disableButton,
            title: buttonText,
            onPressed:
                onClickButton ??
                () {
                  // Handle verify action here
                  Navigator.pop(context);
                },
          ),
          child2 ?? const SizedBox(),
        ],
      ),
    ),
  );
}

translateWiget({required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Image.asset(AppImage.png.translateImage, width: 23.w, height: 23.h),
  );
}

customerSupportWidget({required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Image.asset(AppImage.png.customerSupport, width: 32.w, height: 32.h),
  );
}

showAlertDialogue({
  required BuildContext context,
  required Widget child,
  required GestureTapCallback onClickYesButton,
  bool hideButtonButtons = false,
}) {
  return Dialog(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          child,

          20.height,
          // Buttons
          hideButtonButtons
              ? const SizedBox()
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // No Button
                  Expanded(
                    child: normalButton(
                      buttonText: "No",
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),
                  16.width,

                  // Yes Button
                  Expanded(
                    child: SizedBox(
                      height: 32.h,
                      child: AppButton(
                        onPressed: onClickYesButton,
                        title: "Yes",
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    ),
  );
}

statusButtonWidget({
  required Color statusBackgroundColor,
  required Color statusTextColor,
  required String statusText,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    height: 24.h,
    margin: margin ?? EdgeInsets.only(top: 17.h),
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    decoration: BoxDecoration(
      color: statusBackgroundColor,

      borderRadius: BorderRadius.circular(40),
    ),
    child: Center(
      child: Text(
        statusText,
        style: AppTextStyle.whiteColor14w400.copyWith(color: statusTextColor),
      ),
    ),
  );
}

draggableSheet({required List<Widget> child}) {
  return DraggableScrollableSheet(
    initialChildSize: 0.45.h, // 10% of screen
    minChildSize: 0.45.h, // Minimum size
    maxChildSize: 1.h, // Maximum size
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(spacing: 10.h, children: child),
        ),
      );
    },
  );
}

void showCustomerCareBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
              Image.asset(
                AppImage.png.customerSupportImage,
                height: 237.h,
                width: 237.w,
              ),
              Text(
                "Call Customer Support",
                textAlign: TextAlign.center,
                style: AppTextStyle.textBlackColor20w500,
              ),
              15.height,
              Text(
                "For immediate support, talk to our team now.",
                textAlign: TextAlign.center,
                style: AppTextStyle.textGreyDetailColor12w400,
              ),
              15.height,
              AppButton(
                title: "Call Now",
                onPressed: () {
                  context.pop();
                },
              ),
              15.height,
            ],
          ),
        ),
      );
    },
  );
}
