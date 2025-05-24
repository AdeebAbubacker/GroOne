import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/bloc/lp_create_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/routing/app_routes.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/global_variables.dart';

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
import '../model/lp_company_type_response.dart';

class LpCreateAccount extends StatefulWidget {
  const LpCreateAccount({super.key, required this.id});

  final String id;

  @override
  State<LpCreateAccount> createState() => _LpCreateAccountState();
}

class _LpCreateAccountState extends State<LpCreateAccount> {
  final nameTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final pincode = TextEditingController();
  List<CompanyType> preferredLanesList = [];
  String? companyTypeDropDownValue;
  final _formKey = GlobalKey<FormState>();
  final lpCreateBloc = locator<LpCreateBloc>();

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

  void initFunction() => addPostFrameCallback(() {
    lpCreateBloc.add(LpCompanyTypeRequested());
  });

  void disposeFunction() => addPostFrameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        actions: [
          translateWiget(
            onTap: () {
              lpCreateBloc.add(LpCompanyTypeRequested());
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
        listener: (context, state) {
          if (state is LpCompanyTypeSuccess) {
            preferredLanesList = state.lpCompanyTypeSuccess.data;
            setState(() {});
          }
          if (state is LpCreateSuccess) {
            showSuccessDialog(
              onTap: () {
                context.push(AppRouteName.lpBottomNavigation);
              },
              context,
              text: context.appText.accountCreatedSuccessfully,
              subheading: context.appText.accountCreatedSuccessfullySubHeading,
            );
          } else if (state is LpCreateError) {
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },
        bloc: lpCreateBloc,
        builder: (context, state) {
          final isLoading = state is LpCreateLoading;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.0.h,
                    horizontal: 20.w,
                  ),
                  child: Column(
                    spacing: 15.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(
                        context.appText.createYourAccount,
                        style: AppTextStyle.textBlackColor30w500,
                      ),
                      10.height,

                      createFormWidget(),
                      10.height,
                      AppButton(
                        isLoading: isLoading,
                        title:appContext.appText.continueText,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            lpCreateBloc.add(
                              LpCreateRequested(
                                apiRequest: CreateRequest(
                                  customerName: nameTextController.text,
                                  mobileNumber: phoneNumberTextController.text,
                                  companyName: companyNameTextController.text,
                                  companyTypeId: int.parse(
                                    companyTypeDropDownValue!,
                                  ),
                                  pincode: pincode.text,
                                ),
                                id: widget.id,
                              ),
                            );
                            // All validations passed
                          } else {
                            // Some fields are invalid
                          }
                        },
                      ),
                      30.height,
                      Image.asset(AppImage.png.signUpBanner),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  createFormWidget() {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: nameTextController,
            labelTextStyle: AppTextStyle.textBlackColor18w400,
            decoration: commonInputDecoration(
              fillColor: AppColors.white,
              hintText: "${context.appText.enter} ${context.appText.name}",
            ),
            labelText: context.appText.name,
          ),

          Text(
            context.appText.enterMobileNumber,
            style: AppTextStyle.textBlackColor18w400,
          ),

          Row(
            spacing: 5.w,
            children: [
              Container(
                height: 52.h,
                width: 81.w,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderDisableColor),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(height: 18.h, width: 27.w, AppImage.png.flag),
                    Text("+91", style: AppTextStyle.textBlackColor16w400),
                  ],
                ),
              ),
              1.width,
              Expanded(
                child: AppTextField(
                  validator: (value) => Validator.phone(value),
                  controller: phoneNumberTextController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [phoneNumberInputFormatter],
                  decoration: commonInputDecoration(
                    fillColor: AppColors.white,
                    hintText:
                        "${context.appText.enter} ${context.appText.phoneNumber}",
                  ),
                ),
              ),
            ],
          ),
          // Company Name
          AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: companyNameTextController,
            decoration: commonInputDecoration(
              fillColor: AppColors.white,
              hintText:
                  "${context.appText.enter} ${context.appText.companyName}",
            ),
            labelText: context.appText.companyName,
            labelTextStyle: AppTextStyle.textBlackColor18w400,
          ),
          AppDropdown(
            validator:
                (value) =>
                    Validator.fieldRequired(value, fieldName:appContext.appText.companyType),
            labelText: appContext.appText.companyType,
            labelTextStyle: AppTextStyle.textBlackColor18w400,
            hintText: "${appContext.appText.select} ${appContext.appText.companyType}",
            dropdownValue: companyTypeDropDownValue,
            decoration: commonInputDecoration(fillColor: Colors.white),
            dropDownList:
                preferredLanesList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.companyType, style: AppTextStyle.body),
                      ),
                    )
                    .toList(),
            onChanged: (onChangeValue) {
              companyTypeDropDownValue = onChangeValue;
              setState(() {});
            },
          ),
          AppTextField(
            validator: (value) => Validator.pincode(value),
            controller: pincode,
            keyboardType: TextInputType.number,
            decoration: commonInputDecoration(
              fillColor: AppColors.white,
              hintText: "${context.appText.enter} ${appContext.appText.pinCode}",
            ),
            labelText: appContext.appText.pinCode,
            labelTextStyle: AppTextStyle.textBlackColor18w400,
          ),
        ],
      ),
    );
  }
}
