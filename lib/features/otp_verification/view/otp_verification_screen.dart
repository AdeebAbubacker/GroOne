import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/otp_verification/api_request/otp_request.dart';
import 'package:gro_one_app/features/otp_verification/bloc/otp_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../data/storage/secured_shared_preferences.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/customButton.dart';
import '../../../utils/extra_utils.dart';
import '../../../utils/toast_messages.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.otp,
    required this.roleId,
  });

  final String mobileNumber;
  final String roleId;
  final String otp;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpBloc = locator<OtpBloc>();
  String otpString = "";
  late final SecuredSharedPreferences _secureSharedPrefs;
  int _start = 52;
  Timer? _timer;

  void startTimer() {
    setState(() {
      _start = 52;
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

  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,

        actions: [
          translateWiget(onTap: () {}),
          20.width,
          customerSupportWidget(
            onTap: () {
              showCustomerCareBottomSheet(context);
            },
          ),
          20.width,
          Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          30.width,
        ],
      ),
      body: BlocConsumer(
        bloc: otpBloc,
        listener: (context, state) async {
          if(state is OtpResendSuccess){
            otpString = "";
            ToastMessages.success(
              message:state.loginApiResponseModel.message,
            );
          }
          if (state is OtpSuccess) {


            if (state.otpResponse.data.user.tempflg) {

              context.push(AppRouteName.lpCreateAccount);
            } else {
              showSuccessDialog(
                onTap: () {
                  context.push(AppRouteName.lpBottomNavigation);
                },
                context,
                text: context.appText.loginSuccessful,
                subheading: context.appText.loginSuccessfulSubHeading,
              );
            }
          } else if (state is OtpError) {
            otpString = "";

            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }setState(() {});
        },
        builder: (context, state) {
          final isLoading = state is OtpLoading;
          final isLoadingResend = state is OtpResendLoading;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 18.0.h,
                  horizontal: 20.w,
                ),
                child: Column(
                  spacing: 10.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    50.height,
                    Text(
                      context.appText.otpVerification,
                      style: AppTextStyle.textBlackColor30w500,
                    ),
                    20.height,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            context.appText.enterOtpSendNumber,
                            style: AppTextStyle.textBlackColor18w400,
                          ),
                        ),
                        Text(
                          maskPhoneNumber(widget.mobileNumber),
                          style: AppTextStyle.primaryColor18w400UnderLine
                              .copyWith(decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    Text(textAlign: TextAlign.center, "otp: ${widget.otp}"),
                    20.height,
                    Center(
                      child: OtpTextField(
                        decoration: InputDecoration(hintText: "-"),
                        numberOfFields: 4,
                        showFieldAsBox: true,
                        fieldWidth: 60,
                        borderColor: AppColors.borderDisableColor,
                        onCodeChanged: (String code) {},

                        onSubmit: (String verificationCode) {
                          otpString = verificationCode;
                          setState(() {});
                          // controller.otp.value.text = verificationCode;
                          // controller.update();
                        }, // end
                      ),
                    ),
                    20.height,

                    AppButton(
                      title: context.appText.verifyCode,
                      isLoading: isLoading,
                      disableButton: otpString.length == 4 ? false : true,
                      onPressed: () {
                        otpBloc.add(
                          OtpRequested(
                            apiRequest: OtpRequest(
                              mobile: widget.mobileNumber,
                              role: int.parse(widget.roleId),
                              otp: int.parse(widget.otp),
                            ),
                          ),
                        );
                      },
                    ),
                    5.height,
                    InkWell(
                      onTap: () {
                        if (_isButtonEnabled) {
                          otpBloc.add(
                            OtpResendRequested(
                              apiRequest: LoginApiRequest(
                                mobile: widget.mobileNumber,
                                role: int.parse(widget.roleId),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child:
          isLoadingResend?SizedBox(height: 20.h,width: 20.w,child: CircularProgressIndicator(color: AppColors.primaryColor,)): _isButtonEnabled
                                  ? Text(
                                    context.appText.resend,
                                    style: AppTextStyle.primaryColor16w900,
                                  )
                                  : RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 16.0),
                                      children: [
                                        TextSpan(
                                          text: context.appText.resend,
                                          style:
                                              AppTextStyle.primaryColor16w900,
                                        ),
                                        TextSpan(
                                          text: '  in  ',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: '$_start',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        TextSpan(
                                          text: ' seconds',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),

                          // Text(
                          //   context.appText.resend,
                          //   style: AppTextStyle.primaryColor16w900,
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox.shrink()),
              Image.asset(AppImage.png.signUpBanner),
            ],
          );
        },
      ),
    );
  }
}
