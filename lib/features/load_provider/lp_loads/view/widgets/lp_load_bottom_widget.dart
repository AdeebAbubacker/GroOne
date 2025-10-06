import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/consignee_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/feedback_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/low_credit_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/payment_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/tracking_progress_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/trip_documents.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/source_destination_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart' as vp_helper;
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart' hide LoadSettlement;
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/vp_added_damage.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
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
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';


class LpLoadBottomWidget extends StatefulWidget {
  final LoadData loadItem;
  final LoadStatus loadStatus;

  const LpLoadBottomWidget({super.key, required this.loadItem, required this.loadStatus});

  @override
  State<LpLoadBottomWidget> createState() => _LpLoadBottomWidgetState();
}

class _LpLoadBottomWidgetState extends State<LpLoadBottomWidget> {
 String? consigneeId;
 List<LoadDocumentData>? othersDocument;
  @override
  void initState() {
  initFunction();
  widget.loadItem.loadDocument;
  super.initState();
  }

   @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  final lpLoadLocator = locator<LpLoadCubit>();

   final _formKey = GlobalKey<FormState>();
   TextEditingController consigneeNameController = TextEditingController();

   TextEditingController consigneePhoneController = TextEditingController();

   TextEditingController consigneeEmailController = TextEditingController();
   bool isUpdateConsignee = false;

  void initFunction() => frameCallback(() {
   final consignees = widget.loadItem.consignees;

    final consigneeName = consignees.isNotEmpty ? consignees[0].name : '';
    final consigneePhone = consignees.isNotEmpty ? consignees[0].mobileNumber : '';
    final consigneeEmail = consignees.isNotEmpty ? consignees[0].email : '';

    consigneeNameController = TextEditingController(text: consigneeName.capitalizeFirst);
    consigneePhoneController = TextEditingController(text: consigneePhone);
    consigneeEmailController = TextEditingController(text: consigneeEmail);
    isUpdateConsignee = widget.loadItem.consignees.isNotEmpty;
    getOthersDocument();

  });

   void disposeFunction() => frameCallback(() {
    consigneeNameController.dispose();
    consigneePhoneController.dispose();
    consigneeEmailController.dispose();
  });

   void getOthersDocument(){
     othersDocument=widget.loadItem.loadDocument.where((element) {
       return vp_helper.DocumentFileType.uploadOtherDocument.documentType == (element.documentDetails?.documentType ?? '');
     },).toList();
   }

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
      if(context.mounted) {
        showDialog(context, loadItem, creditData, lpLoadAgreeDetails);
      }
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
    final loadPrice = widget.loadItem.lpPaymentsData != null ? PriceHelper.formatINR(widget.loadItem.lpPaymentsData?.agreedPrice) : (widget.loadItem.loadPrice?.maxRate == null || widget.loadItem.loadPrice?.maxRate == 0)
        ? PriceHelper.formatINR(widget.loadItem.loadPrice?.rate)
        : PriceHelper.formatINRRange('${widget.loadItem.loadPrice?.rate} - ${widget.loadItem.loadPrice?.maxRate}');

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.loadStatus == LoadStatus.matching ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height * 0.45),
        decoration: commonContainerDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                lpLoadLocator.getLpLoadsById(loadId: widget.loadItem.loadId);
              },
              child: SingleChildScrollView(
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
                                        child: Text(widget.loadItem.scheduleTripDetails?.vehicle?.vehicle?.truckNo ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.black))),
                                    8.width,
                                    Text('${widget.loadItem.truckType?.type ?? ''} - ${widget.loadItem.truckType?.subType ?? ''}', style:  AppTextStyle.body3.copyWith(color: AppColors.greyIconColor))],
                                ),
                                5.height,
                                Row(
                                  children: [
                                    Text("${context.appText.driver.capitalizeFirst} - ", style: AppTextStyle.body3.copyWith(color: AppColors.thinLightGray)),
                                    Text(widget.loadItem.scheduleTripDetails?.driver?.name.capitalize ?? '', style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.black)),
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
                        ).expand(flex: 7),
                        if(widget.loadStatus.index >= LoadStatus.assigned.index)
                          ...[
                            GestureDetector(
                              onTap: () async {
                                await callRedirect(widget.loadItem.scheduleTripDetails?.driver?.mobile ?? '');
                              },
                              child: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  child: Icon(Icons.call,color: AppColors.white,)),
                            ).expand(flex: 1)
                          ]

                      ],
                    ),

                    commonDivider(thickness: 3, height: 15).paddingTop(15),

                    // Travel Progress
                   if(widget.loadStatus.index >= LoadStatus.loading.index)
                     ...[
                       20.height,
                       BlocBuilder<LpLoadCubit, LpLoadState>(
                         builder: (context, state) {
                           final trackingData = state.trackingDistance?.data;
                           return TrackingProgress(
                             progressPercentage: trackingData?.coverPercentage ?? 0,
                             coveredDistance: trackingData?.covereddistance ?? '0 Km',
                             totalDistance: trackingData?.overalldistance ?? '0 Km',
                             eta: trackingData?.durationValue ?? 0,
                           );
                         },
                       ),
                     ],

                    25.height,

                    // Source & Destination card
                    SourceDestinationWidget(
                            pickUpLocation:
                                widget.loadItem.loadRoute?.pickUpWholeAddr,
                            dropLocation: widget.loadItem.loadRoute?.dropWholeAddr,
                          ),
                    16.height,

                    if(widget.loadStatus.index <= LoadStatus.assigned.index)
                      ...[
                        // Agreed Price
                        Container(
                          width: double.infinity,
                          decoration: commonContainerDecoration(
                            color: AppColors.primaryLightColor,
                            borderRadius: BorderRadius.circular(commonPadding),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            children: [
                              Text(context.appText.agreedPrice, style: AppTextStyle.body1Normal),
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
                        PaymentWidget(loadItem: widget.loadItem, loadStatus: widget.loadStatus),
                        16.height,
                      ],

                    // load details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 15,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.svg.package, width: 20, colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn)),
                            8.width,
                            Text(widget.loadItem.commodity?.name ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.svg.kgWeight, width: 20,colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn)),
                            8.width,
                            Text('${widget.loadItem.weight?.value} Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.svg.distance, width: 20, colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn)),
                            8.width,
                            Text(lpLoadLocator.state.locationDistance ?? '', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                          ],
                        ),
                      ],
                    ),
                    25.height,

                    if(widget.loadStatus.index >= LoadStatus.assigned.index)
                      ...[
                        BlocConsumer<LpLoadCubit, LpLoadState>(
                          bloc: lpLoadLocator,
                          listenWhen: (previous, current) =>
                              previous.lpAddConsignee != current.lpAddConsignee ||
                              previous.lpUpdateConsignee != current.lpUpdateConsignee,
                          listener: (context, state) {
                            final addState = state.lpAddConsignee;
                            final updateState = state.lpUpdateConsignee;

                            if (isUpdateConsignee) {
                              if (updateState?.status == Status.SUCCESS && addState?.status != Status.LOADING) {
                                lpLoadLocator.emit(
                                lpLoadLocator.state.copyWith(
                                  isFieldUpdatble: true,
                                ));
                                 FocusScope.of(context).unfocus();
                                ToastMessages.success(message: context.appText.consigneeUpdatedSuccesfully);
                              }

                              if (updateState?.status == Status.ERROR && addState?.status != Status.LOADING) {
                                final errorType = updateState?.errorType;
                                 FocusScope.of(context).unfocus();
                                ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
                              }
                            } else {

                              if (addState?.status == Status.SUCCESS && updateState?.status != Status.LOADING) {
                                 FocusScope.of(context).unfocus();
                                 
                                ToastMessages.success(message: context.appText.consigneeAddedSuccesfully);
                                final newConsignee = addState?.data;
                                lpLoadLocator.emit(
                                lpLoadLocator.state.copyWith(
                                  isFieldUpdatble: true,
                                ),
                              );
                                if (newConsignee != null) {
                                  setState(() {
                                    consigneeNameController.text = newConsignee.name;
                                    consigneePhoneController.text = newConsignee.mobileNumber;
                                    consigneeEmailController.text = newConsignee.email;
                                    consigneeId = newConsignee.id;
                                    isUpdateConsignee = true;
                                  });
                                }
                              }

                              if (addState?.status == Status.ERROR && updateState?.status != Status.LOADING) {
                                 FocusScope.of(context).unfocus();
                                final errorType = addState?.errorType;
                                ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
                              }
                            }
                          },
                          builder: (context, state) {

                            return _buildConsigneeDetail(
                              formKey: _formKey,
                              context: context,
                              isTextField: true,
                              isUpdatable: true,
                              isUpdateConsignee:  isUpdateConsignee,
                              nameController: consigneeNameController,
                              phoneController: consigneePhoneController,
                              emailController: consigneeEmailController,
                              onUpdate: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                final name = consigneeNameController.text.trim();
                                final phone = consigneePhoneController.text.trim();
                                final email = consigneeEmailController.text.trim();
                                final loadId = widget.loadItem.loadId;
                                  if (email.isNotEmpty) {
                                    final String? validation = Validator.email(email);
                                    if (validation != null) {
                                      ToastMessages.alert(message: validation);
                                      return;
                                    }
                                  }
                                  if (isUpdateConsignee) {
                                     if (phone.isNotEmpty) {
                                    final String? phoneValidation = Validator.phone(phone);
                                    if (phoneValidation != null) {
                                      ToastMessages.alert(message: phoneValidation);
                                      return;
                                    }
                                    }

                                    if (email.isNotEmpty) {
                                      final String? validation = Validator.email(email);
                                      if (validation != null) {
                                        ToastMessages.alert(message: validation);
                                        return;
                                      }
                                    }
                                        lpLoadLocator.updateConsignee(updateConsigneeReq: UpdateConsigneeApiRequest(email: email,mobileNumber: phone,name: name), consigneeId: consigneeId ?? widget.loadItem.consignees[0].id);
                                   } else {

                                  if (name.isEmpty || phone.isEmpty) {
                                    ToastMessages.alert(message: context.appText.allFieldsAremandatory);
                                    return;
                                  }

                                  final String? phoneValidation = Validator.phone(phone);
                                  if (phoneValidation != null) {
                                    ToastMessages.alert(message: phoneValidation);
                                    return;
                                  }
                                   lpLoadLocator.addConsignee(addConsigneeReq: AddConsigneeApiRequest(email: email,name: name,loadId: loadId,mobileNumber: phone,));
                                  }
                              },
                            );
                          },
                        ),
                        16.height,
                      ],

                    if(widget.loadStatus.index >= LoadStatus.loading.index)
                      ...[

                        if(widget.loadItem.loadDocument.isNotEmpty)
                        // Download Documents
                       ...[
                         Text(context.appText.tripdocument, style: AppTextStyle.h4),
                         10.height,
                         Column(
                           children: widget.loadItem.loadDocument.map((doc) {
                             return Column(
                               children: [
                                if( vp_helper.DocumentFileType.uploadOtherDocument.documentType != (doc.documentDetails?.documentType ?? ''))
                                  TripDocuments(
                                    otherDocument: [],
                                    showViewMoreIcon: false,
                                   docName:
                                   doc.documentDetails?.documentType ?? '',
                                   docDateTime: doc.createdAt!,
                                   docUrl: doc.documentDetails?.filePath ?? '',
                                   downloadKey: doc.loadDocumentId,
                                   docId: doc.documentId,
                                 ),
                                 // 10.height,
                               ],
                             );
                           }).toList(),
                         ),
                         if((othersDocument??[]).isNotEmpty)...[
                           TripDocuments(
                             otherDocument: othersDocument??[],
                             showViewMoreIcon: true,
                             docName:
                             othersDocument?[0].documentDetails?.documentType ?? '',
                             docDateTime:  othersDocument![0].createdAt!,
                             docUrl:  othersDocument?[0].documentDetails?.filePath ?? '',
                             downloadKey:  othersDocument![0].loadDocumentId,
                             docId:  othersDocument![0].documentId,
                           ),
                         ]

                       ],

                        // Feedback and Remarks
                        if(widget.loadStatus.index >= LoadStatus.unloading.index)
                          ...[
                             if(widget.loadItem.loadApproval?.damageAndShortagesApproved == true && widget.loadItem.damageShortage!.isNotEmpty)
                               ...[
                                 15.height,
                                 Text(context.appText.damagesAndShortages, style: AppTextStyle.h4),
                                 15.height,
                                 VpAddedDamageWidget(
                                   damageReport: widget.loadItem.damageShortage,
                                   imageList: lpLoadLocator.state.allDamageImageList,
                                 ),
                               ],
                            if(widget.loadItem.loadApproval?.settlementApproved == true && widget.loadItem.loadSettlement != null)
                              ...[
                                15.height,
                                Text(context.appText.settlements, style: AppTextStyle.h4),
                                _settlementInfoWidget(widget.loadItem.loadSettlement)
                              ],
                            if(widget.loadItem.podDispatch?.loadId != null)
                              _buildDispatchedDetails(widget.loadItem.podDispatch),
                            15.height,
                            FeedbackWidget(loadId: widget.loadItem.loadId),

                          ],


                        20.height
                      ],

                    // Timeline
                    if(widget.loadStatus.index >= LoadStatus.assigned.index)
                      ...[
                        Text(context.appText.timeline, style: AppTextStyle.h4),
                        20.height,
                        LoadTimelineWidget(timelineList: widget.loadItem.timeline)
                      ]
                  ],
                ).paddingAll(16),
              ),
            ).expand(),


            if(widget.loadStatus == LoadStatus.assigned && widget.loadItem.isAgreed == 0)
              CustomSwipeButton(
                price: widget.loadItem.loadPrice?.rate ?? 0,
                loadId: widget.loadItem.loadId,
                enable: isUpdateConsignee,
                onSubmit: () async {
                  if(!isUpdateConsignee) {
                    ToastMessages.error(message: context.appText.pleaseEnterConsigneeDetails);
                  } else {
                    // String? firstPostedLoadId = await lpLoadLocator.getFirstPostedLoadId();
                    // print('first load $firstPostedLoadId');
                    //
                    // if (firstPostedLoadId != null && firstPostedLoadId == widget.loadItem.loadId.toString()) {
                    //   print('condition true');
                    //   if(context.mounted) onSubmit(widget.loadItem, context);
                    // } else {
                    //   if(context.mounted)
                        showAdvancePaymentDialog(context,widget.loadItem, '');
                    // }
                  }
                  }
              ),
            if(widget.loadStatus == LoadStatus.completed)
              AppButton(onPressed: () {
                final extra = {"loadId": widget.loadItem.loadId, "loadItem": widget.loadItem};
                context.push(AppRouteName.lpLoadSummary, extra: extra);
              }, title: context.appText.viewTripStatement).paddingSymmetric(horizontal: 10, vertical: 10)
          ],
        ),
      ),
    );
  }

  Widget _settlementInfoWidget(LoadSettlement? settlement) {
    final days = settlement?.noOfDays ?? 1;
    final perDay = settlement?.amountPerDay ?? 1;

    String inr(dynamic val) => PriceHelper.formatINR(val.toString());

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(context.appText.credits, style: AppTextStyle.h5.copyWith(fontSize: 17)),
          _buildRow("${context.appText.detentions.capitalizeFirst} ($days ${context.appText.days})", ' (+) ${inr(days * perDay)}'),
          _buildRow(context.appText.loadingCharges, '(+) ${inr(settlement?.loadingCharge)}'),
          _buildRow(context.appText.unloadingCharges, '(+) ${inr(settlement?.unLoadingCharge)}'),
          Divider(),
          Text(context.appText.debits, style: AppTextStyle.h5.copyWith(fontSize: 17)),
          _buildRow(context.appText.damageCharges, '(-) ${inr(settlement?.debitDamages ?? 0)}'),
          _buildRow(context.appText.shortageCharges, '(-) ${inr(settlement?.debitShortages ?? 0)}'),
          _buildRow(context.appText.penalties, '(-) ${inr(settlement?.debitPenalities ?? 0)}'),
          5.height,
        ],
      ),
    );
  }

  Widget _buildDispatchedDetails(PodDispatch? podDispatched) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text(context.appText.podDispatch, style: AppTextStyle.h4),
        15.height,
        _buildRow(context.appText.courierCompany, podDispatched?.courierCompany ?? ''),
        10.height,
        _buildRow(context.appText.awbNumber, podDispatched?.awbNumber ?? ''),
        10.height,
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.body2),
        Text(value, style: AppTextStyle.body2.copyWith(color: AppColors.primaryColor)),
      ],
    );
  }
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
  GlobalKey<FormState>? formKey
}) {
  final isEditable = context.read<LpLoadCubit>().state.isFieldUpdatble;
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.consigneeDetails, style: AppTextStyle.h4),
            Spacer(),
             if (isUpdatable && isUpdateConsignee)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     isEditable ?   
                  IconButton(
               onPressed: () {
                  final cubit = context.read<LpLoadCubit>();
                  cubit.emit(
                    cubit.state.copyWith(
                      isFieldUpdatble: !cubit.state.isFieldUpdatble,
                    ),
                  );
                },
              icon: SvgPicture.asset(
                AppIcons.svg.edit,
                color: AppColors.black,
              ),
              splashRadius: 20,
            ): SizedBox.shrink(),
                  
           
                ],
              ),
          ],
        ),
        if (isTextField)
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                20.height,
                AppTextField(
                  decoration: commonInputDecoration(
                  fillColor:  (isUpdateConsignee && isEditable) ?  AppColors.lightGreyColor:  AppColors.white,),     
                  readOnly: isUpdateConsignee ? isEditable : false,
                   enabled: isUpdateConsignee ? !isEditable : true,
                  validator: (value) => Validator.fieldRequired(value),
                  controller: nameController,
                  labelText: context.appText.name,
                  hintText: context.appText.fullNameHint,
                  mandatoryStar: !isUpdateConsignee || (isUpdateConsignee && !isEditable),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'\-]")),
                    LengthLimitingTextInputFormatter(50)
                  ],
                ),
                20.height,
                AppTextField(
                decoration: commonInputDecoration(
                  fillColor:(isUpdateConsignee && isEditable) ?  AppColors.lightGreyColor:  AppColors.white,),    
                readOnly: isUpdateConsignee ? isEditable : false,
                enabled: isUpdateConsignee ? !isEditable : true,
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
                  mandatoryStar: !isUpdateConsignee || (isUpdateConsignee && !isEditable),
            
                ),
                20.height,
                AppTextField(   
                  decoration: commonInputDecoration(
                  fillColor:(isUpdateConsignee && isEditable) ?  AppColors.lightGreyColor:  AppColors.white,),           
                  readOnly: isUpdateConsignee ? isEditable : false,
                  enabled: isUpdateConsignee ? !isEditable : true,
                  validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return Validator.email(value); 
                  }
                  return null; 
                },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  labelText: context.appText.emailId,
                  hintText: context.appText.emailHint,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                ),
                16.height,
               
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                   ((!isUpdateConsignee || (isUpdateConsignee && !isEditable)) &&
                    ((name?.isNotEmpty ?? false) || 
                      (emailController?.text.isNotEmpty ?? false) || 
                      (phoneController?.text.isNotEmpty ?? false)))
                    ?  AppButton(
                        buttonHeight: 40,
                        title:  context.appText.cancel,
                        style: AppButtonStyle.cancelShrink,
                        textStyle: AppTextStyle.buttonRedColorTextColor,
                        onPressed: () {
                          if (formKey?.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            final cubit = context.read<LpLoadCubit>();
                            cubit.emit(
                              cubit.state.copyWith(
                                isFieldUpdatble: true,
                              ),
                            );
                          }
                        },
                      )
                    : SizedBox.shrink(),
                    12.width,  
                    (!isUpdateConsignee || (isUpdateConsignee && !isEditable))
                    ? AppButton(
                        buttonHeight: 40,
                        title: isUpdateConsignee ? context.appText.update : context.appText.add,
                        style: AppButtonStyle.outlineShrink,
                        textStyle: AppTextStyle.buttonPrimaryColorTextColor,
                        onPressed: () {
                              if (formKey?.currentState?.validate() ?? false) {
                                FocusScope.of(context).unfocus();
                                onUpdate?.call();
                              }
                        },
                      )
                    : SizedBox.shrink()
                   
             
                  ],
                ),
                    
              ],
            ),
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
    ),
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



