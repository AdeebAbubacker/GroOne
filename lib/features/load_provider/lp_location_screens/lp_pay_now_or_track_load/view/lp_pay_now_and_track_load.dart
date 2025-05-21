import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../../utils/app_image.dart';

class LpPayNowAndTrackLoad extends StatelessWidget {
  const LpPayNowAndTrackLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Banglore - Chennai"),
      body: Stack(
        children: [
          Center(child: Text("Map  View")),
          draggableSheet(
            child: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.h,
                  horizontal: 20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        5.height,
                        Text(
                          "Trip Lane",
                          style: AppTextStyle.veryLightGreyColor14w400,
                        ),
                        Text(
                          "Bangalore - Chennai",
                          style: AppTextStyle.lightBlackColor14w500,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        5.height,
                        Text(
                          "Trip Date",
                          style: AppTextStyle.veryLightGreyColor14w400,
                        ),
                        Text(
                          "Bangalore - Chennai",
                          style: AppTextStyle.lightBlackColor14w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.h,
                  horizontal: 20.w,
                ),

                color: AppColors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImage.png.bookAShipment,
                      height: 82.h,
                      width: 18.h,
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          bookShipmentWidget(
                            heading: "Pickup Point",
                            subHeading: "23, Whitefield, Bangalore",
                            onClick: () {},
                          ),

                          10.height,
                          bookShipmentWidget(
                            heading: "Drop Point",
                            subHeading: "1/34 A, Sriperumbuthur, Chennai",
                            onClick: () {},
                          ),
                          10.height,
                          Text(
                            "Estimated Time of Arrival - 8 May 2025, 8.30 PM",
                            style: AppTextStyle.textGreyColor12w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              tileWidget(
                headingText: "Vehicle Details",
                statusText: "Yet To Assign",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Text("Ashok Leyland - Boss 1920",style: AppTextStyle.lightBlackColor14w500,),
                    5.height,
                    Text("TN02 UY4356",style: AppTextStyle.primaryColor14w700,)
                  ],
                )
              ),
              tileWidget(
                headingText: "Driver Details",
                statusText: "Yet To Assign",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.height,
                      Text("Dinesh Kumar",style: AppTextStyle.lightBlackColor14w500,),
                      5.height,
                      Text("+91 9876543210",style: AppTextStyle.primaryColor14w700,)
                    ],
                  )
              ),
              tileWidget(
                headingText: "Payment Details",
                statusText: "Pending",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child: Column(spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Text(
                      context.appText.advancePayment,
                      style: AppTextStyle.darkDividerColor16w400,
                    ), Text(
                      "80% advance",
                      style: AppTextStyle.darkDividerColor16w400,
                    ),
                    Text(
                      '₹12000',
                      style: AppTextStyle.textBlackColor26w700.copyWith(fontSize: 20.sp),
                    ),
                   AppButton(title: "Pay Now")

                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  tileWidget({
    required String headingText,
    required String statusText,
    required Color statusTextColor,
    required Color statusBackgroundColor,
      Widget? child,
  }) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headingText, style: AppTextStyle.textBlackColor18w500),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: child??const SizedBox()), Container(
                height: 24.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w,),
                decoration: BoxDecoration(
                  color: statusBackgroundColor,

                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    statusText,
                    style: AppTextStyle.whiteColor14w400.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bookShipmentWidget({
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
            spacing: 2.h,
            children: [
              Text(heading, style: AppTextStyle.textGreyColor12w400),
              Text(subHeading, style: AppTextStyle.textBlackColor12w400),
            ],
          ),
        ],
      ),
    );
  }
}
