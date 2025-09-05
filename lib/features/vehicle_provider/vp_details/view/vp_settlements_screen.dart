import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/settlement_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_count_selector.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../data/ui_state/status.dart';

class VpSettlementsScreen extends StatefulWidget {
  final String? loadId;
  final String? vehicleID;

  const VpSettlementsScreen({super.key,this.loadId,this.vehicleID});

  @override
  State<VpSettlementsScreen> createState() =>
      _VpSettlementsScreenState();
}

class _VpSettlementsScreenState extends State<VpSettlementsScreen> {
  TextEditingController noOfDays = TextEditingController(text: '0');
  TextEditingController detentionAmount = TextEditingController();
  TextEditingController loadingAmount = TextEditingController();
  TextEditingController unloadingAmount = TextEditingController();

  String? detentionAmountRow;
  String? loadingAmountRow;
  String? unloadingAmountRow;

  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  final formKey = GlobalKey<FormState>();
  final vpDetailsCubit = locator<LoadDetailsCubit>();
  bool isSettementsSubmited=false;

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

  void initFunction() => frameCallback(() async { 
  noOfDays.addListener(_refresh);
  detentionAmount.addListener(_refresh);
  loadingAmount.addListener(_refresh);
  unloadingAmount.addListener(_refresh);
  });

  void disposeFunction() => frameCallback(() {
  noOfDays.removeListener(_refresh);
  detentionAmount.removeListener(_refresh);
  loadingAmount.removeListener(_refresh);
  unloadingAmount.removeListener(_refresh);
  });

  bool get canSubmit {
  final numberOfDays = int.tryParse(noOfDays.text) ?? 0;
  final amountPerDays = int.tryParse(detentionAmountRow??"") ?? 0;
  final loadingChargeVal = int.tryParse(loadingAmountRow??"") ?? 0;
  final unloadingChargeVal = int.tryParse(unloadingAmountRow??"") ?? 0;

  final detentionValid = numberOfDays > 0 && amountPerDays > 0;
  final chargesValid = loadingChargeVal > 0 || unloadingChargeVal > 0;

  return detentionValid || chargesValid;
}
 void _refresh() => setState(() {});
  void createAndSubmitSettlements(){
    int numberOfDays=int.tryParse(noOfDays.text)??0;
    int amountPerDays= int.tryParse(detentionAmountRow??"0")??0;

   if(numberOfDays>0){
     if(amountPerDays==0 && loadingAmount.text.isEmpty){
       ToastMessages.error(message: context.appText.detentionRequire);
       return;
     }
   }


   vpDetailsCubit.submitSettlement(SettlementApiRequest(
      loadId: widget.loadId??"",
      amountPerDay:amountPerDays,
      loadingCharge: int.tryParse(loadingAmountRow??"0")??0,
      noOfDays:numberOfDays,
      unloadingCharge: int.tryParse(unloadingAmountRow??"0")??0,
      vehicleId: widget.vehicleID??"",
    ));
  }

  void clearValues()=> frameCallback((){
    noOfDays.clear();
    detentionAmount.clear();
    loadingAmount.clear();
    unloadingAmount.clear();
    vpDetailsCubit.resetSettlementUIState();

  });

  getLoadDetails(String id) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => vpDetailsCubit.getLoadDetails(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.settlements,onLeadingTap: () => Navigator.pop(context,isSettementsSubmited)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Form(
          key:formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              headingText(text: context.appText.detentions),
              StatefulBuilder(builder: (context, refresh) {
                return Column(
                  children: [
                    AppCountSelector(
                      onChanged: (val) {
                        refresh((){

                        });
                       },
                        label: context.appText.noOfDays, controller: noOfDays, isMandatory: false),
                    Visibility(
                      visible:(int.tryParse(noOfDays.text)??0)>0 ,
                      child: AppTextField(
                        controller: detentionAmount,
                        labelText: context.appText.amount,
                        hintText: "Ex: 2000",
                        keyboardType: TextInputType.number,
                        onChanged: (p0) {
                          detentionAmountRow=p0;


                          final formatted = PriceHelper.formatINR(p0,addDecimal:false);
                          detentionAmount.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                          LengthLimitingTextInputFormatter(8),
                        ],
                      ),

                    ),
                  ],
                );
              },),
              2.height,
              headingText(text: context.appText.loadingCharges),

              // Amount
              AppTextField(
                controller: loadingAmount,
                labelText: context.appText.amount,
                hintText: "Ex: 2000",
                keyboardType: TextInputType.number,
                onChanged: (p0) {
                  loadingAmountRow=p0;
                  final formatted = PriceHelper.formatINR(p0,addDecimal:false);
                  loadingAmount.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length));
                },

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                  LengthLimitingTextInputFormatter(8),
                ],
              ),

              headingText(text: context.appText.unloadingCharges),

              // Amount
              AppTextField(
                controller: unloadingAmount,
                labelText: context.appText.amount,
                hintText: "Ex: 2000",
                keyboardType: TextInputType.number,
                onChanged: (p0) {

                  unloadingAmountRow=p0;
                  final formatted = PriceHelper.formatINR(p0,addDecimal:false);
                  unloadingAmount.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length));
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                  LengthLimitingTextInputFormatter(8),
                ],
              ),

              5.height,
              // Verify Button

              BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
                bloc: vpDetailsCubit,
                listenWhen: (previous, current) =>  previous.settlementUIState?.status != current.settlementUIState?.status,
                listener: (context, state) async {
                  final status = state.settlementUIState?.status;
                  if (status == Status.SUCCESS) {
                    clearValues();
                    analyticsHelper.logEvent(AnalyticEventName.SETTLEMENT_ADDED);
                    showSuccessDialog(context);
                  }
                  if (status == Status.ERROR) {
                    final error = state.settlementUIState?.errorType;
                    ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                  }
                },
                builder: (context, state) {
                  final isLoading = state.settlementUIState?.status == Status.LOADING;
                  
                  return AppButton(
                     enable: canSubmit && !isLoading,
                      title: context.appText.submit,
                      isLoading: isLoading,
                      style: AppButtonStyle.primary,
                       onPressed: (!canSubmit || isLoading) ? null : () => createAndSubmitSettlements(),
                  );
                },
              ),

              20.height,
            ],
          )
        ),
      ),
    );
  }

  detailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }

  void showSuccessDialog(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.settlementRecordedSuccessfully,
        message:  context.appText.notifiedTheConcernTeam,
        onContinue: (){
          getLoadDetails(widget.loadId??"");
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          },
      ),
    );
  });


}
