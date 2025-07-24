import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/aadhaar_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';


class EnterAadhaarNumberBottomSheet extends StatefulWidget {
  const EnterAadhaarNumberBottomSheet({super.key});

  @override
  State<EnterAadhaarNumberBottomSheet> createState() => _EnterAadhaarNumberBottomSheetState();
}

class _EnterAadhaarNumberBottomSheetState extends BaseState<EnterAadhaarNumberBottomSheet> {

  final formKey = GlobalKey<FormState>();

  final kycBloc = locator<KycCubit>();
  final profileCubit = locator<ProfileCubit>();
  final lpHomeBloc = locator<LpHomeBloc>();

  final TextEditingController aadhaarNumberTextController = TextEditingController();
  final TextEditingController aadhaarNumberOtpTextController = TextEditingController();

  String? requestID;
  String? aadhaarValue;

  // bool showOtpFieldAadhaar = false;
  final ValueNotifier<bool> showOtpFieldAadhaarNotifier = ValueNotifier(false);



  @override
  void initState() {
    initFunction();
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId();
    // Reset local state
    showOtpFieldAadhaarNotifier.value = false;
    aadhaarNumberTextController.clear();
    aadhaarNumberOtpTextController.clear();
    requestID = '';
    aadhaarValue = null;
    // Reset Cubit state (important)
    kycBloc.resetState();
  });



  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      hideDivider: false,
      isCloseButton: false,
      body: _buildBodyWidget(),
      title: context.appText.verifyYourKYC
    );
  }

  /// Body
  Widget _buildBodyWidget() {
    return BlocConsumer<KycCubit, KycState>(
      bloc: kycBloc,
      listener: (context, state) {

        final otpState = state.aadhaarOtpState;
        if (otpState?.status == Status.SUCCESS) {
          requestID = otpState?.data?.data?.requestId ?? '123456';
          showOtpFieldAadhaarNotifier.value = true;
        }

        final verifyState = state.aadhaarVerifyOtpState;
        if (verifyState?.status == Status.SUCCESS) {
          showOtpFieldAadhaarNotifier.value = false;
          analyticsHelper.logEvent(AnalyticEventName.AADHAAR_VERIFICATION_SUCCESS, {"aadhaarNumber" : aadhaarNumberTextController.text});
          context.pop();
          Navigator.of(context).push(commonRoute(KycUploadDocumentScreen(aadhaarNumber: aadhaarNumberTextController.text))).then((v) {
            if(v != null && v == true){
              profileCubit.fetchProfileDetail();
              aadhaarNumberTextController.clear();
              aadhaarNumberOtpTextController.clear();
            }
          });
        }

        if (otpState?.status == Status.ERROR) {
          analyticsHelper.logEvent(AnalyticEventName.AADHAAR_VERIFICATION_FAILED, {"message" : getErrorMsg(errorType: otpState!.errorType!)});
          ToastMessages.error(message: getErrorMsg(errorType: otpState.errorType!));
        }
      },
      builder: (context, state) {
        final otpState = state.aadhaarOtpState;
        final isLoading = otpState?.status == Status.LOADING;
        return ValueListenableBuilder<bool>(
          valueListenable: showOtpFieldAadhaarNotifier,
          builder: (context, showOtp, _) {
            return showOtp ? _buildAadhaarVerificationWidget(isLoading, context) : _buildAadhaarFormWidget(isLoading, context);
          },
        );
      },
    );
  }

  /// Aadhaar Form
  Widget _buildAadhaarFormWidget(bool isLoading, BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.height,

          // Aadhaar Text Field
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: aadhaarNumberTextController,
            keyboardType: iosNumberKeyboard,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              AadhaarInputFormatter()
            ],
            labelText: context.appText.aadhaarLabel,
            hintText: "XXXX XXXX XXXX",
            maxLength: 14,
            onChanged: (value) {
              final aadhaar = value.replaceAll(' ', '');
              aadhaarValue = aadhaar;
              setState(() {});
            },
          ),
          20.height,


          // Verify Aadhaar Button
          AppButton(
            style: aadhaarNumberTextController.text.length == 14 ? AppButtonStyle.primary : AppButtonStyle.disableButton,
            isLoading: isLoading,
            title: context.appText.verifyAadhaar,
            onPressed:  aadhaarNumberTextController.text.length == 14 ?  () async {
               // Navigator.of(context).push(commonRoute(KycScreen(aadhaarNumber: aadhaarNumberTextController.text)));
                if (formKey.currentState!.validate()) {
                  final request = AddharOtpApiRequest(force: false, aadhaar: aadhaarValue ?? "");
                  await kycBloc.sendAadhaarOtp(request);
                }
            } : (){},
          ),
          20.height,


          // I will do it later Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.appText.iWillDoItLater, style: AppTextStyle.body2PrimaryColor),
          ).center(),
        ],
      ),
    );
  }


  /// Aadhaar Verification
  Widget _buildAadhaarVerificationWidget(bool isLoading, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        20.height,

        // Otp text field
        Text(context.appText.verifyAadhaarOtpLabel, style: AppTextStyle.textFiled),
        10.height,

        OtpTextField(
          borderRadius: BorderRadius.circular(commonRadius),
          numberOfFields: 6,
          fieldWidth: MediaQuery.of(context).size.width * 0.13,
          showFieldAsBox: true,
          borderColor: AppColors.borderDisableColor,
          focusedBorderColor: AppColors.primaryColor,
          onCodeChanged: (String code) {},
          onSubmit: (String verificationCode) {
            aadhaarNumberOtpTextController.text = verificationCode;
            setState(() {});
          }, // end
        ).center(),
        30.height,

        // Verify button
        AppButton(
          style: aadhaarNumberOtpTextController.text.length == 6 ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          isLoading: isLoading,
          title: context.appText.verifyCode,
          onPressed: () {
            if(aadhaarNumberOtpTextController.text.length == 6){
              if(requestID ==''){
                requestID = '123456';
              }
              final apiRequest =  AddharVerifyOtpApiRequest(
                requestId: requestID ?? "123456",
                otp: aadhaarNumberOtpTextController.text.trim(),
                aadhaar: aadhaarValue ?? "",
              );
              kycBloc.verifyAadhaarOtp(apiRequest);
            }
          },
        ),
        20.height,

        // I will do it later Button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.appText.iWillDoItLater, style: AppTextStyle.body2PrimaryColor),
        ).center(),
      ],
    );
  }


}
