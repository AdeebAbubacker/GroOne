import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/otp_verification/api_request/mobile_otp_verification_api_request.dart';
import 'package:gro_one_app/features/otp_verification/bloc/otp_bloc.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:pinput/pinput.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/extra_utils.dart';
import '../../../utils/toast_messages.dart';

class MobileOtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String otp;
  final bool isDriver;
  const MobileOtpVerificationScreen({super.key, required this.mobileNumber, required this.otp, required this.isDriver,});

  @override
  State<MobileOtpVerificationScreen> createState() => _MobileOtpVerificationScreenState();
}

class _MobileOtpVerificationScreenState extends State<MobileOtpVerificationScreen> {
  final otpBloc = locator<OtpBloc>();

  final otpTextController = TextEditingController();

  String otpString = "";

  bool clearOtp = false;
  bool _isButtonEnabled = false;

  int _start = 52;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _start = 10;
      _isButtonEnabled = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Home Redirection
  void homeRedirection(MobileOtpVerificationModel data, BuildContext context, {required tempFlag}) => frameCallback(() {
    // LP Redirection
    if (data?.roleId == 1) {
      if (tempFlag) {
        context.push(
          AppRouteName.chooseRoleScreen,
          extra: {
            "userId": data.roleId.toString(),
            "mobileNumber": widget.mobileNumber.toString(),
          },
        );
      } else {
        loginSuccessDialog(context, AppRouteName.lpBottomNavigationBar);
      }
    } else if (data.roleId == 2) {
      // VP Redirection
      if (tempFlag) {
         context.push(
          AppRouteName.chooseRoleScreen,
          extra: {
            "userId": data.roleId.toString(),
            "mobileNumber": widget.mobileNumber,
          },
        );
         } else {
        loginSuccessDialog(context, AppRouteName.vpBottomNavigationBar);
      }
    } else if (data.roleId == 3) {
      // Both VP & LP Redirection
      if (tempFlag) {
         context.push(
          AppRouteName.chooseRoleScreen,
          extra: {
            "userId": data.roleId.toString(),
            "mobileNumber": widget.mobileNumber,
          },
        );
         } else {
        loginSuccessDialog(context, AppRouteName.lpBottomNavigationBar);
      }
    }
  });

  // Login Success Popup
  void loginSuccessDialog(BuildContext context, String routeName) {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.loginSuccessfully,
        message: context.appText.nowYouCanExploreRates,
        afterDismiss: () => context.go(routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonOnboardingAppbar(),
      body: BlocConsumer(
        bloc: otpBloc,
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is OtpResendSuccess) {
            otpString = "";
          ToastMessages.success(message: context.appText.otpHasBeenSentSuccessfully);
          }
          if (state is OtpSuccess) {
            final data = state.otpResponse;
            final tempFlag = data.tempFlg ?? false;

            //  1. Check if it's a driver

            if (data.driver == true) {
            loginSuccessDialog(context, AppRouteName.driverHome);
            return;
            }
          
            if (tempFlag) {
              context.push(
                AppRouteName.chooseRoleScreen,
                extra: {
                  "userId": data.customerId,
                  "mobileNumber": widget.mobileNumber,
                },
              );
            } else {
              // Navigate to respective home based on role
              final role = data.roleId;
              if (role == 1) {
                loginSuccessDialog(context, AppRouteName.lpBottomNavigationBar);
              } else if (role == 2) {
                loginSuccessDialog(context, AppRouteName.vpBottomNavigationBar);
              } else if (role == 3) {
                // both VP + LP, handle as per your app logic
                loginSuccessDialog(context, AppRouteName.lpBottomNavigationBar);
              }
            }
            if (state.otpResponse!.tempFlg) {
              homeRedirection(
                state.otpResponse,
                context,
                tempFlag: state.otpResponse!.tempFlg,
              );
            } else {
              if (!context.mounted) return;
              homeRedirection(
                state.otpResponse,
                context,
                tempFlag: state.otpResponse!.tempFlg,
              );
            }
          }
          if (state is OtpError) {
            otpTextController.clear();
            otpString = "";
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpLoading;
          final isLoadingResend = state is OtpResendLoading;
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,
                  Text(context.appText.mobileOtpVerification, style: AppTextStyle.h2W600),
                  20.height,
                  Row(
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        context.appText.enterOtpSendNumber,
                        style: AppTextStyle.textBlackColor18w400,
                      ),

                      Text(
                        maskPhoneNumber(widget.mobileNumber),
                        style: AppTextStyle.primaryColor18w400UnderLine
                            .copyWith(decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  20.height,

                  // Otp Text Field
                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    controller: otpTextController,
                    autofocus: true,
                    length: 4,
                    keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursor: Text("|", style: TextStyle(fontSize: 20)),
                    onChanged: (pin) {
                      otpString = pin;
                      setState(() {});
                    },
                    onCompleted: (pin) {
                      otpString = pin;
                      setState(() {});
                    },
                  ).center(),
                  30.height,

                  // Verify Button
                  AppButton(
                    title: context.appText.verifyCode,
                    isLoading: isLoading,
                    style: otpString.length == 4 ? AppButtonStyle.primary : AppButtonStyle.disableButton,
                    onPressed: () {
                      if (otpString.length == 4) {
                        otpBloc.add(
                          OtpRequested(
                            apiRequest: OtpRequest(
                              mobile: widget.mobileNumber,
                               type: 2,
                              otp: int.parse(otpString),
                             driver: widget.isDriver
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  20.height,

                  // Resend OTP Button
                  AppButton(
                    style: _isButtonEnabled ? AppButtonStyle.outline : AppButtonStyle.disableOutline,
                    isLoading: isLoadingResend,
                    richTextWidget:
                        _isButtonEnabled
                            ? Text(
                              context.appText.resend,
                              style: AppTextStyle.buttonPrimaryColorTextColor,
                            )
                            : RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 16.0),
                                children: [
                                  TextSpan(
                                    text: context.appText.resend,
                                    style:
                                        _isButtonEnabled
                                            ? AppTextStyle
                                                .buttonPrimaryColorTextColor
                                            : AppTextStyle
                                                .buttonDisableColorTextColor,
                                  ),
                                  TextSpan(
                                    text: context.appText.inText,
                                    style: AppTextStyle.buttonDisableColorTextColor,
                                  ),
                                  TextSpan(
                                    text: '$_start ',
                                    style: AppTextStyle.button.copyWith(
                                      color: AppColors.activeGreenColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: context.appText.second,
                                    style:
                                        AppTextStyle
                                            .buttonDisableColorTextColor,
                                  ),
                                ],
                              ),
                            ),
                    onPressed: () {
                      if (_isButtonEnabled) {
                        final apiRequest = LoginApiRequest(
                          mobile: int.parse(widget.mobileNumber),
                          type: 1,
                        );
                        otpBloc.add(OtpResendRequested(apiRequest: apiRequest));
                        startTimer();
                        otpTextController.clear();
                      }
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: commonSafeAreaPadding),

              // Bottom Banner Gro Image
              buildBottomBannerImageWidget(),
            ],
          );
        },
      ),
    );
  }

  // Bottom Banner Gro Image Widget
  Widget buildBottomBannerImageWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        AppImage.png.signUpBanner,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    ).expand();
  }
}
