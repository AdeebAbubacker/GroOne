import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../../utils/app_button.dart';
import '../../../../../utils/app_button_style.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_text_style.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/common_widgets.dart';
import '../../../../../utils/constant_variables.dart';

class VpAllLoadMyLoadWidget extends StatefulWidget {
  const VpAllLoadMyLoadWidget({
    super.key,
    required this.data,
    required this.onClickAssignDriver,
  });

  final VpRecentLoadData data;
  final void Function()? onClickAssignDriver;

  @override
  State<VpAllLoadMyLoadWidget> createState() => _VpAllLoadMyLoadWidgetState();
}

class _VpAllLoadMyLoadWidgetState extends State<VpAllLoadMyLoadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: commonContainerDecoration(
        borderColor: AppColors.primaryColor,
        borderWidth: 1,
        color: AppColors.blackishWhite,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImage.png.truckMyLoad,
                width: 50.w,
              ).paddingSymmetric(vertical: 10),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GD 34567', style: AppTextStyle.h5),
                  // Text(
                  //   'TN 04 Y 2344',
                  //   style: AppTextStyle.textDarkGreyColor14w500,
                  // ),
                  Text(
                    formatDateTimeKavach(widget.data.dueDate!.toString()),
                    style: AppTextStyle.primaryColor12w400,
                  ),
                ],
              ).expand(),
              5.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    children: [
                      Text(
                        widget.data.pickUpAddr,
                        style: AppTextStyle.blackColor15w500,
                        maxLines: 2,
                      ),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: AppColors.primaryColor,
                      ).paddingSymmetric(horizontal: 2),
                      Text(
                        widget.data.dropAddr,
                        style: AppTextStyle.blackColor15w500,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Text('Confirmed', style: AppTextStyle.bodyPurpleColor),
                ],
              ).expand(),
            ],
          ),

          commonDivider(),
          //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
          Row(
            children: [
              detailWidget(
                text: widget.data.truckType?.type ?? "--",
                iconSvg: AppIcons.svg.deliveryTruckSpeed,
              ),
              detailWidget(
                text: widget.data.truckType?.subType ?? "--",
                iconSvg: AppIcons.svg.deliveryTruckSpeed,
              ),
            ],
          ),
          10.height,
          Row(
            children: [
              detailWidget(
                text: widget.data.commodity?.name ?? "--",
                iconSvg: AppIcons.svg.package,
              ),
              detailWidget(
                text: "${widget.data.consignmentWeight} Tonn",
                iconSvg: AppIcons.svg.weight,
              ),
            ],
          ),
          15.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryLightColor,
            ),
            child: Row(
              children: [
                Text(
                  "Accepted Price",
                  style: AppTextStyle.textBlackColor18w400,
                  textAlign: TextAlign.center,
                ).expand(),
                Text(
                  "$indianCurrencySymbol${widget.data.rate.isNotEmpty ? widget.data.rate : "0000 - 0000"}",
                  style: AppTextStyle.h4PrimaryColor,
                  textAlign: TextAlign.center,
                ).expand(),
              ],
            ),
          ),
          10.height,
          Row(
            children: [
              IconButton(
                onPressed: () {
                  commonSupportDialog(context);
                },
                icon: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsetsGeometry.all(5),
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
              10.width,
              AppButton(
                buttonHeight: 40,
                onPressed: widget.onClickAssignDriver ?? () {},
                title:
                widget.data.assignStatus == 0
                    ? "Assign Driver"
                    : "Start Trip",
                style: AppButtonStyle.primary,
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailWidget({required String text, required String iconSvg}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSvg,
          width: 18,
          colorFilter: AppColors.svg(AppColors.black),
        ),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    ).expand();
  }
}