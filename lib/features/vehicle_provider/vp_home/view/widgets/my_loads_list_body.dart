import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../../routing/app_route_name.dart';
import '../../../../../utils/app_dialog.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/common_dialog_view/common_dialog_view.dart';
import '../../../../../utils/common_dialog_view/success_dialog_view.dart';

class MyLoadsListBody extends StatefulWidget {
  const MyLoadsListBody({
    super.key,
    required this.data,
    required this.onClickAssignDriver,
  });

  final VpLoadsList data;
  final void Function()? onClickAssignDriver;

  @override
  State<MyLoadsListBody> createState() => _MyLoadsListBodyState();
}

class _MyLoadsListBodyState extends State<MyLoadsListBody> {
  @override
  Widget build(BuildContext context) {
    String amount=(widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"").trim()!="0" ?
    "$indianCurrencySymbol${widget.data.vpRate} - $indianCurrencySymbol${widget.data.vpMaxRate}":
    "$indianCurrencySymbol${(widget.data.vpRate??"").isNotEmpty ? widget.data.vpRate : "0000 - 0000"}";


    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: commonContainerDecoration(
        borderColor: AppColors.primaryColor,
        color: AppColors.blackishWhite,
        borderWidth: 1,
      ),
      child: Column(
        spacing: 3,
        children: [
          ListTile(
            minVerticalPadding: 0.0,
            tileColor: Colors.red,
            style: ListTileStyle.drawer,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 5,
            minTileHeight: 60,
            titleAlignment: ListTileTitleAlignment.bottom,
            leading: Image.asset(
              AppImage.png.truckMyLoad,
              width: 50,
            ).paddingSymmetric(vertical: 10),
            title: Text('${widget.data.loadId}', style: AppTextStyle.h5),
            subtitle: Text(
              formatDateTimeKavach(widget.data.dueDate!.toString()),
              style: AppTextStyle.primaryColor12w400,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                if(widget.data.assignStatus==3)
                Text('Confirmed', style: AppTextStyle.bodyPurpleColor),
                if(widget.data.assignStatus==4)
                  Text('Assigned', style: AppTextStyle.bodyPurpleColor.copyWith(
                    color: AppColors.activeDarkGreenColor
                  ))
              ],
            ),
          ),

          //
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //
          //     10.width,
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('${widget.data.loadId}', style: AppTextStyle.h5),
          //
          //         Text(
          //           formatDateTimeKavach(widget.data.dueDate!.toString()),
          //           style: AppTextStyle.primaryColor12w400,
          //         ),
          //
          //
          //       ],
          //     ).expand(),
          //     5.width,
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //
          //         Text('Confirmed', style: AppTextStyle.bodyPurpleColor),
          //       ],
          //     ).expand(),
          //   ],
          // ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.data.pickUpWholeAddr??"",

                  style: AppTextStyle.blackColor15w500.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Icon(
                  Icons.arrow_right_alt_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.data.dropWholeAddr??"",
                    style: AppTextStyle.blackColor15w500.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          commonDivider(height: 3),

          //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")

          10.height,

          Row(
            children: [

              Column(
                children: [
                  detailWidget(
                    text: widget.data.truckType?.type ?? "--",
                    iconSvg: AppIcons.svg.deliveryTruckSpeed,
                  ),
                  detailWidget(
                    text: widget.data.commodity?.name ?? "--",
                    iconSvg: AppIcons.svg.package,
                  ),
                ],
              ).expand(),
              Column(
                children: [
                  detailWidget(
                    text: widget.data.truckType?.subType ?? "--",
                    iconSvg: AppIcons.svg.deliveryTruckSpeed,
                  ),
                  detailWidget(
                    text: "${widget.data.consignmentWeight} Tonn",
                    iconSvg: AppIcons.svg.weight,
                  ),
                ],
              ).expand(),
              GestureDetector(
                onTap: () {
                  context.push(AppRouteName.loadDetailsScreen,extra: {
                    "loadId":widget.data.id
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyIconColor),
                  ),
                  child: Icon(Icons.chevron_right),
                ),
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
                ).expand()
                // Text(
                //   "$indianCurrencySymbol${(widget.data.vpRate??"").isNotEmpty ? widget.data.vpRate : "0000 - 0000"}",
                //   style: AppTextStyle.h4PrimaryColor,
                //   textAlign: TextAlign.center,
                // ).expand(),
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
                onPressed: widget.onClickAssignDriver ?? () {},
                title: "Assign Driver",
                    // widget.data.assignStatus == 2
                    //     ?
                    //     : "Start Trip",
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
    );
  }
}
