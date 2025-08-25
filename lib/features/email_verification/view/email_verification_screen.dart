import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/global_variables.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String emailAddress;
  final String userId;
  const EmailVerificationScreen({super.key, required this.emailAddress, required this.userId});


  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  final cubit = locator<EmailVerificationCubit>();

  final otpTextController = TextEditingController();

  @override
  void initState() {
    cubit.startTimer();
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() {
    cubit.startTimer(startFrom: 30);
  });

  void disposeFunction() => frameCallback(() {
    otpTextController.dispose();
    cubit.resetResendAndVerifyOtpUIState();
  });


  void setOtpCode(String pin){
    if(pin.length == 4) {
      cubit.enableVerifyButton(true);
    } else {
      cubit.enableVerifyButton(false);
    }
    cubit.setOtp(pin);
    debugPrint(pin);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBodyWidget(),
    );
  }

  /// App Bar
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return CommonOnboardingAppbar();
  }

  /// Body
  Widget buildBodyWidget() {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          30.height,

          buildHeadingWidget(),
          40.height,

          buildOTPTextFieldWidget(),
          40.height,

          buildVerifyCodeButtonWidget(),
          20.height,

          buildResendCodeButtonWidget(),

          buildBottomBannerImageWidget()
        ],
      ),
    );
  }


  // Heading & Email Content
  Widget buildHeadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text(context.appText.emailOtpVerification, style: AppTextStyle.h2W600),
        20.height,

        // Email Content
        Wrap(
          spacing: 5,
          children: [
            Text(context.appText.enterOtpSendNumber, textAlign: TextAlign.start, style: AppTextStyle.body2),
            Text(widget.emailAddress, style: AppTextStyle.body2PrimaryColor),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }


  // Verify Code Button
  Widget buildVerifyCodeButtonWidget(){
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.verifyOtpState != current.verifyOtpState,
      listener: (context, state) {
        if (state.verifyOtpState?.status == Status.SUCCESS) {
            Navigator.of(context).pop(true);
        }
        if (state.verifyOtpState?.status == Status.ERROR) {
          final error = state.verifyOtpState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final bool isLoading = state.verifyOtpState?.status == Status.LOADING;
        final bool isCodeLengthValid = state.otpCode.length == 4;
        return AppButton(
          title: context.appText.verifyCode,
          isLoading: isLoading,
          style: isCodeLengthValid ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          onPressed: !isLoading && isCodeLengthValid ? () async {
            final request = VerifyEmailOtpApiRequest(otp: int.parse(otpTextController.text), customerId: widget.userId);
            await  cubit.verifyOtp(request);
          } : (){},
        );
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }


  // Resend Code Button
  Widget buildResendCodeButtonWidget() {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.resendOtpState != current.resendOtpState,
      listener: (context, state) {
        if (state.resendOtpState?.status == Status.SUCCESS) {
          otpTextController.clear();
          cubit.startTimer(startFrom: 30);
        }
        if (state.resendOtpState?.status == Status.ERROR) {
          final error = state.resendOtpState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final bool isLoading = state.resendOtpState?.status == Status.LOADING;
        final bool resendButtonEnabled = state.isResendButtonEnabled;
        return AppButton(
          style: resendButtonEnabled ?  AppButtonStyle.disableOutline : AppButtonStyle.outline,
          richTextWidget: !state.isResendButtonEnabled
              ? Text((isLoading ? "${context.appText.loading}.." : context.appText.resend), style: resendButtonEnabled ? AppTextStyle.buttonDisableColorTextColor : AppTextStyle.buttonPrimaryColorTextColor)
              : RichText(
            text: TextSpan(
              children: [
                TextSpan(text: context.appText.resend, style:  resendButtonEnabled ? AppTextStyle.buttonDisableColorTextColor :   AppTextStyle.buttonPrimaryColorTextColor),
                TextSpan(text: context.appText.inText, style: AppTextStyle.buttonPrimaryColorTextColor.copyWith(color: Colors.grey)),
                TextSpan(text: ' ${state.timerValue} ', style: AppTextStyle.button.copyWith(color: Colors.green)),
                TextSpan(text: context.appText.second, style: AppTextStyle.button.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          onPressed: !state.isResendButtonEnabled ? () async => await cubit.sendOtp(widget.emailAddress, widget.userId) : (){},
        );
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }



  // OTP Text Filed
  Widget buildOTPTextFieldWidget(){
    return BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
      bloc: cubit,
      builder: (context, state) {
        return Pinput(
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          controller: otpTextController,
          autofocus: true,
          length: 4,
          keyboardType: isAndroid  ? TextInputType.number : iosNumberKeyboard,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          cursor: Text("|", style: TextStyle(fontSize: 20)),
          onChanged: (pin)=> setOtpCode(pin),
          onCompleted: (pin)=> setOtpCode(pin),
        ).center();
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  // Bottom Banner Gro Image Widget
  Widget buildBottomBannerImageWidget(){
    return Container(
      alignment: Alignment.bottomCenter,
      child:SvgPicture.asset(
        alignment: Alignment.bottomCenter,
        AppImage.svg.hindujaLogo,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        height: 50,
      ),
    ).expand();
  }

}


