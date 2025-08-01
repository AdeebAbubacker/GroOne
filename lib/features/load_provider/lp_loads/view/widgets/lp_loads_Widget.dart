import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:lottie/lottie.dart';
import 'low_credit_dialog.dart';

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

  void creditCheck(context) async {
    await widget.lpLoadLocator.getCreditCheck();

    final uiState = widget.lpLoadLocator.state.lpCreditCheck;

    if (uiState?.status == Status.LOADING) {}
    else if (uiState?.status == Status.SUCCESS) {
      final creditData = uiState?.data as CreditCheckApiResponse;

      if (creditData.data == null) {
        ToastMessages.error(message: creditData.message);
        return;
      }

      int availableCredit = double.parse(creditData.data?.availableCreditLimit ?? '0').toInt();
      int rateValue = (widget.loadItem.loadPrice?.maxRate == null || widget.loadItem.loadPrice?.maxRate == 0)
          ? widget.loadItem.loadPrice?.rate ?? 0
          : widget.loadItem.loadPrice?.maxRate ?? 0;


      if(availableCredit < rateValue) {
        AppDialog.show(context, child: LowCreditDialog());
      } else {
        agreeLoadPopUp(context);
      }
    }
    else if (uiState?.status == Status.ERROR) {
      final errorType = uiState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
      return;
    }

  }

  void agreeLoadPopUp(BuildContext context) {
    return AppDialog.show(context, child: CommonDialogView(
      hideCloseButton: true,
      showYesNoButtonButtons: true,
      noButtonText: context.appText.cancel,
      yesButtonText: context.appText.iAgreeLoad,
      child: Column(
        children: [
          Lottie.asset(AppJSON.shipment, repeat: true, frameRate: FrameRate(200)),
          Text(context.appText.areYouSureToAgreeLoad),
        ],
      ),
      onClickYesButton: () async {
        await widget.lpLoadLocator.loadAgree(loadId: widget.loadItem.loadId.toString());

        final uiState = widget.lpLoadLocator.state.lpLoadAgree;


        if (uiState?.status == Status.LOADING) {}
        else if (uiState?.status == Status.SUCCESS) {

          final lpLoadAgreeDetails = uiState?.data as LpLoadAgreeResponse;
          if(context.mounted) {
            Navigator.pop(context);
            AppDialog.show(context, child: AdvancePaymentDialog(loadId: widget.loadItem.loadId, creditLimit: '',lpLoadAgreeData: lpLoadAgreeDetails,), dismissible: true);
          }
        }
        else if (uiState?.status == Status.ERROR) {
          final errorType = uiState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
          return;
        }

      },
    ));
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
            if(loadStatus == LoadStatus.assigned && widget.loadItem.isAgreed == 0)
            buildAgreeButtonWidget(context)
          ],
        )
    );
  }

  /// Load ID Details
  Widget buildLoadIdDetailsWidget(LoadStatus? loadStatus) {
    var statusData = widget.loadItem.loadOnhold ? context.appText.unloadingHeld :widget.loadItem.loadStatusDetails?.loadStatus ?? '';
    return Row(
      children: [
        if(loadStatus!.index <= LoadStatus.assigned.index)
          Container(
            decoration: commonContainerDecoration(
              color: Color(0xffDFE6FF),
              borderRadius: BorderRadius.circular(100),
            ),
            child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
          ),
        if(loadStatus.index >= LoadStatus.loading.index)
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
            if(loadStatus.index >= LoadStatus.loading.index)
              ...[
                Text(
                  widget.loadItem.scheduleTripDetails?.vehicle?.vehicle?.truckNo ?? '',
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
          constraints: BoxConstraints(maxWidth: 90),
          child: Column(
            children: [
              Container(
                decoration: commonContainerDecoration(
                  color: LpHomeHelper.getLoadStatusColor(statusData)
                ),
                child: Text(
                  statusData,
                  style: AppTextStyle.body3.copyWith(color: LpHomeHelper.getLoadStatusTextColor(statusData)),
                  textAlign: TextAlign.center,
                ).center().paddingSymmetric(vertical: 4,horizontal: 10),
              ),
              5.height,
              if(loadStatus == LoadStatus.kycPending || loadStatus == LoadStatus.matching)
               Text(_countDown, style: AppTextStyle.body4.copyWith(color: AppColors.greenColor)).paddingRight(5),
              if(loadStatus.index >= LoadStatus.loading.index)
                Text(
                  'ETA: ${DateTimeHelper.formatCustomDateTimeIST(widget.loadItem.expectedDeliveryDateTime)}',
                  style: AppTextStyle.body4.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
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
    final loadPrice = (widget.loadItem.loadPrice?.maxRate == null || widget.loadItem.loadPrice?.maxRate == 0)
        ? PriceHelper.formatINR(widget.loadItem.loadPrice?.rate)
        : PriceHelper.formatINRRange('${widget.loadItem.loadPrice?.rate} - ${widget.loadItem.loadPrice?.maxRate}');
    return Container(
      decoration: commonContainerDecoration(
        color: AppColors.primaryLightColor,
        borderRadius: BorderRadius.circular(commonButtonRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(context.appText.agreedPrice, style: AppTextStyle.body2),
          Text(loadPrice, style: AppTextStyle.h4.copyWith(color: AppColors.primaryColor)),
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
          onPressed: () async {
            String? firstPostedLoadId = await widget.lpLoadLocator.getFirstPostedLoadId();

            if (firstPostedLoadId != null && firstPostedLoadId == widget.loadItem.loadId.toString()) {
              if(context.mounted) creditCheck(context);
            } else {
              if(context.mounted) agreeLoadPopUp(context);
            }
          },
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
