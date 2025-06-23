import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';


class MemoOtpDialogWidget extends StatelessWidget {
  const MemoOtpDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialogView(
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Verify OTP',
                  style: AppTextStyle.h3.copyWith(fontSize: 26, color: AppColors.primaryColor),
                ),
                TextSpan(
                  text:
                  '  for confirming your\n  load We have sent an OTP to your\n registered mobile number. ',
                  style: AppTextStyle.body2.copyWith(height: 1.9),
                ),
                TextSpan(
                  text: context.appText.needHelp,
                  style: AppTextStyle.primaryColor14w400UnderLine,
                  recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      // Handle terms & conditions tap
                      debugPrint('Terms & Conditions tapped');
                    },
                ),
              ],
            ),
          ),
          30.height,
          Center(
            child: OtpTextField(
              numberOfFields: 4,
              showFieldAsBox: true,
              fieldWidth: 50,
              fieldHeight: 50,
              fillColor: Color(0xffF8F8F8),
              filled: true,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              borderColor: AppColors.borderDisableColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                // controller.otp.value.text = verificationCode;
                // controller.update();
              }, // end
            ),
          ),
          30.height,
          AppButton(
            style: AppButtonStyle.primary,
            title: 'Verify OTP',
            onPressed: () {},
          ),
          20.height,
          InkWell(
            onTap: () {},
            child: SizedBox(
              child: Center(
                child: Text(
                  "Resend OTP",
                  style: AppTextStyle.textBlackColor14w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
