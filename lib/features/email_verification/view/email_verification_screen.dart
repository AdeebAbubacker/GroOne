import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String emailAddress;
  const EmailVerificationScreen({super.key, required this.emailAddress});


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

  });

  void disposeFunction() => frameCallback(() {

  });


  Future verifyCode() async {
    final request = VerifyEmailOtpApiRequest(email: widget.emailAddress, otp: otpTextController.text);
    await  cubit.verifyOtp(request);
  }

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
    return CommonAppBar(
      actions: [
        translateWiget(
          onTap: () {
            Navigator.push(
              context,
              commonRoute(ChooseLanguageScreen(isCloseButton: true)),
            );
          },
        ),
        20.width,
        customerSupportWidget(
          onTap: () {
            commonSupportDialog(context);
          },
        ),
        20.width,
        Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
        30.width,
      ],
    );
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
          Container().expand(flex: 2),
          Image.asset(AppImage.png.signUpBanner, width: double.infinity,  fit: BoxFit.fitWidth).expand(flex: 3),
          10.height,
        ],
      ),
    );
  }


  /// Heading & Email Content
  Widget buildHeadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text("Email OTP Verification", style: AppTextStyle.h2W600),
        20.height,

        // Email Content
        Wrap(
          spacing: 5,
          children: [
            Text("Enter the code sent to", textAlign: TextAlign.start, style: AppTextStyle.body2),
            Text(widget.emailAddress, style: AppTextStyle.body2PrimaryColor),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }


  /// Verify Code Button
  Widget buildVerifyCodeButtonWidget(){
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      bloc: cubit,
      listener: (context, state) {
        if (state.verifyOtpState?.status == Status.SUCCESS) {
           // Navigator.of(context).pop(true);
            debugPrint("OTP Verified");
        }
        if (state.verifyOtpState?.status == Status.ERROR) {
            if (state.verifyOtpState?.errorType != null) {
              ToastMessages.error(message: getErrorMsg(errorType: state.verifyOtpState!.errorType!));
            } else {
              ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
            }
        }
      },
      builder: (context, state) {
        final bool isLoading = state.verifyOtpState?.status == Status.LOADING;
        final bool isCodeLengthValid = state.otpCode.length == 4;
        return AppButton(
          title: context.appText.verifyCode,
          isLoading: isLoading,
          style: isCodeLengthValid ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          onPressed: !isLoading && isCodeLengthValid ? () {
            verifyCode();
          } : (){},
        );
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }


  /// Resend Code Button
  Widget buildResendCodeButtonWidget() {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      bloc: cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return AppButton(
          style: AppButtonStyle.outline,
          richTextWidget: state.isResendButtonEnabled
              ? Text(context.appText.resend, style: AppTextStyle.buttonPrimaryColorTextColor)
              : RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16.0),
              children: [
                TextSpan(
                  text: context.appText.resend,
                  style: AppTextStyle.buttonPrimaryColorTextColor,
                ),
                TextSpan(
                  text: context.appText.inText,
                  style: AppTextStyle.buttonPrimaryColorTextColor.copyWith(color: Colors.grey),
                ),
                TextSpan(
                  text: '${state.timerValue}',
                  style: const TextStyle(color: Colors.green),
                ),
                TextSpan(
                  text: context.appText.second,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          onPressed: state.isResendButtonEnabled ? ()=> cubit.startTimer() : (){},
        );
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }



  /// OTP Text Filed
  Widget buildOTPTextFieldWidget(){

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 2), borderRadius: BorderRadius.circular(10)),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
    );

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
          keyboardType: iosNumberKeyboard,
          cursor: Text("|", style: TextStyle(fontSize: 20)),
          onChanged: (pin)=> setOtpCode(pin),
          onCompleted: (pin)=> setOtpCode(pin),
        ).center();
      },
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

}


