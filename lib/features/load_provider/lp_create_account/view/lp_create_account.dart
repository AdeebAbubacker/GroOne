import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/cubit/lp_create_account_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/widgets/company_type_dropdown.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';


class LpCreateAccount extends StatefulWidget {
  final String userId;
  final String mobileNumber;
  final String roleId;
  const LpCreateAccount({super.key, required this.userId,required this.mobileNumber, required this.roleId});


  @override
  State<LpCreateAccount> createState() => _LpCreateAccountState();
}

class _LpCreateAccountState extends BaseState<LpCreateAccount> {

  final _formKey = GlobalKey<FormState>();

  final lpCreateCubit = locator<LpCreateAccountCubit>();
  final verifyEmailCubit = locator<EmailVerificationCubit>();
  final loginBloc = locator<LoginBloc>();

  final nameTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();

  String? companyTypeDropDownValue;


  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() {
    lpCreateCubit.fetchCompanyType();
    phoneNumberTextController.text = widget.mobileNumber;
  });

  void disposeFunction() => frameCallback(() {
    nameTextController.clear();
    companyNameTextController.clear();
    phoneNumberTextController.clear();
    pinCodeTextController.clear();
    companyTypeDropDownValue = null;
    verifyEmailCubit.resetState();
    lpCreateCubit.resetState();
  });


  // Navigate to home screen
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.accountCreatedSuccessfully,
        message: context.appText.accountCreatedSuccessfullySubHeading,
        afterDismiss: (){
          context.go(AppRouteName.lpBottomNavigationBar);
          disposeFunction();
        },
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonOnboardingAppbar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(right: commonSafeAreaPadding, left: commonSafeAreaPadding, top: commonSafeAreaPadding),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Text(context.appText.createYourAccount, style: AppTextStyle.h3w500),
                  20.height,
                  buildCreateFormWidget(context),
                  50.height,
                  buildSubmitButtonWidget(),
                  50.height,
                  // SvgPicture.asset(AppImage.svg.hindujaLogo)

                  // SvgPicture.asset(
                  //   alignment: Alignment.bottomCenter,
                  //   AppImage.svg.hindujaLogo,
                  //   width: double.infinity,
                  //   fit: BoxFit.fitWidth,
                  //   height: 50,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Form
  Widget buildCreateFormWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Company Name
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: companyNameTextController,
            labelText: context.appText.companyName,
            mandatoryStar: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
            hintText: "${context.appText.enter} ${context.appText.companyName}",
          ),
          20.height,

          // Company Type
            BlocConsumer<LpCreateAccountCubit, LpCreateAccountState>(
            bloc: lpCreateCubit,
            listener: (context, state) {
              final status = state.companyTypeUIState?.status;
              if (status == Status.ERROR) {
                final error = state.companyTypeUIState?.errorType;
                ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
              }
            },
            builder: (context, state) {
              final status = state.companyTypeUIState?.status;
              final isSuccess = status == Status.SUCCESS;
              final data = state.companyTypeUIState?.data;

              if (isSuccess && data != null) {
                return Column(
                  children: [
                    CompanyTypeSearchableDropdown(
                      selectedCompanyTypeId: companyTypeDropDownValue,
                      onCompanyTypeChanged: (newVal) {
                        setState(() {
                          companyTypeDropDownValue = newVal;
                        });
                      },
                      companyTypeList: data,
                      labelText: context.appText.companyType,
                      hintText: context.appText.selectCompanyType,
                      mandatoryStar: true,
                    ),
                    20.height,
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),

           // Name
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: nameTextController,
            labelText: context.appText.fullName,
            hintText:  context.appText.fullNameHint,
            mandatoryStar: true,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'\-]")),
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          20.height,

          // Phone Number
          AppTextField(
            readOnly: true,
            validator: (value)=> Validator.phone(value),
            controller: phoneNumberTextController,
            labelText: context.appText.phoneNumber,
            maxLength: 10,
            inputFormatters: [phoneNumberInputFormatter],
            keyboardType: TextInputType.phone,
            decoration: commonInputDecoration(
              focusColor: AppColors.borderColor,
              fillColor: AppColors.lightGreyColor,
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
          ),
          20.height,


          // Email
          buildEmailTextFieldWidget(),
          20.height,


          // Pin code
          AppTextField(
            validator: (value) => Validator.pincode(value),
            controller: pinCodeTextController,
            labelText: context.appText.pincode,
            hintText: context.appText.enterPinCode,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
             ],
            mandatoryStar: true,
            keyboardType: iosNumberKeyboard,
          ),

        ],
      ),
    );
  }

  // Email Text Field
  Widget buildEmailTextFieldWidget() {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
        bloc: verifyEmailCubit,
        listenWhen: (previous, current) =>  previous.sendOtpState != current.sendOtpState,
        listener:  (context, state) async {
          final status = state.sendOtpState?.status;

          if (status == Status.SUCCESS) {
            if (!context.mounted) return;

            final extra = {"userId": widget.userId, "emailAddress": emailTextController.text};
            final result = await context.push(AppRouteName.emailVerification, extra: extra);
            verifyEmailCubit.setVerifiedEmail(result == true);
          }

          if (status == Status.ERROR) {
            final error = state.sendOtpState?.errorType;
            verifyEmailCubit.setVerifiedEmail(false);
            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
          }
        },
        builder: (context, state) {
          return AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: emailTextController,
            labelText: context.appText.email,
            mandatoryStar: true,
            readOnly: state.isVerifiedEmail,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              FilteringTextInputFormatter.deny(RegExp(r'\+')),
            ],
            decoration: commonInputDecoration(
                focusColor: state.isVerifiedEmail ? AppColors.borderColor : AppColors.primaryColor,
                hintText: context.appText.emailHint,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(!(state.sendOtpState?.status == Status.LOADING) ? (state.isVerifiedEmail ? context.appText.verified : context.appText.verify): "${context.appText.loading}..", style: AppTextStyle.body3.copyWith(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    )),
                    5.width,
                    Icon(Icons.verified, size: 15, color : state.isVerifiedEmail ? AppColors.primaryColor : AppColors.greyIconColor),
                  ],
                ),
                suffixOnTap: () async {
                  if(!state.isVerifiedEmail) {
                    final String? validation = Validator.email(emailTextController.text);
                    if(validation == null){
                      verifyEmailCubit.sendOtp(emailTextController.text, widget.userId);
                    } else {
                      ToastMessages.alert(message: validation);
                    }
                  }
                }

            ),
          );
        }
    );
  }


  // Submit Button
  Widget buildSubmitButtonWidget() {
    return BlocConsumer<LpCreateAccountCubit, LpCreateAccountState>(
      bloc: lpCreateCubit,
      listenWhen: (previous, current) => previous.createAccountUIState?.status != current.createAccountUIState?.status,
      listener: (context, state) {
        final status = state.createAccountUIState?.status;

        if (status == Status.SUCCESS) {
          if (!context.mounted) return;
          loginBloc.add(SaveDeviceToken(widget.userId));
          navigateToHomeScreen(context);
        }

        if (status == Status.ERROR) {
          final error = state.createAccountUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final status = state.createAccountUIState?.status;
        final isLoading = status == Status.LOADING;
        return AppButton(
          title: context.appText.continueText,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () async {
            if (_formKey.currentState!.validate()) {
              if(!verifyEmailCubit.state.isVerifiedEmail && !kDebugMode){
                ToastMessages.alert(message: context.appText.verifyEmail);
                return;
              }
              final apiRequest = LpCreateApiRequest(
                customerName: nameTextController.text.trim(),
                mobileNumber: phoneNumberTextController.text.trim(),
                companyName: companyNameTextController.text.trim(),
                companyTypeId: int.parse(companyTypeDropDownValue ?? "0"),
                pincode: pinCodeTextController.text.trim(),
                email: emailTextController.text.trim(),
                roleId: int.parse(widget.roleId)
              );

              await lpCreateCubit.createAccount(apiRequest);

              if (status == Status.SUCCESS) {
                analyticsHelper.logEvent(AnalyticEventName.ONBOARD_LP_FORM_SUBMITTED, apiRequest.toJson());
              }

            }
          },
        );
      },
    );
  }

}
