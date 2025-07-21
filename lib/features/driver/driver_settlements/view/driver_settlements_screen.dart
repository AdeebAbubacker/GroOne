import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/settlement_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
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
import 'package:gro_one_app/utils/validator.dart';

import '../../../../data/ui_state/status.dart';

class DriverSettlementsScreen extends StatefulWidget {
  final String? loadId;
  final String? vehicleID;
  const DriverSettlementsScreen({super.key,this.loadId,this.vehicleID});

  @override
  State<DriverSettlementsScreen> createState() =>
      _DriverSettlementsScreenState();
}

class _DriverSettlementsScreenState extends State<DriverSettlementsScreen> {
  TextEditingController noOfDays = TextEditingController();
  TextEditingController detentionAmount = TextEditingController();
  TextEditingController loadingAmount = TextEditingController();
  TextEditingController unloadingAmount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final vpDetailsCubit = locator<LoadDetailsCubit>();

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

  void initFunction() => frameCallback(() async {});

  void disposeFunction() => frameCallback(() {});


  void createAndSubmitSettlements(){
    if(formKey.currentState!.validate()){
      vpDetailsCubit.submitSettlement(SettlementApiRequest(
        loadId: widget.loadId??"",
        amountPerDay:int.tryParse(detentionAmount.text)??0,
        loadingCharge: int.tryParse(loadingAmount.text)??0,
        noOfDays:int.tryParse(noOfDays.text)??0,
        unloadingCharge: int.tryParse(unloadingAmount.text)??0,
        vehicleId: widget.vehicleID??"",
      ));
    }
  }

  void clearValues()=> frameCallback((){
    noOfDays.clear();
    detentionAmount.clear();
    loadingAmount.clear();
    unloadingAmount.clear();
    vpDetailsCubit.resetSettlementUIState();

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.settlements),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Form(
          key:formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              headingText(text: context.appText.detentions),

              // No. of Days
              AppTextField(
                controller: noOfDays,
                labelText: context.appText.noOfDays,
                hintText: "Days",
                keyboardType: TextInputType.number,

                validator: (value) => Validator.fieldRequired(value),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                ],
              ),

              // Amount
              AppTextField(
                controller: detentionAmount,
                labelText: context.appText.amount,
                hintText: "Ex: 2000",
                keyboardType: TextInputType.number,

                validator: (value) => Validator.fieldRequired(value),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                ],
              ),
              2.height,
              headingText(text: context.appText.loadingCharges),

              // Amount
              AppTextField(
                controller: loadingAmount,
                labelText: context.appText.amount,
                hintText: "Ex: 2000",
                keyboardType: TextInputType.number,

                validator: (value) => Validator.fieldRequired(value),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                ],
              ),

              headingText(text: context.appText.unloadingCharges),

              // Amount
              AppTextField(
                controller: unloadingAmount,
                labelText: context.appText.amount,
                hintText: "Ex: 2000",
                keyboardType: TextInputType.number,

                validator: (value) => Validator.fieldRequired(value),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                ],
              ),

              5.height,
              // Verify Button

              BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
                bloc: vpDetailsCubit,
                listenWhen: (previous, current) =>  previous.createDamageUIState?.status != current.createDamageUIState?.status,
                listener: (context, state) async {
                  final status = state.createDamageUIState?.status;
                  if (status == Status.SUCCESS) {
                    clearValues();
                    showSuccessDialog(context);
                  }
                  if (status == Status.ERROR) {
                    final error = state.createDamageUIState?.errorType;
                    ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                  }
                },
                builder: (context, state) {
                  final isLoading = state.createDamageUIState?.status == Status.LOADING;
                  return AppButton(
                      title: "Submit",
                      isLoading: isLoading,
                      style: AppButtonStyle.primary,
                      onPressed: isLoading ? (){} : ()=>createAndSubmitSettlements()
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
        heading: "Your settlement details has been recorded.",
        message: "We have notified the concerned team.",
        onContinue: (){
          Navigator.of(context).pop(true);
          },
      ),
    );
  });


}
