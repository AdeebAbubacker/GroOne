import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LPLoadListBodyWidget extends StatelessWidget{
  const LPLoadListBodyWidget({super.key, required this.type});

  final int type;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLoadIdDetailsWidget(),
            commonDivider(),
            buildPickupAndDropAddressWidget(),
            20.height,
            buildRateWidget(),
            10.height,
            if(type == 3)
            buildAgreeButtonWidget(context)
          ],
        )
    );
  }

  /// Load ID Details
  Widget buildLoadIdDetailsWidget() {
    return Row(
      children: [
        Container(
          decoration: commonContainerDecoration(
            color: Color(0xffDFE6FF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
        ),
        15.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  'GD12456',
                  style: AppTextStyle.h5,
                  maxLines: 2,
                ),
              ],
            ),
            8.height,
            Text(
              '12 Jul 2025, 6:30 AM',
              style: AppTextStyle.body4.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ).expand(),
        Column(
          children: [
            Container(
              decoration: commonContainerDecoration(
                color: AppColors.lightPurpleColor,
              ),
              width: 100.w,
              child: Text(
                type == 1 ? 'Matching..' : type == 2 ? 'Confirmed' : 'Assigned',
                style: TextStyle(color: AppColors.purpleColor),
              ).center().paddingAll(4),
            ),
            5.height,
            if(type == 1)
              Text(
                "43 Mins to Match",
                style: AppTextStyle.body4.copyWith(
                  color: AppColors.activeDarkGreenColor,
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// PickUp and Drop Address
  Widget buildPickupAndDropAddressWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
        Text(" Bangalore, Karnataka", style: AppTextStyle.body4.copyWith(fontSize: 12)),
        DottedLine(
          direction: Axis.horizontal,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashGapLength: 3.0,
        ).paddingOnly(right: 8, left: 12).expand(),
        Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
        Text("Chennai, Tamil Nadu", style: AppTextStyle.body4.copyWith(fontSize: 12)),
      ],
    );
  }

  /// Rate
  Widget buildRateWidget() {
    return Container(
      decoration: commonContainerDecoration(
        color: AppColors.primaryLightColor,
        borderRadius: BorderRadius.circular(commonButtonRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Agreed Price", style: AppTextStyle.body2),
          Text(
            type == 1 ? "${indianCurrencySymbol}79,000 - ${indianCurrencySymbol}85,000" : "${indianCurrencySymbol}79,000",
            style: AppTextStyle.h4.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ).paddingAll(8),

    );
  }

  /// Agree Button
  Widget buildAgreeButtonWidget(BuildContext context) {
    return Row(
      children: [
        AppButton(
          buttonHeight: 40,
          onPressed: () {},
          title: context.appText.iAgree,
        ).expand(),
        10.width,
        IconButton(
          onPressed: () {
            commonSupportDialog(context);
          },
          icon: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            child: SvgPicture.asset(
              AppIcons.svg.support,
              width: 25,
              colorFilter: AppColors.svg(AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
