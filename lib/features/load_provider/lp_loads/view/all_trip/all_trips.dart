import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../../utils/app_progress_bar.dart';
import '../../../../../utils/common_widgets.dart';

class AllTrips extends StatelessWidget {
  const AllTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(spacing: 10.h,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  decoration: commonInputDecoration(focusColor: AppColors.primaryColor,

                    prefixIcon: Icon(Icons.search,color: AppColors.primaryColor,),
                    fillColor: Colors.transparent,
                    hintText: "Search - lane, vehicle",
                  ),
                ),
              ),
              10.width,
              Container(height: 50.h,
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor,width: 0.8)),
                child: Image.asset(AppImage.png.filter,height: 24.h,width:24.h,),)
            ],
          ),
         Expanded(
           child: ListView.builder(
             shrinkWrap: true,
             itemCount: 13,
             physics: BouncingScrollPhysics(),
             itemBuilder: (context, index) {
             return allTripWidget();
           },),
         )
        ],
      ),
    );
  }

  allTripWidget(){
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor,width: 0.8)
      ),
      child:Column(mainAxisAlignment: MainAxisAlignment.start,
        spacing: 15.h,
        children: [
          Row(children: [
            Image.asset(AppImage.png.truck,width: 72.w,height: 49.h,),
            5.width,
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Textiles - 20 ft Container",style: AppTextStyle.textBlackColor14w400,),
                Text("GRO9884",style: AppTextStyle.textGreyColor10w400,),
              ],
            )),5.width,Container(height: 22.h,width:77.w ,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: AppColors.primaryColor,width: 0.8)),
              child: Center(child: Text("Upcoming",style: AppTextStyle.primaryColor12w400,)),



            ),

          ],),
          Row(children: [
            Icon(Icons.my_location,color: AppColors.greenColor,size: 15,),
            2.width,
            Text("Banglore",style: AppTextStyle.textDarkGreyColor12w400,),
            2.width,
            Expanded(
              child: DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity, // or set a fixed length
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Colors.grey,
                dashGapLength: 2.0,
              ),
            ), 2.width,
            Image.asset(AppImage.png.locationIcon,height:18.h ,width: 18.w,color: Colors.red,),

            Text("Chennai, Tamil Nadu",style: AppTextStyle.textDarkGreyColor12w400,),  ],),
          AppProgressBar(progress: 0.5),
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(08),
                border: Border.all(color: AppColors.primaryColor)
            ),
            child: Center(child: Text("Pay Now",style: AppTextStyle.primaryColor12w400,)),
          )


        ],
      ),
    );
  }

}




