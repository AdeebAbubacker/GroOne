import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class IncompleteKycStatusWidget extends StatelessWidget {
  const IncompleteKycStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
      color: Colors.red.shade50,
      height: 60,
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(AppImage.png.alertTriangle, width: 20),
              10.width,

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [

                    TextSpan(text: context.appText.your, style: AppTextStyle.textDarkGreyColor14w500),

                    TextSpan(text: "  ${context.appText.kyc}  ", style: AppTextStyle.textDarkGreyColor14w500.copyWith(color: AppColors.orangeTextColor)),

                    TextSpan(text: "is incomplete", style: AppTextStyle.textDarkGreyColor14w500,),
                  ],
                ),
              ),

            ],
          ).expand(),

          // Verify KYC button
          TextButton(
            onPressed: () {
              commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
            },
            style: AppButtonStyle.primaryTextButton.copyWith(backgroundColor: WidgetStateProperty.all(Colors.redAccent)),
            child: Text("Verify", style: AppTextStyle.h5WhiteColor),
          ),
        ],
      ),
    );
  }
}
