import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'app_button_style.dart';
import 'app_colors.dart';
import 'app_image.dart';

String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    return 'Invalid number';
  }

  return '+91 ${phoneNumber.substring(0, 3)}XX XX${phoneNumber.substring(7, 10)}';
}

Widget customCheckbox({
  required BuildContext context,
  required,
  required String text,
  required Function() onTap,
  required bool selected,
}) {
  return InkWell(
  onTap: onTap,
    child: Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.primaryColor, width: 2),
          ),
          child: selected? Center(child: Icon(Icons.check, size: 15)): const SizedBox(),
        ),
        5.width,
        Text(text, style: AppTextStyle.body2),
      ],
    ),
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
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: InkWell(
                onTap: onTap ?? () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.height,
                    Image.asset(AppImage.png.successGif),
                    SizedBox(height: 50),
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


void showSuccessDialogWithButton(
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
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    10.height,
                    Image.asset(AppImage.png.successGif),
                    SizedBox(height: 50),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h2,
                    ),
                    15.height,
                    Text(
                      subheading,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.body2,
                    ),
                    10.height,
                    AppButton(
                      onPressed: onTap ?? () {},
                      title: context.appText.continueText,
                      ).paddingSymmetric(horizontal: 15),
                  ],
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



tabWidget({
  required String text,
  bool selected = false,
  required GestureTapCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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

showCustomDialogue({
  required BuildContext context,
  required Widget child,
  Widget? child2,
  GestureTapCallback? onClickButton,
  required String buttonText,
  bool disableButton = false,
  bool hideButton = false,
}) {
  print("hideButton is $hideButton");

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
          Visibility(
          visible: hideButton,
            child: AppButton(
              style: !disableButton?AppButtonStyle.primary:AppButtonStyle.disableButton,
              title: buttonText,
              onPressed:!disableButton?
                  onClickButton ??
                  () {
                    // Handle verify action here
                    Navigator.pop(context);
                  }: (){},
            ),
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
    child: Image.asset(AppImage.png.translateImage, width: 23, height: 23),
  );
}

customerSupportWidget({required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Image.asset(AppImage.png.customerSupport, width: 32, height: 32),
  );
}

showAlertDialogue({
  required BuildContext context,
  required Widget child,
  required GestureTapCallback onClickYesButton,
  bool hideButtonButtons = false,
  String? yesButtonText,
  String? noButtonText,
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
                    child: AppButton(
                      buttonHeight: 32,
                      style: AppButtonStyle.outline,
                      title: noButtonText??"No",
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  16.width,

                  // Yes Button
                  Expanded(
                    child: AppButton(
                      buttonHeight: 32,
                      onPressed: onClickYesButton,
                      title: yesButtonText ?? "Yes",
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
    height: 24,
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: statusBackgroundColor,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Text(
        statusText,
        style: AppTextStyle.body4.copyWith(color: statusTextColor),
      ),
    ),
  );
}

draggableSheet({required List<Widget> child}) {
  return DraggableScrollableSheet(
    initialChildSize: 0.45, // 10% of screen
    minChildSize: 0.45, // Minimum size
    maxChildSize: 1, // Maximum size
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(spacing: 10, children: child),
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                height: 237,
                width: 237,
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
                onPressed: () async {
                  context.pop();
                  await callRedirect("10090-0008-2345");
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
