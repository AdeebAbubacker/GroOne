import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/consignee_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/initiate_payment_request.dart';
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
import 'package:gro_one_app/features/payments/view/payments_screen.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

class LpLoadBottomWidget extends StatefulWidget {
  final LoadData loadItem;
  final String kilometers;
  final LoadStatus loadStatus;

  LpLoadBottomWidget({super.key, required this.loadItem, required this.kilometers, required this.loadStatus});

  @override
  State<LpLoadBottomWidget> createState() => _LpLoadBottomWidgetState();
}

class _LpLoadBottomWidgetState extends State<LpLoadBottomWidget> {

  @override
  void initState() {
  initFunction();
  super.initState();
  }

   @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  final lpLoadLocator = locator<LpLoadCubit>();

   TextEditingController feedbackController = TextEditingController();

   TextEditingController consigneeNameController = TextEditingController();

   TextEditingController consigneePhoneController = TextEditingController();

   TextEditingController consigneeEmailController = TextEditingController();

  void initFunction() => frameCallback(() {
   final consignees = widget.loadItem.consignees;

    final consigneeName = consignees.isNotEmpty ? consignees[0].name : '';
    final consigneePhone = consignees.isNotEmpty ? consignees[0].mobileNumber : '';
    final consigneeEmail = consignees.isNotEmpty ? consignees[0].email : '';

    consigneeNameController = TextEditingController(text: consigneeName);
    consigneePhoneController = TextEditingController(text: consigneePhone);
    consigneeEmailController = TextEditingController(text: consigneeEmail);

  });

   void disposeFunction() => frameCallback(() {
    consigneeNameController.dispose();
    consigneePhoneController.dispose();
    consigneeEmailController.dispose();
  });

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
    final loadPrice = (widget.loadItem.loadPrice?.maxRate == null || widget.loadItem.loadPrice?.maxRate == 0)
        ? PriceHelper.formatINR(widget.loadItem.loadPrice?.rate)
        : PriceHelper.formatINRRange('${widget.loadItem.loadPrice?.rate} - ${widget.loadItem.loadPrice?.maxRate}');
    final paymentState = LpHomeHelper.getPaymentState(widget.loadStatus);

      final useMemo = widget.loadStatus == LoadStatus.loading ||
                      widget.loadStatus == LoadStatus.inTransit ||
                      widget.loadStatus == LoadStatus.unloadingHeld;

      final memo = widget.loadItem.loadMemoDetails;
      final payments = widget.loadItem.lpPaymentsData?.data.payments;

      // Parse memo values safely
      final String memoAdvance = memo?.advance.toString() ?? '';
      final String memoAgreedPrice = memo?.netFreight.toString() ?? '';
      final String memoPayableAdvance = memo?.advance.toString() ?? '';
      final String memoPayableBalance = memo?.balance.toString() ?? '';

      final String paymentAdvance = payments?.last.advancePaid ?? '';
      final String paymentAgreedPrice = payments?.last.agreedPrice ?? '';
      final String paymentPayableAdvance = payments?.last.payableAdvance ?? '';
      final String paymentPayableBalance = payments?.last.payableBalance ?? '';
      final action = (payments != null && payments.isNotEmpty && payments.last.action == 'pay_advance') ? 'clear_balance' : 'pay_advance';   
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
                          if(widget.loadStatus.index < LoadStatus.assigned.index)
                            ...[
                              Text(context.appText.requested, style: AppTextStyle.body3.copyWith(color: Colors.grey)),
                              4.height,
                              Text('${widget.loadItem.truckType?.type ?? ''} - ${widget.loadItem.truckType?.subType ?? ''}', style: AppTextStyle.body1.copyWith(fontSize: 14, color: AppColors.black)),
                            ],
                          if(widget.loadStatus.index >= LoadStatus.assigned.index)
                            ...[
                              5.height,
                              Row(
                                children: [
                                  Container(
                                      decoration: commonContainerDecoration(color: Color(0xffFFC100), borderRadius: BorderRadius.circular(4)),
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(widget.loadItem.scheduleTripDetails?.vehicle?.truckNo ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.black))),
                                  8.width,
                                  Text('${widget.loadItem.truckType?.type ?? ''} - ${widget.loadItem.truckType?.subType ?? ''}', style:  AppTextStyle.body3.copyWith(color: AppColors.greyIconColor))],
                              ),
                              5.height,
                              Row(
                                children: [
                                  Text(context.appText.driver, style: AppTextStyle.body3.copyWith(color: AppColors.thinLightGray)),
                                  Text(widget.loadItem.scheduleTripDetails?.driver?.name ?? '', style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.black)),
                                ],
                              ),
                              5.height
                            ],
                            if(widget.loadStatus.index >= LoadStatus.confirmed.index)
                              ...[
                              4.height,
                              Container(
                                width: widget.loadStatus.index >= LoadStatus.assigned.index ? MediaQuery.of(context).size.width * 0.60 : null,
                                  padding: EdgeInsets.all(6),
                                  decoration: commonContainerDecoration(
                                      color: Color(0xffE5EBFF), borderRadius: BorderRadius.circular(6)),
                                  child: Text(widget.loadItem.customer?.companyName ?? "",style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)))
                            ]
                        ],
                      ),
                      if(widget.loadStatus.index >= LoadStatus.assigned.index)
                        ...[
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await callRedirect(widget.loadItem.scheduleTripDetails?.driver?.mobile ?? '');
                            },
                            child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(Icons.call,color: AppColors.white,)),
                          )
                        ]

                    ],
                  ),

                  // Travel Progress
                 if(widget.loadStatus.index >= LoadStatus.loading.index)
                   ...[
                     25.height,
                     BlocBuilder<LpLoadCubit, LpLoadState>(
                       builder: (context, state) {
                         final trackingData = state.trackingDistance?.data;
                         if (trackingData == null) {
                           return SizedBox();
                         }
                         return TrackingProgress(
                           progressPercentage: trackingData.coverPercentage??0,
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
                                Text(widget.loadItem.loadRoute?.pickUpWholeAddr ?? '', style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                            commonDivider(),

                            // Destination
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(widget.loadItem.loadRoute?.dropWholeAddr ?? '', style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                          ],
                        ).expand()
                      ],
                    ),
                  ),
                  16.height,

                  if(widget.loadStatus.index <= LoadStatus.assigned.index)
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
                  if(widget.loadStatus.index >= LoadStatus.loading.index)
                    ...[
                      
                      if (LpHomeHelper.getPaymentState(widget.loadStatus) >= 1 &&
                      LpHomeHelper.getPaymentState(widget.loadStatus) <= 5)
                    _buildAdvancePaymentCard(
                      context: context,
                      paymentState: LpHomeHelper.getPaymentState(widget.loadStatus),
                      loadId: widget.loadItem.loadId,
                      customerCity: widget.loadItem.customer?.customerAddress?.city ?? '',
                      customerEmail: widget.loadItem.customer?.emailId ?? '',
                      customerMobile: widget.loadItem.customer?.mobileNumber ?? '',
                      customerName: widget.loadItem.customer?.customerName ?? '',
                      advancePaid: useMemo ? memoAdvance : paymentAdvance,
                    agreedPrice: useMemo ? memoAgreedPrice : paymentAgreedPrice,
                    payableAdvance: useMemo ? memoPayableAdvance : paymentPayableAdvance,
                    payableBalance: useMemo ? memoPayableBalance : paymentPayableBalance,
                     isAdancePaid: widget.loadItem.lpPaymentsData?.data.payments.last.action == "pay_advance"
                     ? true: false,
                     lpLoadCubit: lpLoadLocator,
                     action: action,
                  ),
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
                          Text(widget.loadItem.commodity?.name ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.kgWeight, width: 20,color: Colors.black,),
                          8.width,
                          Text('${widget.loadItem.weight?.value} Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
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

                  if(widget.loadStatus.index >= LoadStatus.loading.index)
                    ...[
                      BlocConsumer<LpLoadCubit, LpLoadState>(
                        bloc: lpLoadLocator,
                        listenWhen: (previous, current) =>
                            previous.lpAddConsignee != current.lpAddConsignee ||
                            previous.lpUpdateConsignee != current.lpUpdateConsignee,
                        listener: (context, state) {
                          final addState = state.lpAddConsignee;
                          final updateState = state.lpUpdateConsignee;

                          if (addState?.status == Status.SUCCESS) {
                          ToastMessages.success(message: context.appText.consigneeAddedSuccesfully);
                          } else if (addState?.status == Status.ERROR) {
                            final errorType = state.lpAddConsignee?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
                          }

                          if (updateState?.status == Status.SUCCESS) {
                            ToastMessages.success(message: context.appText.consigneeUpdatedSuccesfully);
                          } else if (updateState?.status == Status.ERROR) {
                            final errorType = state.lpUpdateConsignee?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
                          }
                        },
                        builder: (context, state) {
                        final consignees = widget.loadItem.consignees;
                        final isAddorUpdate = consignees.isNotEmpty;
                          return _buildConsigneeDetail(
                            context: context,
                            isTextField: true,
                            isUpdatable: true,
                            isUpdateConsignee: isAddorUpdate,
                            nameController: consigneeNameController,
                            phoneController: consigneePhoneController,
                            emailController: consigneeEmailController,
                            onUpdate: () {
                              final name = consigneeNameController.text.trim();
                              final phone = consigneePhoneController.text.trim();
                              final email = consigneeEmailController.text.trim();
                              final loadId = widget.loadItem.loadId;
                              final consignees = widget.loadItem.consignees;
                                if (email.isNotEmpty) {
                                  final String? validation = Validator.email(email);
                                  if (validation != null) {
                                    ToastMessages.alert(message: validation);
                                    return;
                                  }
                                }
                                if (consignees.isNotEmpty) {
                                  final existingConsignee = consignees[0];
                                      lpLoadLocator.updateConsignee(updateConsigneeReq: UpdateConsigneeApiRequest(email: email,mobileNumber: phone,name: name), consigneeId: widget.loadItem.consignees[0].id);
                              
                                 } else {
                                  
                                if (name.isEmpty || phone.isEmpty || email.isEmpty) {
                                  ToastMessages.alert(message: context.appText.allFieldsAremandatory);
                                  return;
                                }

                                final String? validation = Validator.email(email);
                                if (validation != null) {
                                  ToastMessages.alert(message: validation);
                                  return;
                                }
                                 lpLoadLocator.addConsignee(addConsigneeReq: AddConsigneeApiRequest(email: email,name: name,loadId: loadId,mobileNumber: phone,));                              
                                }                   
                            },
                          );
                        },
                      ),          
                      16.height,

                      if(widget.loadItem.loadDocument.isNotEmpty)
                      // Download Documents
                     ...[
                       Text(context.appText.tripdocument, style: AppTextStyle.h4),
                       10.height,
                       Column(
                         children: widget.loadItem.loadDocument.map((doc) {
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
                      if(widget.loadStatus.index >= LoadStatus.unloading.index)
                      FeedbackWidget(loadId: widget.loadItem.loadId),

                      20.height
                    ],

                  // Timeline
                  if(widget.loadStatus.index >= LoadStatus.confirmed.index)
                    ...[
                      Text(context.appText.timeline, style: AppTextStyle.h4),
                      20.height,
                      LoadTimelineWidget(timelineList: widget.loadItem.timeline)
                    ]
                ],
              ).paddingAll(16),
            ).expand(),


            if(widget.loadStatus == LoadStatus.assigned && widget.loadItem.isAgreed == 0)
              CustomSwipeButton(
                price: widget.loadItem.loadPrice?.rate ?? 0,
                loadId: widget.loadItem.loadId,
                onSubmit: () async {
                 String? firstPostedLoadId = await lpLoadLocator.getFirstPostedLoadId();

                  if (firstPostedLoadId != null && firstPostedLoadId == widget.loadItem.loadId.toString()) {
                    if(context.mounted) onSubmit(widget.loadItem, context);
                  } else {
                    if(context.mounted) showAdvancePaymentDialog(context,widget.loadItem, '');
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
  required String loadId,
  required String customerName,
  required String customerEmail,
  required String customerMobile,
  required String customerCity,
  required String agreedPrice,
  required String payableAdvance,
  required String payableBalance,
  required String advancePaid,
  required String action,
  required bool isAdancePaid,
  required LpLoadCubit lpLoadCubit,
}) {
  final lpLoadCubit = context.read<LpLoadCubit>();
final createOrderState = lpLoadCubit.state.lpCreateOrder;
final addPaymentState = lpLoadCubit.state.lpAddCustomerPaymentOption;

final isLoading = createOrderState?.status == Status.LOADING ||
    addPaymentState?.status == Status.LOADING;

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF5FF),
      borderRadius: BorderRadius.circular(commonPadding),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         8.height,
        // Agreed Price
        _buildPriceRow(context.appText.agreedPrice, agreedPrice, context),
        8.height,
        if (paymentState == 5)
        // Advance paid 
        _buildPriceRow(context.appText.advancePaid, advancePaid, context),
        8.height,

        if (paymentState != 5)
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
               8.width,
                 if (!isAdancePaid)
                  Row(
                    children: [
                      const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                      4.width,
                      Text(
                        context.appText.pending,
                        style: AppTextStyle.body.copyWith(
                          fontSize: 10,
                          color: AppColors.iconRed,
                        ),
                      ),
                    ],
                  )
                else if (isAdancePaid)
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
                      ),
                    ),
                  ),
              ],
            ),
            Flexible(
              child: Text(
                PriceHelper.formatINR(payableAdvance),
                style: AppTextStyle.body1GreyColor.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGreyDetailColor,
                ),
              ),
            ),
          ],
        ),

         8.height,

        // Payable Balance (only if paymentState is 2 or 3)
        if (paymentState == 3 || paymentState == 5)
          _buildPriceRow(
            context.appText.payableBalance,
            payableBalance,
            context,
            highlight: true,
          ),

         12.height,

        // Action Button
        if (paymentState == 1 || paymentState == 2 || paymentState == 3|| paymentState == 4 || paymentState == 5)
          AppButton(
            isLoading: isLoading,
            title: context.appText.payAdvance,
            onPressed: () async {
              
             final isPayingBalance = paymentState == 3 || paymentState == 5;
            //  final selectedAmountString = isPayingBalance ? payableBalance : payableAdvance;
            // final paymentAmount = double.tryParse(selectedAmountString.toString())?.toInt() ?? 0;
              final selectedAmountString = isAdancePaid ? payableBalance : payableAdvance;
            final paymentAmount = double.tryParse(selectedAmountString.toString())?.toInt() ?? 0;
 
              // Create Order
               // Create Order
              await lpLoadCubit.createOrder(
                loadId: loadId,
                createOrderidReuest: CreateOrderIdRequest(
                      amount: paymentAmount,
                type: 'online',
                action: action,
                      )
                  );

              final createOrderState = lpLoadCubit.state.lpCreateOrder;

              if (createOrderState?.status == Status.SUCCESS) {
                final orderId = createOrderState?.data?.orderId;
                if (orderId != null) {
                  // Initiate Payment
                  await lpLoadCubit.initaitepayment(
                    initiatePaymentRequest: 
                    InitiatePaymentRequest(
                      orderId: orderId, 
                      amount: paymentAmount,
                      customerName: customerName, 
                      customerEmail: customerEmail, 
                      customerMobile: customerMobile, 
                      customerCity: customerCity)
                  );

                  final addpaymentState = lpLoadCubit.state.lpAddCustomerPaymentOption;

                  if (addpaymentState?.status == Status.SUCCESS) {
                    Navigator.of(context).push(commonRoute(PaymentsScreen(url: addpaymentState?.data?.data?.data?.tinyUrl ?? "",loadId: loadId,)));
                  } else {
                    ToastMessages.error(message: context.appText.paymentFailed);
                  }
                } else {
                  ToastMessages.error(message: context.appText.orderIdNotFound);
                }
              } else {
                ToastMessages.error(message: context.appText.orderCreationFailed);
              }
            },
            richTextWidget: paymentState == 2 || paymentState == 4 || paymentState == 5
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(!!isAdancePaid)
                      SvgPicture.asset(
                        AppIcons.svg.alertWarning,
                        height: 18,
                        width: 18,
                      ),
                      8.width,
                      Text(
                        paymentState == 5 ? context.appText.payBalance : context.appText.payAdvance,  
                        style: AppTextStyle.buttonWhiteTextColor,
                      ),
                    ],
                  )
                : paymentState == 3
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                       context.appText.payBalance ,
                            style: AppTextStyle.buttonWhiteTextColor,
                          ),
                        ],
                      )
                    : null,
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
          PriceHelper.formatINR(amount),
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
  bool isUpdateConsignee = false,
  TextEditingController? nameController,
  TextEditingController? phoneController,
  TextEditingController? emailController,
  VoidCallback? onUpdate,
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
             title: isUpdateConsignee ? context.appText.update : context.appText.add,
              style: AppButtonStyle.outlineShrink,
              textStyle: AppTextStyle.buttonPrimaryColorTextColor,
              onPressed: onUpdate ?? () {},
            ),
        ],
      ),
      if (isTextField)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: nameController,
              labelText: context.appText.name,
              hintText: context.appText.fullNameHint,
              mandatoryStar:  isUpdateConsignee ? false : true,
            ),
            20.height,
            AppTextField(
             validator: (value) => Validator.phone(value),
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: iosNumberKeyboard,
              controller: phoneController,
              labelText: context.appText.contactNumber,
               hintText: "${context.appText.enter} ${context.appText.your} ${context.appText.phoneNumber}",
                mandatoryStar:  isUpdateConsignee ? false : true,

            ),
            20.height,
            AppTextField(
              validator: (value) => Validator.email(value),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              labelText: context.appText.emailId,  
              hintText: context.appText.emailHint,
               mandatoryStar:  isUpdateConsignee ? false : true,
            ),
          ],
        )
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            _buildDetailWidget(text1: context.appText.name, text2: name ?? ""),
            20.height,
            _buildDetailWidget(
              text1: context.appText.contactNo,
              text2: phoneNo ?? "",
            ),
            20.height,
            _buildDetailWidget(
              text1: context.appText.emailId,
              text2: email ?? "",
            ),
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



