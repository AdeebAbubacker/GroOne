import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class RecentAddedLoadListBody extends StatelessWidget {
  const RecentAddedLoadListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor, borderWidth: 1),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Chennai", style: AppTextStyle.h4w500),
                      Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
                      Text("Pune", style: AppTextStyle.h4w500),
                    ],
                  ),
                  Text("GD12456", style: AppTextStyle.body3GreyColor),
                ],
              ),

              leading: Container(
                decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor, borderRadius: BorderRadius.circular(100)),
                child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
              ),

              trailing: SvgPicture.asset(AppIcons.svg.support)
          ),


          commonDivider(),

          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
                  10.width,
                  Text("20 ft Closed Truck", style: AppTextStyle.body),
                ],
              ).expand(),
              statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
            ],
          ),
          10.height,

          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppIcons.svg.package),
                  10.width,
                  Text("Construction Material", style: AppTextStyle.body),
                ],
              ).expand(),
              Text("${indianCurrencySymbol}1000", style: AppTextStyle.h4),
            ],
          ),
          20.height,
          Row(
            children: [
              SvgPicture.asset(AppIcons.svg.package),
              10.width,
              Text("5 Ton", style: AppTextStyle.body),
            ],
          ),
          20.height,
          AppButton(
            onPressed: (){},
            title: context.appText.accept,
            style: AppButtonStyle.outline,
          )
        ],
      ),
    );
  }
}
