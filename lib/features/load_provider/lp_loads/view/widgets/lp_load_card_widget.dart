import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LPLoadListBodyWidget extends StatefulWidget{
  const LPLoadListBodyWidget({super.key, required this.loadItem, required this.lpLoadLocator});

  final LpLoadItem loadItem;
  final LpLoadCubit lpLoadLocator;

  @override
  State<LPLoadListBodyWidget> createState() => _LPLoadListBodyWidgetState();
}

class _LPLoadListBodyWidgetState extends State<LPLoadListBodyWidget> {
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

  void _updateCountDown(LoadStatus? status) {
    if (status == LoadStatus.matching) {
      final matchingStartDate = widget.loadItem.matchingStartDate;
      if (matchingStartDate != null) {
        _countDown = LpHomeHelper.getMatchingTime(matchingStartDate);
      }
    } else if (status == LoadStatus.kycPending) {
      final kycPendingDate = widget.loadItem.customer?.kycPendingDate;
      if (kycPendingDate != null) {
        _countDown = LpHomeHelper.getKycPendingTimeLeft(kycPendingDate.toString());
      }
    } else {
      _countDown = "--:--:--";
    }

    if (mounted) {
      setState(() {});
    }
  }

  void callTimer(){
    if(widget.loadItem.createdAt != null && widget.loadItem.loadStatusDetails?.loadStatus != null){
      final statusString = widget.loadItem.loadStatusDetails?.loadStatus;
      final status = LpHomeHelper.getLoadStatusFromString(statusString);
      if (status == LoadStatus.matching || status == LoadStatus.kycPending) {
        _updateCountDown(status);                                   // first paint
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
          _updateCountDown(status);
        });
      }
    } else {
      _ticker = Timer(const Duration(seconds: 0), () {});   // dummy, will cancel
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadStatus = LpHomeHelper.getLoadStatusFromString(widget.loadItem.loadStatusDetails?.loadStatus);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLoadIdDetailsWidget(loadStatus),
            commonDivider(),
            buildPickupAndDropAddressWidget(),
            20.height,
            buildRateWidget(),
            10.height,
          ],
        )
    );
  }

  /// Load ID Details
  Widget buildLoadIdDetailsWidget(LoadStatus? loadStatus) {
    var statusData = widget.loadItem.loadOnhold ? context.appText.unloadingHeld :widget.loadItem.loadStatusDetails?.loadStatus ?? '';
    var payment = widget.loadItem.lpPaymentsData;
    var status = loadStatus?.index ?? 0;
    return Row(
      children: [
        if(status <= LoadStatus.assigned.index)
          Container(
            decoration: commonContainerDecoration(
              color: Color(0xffDFE6FF),
              borderRadius: BorderRadius.circular(100),
            ),
            child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
          ),
        if(status >= LoadStatus.loading.index)
          Image.asset(AppImage.png.truck, width: 57, height: 42),

        15.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  widget.loadItem.loadSeriesId,
                  style: AppTextStyle.h5,
                  maxLines: 2,
                ),
              ],
            ),
            4.height,
            if(status >= LoadStatus.loading.index)
              ...[
                Text(
                  widget.loadItem.scheduleTripDetails?.vehicle?.truckNo ?? '',
                  style: AppTextStyle.body3.copyWith(color: AppColors.textBlackDetailColor),
                ),
                4.height,
              ],

            Text(
              widget.loadItem.createdAt != null ? DateTimeHelper.formatCustomDateTimeIST(widget.loadItem.createdAt!) : "--",
              style: AppTextStyle.body4.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ).expand(),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 100),
          child: Column(
            children: [
              Container(
                decoration: commonContainerDecoration(
                    color: widget.loadItem.loadOnhold ? AppColors.red : LpHomeHelper.getColor(widget.loadItem.loadStatusDetails?.statusBgColor ?? '')
                ),
                child: Text(
                  statusData,
                  style: AppTextStyle.body3.copyWith(color: widget.loadItem.loadOnhold ? AppColors.white : LpHomeHelper.getColor(widget.loadItem.loadStatusDetails?.statusTxtColor ?? '')),
                  textAlign: TextAlign.center,
                ).center().paddingSymmetric(vertical: 4,horizontal: 10),
              ),
              5.height,
              if(loadStatus == LoadStatus.kycPending || loadStatus == LoadStatus.matching)
                Text(_countDown, style: AppTextStyle.body4.copyWith(color: AppColors.greenColor)).paddingRight(5),
              if(status >= LoadStatus.loading.index)
                Text(
                  'ETA: ${DateTimeHelper.formatCustomDateTimeIST(widget.loadItem.expectedDeliveryDateTime)}',
                  style: AppTextStyle.body4.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              if((status >= LoadStatus.inTransit.index && (payment?.receivableAdvancePaidFlg == false)))
                Row(
                  children: [
                    const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                    4.width,
                    Text(
                      context.appText.advanceUnpaid,
                      style: AppTextStyle.body.copyWith(fontSize: 10, color: AppColors.iconRed),
                    ).flexible(),
                  ],
                ),
              if((loadStatus == LoadStatus.completed && (payment?.receivableBalancePaidFlg == false && payment?.receivableAdvancePaidFlg == true && payment?.receivableBalance != '0.00')))
                Row(
                  children: [
                    const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                    4.width,
                    Text(
                      context.appText.balanceUnpaid,
                      style: AppTextStyle.body.copyWith(fontSize: 10, color: AppColors.iconRed),
                    ).flexible(),
                  ],
                )
            ],
          ),
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
        5.width,
        Text(
          widget.loadItem.loadRoute?.pickUpWholeAddr ?? "",
          style: AppTextStyle.body4.copyWith(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).flexible(flex: 2),
        DottedLine(
          direction: Axis.horizontal,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashGapLength: 3.0,
        ).paddingOnly(right: 8, left: 12).expand(),
        Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
        Text(
          widget.loadItem.loadRoute?.dropWholeAddr ?? "",
          style: AppTextStyle.body4.copyWith(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).flexible(flex: 2),
      ],
    );
  }

  /// Rate
  Widget buildRateWidget() {
    final loadPrice = widget.loadItem.lpPaymentsData != null ? PriceHelper.formatINR(widget.loadItem.lpPaymentsData?.agreedPrice) : (widget.loadItem.loadPrice?.maxRate == null || widget.loadItem.loadPrice?.maxRate == 0)
        ? PriceHelper.formatINR(widget.loadItem.loadPrice?.rate)
        : PriceHelper.formatINRRange('${widget.loadItem.loadPrice?.rate} - ${widget.loadItem.loadPrice?.maxRate}');
    return Container(
      width: double.infinity,
      decoration: commonContainerDecoration(
        color: AppColors.primaryLightColor,
        borderRadius: BorderRadius.circular(commonButtonRadius),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        children: [
          Text(context.appText.agreedPrice, style: AppTextStyle.body1Normal),
          Text(loadPrice, style: AppTextStyle.h4.copyWith(color: AppColors.primaryColor)),
        ],
      ).paddingAll(8),

    );
  }

}
