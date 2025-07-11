import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/kavach/view/kavach_support_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/payment_information_dialogue.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/source_destination_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_damages_and_shortages/view/vp_damages_and_shortages_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_setllements/view/vp_settlements_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/trip_schedule_screen.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class LoadDetailsWidget extends StatelessWidget {
  final LoadDetailsCubit cubit;
  final LPHomeCubit lpHomeCubit;
  final VpHomeBloc vpHomeBloc;
  const LoadDetailsWidget({super.key, required this.cubit,required this.lpHomeCubit,required this.vpHomeBloc});


  changeLoadStatus(BuildContext context,String? id) async {

    if(cubit.state.loadStatus==LoadStatus.accepted){
      await Navigator.push(context, MaterialPageRoute(builder: (context) => TripScheduleScreen(),)).then((value) {
        // cubit.getLoadDetails(id??"0");
      },);
      return;
    }
    String? userId=await vpHomeBloc.getUserId();
    await cubit.changedLoadStatus(id??"0", customerId:userId,
      loadStatus: 3,
    ).then((value) {
      if(cubit.state.loadStatus==LoadStatus.accepted && cubit.state.vpLoadStatus?.status==Status.SUCCESS){
        AppDialog.show(
          context,
          child: SuccessDialogView(
            message: 'Load Accepted Successfully',
            afterDismiss: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    },);

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      buildWhen: (previous, current) => current!=previous,
      listener: (context, state) {},
      bloc: cubit,
      builder: (context, state) {
        LoadDetails? loadDetails;
        if (state.loadDetailsUIState?.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }
        if (state.loadDetailsUIState?.status == Status.ERROR) {
          return genericErrorWidget(
              error: state.loadDetailsUIState?.errorType);
        }
        if (state.loadDetailsUIState?.status == Status.SUCCESS) {
          final loads = state.loadDetailsUIState?.data;

          if (loads?.data == null) {
            return genericErrorWidget(error: NotFoundError());
          }
          loadDetails=loads?.data;

          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45),
              decoration:commonContainerDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                shadow: true
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRequestWidget((state.loadStatus==LoadStatus.accepted),loadDetails,state.loadStatus),
                        10.height,
                        Divider(color: Color(0xffE1E1E1), thickness: 3),
                        12.height,

                        SourceDestinationWidget(
                          pickUpLocation: loadDetails?.pickUpLocation,
                          dropLocation:  loadDetails?.dropLocation,
                        ).paddingSymmetric(horizontal: 15),
                        15.height,
                        _buildQuotedPriceWidget((state.loadStatus==LoadStatus.accepted),loadDetails?.rate, loadDetails?.vpRate, loadDetails?.vpMaxRate),
                        15.height,
                        _buildLoadEntityWidget(loadDetails,state.locationDistance),
                        20.height,
                        _buildLoadProviderAdvancePaymentCardViewOnly(
                          context: context,
                          agreedAdvance: "500",
                          paymentStatus: 2,
                          advancePayment: "300",
                          agreedPrice: "600",
                          balancePayment: "500",
                          onViewTap: () {
                            showPaymentView(context);
                          },
                          tripPrice: "1000"
                        ),

                        _buildConsigneeDetail(
                          context: context,
                          name: loadDetails?.consignee?.name,
                          email: loadDetails?.consignee?.email,
                          phoneNo: loadDetails?.consignee?.email,
                          isUpdatable: false,
                          isTextField: false,
                        ),

                        20.height,
                        Text("Trip Documents", style: AppTextStyle.h4).paddingSymmetric(horizontal: 15),
                        20.height,
                        _buildUploadedDocPreviewItem(
                          context: context,
                          isDownloadable: true,
                          fileUrl: 'https://picsum.photos/id/237/500/300.jpg',
                          fileTitle: 'Material Invoice',
                          dateTime: '07-12-2024 | 02:52 pm',
                          isFileAvailable: true,
                        ),
                        20.height,
                        _buildAdableSectionHeader(context: context, title: 'Damages and Shortages', onAdd: () {
                          Navigator.push(context, commonRoute(VpDamagesAndShortagesScreen()));
                        }),
                        20.height,
                        _buildAdableSectionHeader(context: context, title: 'Settlements', onAdd: () {
                          Navigator.push(context, commonRoute(VpSettlementsScreen()));
                        }),
                        20.height,
                        if(state.loadStatus==LoadStatus.assigned)
                          ...[
                            Text("Timeline", style: AppTextStyle.h4).paddingSymmetric(horizontal: 15),
                            20.height,
                            LoadTimelineWidget(
                              timelineList: loadDetails?.timeline??[],
                            ).paddingSymmetric(horizontal: 15),
                          ]
                      ],
                    ),
                  ).expand(),
                  _buildBottomButtonWidget(loadDetails ,state,context)
                ],
              ).paddingTop(15),
            ),
          );
        }
        return genericErrorWidget(error: GenericError());
      });
  }

  /// Build Request Widget
  Widget _buildRequestWidget(bool isAccepted,LoadDetails? loadDetails,LoadStatus? loadStatus) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Image.asset(AppImage.png.dummyTruckLoad, width: 57, height: 42),
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(loadStatus==LoadStatus.assigned)
                _buildAssignedTruckDetails(loadDetails?.trip?.vehicle,loadDetails?.truckType)
              else
              Text("Requested", style: AppTextStyle.body1GreyColor.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color:Color(0xff979797)
              )),
              if(loadStatus==LoadStatus.assigned)
                  _buildAssignedDriverDetails(loadDetails?.trip?.driver)
                else
                  Text(
                "${loadDetails?.truckType?.type} - ${loadDetails?.truckType?.subType}",
                style: AppTextStyle.body1BlackColor.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.textBlackDetailColor
                ),
              ),
            ],
          ),
          if(loadStatus==LoadStatus.assigned)
          GestureDetector(
              onTap: () => callRedirect(loadDetails?.trip?.driver?.mobile??""),
              child: SvgPicture.asset(AppIcons.svg.phoneCall)),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }


  /// assigned truck details
  Widget _buildAssignedTruckDetails(Vehicle? vehicle,TruckType? truckType){
    return Row(
      children: [
        Container(
          decoration: commonContainerDecoration(
            color: Color(0xffFFC100),
            borderRadius: BorderRadius.circular(4)
          ),
          child: Text(vehicle?.vehicleNumber??"").paddingSymmetric(vertical: 2,horizontal: 5),
        ),
        5.width,
        Text(truckType?.type??"",style: AppTextStyle.body3.copyWith(
          color: AppColors.thinLightGray
        ),),
        5.width,
        Text("(${truckType?.subType??""})",style: AppTextStyle.body3.copyWith(
            color: AppColors.thinLightGray
        ),)
      ],
    );
  }


  /// show trip assigned driver details
  Widget _buildAssignedDriverDetails(Driver? driver){
    return Row(
      children: [
        Text("Driver:",style: AppTextStyle.body3.copyWith(
          color: AppColors.thinLightGray
        ),),
        Text(" ${driver?.name.capitalizeFirst}",style: AppTextStyle.h3w500.copyWith(
          fontSize: 13,
          color: AppColors.textBlackDetailColor
        ),),
      ],
    );
  }

  Widget _buildQuotedPriceWidget(bool isAccepted,String? rate, String? vpRate, String? vpMaxRate) {
    final vpLoadPrice = (vpMaxRate == null || vpMaxRate.isEmpty || vpMaxRate == "0")
        ? PriceHelper.formatINR(vpRate)
        : '${PriceHelper.formatINR(vpRate)} - ${PriceHelper.formatINR(vpMaxRate)}';
    return Container(
      height: 37,
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration:commonContainerDecoration( color: AppColors.lightBlueColor,borderRadius: BorderRadius.circular(6)),

      child: Row(
        mainAxisAlignment:isAccepted ?  MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround,
        children: [
          Text( isAccepted? "Trip Price": "Quoted price"),
          Text(
            vpLoadPrice,
            style: AppTextStyle.h1PrimaryColor.copyWith(fontSize: 20),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildLoadEntityWidget(LoadDetails? loadDetails,String?locationDistance ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 15,

      children: [
        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.svg.package, height: 24, width: 24),
            Text(
              loadDetails?.commodity?.name??"",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.kgWeight,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),

            Text(
              "${loadDetails?.consignmentWeight} Ton",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.locationDistance,
              height: 24,
              width: 24,
            ),

            Text(
              "$locationDistance KM",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildBottomButtonWidget(LoadDetails? loadDetails,LoadDetailsState state,BuildContext context){
  return  Container(
      decoration: commonContainerDecoration(
          color: Colors.white,
          blurRadius: 30,
          shadow: state.loadStatus==LoadStatus.accepted || state.loadStatus==LoadStatus.assigned
      ), child: Row(
      spacing: 10,
      children:   [
        ...[
           if(state.loadStatus==LoadStatus.matching)
            AppButton(
              title: "Support",
             style: AppButtonStyle.outline.copyWith(
               shape: WidgetStatePropertyAll(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8),
                 ),
               ),
             ),
             onPressed: () {
               commonSupportDialog(context);
             },
             textStyle: TextStyle(fontSize: 14),
           ).expand(),
           if(state.loadStatus==LoadStatus.matching || state.loadStatus==LoadStatus.accepted)
           AppButton(
             isLoading:state.vpLoadStatus?.status==Status.LOADING,
             title: state.loadStatus==LoadStatus.accepted
                 ? "Assign Driver"
                 : "Accept Load",
             style: AppButtonStyle.primary.copyWith(
               shape: WidgetStatePropertyAll(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8),
                 ),
               ),
             ),
             onPressed:   () async {
               changeLoadStatus(context,loadDetails?.loadId?.toString());
             },
             textStyle: TextStyle(
               fontSize: 14,
               color: AppColors.white,
             ),
           ).expand(),
           if(state.loadStatus==LoadStatus.assigned)
             SizedBox(
               height: 60,
               width:MediaQuery.of(context).size.width * 0.90,
               child: CustomSwipeButton(
                 padding: 0,
                 price:0,
                 loadId: "",
                 text: "Swipe to Start Trip",
                 onSubmit: () {
                   return null;

                   },),
             )

         ],
      ],
    ).paddingSymmetric(horizontal: 15, vertical: 12),
    );
  }

  Future showPaymentView(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return showCustomDialogue(
              hideButton: true,

              context: context, child: PaymentInformationDialogView(
            advanceAmount: 14000,
            balancePayout: 3200,
            isAdvanceCompleted: true,
            isBalancePending: true,
            onProceed: () {},
            paymentMode: "NEFT",
            receivedOn: "12 Jun2 2025, 7:34 AM",
            transactionId: "467898765432",
            tripCost: 73000,
          ), buttonText: "Proceed");
        });
  }
}





//Payment View only
Widget _buildLoadProviderAdvancePaymentCardViewOnly({
  required BuildContext context,
  String? tripPrice,
  String? agreedPrice,
  required String agreedAdvance,
  String? advancePayment,
  String? balancePayment,
  required int paymentStatus,
  VoidCallback? onViewTap,
}) {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.lightBlueColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         if (paymentStatus == 1 && tripPrice != null)
          _buildPriceRow(
            context.appText.tripPrice,
            tripPrice,
            context,
            highlight: true,
          ),

        if (paymentStatus == 2 || paymentStatus == 3 || paymentStatus == 4)
          _buildPriceRow(
            context.appText.agreedPrice,
            agreedPrice ?? '',
            context,
            highlight: true,
          ),
        8.height,
        _buildPriceRow(
          context.appText.agreedAdvance,
          agreedAdvance,
          context,
          highlight: true,
        ),
        12.height,

        if (paymentStatus == 2 || paymentStatus == 3 || paymentStatus == 4)
          _buildStatusRow(
            title: '${context.appText.advancePayment} (80%)',
            amount: advancePayment ?? "",
            statusText: context.appText.received,
            statusColor: AppColors.lightGreenBox,
          ),

        if (paymentStatus == 3)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildStatusRow(
              title: context.appText.balancePayment,
              amount: balancePayment ?? "",
              statusText: context.appText.received,
              statusColor: AppColors.lightGreenBox,
            ),
          ),

        12.height,
        if(paymentStatus != 4 )
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: onViewTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.appText.view,
                  style: AppTextStyle.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 25,
                  color: AppColors.black,
                ),
              ],
            ),
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

// Status Details
Widget _buildStatusRow({
  required String title,
  required String amount,
  required String statusText,
  required Color statusColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyle.body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.darkDividerColor,
        ),
      ),
      6.height,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            amount,
            style: AppTextStyle.body.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: AppTextStyle.textBlackColor12w400.copyWith(
                color: AppColors.textGreen,
              ),
            ),
          ),
        ],
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
  ).paddingSymmetric(horizontal: 15);
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
          color: AppColors.primaryColor,
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
  ).paddingSymmetric(horizontal: 15);
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


// Divider
Widget _buildDivider() {
  return Divider(color: AppColors.bottomSheetDividerColor, thickness: 3);
}


// Addable Section Header
Widget _buildAdableSectionHeader({
  required BuildContext context,
  required String title,
  required VoidCallback onAdd,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildHeading(text: title),
      Spacer(),
      GestureDetector(
        onTap: onAdd,
        child: Text(
          '+ ${context.appText.add}',
          style: AppTextStyle.body2.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      10.width,
    ],
  );
}
// Heading
Widget _buildHeading({required String text}) {
  return Text(text, style: AppTextStyle.h4).paddingSymmetric(horizontal: 15);
}
