import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_image.dart';
import '../../../../../../utils/app_text_style.dart';

class LpSetting extends StatelessWidget {
  const LpSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:   CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.settings,style:AppTextStyle.textBlackColor18w500,),
        toolbarHeight: 50.h,

      ),
      body: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 18.0.w,vertical: 18.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30.h,
          children: [
            headingText(text: "Notification"),
           10.width,
            notificationSwitchWidget(text: "Load Updates",selected: true,onTap: () {

           },),
            notificationSwitchWidget(text: "System Updates",selected: true,onTap: () {

           },),
            notificationSwitchWidget(text: "Payment Alerts",selected: true,onTap: () {

           },),
            notificationSwitchWidget(text: "Offers & Promotions",onTap: () {

           },),
            dividerWidget(),
            headingText(text: context.appText.language),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                languageRadioButtonWidget(text: "English", onTap: () {},selected: true),
                languageRadioButtonWidget(text: "Hindi", onTap: () {},),
                languageRadioButtonWidget(text: "Tamil", onTap: () {},),

               ],
            ),
            dividerWidget(),
            headingText(text: "Security"),
            notificationSwitchWidget(text: "Enable App Lock",selected: true,onTap: () {

            },),
          Column(
            children: [
              profileWidget(imageString: AppImage.png.document, text: "Terms & Conditions",onTap: (){}),
              profileWidget(imageString: AppImage.png.privacy, text: "Privacy Policy",onTap: (){}),
            ],
          )
          ],
        ),
      ),
    );
  }
languageRadioButtonWidget({required String text,  bool selected=false,required GestureTapCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(height: 14.w,width: 14.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                border: Border.all(color: selected?AppColors.primaryColor:AppColors.disableColor,width:selected?4: 2)

            ),

          ),10.width, Text(text,style: AppTextStyle.blackColor14w400,),

        ],
      ),
    );
}
  notificationSwitchWidget({required String text, bool selected=false,required GestureTapCallback onTap}){
    return  InkWell(onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              text,
              style: AppTextStyle.textBlackDetailColor14w400
          ),

          Container(decoration: BoxDecoration(
            color: selected?AppColors.primaryColor:AppColors.disableColor,
            borderRadius: BorderRadius.circular(50)
          ),
            height: 20.h,width: 40.w,
            child:Align(alignment: selected?Alignment.centerRight:Alignment.centerLeft,
                child: Icon(Icons.circle,color: AppColors.white,size: 20,))
          )
        ],
      ),
    );
  }
}
