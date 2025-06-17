import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/mobile_number_text_filed.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'legal_detail_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.roleId});

  final int roleId;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController phoneNumber = TextEditingController();
  bool checkBoxBool = false;

  @override
  void initState() {
    initFun();
    super.initState();
  }

  initFun() => frameCallback(() async {
    await HasInternetConnection().checkConnectivity();
  });

  final loginBloc = locator<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        actions: [
          translateWiget(
              onTap: () {
                Navigator.push(context, commonRoute(ChooseLanguageScreen(isCloseButton: true)));
              },
          ),
          20.width,

          customerSupportWidget(
            onTap: () {
              commonSupportDialog(context);
             // showCustomerCareBottomSheet(context);
            },
          ),
          20.width,

          Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          20.width,
        ],
      ),

      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          if (state is LogInSuccess) {
            context.push(
              AppRouteName.otpVerificationScreen,
              extra: {
                "mobileNumber": state.loginApiResponseModel.data.user.mobileNumber,
                "otp": state.loginApiResponseModel.data.user.otp.toString(),
                "roleId": widget.roleId.toString(),
              },
            );
          }
          if (state is LogInError) {
            ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
          }
        },
        builder: (context, state) {
          final isLoading = state is LogInLoading;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    20.height,

                    // Login Heading
                    Text(context.appText.loginSingUp, style: AppTextStyle.h2W600),
                    10.height,

                    // Login Sub Heading
                    Text(context.appText.enterMobileNumber, style: AppTextStyle.body1Normal),
                    5.height,

                    // Phone Number
                    // MobileNumberTextField(
                    //   countryFlagAssetPath: AppImage.png.flag,
                    //   controller: phoneNumber,
                    //   onChanged: (value){
                    //     setState(() {});
                    //   },
                    // ),
                    AppTextField(
                      validator: (value)=> Validator.phone(value),
                      controller: phoneNumber,
                      //labelText: context.appText.phoneNumber,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: iosNumberKeyboard,
                      decoration: commonInputDecoration(
                        hintText: "${context.appText.enter} ${context.appText.phoneNumber}",
                        prefixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(AppImage.png.flag),
                            10.width,
                            Text("+91", style: AppTextStyle.textFieldHintBlackColor),
                          ],
                        ).paddingOnly(left: 20, right: 5),
                      ),
                      onChanged: (v){
                        setState(() {});
                      },
                    ),
                    20.height,

                    // Get Otp Button
                    AppButton(
                      isLoading: isLoading,
                      title: "Get OTP",
                      style:(phoneNumber.text.length == 10 && checkBoxBool == true) ? AppButtonStyle.primary : AppButtonStyle.disableButton,
                      onPressed: () {
                        if(phoneNumber.text.length == 10 && checkBoxBool == true){
                          loginBloc.add(
                            LoginInRequested(apiRequest: LoginApiRequest(
                              mobile:phoneNumber.text,
                              role: widget.roleId,
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
                            text: "Terms & Conditions",
                            style: AppTextStyle.primaryColor14w400UnderLine,
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle terms & conditions tap
                                    Navigator.push(context,commonRoute(LegalDetailScreen(type: 'terms')));
                                  },
                          ),
                          TextSpan(
                            text: context.appText.and,
                            style: AppTextStyle.blackColor14w400,
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: AppTextStyle.primaryColor14w400UnderLine,
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,commonRoute(LegalDetailScreen(type: 'privacy')));
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
                        setState(() {});
                      },
                      selected: checkBoxBool,
                    ),
                  ],
                ),
              ),
              Container().expand(flex: 2),
              Image.asset(AppImage.png.signUpBanner, width: double.infinity,  fit: BoxFit.fitWidth).expand(flex: 3),
              20.height,
            ],
          );
        },
      ),
    );
  }
}
