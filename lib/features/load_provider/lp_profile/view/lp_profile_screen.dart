import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_style.dart';

class LpProfileScreen extends StatelessWidget {
  const LpProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      toolbarHeight: 50,
centerTitle: true,
      title: Text(context.appText.profile,style:AppTextStyle.textBlackColor18w500,),
    ),

    body: Column(spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          child:Text("Blue Membership ID: B12345",style: AppTextStyle.whiteColor14w400,),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [

            ],
          ),
        )
      ],
    ),
    );
  }
  profileWidget({required String imageString, required String text, }){
    return  Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Image.asset(AppImage.png.appIcon,height: 20.h,width: 20.w,),
          10.width,
          Text("Profile"),Expanded(child: SizedBox.shrink()),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
