import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/feedback_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/low_credit_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/tracking_progress_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/trip_documents.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

class LpLoadBottomWidget extends StatelessWidget {
  final LoadData loadItem;
  final String kilometers;
  final LoadStatus loadStatus;

  LpLoadBottomWidget({super.key, required this.loadItem, required this.kilometers, required this.loadStatus});

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
      int rateValue = (loadItem.loadPrice?.maxRate == null || loadItem.loadPrice?.maxRate == 0)
          ? loadItem.loadPrice?.rate ?? 0
          : loadItem.loadPrice?.maxRate ?? 0;


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

    await lpLoadLocator.loadAgree(loadId: loadItem.loadId.toString());

    final uiState = lpLoadLocator.state.lpLoadAgree;

    if (uiState?.status == Status.LOADING) {}
    else if (uiState?.status == Status.SUCCESS) {

      final lpLoadAgreeDetails = uiState?.data as LpLoadAgreeResponse;
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
      child: AdvancePaymentDialog(loadId: loadItem.loadId, creditLimit: creditData, lpLoadAgreeData: lpLoadAgreeDetails,),
      dismissible: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    final loadPrice = (loadItem.loadPrice?.maxRate == null || loadItem.loadPrice?.maxRate == 0)
        ? PriceHelper.formatINR(loadItem.loadPrice?.rate)
        : PriceHelper.formatINRRange('${loadItem.loadPrice?.rate} - ${loadItem.loadPrice?.maxRate}');
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
                          if(loadStatus.index < LoadStatus.assigned.index)
                            ...[
                              Text(context.appText.requested, style: AppTextStyle.body3.copyWith(color: Colors.grey)),
                              4.height,
                              Text('${loadItem.truckType?.type ?? ''} - ${loadItem.truckType?.subType ?? ''}', style: AppTextStyle.body1.copyWith(fontSize: 14, color: AppColors.black)),
                            ],
                          if(loadStatus.index >= LoadStatus.assigned.index)
                            ...[
                              5.height,
                              Row(
                                children: [
                                  Container(
                                      decoration: commonContainerDecoration(color: Color(0xffFFC100), borderRadius: BorderRadius.circular(4)),
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(loadItem.scheduleTripDetails?.vehicle?.truckNo ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.black))),
                                  8.width,
                                  Text('${loadItem.truckType?.type ?? ''} - ${loadItem.truckType?.subType ?? ''}', style:  AppTextStyle.body3.copyWith(color: AppColors.greyIconColor))],
                              ),
                              5.height,
                              Row(
                                children: [
                                  Text(context.appText.driver, style: AppTextStyle.body3.copyWith(color: AppColors.thinLightGray)),
                                  Text(loadItem.scheduleTripDetails?.driver?.name ?? '', style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.black)),
                                ],
                              ),
                              5.height
                            ],
                            if(loadStatus.index >= LoadStatus.confirmed.index)
                              ...[
                              4.height,
                              Container(
                                width: loadStatus.index >= LoadStatus.assigned.index ? MediaQuery.of(context).size.width * 0.60 : null,
                                  padding: EdgeInsets.all(6),
                                  decoration: commonContainerDecoration(
                                      color: Color(0xffE5EBFF), borderRadius: BorderRadius.circular(6)),
                                  child: Text(loadItem.customer?.companyName ?? "",style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)))
                            ]
                        ],
                      ),
                      if(loadStatus.index >= LoadStatus.assigned.index)
                        ...[
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await callRedirect(loadItem.scheduleTripDetails?.driver?.mobile ?? '');
                            },
                            child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(Icons.call,color: AppColors.white,)),
                          )
                        ]

                    ],
                  ),

                  // Travel Progress
                 if(loadStatus.index >= LoadStatus.loading.index)
                   ...[
                     25.height,
                     BlocBuilder<LpLoadCubit, LpLoadState>(
                       builder: (context, state) {
                         final trackingData = state.trackingDistance?.data;
                         if (trackingData == null) {
                           return SizedBox();
                         }
                         return TrackingProgress(
                           progressPercentage: trackingData.percentage,
                           remainingDistance: trackingData.currentdistance ?? '--',
                           totalDistance: trackingData.overalldistance ?? '--',
                           eta: trackingData.durationValue,
                         );
                       },
                     ),
                   ],

                  25.height,

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
                                Text(loadItem.loadRoute?.pickUpWholeAddr ?? '', style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                            commonDivider(),

                            // Destination
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(loadItem.loadRoute?.dropWholeAddr ?? '', style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                          ],
                        ).expand()
                      ],
                    ),
                  ),
                  16.height,

                  if(loadStatus.index <= LoadStatus.assigned.index)
                    ...[
                      // Agreed Price
                      Container(
                        decoration: commonContainerDecoration(
                          color: AppColors.primaryLightColor,
                          borderRadius: BorderRadius.circular(commonPadding),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(context.appText.agreedPrice, style: AppTextStyle.body2),
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
                    ],

                  // Pay Advance
                  if(loadStatus.index >= LoadStatus.loading.index)
                    ...[
                      _buildAdvancePaymentCard(context: context, paymentState: 1),
                      16.height,
                    ],

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
                          Text('${loadItem.weight?.value} Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
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

                  if(loadStatus.index >= LoadStatus.loading.index)
                    ...[
                      _buildConsigneeDetail(
                        context: context,
                        name: loadItem.consigneeDetails?.name,
                        email: loadItem.consigneeDetails?.email,
                        phoneNo: loadItem.consigneeDetails?.mobileNumber,
                        isUpdatable: true,
                        isTextField: true,
                      ),
                      16.height,

                      if(loadItem.loadDocument.isNotEmpty)
                      // Download Documents
                     ...[
                       Text(context.appText.tripdocument, style: AppTextStyle.h4),
                       10.height,
                       Column(
                         children: loadItem.loadDocument.map((doc) {
                           return Column(
                             children: [
                               TripDocuments(
                                 docName: doc.documentDetails?.title ?? '',
                                 docDateTime: doc.createdAt!,
                                 docUrl: doc.documentDetails?.filePath ?? '',
                                 downloadKey: doc.loadDocumentId,
                                 docId: doc.documentId,
                               ),
                               10.height,
                             ],
                           );
                         }).toList(),
                       ),
                     ],

                      // Feedback and Remarks
                      if(loadStatus.index >= LoadStatus.unloading.index)
                      FeedbackWidget(loadId: loadItem.loadId),

                      20.height
                    ],

                  // Timeline
                  if(loadStatus.index >= LoadStatus.confirmed.index)
                    ...[
                      Text(context.appText.timeline, style: AppTextStyle.h4),
                      20.height,
                      LoadTimelineWidget(timelineList: loadItem.timeline)
                    ]
                ],
              ).paddingAll(16),
            ).expand(),


            if(loadStatus == LoadStatus.assigned && loadItem.isAgreed == 0)
              CustomSwipeButton(
                price: loadItem.loadPrice?.rate ?? 0,
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

// Advance Payment Card
Widget _buildAdvancePaymentCard({
  required BuildContext context,
  required int paymentState,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF5FF),
      borderRadius: BorderRadius.circular(commonPadding),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Agreed Price
        _buildPriceRow(context.appText.agreedPrice, "₹ 79,000", context),
        const SizedBox(height: 8),

        // Payable Advance Row with Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  context.appText.payableAdvance,
                  style: AppTextStyle.body2.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlackColor,
                  ),
                ),
                const SizedBox(width: 8),
                if (paymentState == 2)
                  Row(
                    children: [
                      const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                      const SizedBox(width: 4),
                      Text(
                        context.appText.pending,
                        style: AppTextStyle.body.copyWith(
                          fontSize: 10,
                          color: AppColors.iconRed,
                        ),
                      ),
                    ],
                  )
                else if (paymentState == 3)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.boxGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                        context.appText.paid,
                        style: AppTextStyle.body.copyWith(
                          fontSize: 12,
                          color: AppColors.greenColor,
                          fontWeight: FontWeight.w500,
                        )

                    ),
                  ),
              ],
            ),
            Flexible(
              child: Text(
                "₹ 70,000",
                style: AppTextStyle.body1GreyColor.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGreyDetailColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Payable Balance (only if paymentState is 2 or 3)
        if (paymentState == 3)
          _buildPriceRow(
            context.appText.payableBalance,
            "₹ 9,000",
            context,
            highlight: true,
          ),

        const SizedBox(height: 12),

        // Action Button
        if (paymentState == 1)
          AppButton(
            isLoading: false,
            title: context.appText.payAdvance,
            onPressed: () {},
          )
        else if (paymentState == 2)
          AppButton(
            isLoading: false,
            title: context.appText.payAdvance,
            onPressed: () {},
            richTextWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppIcons.svg.alertWarning,
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  context.appText.payAdvance,
                  style: AppTextStyle.buttonWhiteTextColor,
                ),
              ],
            ),
          )
        else if (paymentState == 3)
            AppButton(
              isLoading: false,
              title: context.appText.payAdvance,
              onPressed: () {},
              richTextWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.appText.payBalance,
                    style: AppTextStyle.buttonWhiteTextColor,
                  ),
                ],
              ),
            ),
      ],
    ),
  );
}


// Price Row
Widget _buildPriceRow(
    String label,
    String amount,
    BuildContext context, {
      bool highlight = false,
    }) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppTextStyle.body2.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.textBlackColor,
        ),
      ),
      Flexible(
        child: Text(
          amount,
          style: AppTextStyle.body1GreyColor.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color:
            highlight
                ? AppColors.primaryColor
                : AppColors.textGreyDetailColor,
          ),
        ),
      ),
    ],
  );
}


// Consignee Details
Widget _buildConsigneeDetail({
  required BuildContext context,
  String? name,
  String? phoneNo,
  String? email,
  bool isTextField = false,
  bool isUpdatable = false,
  TextEditingController? nameController,
  TextEditingController? phoneController,
  TextEditingController? emailController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(context.appText.consigneeDetails, style: AppTextStyle.h4),
          Spacer(),
          if (isUpdatable)
            AppButton(
              buttonHeight: 40,
              title: context.appText.update,
              style: AppButtonStyle.outlineShrink,
              textStyle: AppTextStyle.buttonPrimaryColorTextColor,
              onPressed: () {},
            ),
        ],
      ),
      if (isTextField)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            // Name
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: nameController,
              labelText: context.appText.name,
              mandatoryStar: true,
            ),
            20.height,
            // Contact Number
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: phoneController,
              labelText: context.appText.contactNumber,
              mandatoryStar: true,
            ),
            20.height,
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: emailController,
              labelText: context.appText.emailId,
              mandatoryStar: false,
            ),
          ],
        )
      else
        Column(
          children: [
            20.height,
            // Contact Name
            _buildDetailWidget(text1: context.appText.name, text2: name ?? ""),

            20.height,

            // Contact Number
            _buildDetailWidget(text1: context.appText.contactNo, text2: phoneNo ?? ""),
            20.height,

            // Email Id
            _buildDetailWidget(text1: context.appText.emailId, text2: email ?? ""),
          ],
        ),
    ],
  );
}

// Detail Widget
Widget _buildDetailWidget({required String text1, required String text2}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text1,
        style: AppTextStyle.body2.copyWith(color: AppColors.textBlackColor),
      ),
      Text(
        text2,
        style: AppTextStyle.body2.copyWith(
          fontWeight: FontWeight.w500,
          color: Color(0xFF003CFF),
        ),
      ),
    ],
  );
}



