import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/otp_verification/api_request/otp_request.dart';
import 'package:gro_one_app/features/otp_verification/bloc/otp_bloc.dart';
import 'package:gro_one_app/features/otp_verification/model/otp_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

import '../../../data/storage/secured_shared_preferences.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/extra_utils.dart';
import '../../../utils/toast_messages.dart';
import '../../choose_language_screen/view/choose_language_screen.dart';

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

  int _start = 52;
  Timer? _timer;

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

  void homeRedirection(OtpResponse data, BuildContext context,{required tempFlag}) => addPostFrameCallback((){
    debugPrint("homeRedirection ${data.toJson()}");
    if (data.data?.user?.role == 1) {
      if (tempFlag) {
        context.push(AppRouteName.lpCreateAccount, extra: {"id": data.data!.user!.id.toString(),"mobileNumber":widget.mobileNumber});
      } else {
        context.push(AppRouteName.lpBottomNavigationBar);
      }
    } else if (data.data?.user?.role == 2) {
      if (tempFlag) {
        Navigator.push(context, commonRoute(VpCreationFormScreen(id: data.data!.user!.id.toString(),mobileNumber:widget.mobileNumber), isForward: true));
      } else {
        context.push(AppRouteName.vpBottomNavigationBar);
      }
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,

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
          if (state is OtpResendSuccess) {
            otpString = "";
            ToastMessages.success(message: state.loginApiResponseModel.message);
          }
          if (state is OtpSuccess) {
            if (state.otpResponse.data!.user!.tempflg) {
               homeRedirection(state.otpResponse, context,tempFlag: state.otpResponse.data!.user!.tempflg);
            } else {
              showSuccessDialog(
                onTap: () {
                //  context.push(AppRouteName.lpBottomNavigationBar);
                },
                context,
                text: context.appText.loginSuccessful,
                subheading: context.appText.loginSuccessfulSubHeading,
              );
              await Future.delayed(Duration(seconds: 2));
              if(!context.mounted) return;
              homeRedirection(state.otpResponse, context,tempFlag:state.otpResponse.data!.user!.tempflg);
            }
          } else if (state is OtpError) {
            otpString = "";

            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
          setState(() {});
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
                  spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.height,
                    Text(
                      context.appText.otpVerification,
                      style: AppTextStyle.textBlackColor30w500,
                    ),
                    20.height,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.start,
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

                        onCodeChanged: (String code) {

                          otpString=code;
                          setState(() {});},

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
                   //   disableButton: otpString.length == 4 ? false : true,
                      style: otpString.length == 4 ?AppButtonStyle.primary:AppButtonStyle.disableButton,
                      onPressed: () {
                       if(otpString.length == 4 ) {
                         otpBloc.add(
                           OtpRequested(
                             apiRequest: OtpRequest(
                               mobile: widget.mobileNumber,
                               role: int.parse(widget.roleId),
                               otp: int.parse(otpString),
                             ),
                           ),
                         );
                       }
                      },
                    ),
                    5.height,
                    AppButton(
                      isLoading: isLoadingResend,
                      richTextWidget:
                          _isButtonEnabled
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
                                      style: AppTextStyle.primaryColor16w900,
                                    ),
                                    TextSpan(
                                      text: context.appText.inText,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextSpan(
                                      text: '$_start',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(
                                      text: context.appText.second,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                      onPressed: () {
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
                      style: AppButtonStyle.outline,
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
