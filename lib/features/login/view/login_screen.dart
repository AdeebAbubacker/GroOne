import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../routing/app_route_name.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/customButton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController phoneNumber=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,

        actions: [
          Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          SizedBox(width: 30.h),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.w),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  30.height,

                Text(
                  context.appText.loginSingUp,
                  style: AppTextStyle.textBlackColor30w500
                ),
          20.height,
                Text(
                  context.appText.enterMobileNumber,
                  style:AppTextStyle. textBlackColor18w400
                ),
                  20.height,
                Row(
                  spacing: 5.w,
                  children: [
                    Container(
                      height: 44.h,
                      width: 81.w,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderDisableColor),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            height: 18.h,
                            width: 27.w,
                            AppImage.png.flag,
                          ),
                          Text(
                            "+91",
                            style: AppTextStyle.textBlackColor16w400
                          ),
                        ],
                      ),
                    ),
               1.width,
                    Expanded(
                      child: Container(
                        height: 44.h,
                        width: 81.w,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.borderDisableColor,
                          ),
                        ),
                        child: TextFormField(
                          focusNode: focusNode,
                          onChanged: (va) {

                            if (va.length == 10) {
                            focusNode.unfocus();
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.number,
                          controller:  phoneNumber,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              20.height,
                CustomButton(
                  buttonText: context.appText.getOtp,
                  disable: true,
                  onClick: () {
                   context.push(AppRouteName.otpVerificationScreen);
                  },
                ),

                20.height,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(

                    children: [
                      TextSpan(
                        text: context.appText.agree,
                        style: AppTextStyle.blackColor14w400
                      ),
                      TextSpan(
                        text: context.appText.termsAndConditions,
                        style: AppTextStyle.primaryColor14w400UnderLine,
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Handle terms & conditions tap
                                debugPrint('Terms & Conditions tapped');
                              },
                      ),
                      TextSpan(
                        text: context.appText.and,
                        style: AppTextStyle.blackColor14w400
                      ),
                      TextSpan(
                        text: context.appText.privacyPolicy,
                        style: AppTextStyle.primaryColor14w400UnderLine,
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Handle privacy policy tap
                                debugPrint('Privacy Policy tapped');
                              },
                      ),
                    ],
                  ),
                ),
            1.height,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // controller.termsAgree.value =
                        //     !controller.termsAgree.value;
                        // controller.update();
                      },
                      child: Container(
                        height: 17.h,
                        width: 17.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child:
                            true
                                ? Center(child: Icon(Icons.check, size: 13.h))
                                : const SizedBox(),
                      ),
                    ),
                     5.width,
                    Text(
                      context.appText.iAgree,
                      style:AppTextStyle.textBlackColor12w400
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox.shrink()),
          Image.asset(AppImage.png.signUpBanner),
        ],
      ),
    );
  }
}
