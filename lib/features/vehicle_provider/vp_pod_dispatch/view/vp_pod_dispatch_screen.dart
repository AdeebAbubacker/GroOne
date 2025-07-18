import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/api_request/submit_pod_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/cubit/pod_dispatch_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

class VpPodDispatchScreen extends StatefulWidget {
  final String? loadId;
  const VpPodDispatchScreen({super.key, this.loadId});

  @override
  State<VpPodDispatchScreen> createState() => _VpPodDispatchScreenState();
}

class _VpPodDispatchScreenState extends State<VpPodDispatchScreen> {

  final cubit = locator<PodDispatchCubit>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final courierCompanyTextController = TextEditingController();
  final awbNumberTextController = TextEditingController();

  String? podCenterIdDropDownValue;
  String? podCenterNameDropDownValue;

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
    cubit.fetchPodCenterList();
  });

  void disposeFunction() => frameCallback(() {
    cubit.resetState();
  });


  // Submit Pod Api call
  void submitPodApiCall() {
    if (widget.loadId == null && widget.loadId!.isEmpty) {
      ToastMessages.error(message: "Something went wrong - Load Id : ${widget.loadId}");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (podCenterNameDropDownValue != null && podCenterNameDropDownValue!.isEmpty) {
        ToastMessages.alert(message: "Something went wrong - Pod Center Name : $podCenterNameDropDownValue");
        return;
      }

      final request = SubmitPodApiRequest(
          loadId: widget.loadId!,
          courierCompany: courierCompanyTextController.text,
          awbNumber: awbNumberTextController.text,
          podCenterId: podCenterIdDropDownValue!,
          podCenterName: podCenterNameDropDownValue!
      );
      cubit.submitPod(request);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.podDispatch),
      body: _buildBodyWidget(context),
      bottomNavigationBar: _buildSubmitButtonWidget(),
    );
  }

  // Body
  Widget _buildBodyWidget(BuildContext context){
    return  SafeArea(
      minimum : EdgeInsets.all(commonSafeAreaPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [

            // Courier Company
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: courierCompanyTextController,
              labelText: context.appText.courierCompany,
              hintText: "LED TV 42”",
              textInputAction: TextInputAction.next,
            ),

            // AWB Number
            AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: awbNumberTextController,
              labelText: context.appText.awbNumber,
              hintText: "54678765436898",
              textInputAction: TextInputAction.next,
            ),

            orDivider(),


            // POD Center
            BlocConsumer<PodDispatchCubit, PodDispatchState>(
              bloc: cubit,
              listenWhen: (previous, current) =>  previous.podCenterListUIState?.status != current.podCenterListUIState?.status,
              listener: (context, state) {
                final status = state.podCenterListUIState?.status;

                if (status == Status.ERROR) {
                  final error = state.podCenterListUIState?.errorType;
                  ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                }

              },
              builder: (context, state) {
                final data = state.podCenterListUIState?.data;
                if(data != null && data.data.isNotEmpty){
                  return Column(
                    children: [
                      AppDropdown(
                        validator: (value) => Validator.fieldRequired(value),
                        labelText: context.appText.podCenter,
                        hintText: "Select POD Center",
                        dropdownValue: podCenterIdDropDownValue,
                        decoration: commonInputDecoration(fillColor: Colors.white),
                        dropDownList: data.data.map((e) => DropdownMenuItem(
                          value: e.podCenterId,
                          child: Text(e.podCenterName.capitalize, style: AppTextStyle.body),
                          onTap: (){
                            podCenterIdDropDownValue = e.podCenterId;
                            podCenterNameDropDownValue = e.podCenterName;
                          },
                        )).toList(),
                        onChanged: (onChangeValue) {
                          podCenterIdDropDownValue = onChangeValue;
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),

          ],
        ),
      ),
    );
  }


  ///  Submit Button
  Widget _buildSubmitButtonWidget(){
    return BlocConsumer<PodDispatchCubit, PodDispatchState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.submitPodUIState?.status != current.submitPodUIState?.status,
      listener: (context, state) async {
        final status = state.submitPodUIState?.status;
        if (status == Status.SUCCESS) {
           Navigator.of(context).pop(true);
        }
        if (status == Status.ERROR) {
          final error = state.submitPodUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final isLoading = state.submitPodUIState?.status == Status.LOADING;
        return AppButton(
          title: context.appText.submit,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () => submitPodApiCall(),
        ).bottomNavigationPadding();
      },
    );
  }


 // Or Divider
  Widget orDivider() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            context.appText.or,
            style: AppTextStyle.textGreyDetailColor14w400.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
          color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
