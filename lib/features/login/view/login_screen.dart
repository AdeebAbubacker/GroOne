import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../dependency_injection/locator.dart';
import '../../../routing/app_route_name.dart';
import '../../../service/has_internet_connection.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/customButton.dart';
import '../../../utils/toast_messages.dart';
import '../../choose_language_screen/view/choose_language_screen.dart';
import '../bloc/login_bloc.dart';

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
    debugPrint("Role Id ${widget.roleId}");
    super.initState();
  }

  initFun() => addPostFrameCallback(() async {
    await HasInternetConnection().checkConnectivity();
    // await authRepo.signOut();
  });

  final loginBloc = locator<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,

        actions: [
          translateWiget(onTap: () {   Navigator.push(context, commonRoute(ChooseLanguageScreen(isCloseButton: true,)));}),
          20.width,
          customerSupportWidget(
            onTap: () {
              showCustomerCareBottomSheet(context);
            },
          ),
          20.width,
          InkWell(
            onTap: (){
              context.push(AppRouteName.lpBottomNavigationBar);
            },
            child: Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          ),
          30.width,
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
          } else if (state is LogInError) {
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LogInLoading;
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
                    30.height,

                    Text(
                      context.appText.loginSingUp,
                      style: AppTextStyle.textBlackColor30w500,
                    ),
                    20.height,
                    Text(
                      context.appText.enterMobileNumber,
                      style: AppTextStyle.textBlackColor18w400,
                    ),
                    20.height,
                    Row(
                      spacing: 5.w,
                      children: [
                        Container(
                          height: 44.h,
                          width: 81.w,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderDisableColor,
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                height: 18.h,
                                width: 27.w,
                                AppImage.png.flag,
                              ),
                              Text(
                                "+91",
                                style: AppTextStyle.textBlackColor16w400,
                              ),
                            ],
                          ),
                        ),
                        1.width,
                        Expanded(
                          child: Container(
                            height: 44.h,

                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.borderDisableColor,
                              ),
                            ),
                            child: TextFormField(
                              focusNode: focusNode,
                              onChanged: (va) {
                                if (va.length == 10) {
                                  focusNode.unfocus();
                                }
                                setState(() {

                                });
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.number,
                              controller: phoneNumber,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    AppButton(
                      disableButton: !(phoneNumber.text.length==10 && checkBoxBool==true),
                      isLoading: isLoading,
                      title: context.appText.getOtp,

                      onPressed: () {
                        loginBloc.add(
                          LoginInRequested(
                            apiRequest: LoginApiRequest(
                              mobile:phoneNumber.text,
                              role: widget.roleId,
                            ),
                          ),
                        );
                        //context.push(AppRouteName.otpVerificationScreen);
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
                                    debugPrint('Terms & Conditions tapped');
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
                                    // Handle privacy policy tap
                                    debugPrint('Privacy Policy tapped');
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
              Expanded(child: SizedBox.shrink()),
              Image.asset(AppImage.png.signUpBanner),
            ],
          );
        },
      ),
    );
  }
}
