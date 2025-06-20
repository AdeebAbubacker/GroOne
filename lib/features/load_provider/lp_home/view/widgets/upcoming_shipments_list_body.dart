import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/LPGetLoadModel.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class UpcomingShipmentsListBody extends StatelessWidget {
  final LoadData loadData;
  const UpcomingShipmentsListBody({super.key, required this.loadData});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(15),
      decoration: commonContainerDecoration(color: Colors.white, borderColor: AppColors.primaryColor),
      child: Column(
        children: [

          Row(
            children: [
              Image.asset(AppImage.png.shipmentBox, height: 45, width: 45),
              10.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Text(context.appText.idNumber, style: AppTextStyle.body4, maxLines: 1),
                  Text("GD12456", style: AppTextStyle.h5,  maxLines: 1),
                  Text(loadData.dueDate != null ? DateTimeHelper.formatCustomDate(loadData.dueDate!) : "--", style: AppTextStyle.body4PrimaryColor),
                ],
              ).expand(),


              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   decoration: commonContainerDecoration(color: AppColors.lightPurpleColor, borderRadius: BorderRadius.circular(100)),
              //   child: Text("Sourcing", style: AppTextStyle.body4.copyWith(color: AppColors.purpleColor,),
              //   ),
              // ),
              // 10.width,

              // KYC Hours Timer
              if(loadData.loadStatusDetails != null && loadData.loadStatusDetails!.loadType.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: commonContainerDecoration(color: LpHomeHelper.getLoadStatusColor(loadData.loadStatusDetails!.loadType)),
                      child: Text(loadData.loadStatusDetails!.loadType, style: AppTextStyle.body4PrimaryColor.copyWith(color:  LpHomeHelper.getLoadStatusTextColor(loadData.loadStatusDetails!.loadType))),
                    ),
                    5.height,

                    // Matching Timer
                    if (loadData.loadStatusDetails?.loadType == LpHomeHelper.getLoadTypeDisplayText(loadData.loadStatusDetails!.loadType))
                      // Text(LpHomeHelper.getMatchingTime(loadData.createdAt.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5)
                      BlocBuilder<LPHomeCubit, LPHomeState>(
                        buildWhen: (p, c) => p.matchingText != c.matchingText,
                        builder: (context, state) {
                          return Text(
                            state.matchingText ?? "00:00:00",
                            style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                          );
                        },
                      )
                    else
                    if (loadData.loadStatusDetails?.loadType == "KYC Pending")
                      if(loadData.customer?.createdAt != null)
                        Text(LpHomeHelper.getKycPendingTimeLeft(loadData.customer!.createdAt.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5),

                  ],
                ).expand(),
            ],
          ),

          commonDivider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
                  5.width,
                  Text(loadData.pickUpLocation, style: AppTextStyle.body2, maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                ],
              ).expand(),

              DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity, // or set a fixed length
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Colors.grey,
                dashGapLength: 3.0,
              ).paddingSymmetric(horizontal: 10).expand(),

              //Icon(Icons.arrow_forward, color: AppColors.primaryColor).paddingSymmetric(horizontal: 15),

              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
                  5.width,
                  Text(loadData.dropLocation,  style: AppTextStyle.body2, maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                ],
              ).expand(),
            ],
          ),
          20.height,

          Container(
            decoration: commonContainerDecoration(color: AppColors.lightBlueColor, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Agreed Price", style: AppTextStyle.body1Normal),
                Text(PriceHelper.formatINR(loadData.rate), style: AppTextStyle.h3PrimaryColor),
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 10),
          ),

        ],
      ),
    );
  }
}
