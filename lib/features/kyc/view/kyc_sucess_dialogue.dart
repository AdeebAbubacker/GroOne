import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class KycSuccessDialogue extends StatelessWidget {
  const KycSuccessDialogue();

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(hideDivider: false,body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10.h,
      children: [
        Center(child: SvgPicture.asset(AppImage.svg.kycSuccess)),
        Text("KYC Submitted for\napproval",textAlign: TextAlign.center,style: AppTextStyle.greenColor20w700.copyWith(fontSize: 26.sp),),
        Text("Will get back to you within 48 hours.",style: AppTextStyle.textDarkGreyColor14w400,),


      ],
    ));
  }
}
