import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

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
import 'package:gro_one_app/utils/textFieldInputFormatter/alpha_only_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/no_space_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

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

class VpPodDispatchScreen extends StatefulWidget {
  final String? loadId;
  const VpPodDispatchScreen({super.key, this.loadId});

  @override
  State<VpPodDispatchScreen> createState() => _VpPodDispatchScreenState();
}

class _VpPodDispatchScreenState extends State<VpPodDispatchScreen> {
  final cubit = locator<PodDispatchCubit>();
  final loadDetailsCubit = locator<LoadDetailsCubit>();

  final courierCompanyTextController = TextEditingController();
  final awbNumberTextController = TextEditingController();

  static final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  String? podCenterIdDropDownValue;
  bool isPodCenterDropDownEnabled = false;

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

  void disposeFunction() => frameCallback(() {
    cubit.resetState();
  });

  void clearTextFields() {
    courierCompanyTextController.clear();
    awbNumberTextController.clear();
  }

  void clearDropDownFields() {
    podCenterIdDropDownValue = null;
  }

  // Submit Pod Api call
  void submitPodApiCall() {
    if (widget.loadId == null || widget.loadId!.isEmpty) {
      ToastMessages.error(
        message:
            "${context.appText.somethingWentWrong} - "
            "${context.appText.loadId} : ${widget.loadId}",
      );
      return;
    }

    final bool isCourierEntered =
        courierCompanyTextController.text.trim().isNotEmpty;
    final bool isAwbEntered = awbNumberTextController.text.trim().isNotEmpty;

    // Both fields are now required (since Pod Center is removed)
    if (!isCourierEntered || !isAwbEntered) {
      if (!isCourierEntered) {
        ToastMessages.alert(message: context.appText.pleaseEnterCourierCompany);
      }

      if (!isAwbEntered) {
        ToastMessages.alert(message: context.appText.pleaseEnterawbNumber);
      }
      return;
    }

    final request = SubmitPodApiRequest(
      loadId: widget.loadId!,
      courierCompany: courierCompanyTextController.text.trim(),
      awbNumber: awbNumberTextController.text.trim(),
      podCenterId: "", // no pod center id because field removed
      podCenterName: "",
    );

    cubit.submitPod(request);
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
  Widget _buildBodyWidget(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          // Courier Company
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: courierCompanyTextController,
            labelText: context.appText.courierCompany,
            hintText: context.appText.enterCourierCompany,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              AlphaOnlyTextFormatter(),
              LengthLimitingTextInputFormatter(50),
            ],
            onChanged: (value) {
              clearDropDownFields();
            },
          ),

          // AWB Number
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: awbNumberTextController,
            labelText: context.appText.awbNumber,
            hintText: "54678765436898",
            textInputAction: TextInputAction.next,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              NoSpaceTextFormatter(),
            ],
            onChanged: (value) {
              clearDropDownFields();
            },
          ),
        ],
      ),
    );
  }

  ///  Submit Button
  Widget _buildSubmitButtonWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocConsumer<PodDispatchCubit, PodDispatchState>(
          bloc: cubit,
          listenWhen:
              (previous, current) =>
                  previous.submitPodUIState?.status !=
                  current.submitPodUIState?.status,
          listener: (context, state) async {
            final status = state.submitPodUIState?.status;
            if (status == Status.SUCCESS) {
              Navigator.of(context).pop(true);
              analyticsHelper.logEvent(AnalyticEventName.POD_DETAILS_ADDED,{
                "courierCompany":courierCompanyTextController.text,
                "awbNumber":awbNumberTextController.text
              });
            }
            if (status == Status.ERROR) {
              final error = state.submitPodUIState?.errorType;
              ToastMessages.error(
                message: getErrorMsg(errorType: error ?? GenericError()),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.submitPodUIState?.status == Status.LOADING;
            return AppButton(
              title: context.appText.submit,
              isLoading: isLoading,
              onPressed: isLoading ? () {} : () => submitPodApiCall(),
            ).paddingSymmetric(horizontal: 20, vertical: 10);
          },
        ),
        TextButton(
          onPressed: () {
            loadDetailsCubit.skipPodView(value: true);
            Navigator.pop(context);
          },
          child: Text(context.appText.skip),
        ).center(),

        10.height,
      ],
    );
  }

  // Or Divider
  Widget orDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: AppColors.primaryColor)),
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
        Expanded(child: Divider(thickness: 1, color: AppColors.primaryColor)),
      ],
    );
  }
}
