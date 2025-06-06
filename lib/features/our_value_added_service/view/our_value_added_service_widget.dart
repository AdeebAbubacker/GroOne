import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/kavach/view/kavach_benefits_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_orders_list_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';

valueAddedService(BuildContext context) {
  return Container(
    decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(0)),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.w),
      child: Column(
        spacing: 20.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.appText.ourValueAddedServices,
                  style: TextStyle(
                    color: AppColors.textBlackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_outlined),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              valueAddedServiceWidget(
                title: context.appText.buyFastTag,
                imageString: AppImage.png.buyFastTag,
                onClick: () {
                  context.push(AppRouteName.buyFastag);
                },
              ),
              valueAddedServiceWidget(
                title: context.appText.enDan,
                imageString: AppImage.png.enDhan,
                onClick: () {
                  context.push(AppRouteName.enDhanCard);
                },
              ),
              valueAddedServiceWidget(
                title: context.appText.gps,
                imageString: AppImage.png.gps,
                onClick: () {
                  context.push(AppRouteName.gps);
                },
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              valueAddedServiceWidget(
                title: context.appText.instantLoan,
                imageString: AppImage.png.insuranceLoan,
                onClick: () {
                  context.push(AppRouteName.instantLoan);
                },
              ),
              valueAddedServiceWidget(
                title: context.appText.insurance,
                imageString: AppImage.png.insurance,
                onClick: () {
                  context.push(AppRouteName.insurance);
                },
              ),
              valueAddedServiceWidget(
                title: context.appText.kavach,
                imageString: AppImage.png.kavach,

                onClick: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => KavachOrdersListScreen(),
                      settings: RouteSettings(name: 'KavachOrderListScreen'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

valueAddedServiceWidget({
  required String title,
  required String imageString,
  required GestureTapCallback onClick,
}) {
  return InkWell(
    onTap: onClick,
    child: Container(
      width: 103.w,
      height: 90.h,
      decoration: BoxDecoration(
        color: Color(0xffE9F3FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageString, height: 26.h, width: 26.w),
          SizedBox(height: 5.h),
          Text(
            title,textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textBlackColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}