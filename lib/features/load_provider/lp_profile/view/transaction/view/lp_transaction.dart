import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_text_style.dart';
import '../../../../../../utils/extra_utils.dart';

class LpTransaction extends StatefulWidget {
  const LpTransaction({super.key});

  @override
  State<LpTransaction> createState() => _LpTransactionState();
}

class _LpTransactionState extends State<LpTransaction> {
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.transactions,style:AppTextStyle.textBlackColor18w500,),
        toolbarHeight: 50.h,

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
        child: Column(
            spacing: 20.h,
            children: [
          Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

          tabWidget(text: context.appText.all,onTap: (){
            selectedIndex=0;
            setState(() {

            });
          },selected: selectedIndex==0?true:false),
            tabWidget(text: context.appText.pending,onTap: (){
              selectedIndex=1;
              setState(() {

              });
            },selected: selectedIndex==1?true:false),
            tabWidget(text: context.appText.completed,onTap: (){
              selectedIndex=2;
              setState(() {

              });
            },selected: selectedIndex==2?true:false),


        ]),
          AppTextField(decoration: commonInputDecoration(suffixIcon: Icon(Icons.search),  hintText: "Search",fillColor: AppColors.white),),
              selectedIndex==0?allWidget():selectedIndex==1?Center(child: Text("Pending"),):Center(child: Text("Completed"),)

        ]
        ),
      ),
    );
  }
allWidget(){
    return    Expanded(
      child: ListView.builder(

        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: 24,
        itemBuilder: (context, index) {
          return   ListTile(tileColor: AppColors.white,

            leading: Image.asset( !index.isEven?AppImage.png.pendingTransaction:AppImage.png.completedTransaction,height: 30.h,width: 30.w,),
            title: Text("₹820",style: AppTextStyle.textBlackDetailColor16w500,),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("GD12456 • Pune to Chennai",style: AppTextStyle.textGreyDetailColor12w400,),
                Text("22 Apr 2025, 3:45 PM",style: AppTextStyle.textGreyDetailColor12w400.copyWith(fontSize: 10.sp),),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color:
                index.isEven
                    ? AppColors.boxGreen
                    : AppColors.appRedColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(context.appText.pending, style: AppTextStyle.whiteColor14w400.copyWith(color:  index.isEven?AppColors.textGreen:AppColors.textRed)),
            ),
          );
        },),
    );
}

}
