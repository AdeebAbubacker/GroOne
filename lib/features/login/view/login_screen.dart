import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

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
                SizedBox(height: 30.h),

                Text(
                  context.appText.loginSingUp,
                  style: TextStyle(
                    color: AppColors.textBlackColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  context.appText.enterMobileNumber,
                  style: TextStyle(
                    color: AppColors.textBlackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
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
                            style: TextStyle(
                              color: AppColors.textBlackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 1.w),
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
                SizedBox(height: 20.h),
                CustomButton(
                  buttonText: context.appText.getOtp,
                  disable: true,
                  onClick: () {
                    //Get.toNamed(ScreensNames.loginScreen);
                  },
                ),

                SizedBox(height: 20.h),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    children: [
                      TextSpan(
                        text: context.appText.agree,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: context.appText.termsAndConditions,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Handle terms & conditions tap
                                debugPrint('Terms & Conditions tapped');
                              },
                      ),
                      TextSpan(
                        text: context.appText.and,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: context.appText.privacyPolicy,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
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
                SizedBox(height: 1.h),
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
                    SizedBox(width: 5.w),
                    Text(
                      context.appText.iAgree,
                      style: TextStyle(
                        color: AppColors.textBlackColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
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
