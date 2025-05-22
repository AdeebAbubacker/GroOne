import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../../../routing/app_route_name.dart';
import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_text_style.dart';
import '../../../../../../utils/extra_utils.dart';

class LpMyAccount extends StatelessWidget {
  const LpMyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.myAccount,style:AppTextStyle.textBlackColor18w500,),
        toolbarHeight: 50.h,
actions: [  InkWell(onTap: (){
  context.push(AppRouteName.lpEditMyAccount);
},
  child: Text(context.appText.edit,style: AppTextStyle.primaryColor18w500UnderLine,),).paddingOnly(right: 10)
],
      ),

      body: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 18.0.w,vertical: 18.h),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20.h,
          children: [
  headingText(text: context.appText.personalDetails),

  10.width,
    detailWidget(text1: context.appText.name, text2: "Jhon Doe"),
      detailWidget(text1:context.appText.mobileNumber, text2: "7784026558"),
            dividerWidget(),

            headingText(text:context.appText.accountDetails),
            10.width,

            detailWidget(text1: context.appText.blueMembershipId, text2: "B123456"),
            detailWidget(text1: context.appText.accountType, text2: "Shipper"),
            detailWidget(text1: context.appText.registrationData, text2: "10-03-2022"),
            detailWidget(text1: context.appText.kycStatus, text2: "Verified"),
            dividerWidget(),

            headingText(text: context.appText.companyDetails),
            10.width,

            detailWidget(text1: context.appText.companyName, text2: "Bloom Cosmetic Pvt. Ltd"),
            detailWidget(text1: context.appText.gst, text2: "22AAAAA0000A1Z5"),

          ],
        ),
      ),
    );
  }


  detailWidget({required String text1,required String text2}){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1,style: AppTextStyle.textGreyDetailColor14w400,),
        Text(text2,style: AppTextStyle.textGreyDetailColor14w400,),
      ],
    );
  }
}
