import 'package:dio/dio.dart';
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
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_multiline_textfield.dart';
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
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


class LpLoadBottomWidget extends StatelessWidget {
  final LoadData loadItem;
  final String kilometers;

  LpLoadBottomWidget({super.key, required this.loadItem, required this.kilometers});

  final lpLoadLocator = locator<LpLoadCubit>();
  final TextEditingController feedbackController = TextEditingController();
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

    return  Positioned(
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
                        25.height,
                        // Travel Progress
                          _buildProgressEtaWidget(
                          context: context,
                          progressPercentage: 6,
                          remainingDistance: "250 KMs",
                          totalDistance: "456KMs",
                          eta: "31-09-2024, 09:30 PM",
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
                       
                        // Pay Adavance
                        _buildAdvancePaymentCard(context: context, paymentState: 2),
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
                        //Consignee Details
                         
                               _buildConsigneeDetail(
                               context: context,
                               name: 'dd',
                               email: 'd',
                               phoneNo: '6587443',
                               isUpdatable: true,
                               isTextField: true,
                               ),
                          16.height,   
                        // Download Documents  
                          Text(context.appText.tripdocument, style: AppTextStyle.h4),
                              Column(
                        children: [
                          20.height,
                          _buildUploadedDocPreviewItem(
                            context: context,
                            isDownloadable: true,
                            fileUrl: 'https://picsum.photos/id/237/500/300.jpg',
                            fileTitle: 'LR copy',
                            dateTime: '07-12-2024 | 02:52 pm',
                            isFileAvailable: true,
                          ),
                          10.height,
                          _buildUploadedDocPreviewItem(
                            context: context,
                            isDownloadable: true,
                            fileUrl: 'https://picsum.photos/id/237/500/300.jpg',
                            fileTitle: 'E-way bill',
                            dateTime: '07-12-2024 | 02:52 pm',
                            isFileAvailable: true,
                          ),
                          10.height,
                          _buildUploadedDocPreviewItem(
                            context: context,
                            isDownloadable: true,
                            fileUrl: 'https://picsum.photos/id/237/500/300.jpg',
                            fileTitle: 'Material Invoice',
                            dateTime: '07-12-2024 | 02:52 pm',
                            isFileAvailable: true,
                          ),
                          20.height,                   
                        ],
                      ),
                      16.height,
                       
                       // Feedback and Remarks
                       _buildFeedbackRemarksWidget(context: context, controller: feedbackController),
          
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


// Prcie Row
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


// Doc Preview
Widget _buildUploadedDocPreviewItem({
  required String fileTitle,
  required String dateTime,
  required bool isFileAvailable,
  required bool isDownloadable,
  required String fileUrl,
  required BuildContext context,
}) {
  Future<void> downloadAndOpenFile(String url) async {
    try {
      final fileName = path.basename(url);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, fileName);

      final dio = Dio();
      await dio.download(url, filePath);

      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint("Error downloading/opening file: $e");
    }
  }

  return Container(
    height: 55,
    width: double.infinity,
    margin:  EdgeInsets.symmetric(vertical: 5),
    padding:  EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.docViewCardBgColor,
      borderRadius: BorderRadius.circular(commonTexFieldRadius),
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          AppIcons.svg.documentView,
          width: 22,
          height: 22,
          colorFilter: AppColors.svg(
            isFileAvailable ? AppColors.primaryColor : AppColors.iconRed,
          ),
        ),
        10.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isFileAvailable ? fileTitle : context.appText.fileNotFound,
              style: AppTextStyle.body.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color:
                    isFileAvailable
                        ? AppColors.textBlackColor
                        : AppColors.iconRed,
              ),
            ),
            4.height,
            Text(
              dateTime,
              style: AppTextStyle.body.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: AppColors.textGreyColor,
              ),
            ),
          ],
        ).expand(),

        if (isFileAvailable && isDownloadable)
          IconButton(
            icon: Icon(
              Icons.download_rounded,
              size: 20,
              color: AppColors.primaryColor,
            ),
            onPressed: () => downloadAndOpenFile(fileUrl),
          ),
      ],
    ),
  );
}


// Travel Progress Details
Widget _buildProgressEtaWidget({
  required BuildContext context,
  required double progressPercentage,
  required String remainingDistance,
  required String totalDistance,
  required String eta,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Radial Progress
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: progressPercentage / 100,
              strokeWidth: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          Text(
            "${progressPercentage.toInt()}%",
            style: AppTextStyle.radialProgressText,
          ),
        ],
      ),

      const SizedBox(width: 12),

      // Main content with distance/ETA
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remaining Distance
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appText.remainingDistance,
                    style: AppTextStyle.body3SoftGrey,
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: remainingDistance,
                          style: AppTextStyle.body2.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' / $totalDistance',
                          style: AppTextStyle.textDarkGreyColor14w400.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vertical Divider
            Container(
              width: 1,
              height: 35,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),

            // ETA
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appText.estArrivalTime,
                    style: AppTextStyle.body3SoftGrey,
                  ),
                  const SizedBox(height: 4),
                  Text(eta, style: AppTextStyle.body3),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


// Feedback and Remarks Widget
Widget _buildFeedbackRemarksWidget({
  required BuildContext context,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Header Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${context.appText.feedback} / ${context.appText.remarks}",
            style: AppTextStyle.h4,
          ),
           AppButton(
           title: context.appText.update,
           style: AppButtonStyle.outlineShrink,
           textStyle: AppTextStyle.buttonPrimaryColorTextColor,
           onPressed: () {},
          ),
        ],
      ),

      10.height,

      /// Multiline TextField
      AppMultilineTextField(controller: controller,hintText: context.appText.enterRemarks,),
    ],
  );
}
