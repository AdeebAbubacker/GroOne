import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_dropdown.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/extra_utils.dart';
import '../../../../utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import '../../../../utils/validator.dart';

class LpCreateAccount extends StatefulWidget {
  const LpCreateAccount({super.key});

  @override
  State<LpCreateAccount> createState() => _LpCreateAccountState();
}

class _LpCreateAccountState extends State<LpCreateAccount> {
  final nameTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final pincode = TextEditingController();
  final List<String> preferredLanesList = [
    'Chennai - Mumbai',
    'Chennai -  Pune',
    'Chennai - Delhi',
    'Chennai - Bangalore',
    'Mumbai - Hyderabad',
    'Mumbai - Chennai',
    'Mumbai - Pune',
    'Mumbai - Delhi',
    'Mumbai - Bangalore',
  ];
  String? preferredLanesDropDownValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.w),
              child: Column(
                spacing: 15.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Text(
                    "Create your account",
                    style: AppTextStyle.textBlackColor30w500,
                  ),
                  10.height,

                  createFormWidget(),
                  10.height,
                  AppButton(
                    title: "Continue",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
      ),
    );
  }

  createFormWidget() {
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: _formKey,
      child: Column(
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
                    Validator.fieldRequired(value, fieldName: "Company Type"),
            labelText: "Company Type",
            labelTextStyle: AppTextStyle.textBlackColor18w400,
            hintText: "Select Company Type",
            dropdownValue: preferredLanesDropDownValue,
            decoration: commonInputDecoration(fillColor: Colors.white),
            dropDownList:
                preferredLanesList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: AppTextStyle.body),
                      ),
                    )
                    .toList(),
            onChanged: (onChangeValue) {
              preferredLanesDropDownValue = onChangeValue;
            },
          ),
          AppTextField(
            validator: (value) => Validator.pincode(value),
            controller: pincode,
            decoration: commonInputDecoration(
              fillColor: AppColors.white,
              hintText: "${context.appText.enter} pincode",
            ),
            labelText: "Pincode",
            labelTextStyle: AppTextStyle.textBlackColor18w400,
          ),
        ],
      ),
    );
  }
}
