import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
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
     this.showButton=true,
  });

  final VpRecentLoadData data;
  final bool? showButton;
  final void Function()? onClickAssignDriver;

  @override
  State<VpAllLoadMyLoadWidget> createState() => _VpAllLoadMyLoadWidgetState();
}

class _VpAllLoadMyLoadWidgetState extends State<VpAllLoadMyLoadWidget> {
  @override
  Widget build(BuildContext context) {

    print("load status ${widget.data.loadStatus}");
    String amount=(widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"").trim()!="0" ?
    "$indianCurrencySymbol${widget.data.vpRate} - $indianCurrencySymbol${widget.data.vpMaxRate}":
    "$indianCurrencySymbol${(widget.data.vpRate??"").isNotEmpty ? widget.data.vpRate : "0000 - 0000"}";
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
                width: 50,
              ).paddingSymmetric(vertical: 10),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.loadId, style: AppTextStyle.h5),
                  // Text(
                  //   'TN 04 Y 2344',
                  //   style: AppTextStyle.textDarkGreyColor14w500,
                  // ),
                  Text(
                    formatDateTimeKavach(widget.data.createdAt!.toString()),
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
                        widget.data.pickUpLocation??"",
                        style: AppTextStyle.blackColor15w500,
                        maxLines: 2,
                      ),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: AppColors.primaryColor,
                      ).paddingSymmetric(horizontal: 2),
                      Text(
                        widget.data.dropLocation??"",
                        style: AppTextStyle.blackColor15w500,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  if(widget.data.loadStatus==3)
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
                  amount,
                  style: AppTextStyle.h4PrimaryColor,
                  textAlign: TextAlign.center,
                ).expand(),
              ],
            ),
          ),
          10.height,
          if(widget.showButton??true)
          Row(
            children: [
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
              10.width,
              AppButton(
                buttonHeight: 40,
                onPressed: widget.onClickAssignDriver ?? () {

                },
                title:"Assign Driver",
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