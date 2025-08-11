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
import 'package:gro_one_app/features/kyc/api_request/init_kyc_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/helper/kyc_helper.dart';
import 'package:gro_one_app/features/kyc/model/aadhar_status_response.dart';
import 'package:gro_one_app/features/kyc/model/kyc_init_response.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/kyc/view/kyc_verification_webview.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
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

  String? aadharRequestId;



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

   Future<void> _checkKycVerification(AadharVerificationData? aadharVerificationData)async{
     String? statusVerified=aadharVerificationData?.status;
     if(statusVerified=="VERIFIED"){
       String? path= await KycHelper.saveBase64PdfToFile(aadharVerificationData?.dataPdf??"");
       Navigator.pop(context);
       Navigator.of(navigatorKey.currentState!.context).push(commonRoute(KycUploadDocumentScreen(aadhaarNumber: aadhaarNumberTextController.text,pdfPath: path,))).then((v) {
         if(v != null && v == true){
           profileCubit.fetchProfileDetail();
           aadhaarNumberTextController.clear();
           aadhaarNumberOtpTextController.clear();
         }
       });
       return;
     }
   }



  Future<void> _checkVerification(KycInitResponse? kycInitResponse) async {
    String? sdkUrl=kycInitResponse?.sdkUrl??"";
    aadharRequestId??=kycInitResponse?.requestId??"";

    if(sdkUrl.isNotEmpty){
    final isVerified= await Navigator.push(context, commonRoute(KycVerificationWebView(
        url: sdkUrl,
      )));

     if(isVerified!=null && isVerified){
       kycBloc.getKYCStatus(aadharRequestId??"");
     }
    }
  }

  /// Body
  Widget _buildBodyWidget() {
    return BlocConsumer<KycCubit, KycState>(
      bloc: kycBloc,
      listenWhen: (previous, current) => previous.kycInitResponse!=current.kycInitResponse || previous.aadharVerificationState!=current.aadharVerificationState,
      listener: (context, state) {
        final initState = state.kycInitResponse;

        if (initState?.status == Status.SUCCESS) {
          requestID = initState?.data?.requestId ?? '123456';
          _checkVerification(initState?.data);
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
        final aadharVerificationResponse = state.aadharVerificationState;
        if(aadharVerificationResponse?.status==Status.SUCCESS){
          _checkKycVerification(aadharVerificationResponse?.data?.data);
        }

        // if (verifyState?.status == Status.ERROR) {
        //   analyticsHelper.logEvent(AnalyticEventName.AADHAAR_VERIFICATION_FAILED, {"message" : getErrorMsg(errorType: verifyState!.errorType!)});
        //   ToastMessages.error(message: getErrorMsg(errorType: verifyState.errorType!));
        // }
      },
      builder: (context, state) {
        final kycInitState = state.kycInitResponse;
        final isLoading = kycInitState?.status == Status.LOADING;
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
              /// TODO
              /// 1 : TEMP navigation
              /// 2 : REMOVE AFTER THIS IS STATED WORKING
              /// 3:  REMOVE return; statement

              // Navigator.of(context).push(commonRoute(KycScreen(aadhaarNumber: aadhaarNumberTextController.text)));
                if (formKey.currentState!.validate()) {
                  final request = KycInitRequest(aadharNumber:  aadhaarValue ?? "");
                  await kycBloc.sendKycRequest(request);
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
