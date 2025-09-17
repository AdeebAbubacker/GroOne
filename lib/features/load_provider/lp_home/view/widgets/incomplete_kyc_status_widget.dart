import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class IncompleteKycStatusWidget extends StatelessWidget {
  final num? companyId;
  IncompleteKycStatusWidget({super.key, required this.companyId});
  final securePrefs = locator<SecuredSharedPreferences>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
      color: AppColors.lightRedColor,
      height: 60,
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(AppImage.png.alertTriangle, width: 20),
              10.width,

              Flexible(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                
                      TextSpan(text: context.appText.your, style: AppTextStyle.textDarkGreyColor14w500),
                
                      TextSpan(text: "  ${context.appText.kyc}  ", style: AppTextStyle.textDarkGreyColor14w500.copyWith(color: AppColors.orangeTextColor)),
                
                      TextSpan(text: context.appText.isIncomplete, style: AppTextStyle.textDarkGreyColor14w500,),
                    ],
                  ),
                ),
              ),

            ],
          ).expand(),

          // Verify KYC button
          TextButton(
            onPressed: () async{
              bool isKycCompleted = await securePrefs.getBooleans(AppString.sessionKey.iskycAdarWebview);
              bool isAadharVerified = await securePrefs.getBooleans(AppString.sessionKey.aadharVerified);
              String? aadhaarNumber = await securePrefs.get(AppString.sessionKey.aadharNumber);
              String? aadhaarPDF = await securePrefs.get(AppString.sessionKey.aadharPdf);

              final extra = { 'aadhaarNumber': aadhaarNumber, 'pdfPath': aadhaarPDF};


              if (companyId != null && (companyId == 2 || companyId == 1)) {
                if ((isKycCompleted || isAadharVerified) && context.mounted) {
                  context.push(AppRouteName.kycUploadDocument, extra: extra);
                } else{
                  if(context.mounted) {
                    commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                  }
                }

              } else {
                if(context.mounted) {
                  context.push(AppRouteName.kycUploadDocument, extra: extra);
                }
              }
            },
            style: AppButtonStyle.primaryTextButton.copyWith(backgroundColor: WidgetStateProperty.all(AppColors.red)),
            child: Text(context.appText.verify, style: AppTextStyle.h5WhiteColor),
          ),
       
       
        ],
      ),
    );
  }
}
