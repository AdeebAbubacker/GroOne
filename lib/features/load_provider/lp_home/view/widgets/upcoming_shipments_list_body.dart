import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
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

                    if (loadData.loadStatusDetails?.loadType == LpHomeHelper.getLoadTypeDisplayText(loadData.loadStatusDetails!.loadType))
                      // Text(LpHomeHelper.getMatchingTime(loadData.createdAt.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5)
                      BlocBuilder<LPHomeCubit, LPHomeState>(
                        buildWhen: (p, c) => p.remainingTime != c.remainingTime,
                        builder: (context, state) {
                          final remaining = state.remainingTime ?? Duration.zero;

                          if (remaining == Duration.zero) {
                            return Text("00:00:00", style: AppTextStyle.body4.copyWith(color: Colors.red));
                          }

                          final hours = remaining.inHours;
                          final minutes = remaining.inMinutes % 60;
                          final seconds = remaining.inSeconds % 60;

                          return Text(
                            "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                            style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                          ).paddingRight(5);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Text(loadData.dueDate != null ? DateTimeHelper.formatCustomDate(loadData.dueDate!) : "--", style: AppTextStyle.body4GreyColor),
                  Row(
                    children: [
                      Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
                      5.width,
                      Text(loadData.pickUpAddr, style: AppTextStyle.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),

              DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity, // or set a fixed length
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Colors.grey,
                dashGapLength: 3.0,
              ).paddingOnly(right: 8, left: 12).expand(),

              //Icon(Icons.arrow_forward, color: AppColors.primaryColor).paddingSymmetric(horizontal: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text(loadData.dueDate != null ? DateTimeHelper.formatCustomDate(loadData.dueDate!) : "--",  style: AppTextStyle.body4GreyColor),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
                      5.width,
                      Text(loadData.dropAddr,  style: AppTextStyle.body2, maxLines: 1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          20.height,

          Container(
            decoration: commonContainerDecoration(color: AppColors.lightBlueColor, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Agreed Price", style: AppTextStyle.body1Normal),
                Text("₹${loadData.rate}", style: AppTextStyle.h3PrimaryColor),
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 10),
          ),

          //20.height,


          // if (memoDone)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //
          //         AppButton(
          //           buttonHeight: 40,
          //           style: AppButtonStyle.outline,
          //           title: "Pay Now",
          //           onPressed: () {
          //             context.push(AppRouteName.lpPayNowAndTrackLoad);
          //           },
          //         ).expand(),
          //         15.width,
          //
          //         AppButton(
          //           buttonHeight: 40,
          //           style: AppButtonStyle.outline,
          //           title: "Track Load",
          //           onPressed: () {
          //             context.push(AppRouteName.lpPayNowAndTrackLoad);
          //           },
          //         ).expand(),
          //
          //       ],
          //     )
          //   else
          //      AppButton(
          //        buttonHeight: 40,
          //        style: AppButtonStyle.outline,
          //        title: context.appText.iAgreeTripToGo,
          //        onPressed: () {
          //          AppDialog.show(context, child: AdvancePaymentDialog());
          //          //showAdvancePaymentDialogue(context: context);
          //        },
          //      ),

        ],
      ),
    );
  }
}
