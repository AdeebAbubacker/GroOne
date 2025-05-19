import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../../utils/common_widgets.dart';

class AllTrips extends StatelessWidget {
  const AllTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
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
        ],
      ),
    );
  }
}
