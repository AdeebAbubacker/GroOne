import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/extra_utils.dart';

class LpProfileScreen extends StatelessWidget {
  const LpProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBar(
        backgroundColor: Colors.transparent,
      title: Text(context.appText.profile,style:AppTextStyle.textBlackColor18w500,),
        toolbarHeight: 50.h,

      ),


    body: SingleChildScrollView(
      child: Column(spacing: 15.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          15.width,
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circle profile image
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(AppImage.png.appIcon), // Replace with your image
                ),
                // Blue edit button at the bottom-right
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor
      
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Text("Sachin Mehta",style: AppTextStyle.blackColor15w500,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor,
            ),
            child:Text("${context.appText.blueMembershipId} : qwesd123",style: AppTextStyle.whiteColor14w400,),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                profileWidget(imageString: AppImage.png.user, text: context.appText.myAccount,onTap: (){
                  context.push(AppRouteName.lpMyAccount);


                }),
                dividerWidget(),
                profileWidget(imageString: AppImage.png.transaction, text: context.appText.transactions,onTap: (){
                  context.push(AppRouteName.lpTransaction);
                }),
                dividerWidget(),
                profileWidget(imageString: AppImage.png.settings, text: context.appText.settings,onTap: (){
                  context.push(AppRouteName.lpSetting);
                }),
                dividerWidget(),
                profileWidget(imageString: AppImage.png.support, text: context.appText.support,onTap: (){
                  context.push(AppRouteName.lpSupport);
                }),
                dividerWidget(),
                profileWidget(imageString: AppImage.png.logOut, text: context.appText.logOut,onTap: (){},showArrow: false),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
  dividerWidget(){
    return   Divider(color: AppColors.dividerColor,thickness: 0.5,indent: 20,endIndent: 20,);
  }

}
