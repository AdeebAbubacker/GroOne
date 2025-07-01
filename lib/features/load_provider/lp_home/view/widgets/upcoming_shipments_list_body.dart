import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/LPGetLoadModel.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class UpcomingShipmentsListBody extends StatefulWidget {
  final LoadData loadData;
  const UpcomingShipmentsListBody({super.key, required this.loadData});

  @override
  State<UpcomingShipmentsListBody> createState() => _UpcomingShipmentsListBodyState();
}

class _UpcomingShipmentsListBodyState extends State<UpcomingShipmentsListBody> {

  final lpHomeCubit = locator<LPHomeCubit>();

  Timer? _ticker;
  String _countDown = "00:00:00";

  @override
  void initState() {
    callTimer();
    super.initState();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _updateCountDown() {
    setState(() {
      _countDown = LpHomeHelper.getMatchingTime(widget.loadData.matchingStartDate!.toIso8601String());
    });
  }

  void callTimer(){
    if(widget.loadData.createdAt != null && widget.loadData.loadStatusDetails?.loadType != null){
      final status = widget.loadData.loadStatusDetails?.loadType;
      if (status == 'Matching') {
        //lpHomeCubit.startMatchingTimer(widget.loadData.createdAt!.toIso8601String());
        _updateCountDown();                                   // first paint
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
          _updateCountDown();
        });
      }
    } else {
      _ticker = Timer(const Duration(seconds: 0), () {});   // dummy, will cancel
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadPrice = (widget.loadData.maxRate == null || widget.loadData.maxRate!.isEmpty || widget.loadData.maxRate == "0")
        ? PriceHelper.formatINR(widget.loadData.rate)
        : PriceHelper.formatINRRange('${widget.loadData.rate} - ${widget.loadData.maxRate}');
    return  GestureDetector(
      onTap: () {
        Navigator.push(context, commonRoute(LpLoadsLocationDetailsScreen(loadId: widget.loadData.id)));
      },
      child: Container(
        padding: EdgeInsets.all(15).copyWith(top: 0),
        decoration: commonContainerDecoration(color: Colors.white, borderColor: AppColors.primaryColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListTile(
              minVerticalPadding: 0.0,
              tileColor: Colors.red,
              style:ListTileStyle.drawer,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 5,
              minTileHeight: 60,
                titleAlignment: ListTileTitleAlignment.bottom,

              leading: Image.asset(AppImage.png.shipmentBox, height: 45, width: 45),
              title :Align(alignment: Alignment.topLeft, child: (widget.loadData.loadId.isNotEmpty) ? Text(widget.loadData.loadId, style: AppTextStyle.h5,  maxLines: 1):SizedBox(),
              ),
              subtitle:Text(widget.loadData.pickUpDateTime != null ? DateTimeHelper.formatCustomDateIST(widget.loadData.pickUpDateTime!) : "--", style: AppTextStyle.body4PrimaryColor) ,
              trailing: (widget.loadData.loadStatusDetails != null && widget.loadData.loadStatusDetails!.loadType.isNotEmpty) ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: commonContainerDecoration(color: LpHomeHelper.getLoadStatusColor(widget.loadData.loadStatusDetails!.loadType)),
                      child: Text(widget.loadData.loadStatusDetails!.loadType, style: AppTextStyle.body4PrimaryColor.copyWith(color:  LpHomeHelper.getLoadStatusTextColor(widget.loadData.loadStatusDetails!.loadType))),
                    ),
                    5.height,

                    // Matching Timer
                    if (widget.loadData.loadStatusDetails?.loadType == "Matching")
                      // BlocBuilder<LPHomeCubit, LPHomeState>(
                      //   bloc: lpHomeCubit,
                      //   buildWhen: (p, c) => p.matchingText != c.matchingText,
                      //   builder: (context, state) {
                      //     return Text(
                      //        _countDown,
                      //       style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                      //     );
                      //   },


                      // )
                      Text(
                        _countDown,
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                      )

                    else if (widget.loadData.loadStatusDetails?.loadType == "KYC Pending")
                      if(widget.loadData.customer?.kycPendingDate != null)
                        Text(LpHomeHelper.getKycPendingTimeLeft(widget.loadData.customer!.kycPendingDate.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5),
                  ],
                ) : SizedBox()
            ),

            commonDivider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
                    5.width,
                    Text(widget.loadData.pickUpWholeAddr, style: AppTextStyle.body2, maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
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
                    Text(widget.loadData.dropWholeAddr,  style: AppTextStyle.body2, maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
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
                  Text(
                      loadPrice,
                      style: AppTextStyle.h3.copyWith(color: AppColors.primaryColor)
                  ),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 10),
            ),

          ],
        ),
      ),
    );
  }
}
