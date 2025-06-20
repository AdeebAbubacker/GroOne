import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/load_summary_widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class LoadSummaryScreen extends StatefulWidget {
  final CreateLoadApiRequest apiRequest;
  final String pickupAddress;
  final String pickupLocation;
  final String destinationAddress;
  final String destinationLocation;
  final String vehicleType;
  final String vehicleLength;
  final String approxWeight;
  final String category;
  final String price;
  final String date;
  const LoadSummaryScreen({super.key, required this.pickupAddress, required this.destinationAddress, required this.vehicleType, required this.vehicleLength, required this.approxWeight, required this.category, required this.price, required this.apiRequest, required this.date, required this.pickupLocation, required this.destinationLocation});

  @override
  State<LoadSummaryScreen> createState() => _LoadSummaryScreenState();
}

class _LoadSummaryScreenState extends State<LoadSummaryScreen> {

  final loadPostingBloc = locator<LoadPostingBloc>();
  final lpHomeCubit = locator<LPHomeCubit>();

  final noteTextController = TextEditingController();
  final handlingChargesTextController = TextEditingController();

  String? dateAndTime;
  String? sendDateAndTimeInApi;



  Future<void> postLoadApiCall() async {
    if (sendDateAndTimeInApi == null) {
      ToastMessages.alert(message: "Expected Delivery Date is required");
      return;
    }
    if(handlingChargesTextController.text.isEmpty){
      ToastMessages.alert(message: "Handling Charges is required");
      return;
    }
    final req = widget.apiRequest.copyWith(
        note: noteTextController.text,
        handlingCharges: int.parse(LpHomeHelper.calculateTenPercentOfAverage(widget.price)),
        expectedDeliveryDateTime: sendDateAndTimeInApi ?? ""
    );
    await loadPostingBloc.loadPostingApiCall(CreateLoadPostingEvent(apiRequest: req));
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
      bottomNavigationBar: buildButtonWidget(context),
    );
  }

  // App bar
  PreferredSizeWidget buildAppBarWidget (BuildContext context) {
    return CommonAppBar(
      backgroundColor: AppColors.white,
      title: "Post Load Summary",
      actions: [

        TextButton.icon(
            onPressed: ()=> context.pop(),
            icon: Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: 20),
            label: Text(context.appText.edit, style: AppTextStyle.h5PrimaryColor),
        ),

      ],
    );
  }

///  buildBodyWidget:
  Widget buildBodyWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [

            // Suggested Price Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
              child: Column(
                children: [
                  Text("Suggested Price", style: AppTextStyle.h3PrimaryColor),
                  5.height,
                  Text(
                    PriceHelper.formatINR(widget.price),
                    style: AppTextStyle.h4.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form-style details using TextFields
            buildReadOnlyField("Loading Point", LpHomeHelper.getPickUpAndDropLocationDisplay(address: widget.pickupAddress, location: widget.pickupLocation)),
            buildReadOnlyField("Unloading point", LpHomeHelper.getPickUpAndDropLocationDisplay(address: widget.destinationAddress, location: widget.destinationLocation)),
            buildReadOnlyField("Vehicle type", widget.vehicleType),
            buildReadOnlyField("Vehicle Length", widget.vehicleLength),
            buildReadOnlyField("Consignment weight", "${widget.approxWeight} MT"),
            buildReadOnlyField("Commodity", widget.category),
            buildReadOnlyField("Pickup date & time", widget.date),

            InkWell(
                onTap: () async {

                  final String? date = await commonDatePicker(
                    context,
                    firstDate: DateTime.now(),
                    initialDate: DateTimeHelper.convertToDateTimeWithCurrentTime(dateAndTime ?? DateTime.now().toString()),
                  );

                  if(!context.mounted) return;
                  final String? time = await commonTimePicker(context);

                  if (date != null && time != null) {
                    dateAndTime = "$date - $time";
                    sendDateAndTimeInApi = DateTimeHelper.convertToDatabaseFormat(date);
                    debugPrint(sendDateAndTimeInApi);
                  }
                  setState(() {});
                },
              child: buildReadOnlyField("Expected Delivery Date & Time" , dateAndTime ?? "Please Select Date & Time", fillColor: Colors.white)
            ),

            AppTextField(
              controller: handlingChargesTextController,
              hintText: "Enter Handling Charges",
              labelText: "Handling Charges",
              keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value){
                debugPrint("Handling Charges of 10% : ${LpHomeHelper.calculateTenPercentOfAverage(widget.price)}");

                if (handlingChargesTextController.text.isNotEmpty){
                  if (int.parse(handlingChargesTextController.text) > int.parse(LpHomeHelper.calculateTenPercentOfAverage(widget.price))){
                    ToastMessages.alert(message: "Handling charges should be less than 10% of the average price");
                    return;
                  } else {
                    handlingChargesTextController.text = value;
                  }
                }
                setState(() {});
              },
            ),

           // buildReadOnlyField("Handling Charges","Rs. ${calculateTenPercentOfAverage(widget.price)}", fillColor: Colors.white),

            // Notes Field
            AppTextField(
              controller: noteTextController,
              labelText: "Notes/ Instructions",
              hintText: "Handle with care",
              maxLines: 2,
            ),

            10.height,
          ],
        ),
      ),
    );
  }

/// Reusable read-only field UI (mimicking input style)
  Widget buildReadOnlyField(String label, String value,{Color? fillColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textFiled),
        6.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: commonContainerDecoration(color: fillColor ?? AppColors.lightGreyBackgroundColor, borderRadius: BorderRadius.circular(commonTexFieldRadius), borderColor: AppColors.borderDisableColor),
          child: Text(value, style: AppTextStyle.textFiled),
        ),
      ],
    );
  }


/// inside buildButtonWidget:
  Widget buildButtonWidget(BuildContext context) {
    return BlocConsumer<LoadPostingBloc, LoadPostingState>(
      bloc: loadPostingBloc,
      listenWhen: (previous, current) =>  previous != current,
      listener: (context, state) async {
        if (state is CreateLoadError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
        if (state is CreateLoadSuccess) {
          AppDialog.show(
            context,
            child: SuccessDialogView(
              message: 'Load Created Successfully',
              afterDismiss: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
          );
          lpHomeCubit.fetchGetLoadList();
          lpHomeCubit.clearPickUpAndDestination();
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateLoadLoading;
        final successState = state is CreateLoadSuccess;
        return Row(
          children: [
            AppButton(
              onPressed: () {
                commonSupportDialog(context);
              },
              style: AppButtonStyle.outline,
              title: "Customer Support",
            ).expand(),
            15.width,

            AppButton(
              title: "Post Load",
              isLoading: isLoading,
              onPressed: isLoading ? () {} : () async {

                await postLoadApiCall();

              },
            ).expand(),
          ],
        ).bottomNavigationPadding();
      },
    );
  }


}
