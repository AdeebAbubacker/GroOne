import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/low_credit_dialog.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:lottie/lottie.dart';

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
  final int isKycValid;
  const LoadSummaryScreen({super.key, required this.pickupAddress, required this.destinationAddress, required this.vehicleType, required this.vehicleLength, required this.approxWeight, required this.category, required this.price, required this.apiRequest, required this.date, required this.pickupLocation, required this.destinationLocation, required this.isKycValid});

  @override
  State<LoadSummaryScreen> createState() => _LoadSummaryScreenState();
}

class _LoadSummaryScreenState extends BaseState<LoadSummaryScreen> {

  final loadPostingBloc = locator<LoadPostingBloc>();
  final lpHomeCubit = locator<LPHomeCubit>();
  final lpLoadLocator = locator<LpLoadCubit>();

  final noteTextController = TextEditingController();
  final handlingChargesTextController = TextEditingController();

  String? dateAndTime;
  String? sendDateAndTimeInApi;

  Future<dynamic>? onSubmit(context) async {
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
      int rateValue = widget.price.contains('-')
          ? int.parse(widget.price.split('-')[1].trim())
          : int.parse(widget.price.trim());
      if (availableCredit < rateValue) {
        AppDialog.show(context, child: LowCreditDialog());
      } else {
        await _postLoad(context);
      }

    }
    else if (uiState?.status == Status.ERROR) {
      final errorType = uiState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
      return;
    }
  }


  Future<void> postLoadApiCall(BuildContext context) async {
    if (sendDateAndTimeInApi == null) {
      ToastMessages.alert(message: context.appText.expectedDeliveryRateRequired);
      return;
    }

    if(handlingChargesTextController.text.isNotEmpty) {
      if (int.parse(handlingChargesTextController.text) > int.parse(LpHomeHelper.calculateTenPercentOfAverage(widget.price))){
        ToastMessages.alert(message: context.appText.handlingChargeLessTenPercent);
        return;
      }
    }

    if (widget.isKycValid == 3) {
      await onSubmit(context);
    } else {
      await _postLoad(context);
    }
  }

  Future<void> _postLoad(BuildContext context) async {
    final req = widget.apiRequest.copyWith(
      note: noteTextController.text,
      handlingCharges: handlingChargesTextController.text.isNotEmpty ? int.parse(handlingChargesTextController.text) : null,
      expectedDeliveryDateTime: sendDateAndTimeInApi ?? "",
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
      title: context.appText.postLoadSummary,
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
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
              child: Column(
                children: [
                  Text(context.appText.suggestedPrice, style: AppTextStyle.h3PrimaryColor),
                  5.height,
                  Text(
                    PriceHelper.formatINRRange(widget.price),
                    style: AppTextStyle.h4.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form-style details using TextFields
            buildReadOnlyField(context.appText.loadingPoint, LpHomeHelper.getPickUpAndDropLocationDisplay(address: widget.pickupAddress, location: widget.pickupLocation)),
            buildReadOnlyField(context.appText.unLoadingPoint, LpHomeHelper.getPickUpAndDropLocationDisplay(address: widget.destinationAddress, location: widget.destinationLocation)),
            buildReadOnlyField(context.appText.vehicleType, widget.vehicleType),
            buildReadOnlyField(context.appText.vehicleLength, widget.vehicleLength),
            buildReadOnlyField(context.appText.consignmentWeight, "${widget.approxWeight} MT"),
            buildReadOnlyField(context.appText.commodity, widget.category),
            buildReadOnlyField(context.appText.pickupDateAndTime, DateTimeHelper.getDateTimeFormat(DateTime.parse(widget.apiRequest.pickUpDateTime ?? ''))),

            InkWell(
                onTap: () async {
                  final DateTime? pickupDate = DateTimeHelper.convertStringToDateTime(widget.date);

                  final String? date = await commonDatePicker(
                    context,
                    firstDate: pickupDate,
                    initialDate: pickupDate,
                  );

                  if(!context.mounted) return;
                  final String? time = await commonTimePicker(context);

                  if (date != null && time != null) {
                    dateAndTime = "$date - $time";
                    sendDateAndTimeInApi =  DateTimeHelper.convertToApiDateTime(date, time);
                    debugPrint(sendDateAndTimeInApi);
                  }
                  setState(() {});
                },
              child: buildReadOnlyField(context.appText.expectedDeliveryDateAndTime , dateAndTime ?? context.appText.pleaseSelectSDateAndTime, fillColor: Colors.white, mandatoryStar: true)
            ),

            AppTextField(
              controller: handlingChargesTextController,
              hintText: context.appText.enterHandlingCharges,
              labelText: context.appText.handlingCharges,
              keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value){

                if (handlingChargesTextController.text.isNotEmpty){
                  if (int.parse(handlingChargesTextController.text) > int.parse(LpHomeHelper.calculateTenPercentOfAverage(widget.price))){
                    ToastMessages.alert(message: context.appText.handlingChargeLessTenPercent);
                    return;
                  } else {
                    handlingChargesTextController.text = value;
                  }
                }
                setState(() {});
              },
            ),

            // Notes Field
            AppTextField(
              controller: noteTextController,
              labelText: context.appText.notesOrInstruction,
              maxLines: 2,
              inputFormatters: [
                LengthLimitingTextInputFormatter(240),
              ],
            ),

            10.height,
          ],
        ),
      ),
    );
  }

/// Reusable read-only field UI (mimicking input style)
  Widget buildReadOnlyField(String label, String value,{Color? fillColor, bool mandatoryStar = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyle.textFiled),
            if(mandatoryStar)
            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
          ],
        ),
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
          final createdLoadId = state.createLoadModel.data?.loadId;
          if (createdLoadId != null) {
            await lpLoadLocator.setFirstPostedLoadIdIfAbsent(createdLoadId.toString());
          }
          if(context.mounted) {
            AppDialog.show(
              context,
              dismissible: true,
              child: CommonDialogView(
                hideCloseButton: true,
                onSingleButtonText: context.appText.continueText,
                onTapSingleButton: () {
                  analyticsHelper.logEvent(AnalyticEventName.CREATE_LOAD, widget.apiRequest.toJson());
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
                child: Column(
                  children: [
                    Lottie.asset(AppJSON.success, width: 150, repeat: false, frameRate: FrameRate(120)),
                    Text('${context.appText.loadId} : ${state.createLoadModel.data?.loadSeriesId}', style: AppTextStyle.h4),
                    20.height,
                    Text(context.appText.loadPostedSuccess, style: AppTextStyle.greenColor20w700),
                    20.height,
                    Text(context.appText.weWillAssignVehicleAndDriver, style: AppTextStyle.bodyGreyColor),
                  ],
                ),
              ),
            );
          }
          lpHomeCubit.fetchGetLoadList();
          lpHomeCubit.clearPickUpAndDestination();
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateLoadLoading;
        return Row(
          children: [
            AppButton(
              onPressed: () {
                commonSupportDialog(context);
              },
              style: AppButtonStyle.outline,
              title: context.appText.support,
            ).expand(),
            15.width,

            AppButton(
              title: context.appText.postLoad,
              isLoading: isLoading,
              onPressed: isLoading ? () {} : () async {
                await postLoadApiCall(context);
              },
            ).expand(),
          ],
        ).bottomNavigationPadding();
      },
    );
  }


}
