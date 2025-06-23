import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/email_verification/view/email_verification_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/bloc/lp_create_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/mobile_number_text_filed.dart';

import '../../../../dependency_injection/locator.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_dropdown.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/extra_utils.dart';
import '../../../../utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import '../../../../utils/toast_messages.dart';
import '../../../../utils/validator.dart';
import '../../../choose_language_screen/view/choose_language_screen.dart';
import '../model/lp_company_type_response.dart';

class LpCreateAccount extends StatefulWidget {
  final String userId;
  final String mobileNumber;
  final String roleId;
  const LpCreateAccount({super.key, required this.userId,required this.mobileNumber, required this.roleId});


  @override
  State<LpCreateAccount> createState() => _LpCreateAccountState();
}

class _LpCreateAccountState extends State<LpCreateAccount> {

  final _formKey = GlobalKey<FormState>();

  final lpCreateBloc = locator<LpCreateBloc>();
  final verifyEmailCubit = locator<EmailVerificationCubit>();


  final nameTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();

  List<CompanyType> preferredLanesList = [];

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
    lpCreateBloc.add(LpCompanyTypeRequested());
    phoneNumberTextController.text = widget.mobileNumber;
  });

  void disposeFunction() => frameCallback(() {
    nameTextController.clear();
    companyNameTextController.clear();
    phoneNumberTextController.clear();
    pinCodeTextController.clear();
    preferredLanesList.clear();
    companyTypeDropDownValue = null;
    verifyEmailCubit.resetState();
  });


  // Navigate to home screen
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.accountCreatedSuccessfully,
        heading: context.appText.accountCreatedSuccessfullySubHeading,
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
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
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
      ),
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
                  Image.asset(AppImage.png.signUpBanner),
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
            hintText: "${context.appText.enter} ${context.appText.companyName}",
          ),
          20.height,

          // Company Type
          AppDropdown(
            validator: (value) => Validator.fieldRequired(value),
            labelText: context.appText.companyType,
            hintText: context.appText.selectCompanyType,
            dropdownValue: companyTypeDropDownValue,
            mandatoryStar: true,
            decoration: commonInputDecoration(fillColor: Colors.white),
            dropDownList: preferredLanesList.map((e) => DropdownMenuItem(
                value: e.id.toString(),
                child: Text(e.companyType, style: AppTextStyle.body)),
            ).toList(),
            onChanged: (onChangeValue) {
              companyTypeDropDownValue = onChangeValue;
              setState(() {});
            },
          ),
          20.height,

          // Name
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: nameTextController,
            labelText: context.appText.fullName,
            hintText:  context.appText.fullNameHint,
            mandatoryStar: true,
          ),
          20.height,

          // Phone Number
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(" Phone Number", style: AppTextStyle.textFiled),
          //     6.height,
          //     MobileNumberTextField(
          //       controller: phoneNumberTextController,
          //       countryFlagAssetPath: AppImage.png.flag,
          //       readOnly: true,
          //     ),
          //   ],
          // ),
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
            hintText: "Enter Your Pincode",
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
            final result = await Navigator.of(context).push(commonRoute(EmailVerificationScreen(userId: widget.userId,emailAddress: emailTextController.text), isForward: true));
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
            decoration: commonInputDecoration(
                focusColor: state.isVerifiedEmail ? AppColors.borderColor : AppColors.primaryColor,
                hintText: context.appText.emailHint,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(!(state.sendOtpState?.status == Status.LOADING) ? (state.isVerifiedEmail ? "Verified" :"Verify"): "Loading..", style: AppTextStyle.body3.copyWith(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    )),
                    5.width,
                    Icon(Icons.verified, size: 15, color : state.isVerifiedEmail ? AppColors.primaryColor : AppColors.greyIconColor),
                  ],
                ),
                suffixOnTap: () async {
                  final String? validation = Validator.email(emailTextController.text);
                  if(validation == null){
                     verifyEmailCubit.sendOtp(emailTextController.text);
                  } else {
                    ToastMessages.alert(message: validation);
                  }
                }

            ),
          );
        }
    );
  }

  // Submit Button
  Widget buildSubmitButtonWidget() {
    return BlocConsumer<LpCreateBloc, LpCreateState>(
      bloc: lpCreateBloc,
      listener: (context, state) {
        if (state is LpCompanyTypeSuccess) {
          preferredLanesList = state.lpCompanyTypeSuccess.data;
          setState(() {});
        }
        if (state is LpCreateSuccess) {
          navigateToHomeScreen(context);
        }
        if (state is LpCreateError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (context, state) {
        final isLoading = state is LpCreateLoading;
        return AppButton(
          title: context.appText.continueText,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () {
            if (_formKey.currentState!.validate()) {
              if(!verifyEmailCubit.state.isVerifiedEmail){
                ToastMessages.alert(message: "Please verify your email");
                return;
              }
              final apiRequest = CreateRequest(
                customerName: nameTextController.text,
                mobileNumber: phoneNumberTextController.text,
                companyName: companyNameTextController.text,
                companyTypeId: int.parse(companyTypeDropDownValue ?? "0"),
                pincode: pinCodeTextController.text,
                email: emailTextController.text,
                roleId: int.parse(widget.roleId)
              );
              lpCreateBloc.add(LpCreateRequested(apiRequest: apiRequest, id: widget.userId));
            }
          },
        );
      },
    );
  }

}
