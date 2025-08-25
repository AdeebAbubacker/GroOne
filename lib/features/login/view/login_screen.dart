import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/features/privacy_policy/view/privacy_polcy_screen.dart';
import 'package:gro_one_app/features/terms_and_conditions/view/terms_and_conditions_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/enhanced_dispose.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/nullable_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

class LoginScreen extends StatefulWidget {
  final bool showBackButton;
  const LoginScreen({super.key, this.showBackButton = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen>
    with EnhancedDisposeMixin {
  final loginBloc = locator<LoginBloc>();
  final formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();
  TextEditingController phoneNumber = TextEditingController();
  bool checkBoxBool = false;

  @override
  void initState() {
    // Add focus node to dispose list
    addNotifier(focusNode);
    addNotifier(phoneNumber);

    initFun();
    super.initState();
  }

  initFun() => safePostFrameCallback(() async {
    await HasInternetConnection().checkConnectivity();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: CommonOnboardingAppbar(),
      appBar: CommonOnboardingAppbar(showBackButton: widget.showBackButton),
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) async {
          if (state is LogInSuccess) {
            ToastMessages.success(
              message: context.appText.otpHasBeenSentSuccessfully,
            );
            await Future.delayed(Duration(seconds: 1));
            final extra = {
              "mobileNumber": state.loginApiResponseModel.mobile.toString(),
              "otp": state.loginApiResponseModel.otp.toString(),
              "driver": state.loginApiResponseModel.driver,
            };
            if (context.mounted) {
              context.push(AppRouteName.otpVerificationScreen, extra: extra);
            }
            analyticsHelper.logEvent(AnalyticEventName.ONBOARD_OTP_SENT);
          }

          if (state is LogInError) {
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LogInLoading;
          return Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,

                      // Login Heading
                      Text(
                        context.appText.loginSingUp,
                        style: AppTextStyle.h2W600,
                      ),
                      10.height,

                      // Login Sub Heading
                      Text(
                        context.appText.enterMobileNumber,
                        style: AppTextStyle.body1Normal,
                      ),
                      5.height,

                      AppTextField(
                        validator: (value) => Validator.phone(value),
                        controller: phoneNumber,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: iosNumberKeyboard,
                        decoration: commonInputDecoration(
                          hintText:
                              "${context.appText.enter} ${context.appText.your} ${context.appText.phoneNumber}",
                          prefixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(AppImage.png.flag),
                              10.width,
                              Text(
                                "+91",
                                style: AppTextStyle.textFieldHintBlackColor,
                              ),
                            ],
                          ).paddingOnly(left: 20, right: 5),
                        ),
                        onChanged: (v) {
                          setState(() {});
                        },
                      ),
                      20.height,

                      // Get Otp Button
                      AppButton(
                        isLoading: isLoading,
                        title: context.appText.getOtp,
                        style:
                            (phoneNumber.text.length == 10 &&
                                    checkBoxBool == true)
                                ? AppButtonStyle.primary
                                : AppButtonStyle.disableButton,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (phoneNumber.text.length == 10 &&
                              checkBoxBool == true) {
                            loginBloc.add(
                              LoginInRequested(
                                apiRequest: LoginApiRequest(
                                  mobile: int.parse(phoneNumber.text.toInt),
                                  type: 1,
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      20.height,

                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: context.appText.agree,
                              style: AppTextStyle.blackColor14w400,
                            ),
                            TextSpan(
                              text: context.appText.termsAndConditions,
                              style: AppTextStyle.primaryColor14w400UnderLine,
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle terms & conditions tap
                                      Navigator.push(
                                        context,
                                        commonRoute(TermsAndConditionsScreen()),
                                      );
                                    },
                            ),
                            TextSpan(
                              text: context.appText.and,
                              style: AppTextStyle.blackColor14w400,
                            ),
                            TextSpan(
                              text: context.appText.privacyPolicy,
                              style: AppTextStyle.primaryColor14w400UnderLine,
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        commonRoute(PrivacyPolicyScreen()),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),

                      1.height,
                      customCheckbox(
                        context: context,
                        text: context.appText.iAgree,
                        onTap: () {
                          checkBoxBool = !checkBoxBool;
                          safeSetState(() {}); // ✅ Safe setState
                        },
                        selected: checkBoxBool,
                      ),
                    ],
                  ),
                ),

                // Bottom Banner Gro Image
                buildBottomBannerImageWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bottom Banner Gro Image
  Widget buildBottomBannerImageWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        alignment: Alignment.bottomCenter,
        AppImage.svg.hindujaLogo,
        width: double.infinity,
        fit: BoxFit.fitWidth,
         height: 50,
      ),
    ).expand();
  }
}
