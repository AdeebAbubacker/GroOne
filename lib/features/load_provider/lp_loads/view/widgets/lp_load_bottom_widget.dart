import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/low_credit_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class LpLoadBottomWidget extends StatelessWidget {
  final LoadData loadItem;
  final String kilometers;

  LpLoadBottomWidget({super.key, required this.loadItem, required this.kilometers});

  final lpLoadLocator = locator<LpLoadCubit>();

  Future<dynamic>? onSubmit(LoadData loadItem, context) async {
    await lpLoadLocator.getCreditCheck();

    final uiState = lpLoadLocator.state.lpCreditCheck;

    if (uiState?.status == Status.LOADING) {}
    else if (uiState?.status == Status.SUCCESS) {
      final creditData = uiState?.data as CreditCheckApiResponse;

      if (creditData.data == null) {
        ToastMessages.error(message: creditData.message);
        return;
      }

      int availableCredit = double.parse(creditData.data!.availableCreditLimit).toInt();
      int rateValue = (loadItem.maxRate == null || loadItem.maxRate!.isEmpty || loadItem.maxRate == "0")
          ? double.parse(loadItem.rate).toInt()
          : double.parse(loadItem.maxRate ?? '').toInt();


      if (availableCredit < rateValue) {
        AppDialog.show(context, child: LowCreditDialog());
      } else {
        showAdvancePaymentDialog(context,loadItem, '');
      }
    }
    else if (uiState?.status == Status.ERROR) {
      final errorType = uiState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
      return;
    }
  }

  void showAdvancePaymentDialog(BuildContext context,LoadData loadItem, creditData) async {

    await lpLoadLocator.loadAgree(loadId: loadItem.id.toString());

    final uiState = lpLoadLocator.state.lpLoadAgree;

    if (uiState?.status == Status.LOADING) {}
    else if (uiState?.status == Status.SUCCESS) {

      final lpLoadAgreeDetails = uiState?.data?.lpLoadAgreeData as LpLoadAgreeData;
      showDialog(context, loadItem, creditData, lpLoadAgreeDetails);
    }
    else if (uiState?.status == Status.ERROR) {
      final errorType = uiState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
      return;
    }
  }

  void showDialog(BuildContext context,LoadData loadItem, creditData, lpLoadAgreeDetails) {
    AppDialog.show(
      context,
      child: AdvancePaymentDialog(loadId: '${loadItem.id}', creditLimit: creditData, lpLoadAgreeData: lpLoadAgreeDetails,),
      dismissible: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    final loadPrice = (loadItem.maxRate == null || loadItem.maxRate!.isEmpty || loadItem.maxRate == "0")
        ? PriceHelper.formatINR(loadItem.rate)
        : PriceHelper.formatINRRange('${loadItem.rate} - ${loadItem.maxRate}');

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
        decoration: commonContainerDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Truck Type Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppImage.png.truck, width: 57, height: 42),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(loadItem.loadStatus < 4)
                            ...[
                              Text('Requested', style: AppTextStyle.body3.copyWith(color: Colors.grey)),
                              4.height,
                              Text('${loadItem.truckType?.type ?? ''} - ${loadItem.truckType?.subType ?? ''}', style: AppTextStyle.body1.copyWith(fontSize: 14, color: AppColors.black)),
                            ],
                          if(loadItem.loadStatus > 3)
                            ...[
                              5.height,
                              Row(
                                children: [
                                  Container(
                                      decoration: commonContainerDecoration(color: Color(0xffFFC100), borderRadius: BorderRadius.circular(4)),
                                      padding: EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(loadItem.trip?.vehicle?.vehicleNumber ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.black))),
                                  5.width,
                                  Text('${loadItem.truckType?.type ?? ''} - ${loadItem.truckType?.subType ?? ''}', style:  AppTextStyle.body3.copyWith(color: AppColors.greyIconColor))],
                              ),
                              5.height,
                              Row(
                                children: [
                                  Text('Driver:  ', style: AppTextStyle.body3.copyWith(color: AppColors.greyIconColor)),
                                  Text(loadItem.trip?.driver?.name ?? '', style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.black)),
                                ],
                              ),
                              5.height
                            ],
                          if(loadItem.loadStatus > 2)
                            ...[
                              4.height,
                              Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: commonContainerDecoration(
                                      color: Color(0xffE5EBFF), borderRadius: BorderRadius.circular(6)),
                                  child: Text(loadItem.customer?.customerDetails?.companyName ?? "",style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)))
                            ]
                        ],
                      ),
                      if(loadItem.loadStatus > 3)
                        ...[
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await callRedirect(loadItem.trip?.driver?.mobile ?? '');
                            },
                            child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(Icons.call,color: AppColors.white,)),
                          )
                        ]

                    ],
                  ),
                  16.height,

                  // Source & Destination card
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: commonContainerDecoration(
                      color: AppColors.lightPrimaryColor2,
                      borderColor: AppColors.borderColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
                        10.width,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Source (Pick Up)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.source, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(loadItem.pickUpWholeAddr, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                            commonDivider(),

                            // Destination
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(loadItem.dropWholeAddr, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                          ],
                        ).expand()
                      ],
                    ),
                  ),
                  16.height,

                  // Agreed Price
                  Container(
                    decoration: commonContainerDecoration(
                      color: AppColors.primaryLightColor,
                      borderRadius: BorderRadius.circular(commonPadding),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Agreed Price", style: AppTextStyle.body2),
                        Text(
                          loadPrice,
                          style: AppTextStyle.h4.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ).paddingAll(8),

                  ),
                  16.height,

                  // load details
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.orderBox, width: 20,color: Colors.black,),
                          8.width,
                          Text(loadItem.commodity?.name ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.kgWeight, width: 20,color: Colors.black,),
                          8.width,
                          Text('${loadItem.weightage?.value} Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.distance, width: 20,color: Colors.black,),
                          8.width,
                          Text("${lpLoadLocator.state.locationDistance ?? ''} KM", style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                    ],
                  ),
                  25.height,

                  // Timeline
                  if(loadItem.loadStatus > 2)
                    ...[
                      Text("Timeline", style: AppTextStyle.h4),
                      20.height,
                      LoadTimelineWidget(timelineList: loadItem.timeline)
                    ]
                ],
              ).paddingAll(16),
            ).expand(),
            if(loadItem.loadStatus == 4 && loadItem.isAgreed == 0)
              CustomSwipeButton(
                price:loadItem.rate == "" ? 0 : int.parse(loadItem.rate),
                loadId: loadItem.loadId,
                onSubmit: () async {
                 String? firstPostedLoadId = await lpLoadLocator.getFirstPostedLoadId();

                  if (firstPostedLoadId != null && firstPostedLoadId == loadItem.loadId.toString()) {
                    if(context.mounted) onSubmit(loadItem, context);
                  } else {
                    if(context.mounted) showAdvancePaymentDialog(context,loadItem, '');
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}
