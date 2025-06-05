import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class KycPendingDialogue extends StatelessWidget {
  const KycPendingDialogue({super.key,required this.onPressed});
final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(hideDivider: false,body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10.h,
      children: [
        Center(child: SvgPicture.asset(AppImage.svg.kycPending)),
        Text("KYC Pending",style: AppTextStyle.orangeTextColor26w700,),
        Text("Please complete your KYC to accept load",style: AppTextStyle.textDarkGreyColor14w400,),
     AppButton(
onPressed: onPressed,
       title: "Go to KYC",
     )

      ],
    ));
  }
}
