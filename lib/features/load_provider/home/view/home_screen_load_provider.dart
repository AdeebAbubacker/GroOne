import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../our_value_added_service/view/our_value_added_service_widget.dart';

class HomeScreenLoadProvider extends StatelessWidget {
  const HomeScreenLoadProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: (){
              context.push(AppRouteName.vpBottomNavigationBar);
            },
            child: Image.asset(
              AppImage.png.appIcon,
              height: 33.h,
              width: 75.w,
              scale: 1,
            ),
          ),
        ),
        actions: [
          Container(
            height: 36.h,
            width: 36.w,
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                "KYC",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          20.width,

        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey.shade200, thickness: 3),
          valueAddedService(context),
          Divider(color: Colors.grey.shade200, thickness: 3),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.h,
              children: [
                Text(
                  context.appText.bookShipment,
                  style: AppTextStyle.textBlackColor18w500,
                ),

                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderDisableColor,
                      width: 0.6.w,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.backGroundBlue,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImage.png.bookAShipment,
                        height: 86.h,
                        width: 18.h,
                      ),
                        10.width,
                      Expanded(
                        child: Column(
                          children: [
                            bookShipment(
                              heading: "Source",
                              subHeading: "Select pickup point",
                              onClick: () {},
                            ),

                            Divider(
                              color: AppColors.disableColor,
                              thickness: 0.5,
                            ),
                            bookShipment(
                              heading: "Destination",
                              subHeading: "Select destination",
                              onClick: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bookShipment({
    required String heading,
    required String subHeading,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.h,
            children: [
              Text(
                heading,
                style:  AppTextStyle.textGreyColor12w400,
              ),
              Text(
                subHeading,
                style: AppTextStyle.textBlackColor12w400
              ),
            ],
          ),
          Image.asset(AppImage.png.locationIcon, height: 18.h, width: 18.w),
        ],
      ),
    );
  }


}
