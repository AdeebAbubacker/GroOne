import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../../utils/app_icons.dart';

class MyLoadsListBody extends StatefulWidget {
  const MyLoadsListBody( {super.key,required this.data,required this.onClickAssignDriver});
final VpLoadsList data;
final void Function()?  onClickAssignDriver;

  @override
  State<MyLoadsListBody> createState() => _MyLoadsListBodyState();
}

class _MyLoadsListBodyState extends State<MyLoadsListBody> {
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
                      Text(widget.data.pickUpAddr, style: AppTextStyle.h4w500),
                      Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
                      Expanded(child: Text(widget.data.dropAddr, style: AppTextStyle.h4w500.copyWith(overflow: TextOverflow.ellipsis))),
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
                  Text(widget.data.truckType!.subType, style: AppTextStyle.body),
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
                  Text(widget.data.commodity!.name, style: AppTextStyle.body),
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
              Text("${widget.data.consignmentWeight} Tonn", style: AppTextStyle.body),
            ],
          ),
          20.height,
          AppButton(
            buttonHeight: 32.h,
            onPressed: widget.onClickAssignDriver,
            title: "Assign Driver",
            style: AppButtonStyle.outline,
          )
        ],
      ),
    );
  }
}
