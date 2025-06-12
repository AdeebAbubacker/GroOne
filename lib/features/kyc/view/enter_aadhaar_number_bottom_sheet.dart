import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/view/kyc_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
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

class _EnterAadhaarNumberBottomSheetState extends State<EnterAadhaarNumberBottomSheet> {

  final formKey = GlobalKey<FormState>();

  final kycBloc = locator<KycCubit>();
  final lpHomeBloc = locator<LpHomeBloc>();

  final TextEditingController aadhaarNumberTextController = TextEditingController();
  final TextEditingController aadhaarNumberOtpTextController = TextEditingController();

  String? requestID;

  bool showOtpFieldAadhaar = false;


  @override
  void initState() {
    initFunction();
    super.initState();
  }


  void initFunction()=> frameCallback(() async {
    await lpHomeBloc.getUserId();
    showOtpFieldAadhaar=false;
    aadhaarNumberOtpTextController.clear();
    aadhaarNumberOtpTextController.clear();
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
      builder: (context, state) {
        final otpState = state.aadhaarOtpState;

        final isLoading = otpState?.status == Status.LOADING;

        if (showOtpFieldAadhaar) {
          return _buildAadhaarVerificationWidget(isLoading, context);
        } else {
          return _buildAadhaarFormWidget(isLoading, context);
        }
      },
      listener: (context, state) {
        final otpState = state.aadhaarOtpState;

        if (otpState?.status == Status.SUCCESS) {
          final result = otpState?.data;
          requestID = result?.data?.requestId;
          showOtpFieldAadhaar = true;
          setState(() {});
        }

        if (otpState?.status == Status.ERROR) {
          ToastMessages.error(message: getErrorMsg(errorType: otpState!.errorType!));
        }

        final verifyState = state.aadhaarOtpState;

        if (verifyState?.status == Status.SUCCESS) {
          showOtpFieldAadhaar = false;
          setState(() {});
          context.pop();
          context.push(AppRouteName.kycScreen, extra: {"addharNumber": aadhaarNumberTextController.text,}).then((v) {
            lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "0"));
            aadhaarNumberTextController.clear();
            aadhaarNumberOtpTextController.clear();
          });
        }
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
            keyboardType: TextInputType.number,
            labelText: context.appText.aadhaarLabel,
            hintText: "XXXX XXXX XXXX XXXX",
            maxLength: 14,
            inputFormatters: [AadhaarInputFormatter()],
            onChanged: (value) {
              aadhaarNumberTextController.text = value;
              setState(() {});
            },
          ),
          20.height,


          // Verify Aadhaar Button
          AppButton(
            style:aadhaarNumberTextController.text.length == 14 ? AppButtonStyle.primary : AppButtonStyle.disableButton,
            isLoading: isLoading,
            title: context.appText.verifyAadhaar,
            onPressed: () async {
              if(aadhaarNumberTextController.text.length == 14){
                Navigator.of(context).push(commonRoute(KycScreen(aadhaarNumber: aadhaarNumberTextController.text)));
                // if (formKey.currentState!.validate()) {
                //   final request = AddharOtpApiRequest(force: false, aadhaar: aadhaarNumberTextController.text);
                //   await kycBloc.sendAadhaarOtp(request);
                // }
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
              final apiRequest =  AddharVerifyOtpApiRequest(
                requestId: requestID ?? "",
                otp: aadhaarNumberOtpTextController.text,
                aadhaar: aadhaarNumberTextController.text,
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
