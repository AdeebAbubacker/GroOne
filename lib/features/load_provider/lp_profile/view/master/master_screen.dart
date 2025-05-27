import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../../utils/app_application_bar.dart';
import '../../../../../utils/app_text_style.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text("Masters", style: AppTextStyle.textBlackColor18w500),
        toolbarHeight: 50.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 23,
          physics: BouncingScrollPhysics(),

          itemBuilder: (context, index) {
          return masterInfoWidget();
        },)
      ),
    );
  }

  masterInfoWidget(){
    return   Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          Text(
            "Address1",
            style: AppTextStyle.textBlackDetailColor15w500,
          ),
          Row(
            children: [
              SvgPicture.asset(
                AppImage.svg.location,
                height: 47.h,
                width: 20.h,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "45, Maple Avenue, Greenfield, Karnataka, 560034",
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                    10.height,
                    Text(
                      "45, Maple Avenue, Greenfield, Karnataka, 560034",
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
