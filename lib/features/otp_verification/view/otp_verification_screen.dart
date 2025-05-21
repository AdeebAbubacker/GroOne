import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/customButton.dart';
import '../../../utils/extra_utils.dart';


class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
      backgroundColor: Colors.transparent,

      actions: [
        Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
         30.width,
      ],
    ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 18.0.h,
              horizontal: 20.w,
            ),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


         50.height,
                Text(
                  context.appText.otpVerification,
                  style: AppTextStyle.textBlackColor30w500
                ),
                 20.height,
                Row(
                  children: [
                    Expanded(
                      child: Text(textAlign: TextAlign.center,
                        context.appText.enterOtpSendNumber,
                        style: AppTextStyle.textBlackColor18w400
                      ),
                    ),
                    Text(
                      maskPhoneNumber("9876541234"),
                      style:AppTextStyle.primaryColor18w400UnderLine
                    ),
                  ],
                ),
                20.height,
                Center(
                  child: OtpTextField(
                    numberOfFields: 4,
                    showFieldAsBox: true,
                    fieldWidth: 60,
                    borderColor: AppColors.borderDisableColor,
                    onCodeChanged: (String code) {},

                    onSubmit: (String verificationCode) {
                      // controller.otp.value.text = verificationCode;
                      // controller.update();
                    }, // end
                  ),
                ),
            20.height,

                CustomButton(
                  disable:true,
              //    controller.otp.value.text.length == 4 ? true : false,
                  onClick: () {
                    showSuccessDialog(
                      context,
                      text: context.appText.loginSuccessful,
                      subheading: context.appText.loginSuccessfulSubHeading,
                    );
                    Future.delayed(const Duration(seconds: 2),(){
                      Navigator.pop(context);
                    context.push(AppRouteName.lpBottomNavigation);
                    });

                  },
                  buttonText: context.appText.verifyCode,
                ),
                 5.height,
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        context.appText.resend,
                        style:AppTextStyle.primaryColor16w900
                      ),
                    ),
                  ),
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
