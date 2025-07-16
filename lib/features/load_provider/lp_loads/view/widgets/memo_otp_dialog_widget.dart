import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../../data/ui_state/status.dart';

class MemoOtpDialogWidget extends StatefulWidget {
  final BuildContext parentContext;
  final String loadId;

  const MemoOtpDialogWidget({
    super.key,
    required this.parentContext,
    required this.loadId,
  });

  @override
  State<MemoOtpDialogWidget> createState() => _MemoOtpDialogWidgetState();
}

class _MemoOtpDialogWidgetState extends State<MemoOtpDialogWidget> {
  final otpController = TextEditingController();
  final lpLoadLocator = locator<LpLoadCubit>();

  int _secondsRemaining = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void handleOtpVerification(uiState) async {
    if (uiState?.data?.message == 'OTP verified successfully') {
      // Store parent context reference before popping
      final parentCtx = widget.parentContext;

      Navigator.of(parentCtx, rootNavigator: true).pop();

      await lpLoadLocator.clearFirstPostedLoadId();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppDialog.show(
          parentCtx,
          child: SuccessDialogView(
            heading: context.appText.memoESignSuccess,
            onContinue: () {
              LpBottomNavigation.selectedIndexNotifier.value = 1;
              Navigator.pushReplacement(
                parentCtx,
                commonRoute(LpBottomNavigation()),
              );
            },
          ),
        );
      });
    } else {
      final errorType = uiState.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialogView(
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.appText.verifyOtp,
                  style: AppTextStyle.h3.copyWith(
                    fontSize: 26,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextSpan(
                  text:
                  context.appText.otpSendToMobile,
                  style: AppTextStyle.body2.copyWith(height: 1.9),
                ),
                TextSpan(
                  text: context.appText.needHelp,
                  style: AppTextStyle.primaryColor14w400UnderLine,
                  recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      commonSupportDialog(context);
                    },
                ),
              ],
            ),
          ),
          10.height,
          // Text(
          //   'OTP: ${lpLoadLocator.state.lpLoadMemoSendOtp?.data?.otp ?? ''}',
          // ),
          10.height,
          Center(
            child: OtpTextField(
              numberOfFields: 4,
              showFieldAsBox: true,
              fieldWidth: 50,
              fieldHeight: 50,
              fillColor: Color(0xffF8F8F8),
              filled: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              borderColor: AppColors.borderDisableColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              onCodeChanged: (String code) {
                setState(() {
                  otpController.text = code;
                });
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  otpController.text = verificationCode;
                });
              }, // end
            ),
          ),
          30.height,
          AppButton(
            style:
                (otpController.text.length == 4)
                    ? AppButtonStyle.primary
                    : AppButtonStyle.disableButton,
            title: context.appText.verifyOtp,

            onPressed: () async {
              if (otpController.text.length == 4) {
                await lpLoadLocator.verifyOtp(
                  otp: otpController.text,
                  loadId: widget.loadId,
                );
                final uiState = lpLoadLocator.state.lpLoadMemoVerifyOtp;
                handleOtpVerification(uiState);
              }
            },
          ),
          20.height,
          InkWell(
            onTap:
                (_secondsRemaining == 0)
                    ? () async {
                      await lpLoadLocator.sendOtp(loadId: widget.loadId);
                      final otpState = lpLoadLocator.state.lpLoadMemoSendOtp;
                      if (otpState?.status == Status.SUCCESS) {
                        final message = otpState?.data?.message ?? "OTP sent";
                        if (context.mounted) {
                          ToastMessages.success(message: message);
                        }
                        _secondsRemaining = 10;
                        startResendTimer();
                        setState(() {});
                      } else if (otpState?.status == Status.ERROR) {
                        final errorType = otpState?.errorType;
                        ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()),
                        );
                      }
                    }
                    : null,

            child: SizedBox(
              child: Center(
                child: Text(
                  _secondsRemaining > 0
                      ? "Resend OTP in $_secondsRemaining Seconds"
                      : context.appText.resendOtp,
                  style: AppTextStyle.textBlackColor14w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
