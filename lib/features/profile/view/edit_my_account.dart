import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';


class LpEditMyAccount extends StatefulWidget {
  final ProfileDetailsData profileData;
  const LpEditMyAccount({super.key, required this.profileData});

  @override
  State<LpEditMyAccount> createState() => _LpEditMyAccountState();
}

class _LpEditMyAccountState extends State<LpEditMyAccount> {

  final lpProfile = locator<ProfileBloc>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController customerName = TextEditingController();
  TextEditingController customerMobileNumber = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController gstIn = TextEditingController();

  @override
  void initState() {
    initFunction();
    super.initState();
  }


  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpProfile.getUserId();
    customerMobileNumber.text=widget.profileData.customer!.mobileNumber;
    customerName.text=widget.profileData.customer!.customerName;
    companyName.text=widget.profileData.details!.companyName;
    gstIn.text=widget.profileData.details!.gstin??"--";
  });

  void disposeFunction() => frameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            context.appText.myAccount,
            style: AppTextStyle.textBlackColor18w500,
          ),
          toolbarHeight: 50.h,
        ),
        body: BlocConsumer(
          bloc: lpProfile,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  headingText(text: context.appText.personalDetails),
                  15.height,
                  updateFormWidget(),
                  Expanded(child: SizedBox.shrink()),
                  updateButtonWidget(),
                ],
              ),
            );
          }, listener: (context, state) {
          if (state is ProfileUpdateSuccess) {


          }
          if (state is ProfileUpdateError) {
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },)
    );
  }

  updateButtonWidget() {
    return BlocConsumer(
      bloc: lpProfile,
      listener: (context, state) async {
        if (state is ProfileUpdateSuccess) {


context.pop();
context.pop();
        } else if (state is ProfileUpdateError) {
          ToastMessages.error(
            message: getErrorMsg(errorType: state.errorType),
          );
        }
      },
      builder: (context, state) {
        bool isLoading=state is ProfileUpdateLoading;
        return AppButton(isLoading: isLoading,
          title: context.appText.updateChanges,

          onPressed: () {
            if (_formKey.currentState!.validate()) {
              lpProfile.add(ProfileUpdateRequested(
                  apiRequest: ProfileUpdateRequest(customerName: customerName.text,
                      mobileNumber: customerMobileNumber.text,
                      accountNumber: widget.profileData.details!.bankAccount??"",
                      bankName:  widget.profileData.details!.bankName??"",
                      branchName:  widget.profileData.details!.branchName??"",
                      ifscCode:  widget.profileData.details!.ifscCode??"",
                      companyName: companyName.text,
                      gstin: gstIn.text),userID: lpProfile.userId??""));
            }
          },
        );
      },
    );
  }

  updateFormWidget() {
    return Form(key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(validator: (value) => Validator.fieldRequired(value),
            controller: customerName,
            decoration: commonInputDecoration(fillColor: Colors.white),
            labelText: context.appText.name,
          ),
          AppTextField(
            validator: (value) => Validator.phone(value),
            keyboardType: TextInputType.number,
            controller: customerMobileNumber,
            inputFormatters: [phoneNumberInputFormatter,
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: commonInputDecoration(fillColor: Colors.white),
            labelText: context.appText.mobileNumber,
          ),
          10.height,
          headingText(text: context.appText.companyDetails),
          15.height,
          AppTextField(validator: (value) => Validator.fieldRequired(value),
            controller: companyName,
            decoration: commonInputDecoration(fillColor: Colors.white),
            labelText: context.appText.companyName,
          ),
          AppTextField(
            controller: gstIn,
            validator: (value) => Validator.fieldRequired(value),
            decoration: commonInputDecoration(fillColor: Colors.white),
            labelText: context.appText.gst,
          ),
        ],
      ),
    );
  }
}
