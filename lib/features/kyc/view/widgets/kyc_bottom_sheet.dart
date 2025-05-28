import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

import '../../../../dependency_injection/locator.dart';
import '../../api_request/addhar_otp_request.dart';
import '../../api_request/addhar_verify_otp_request.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/common_widgets.dart';

class KycBottomSheet extends StatefulWidget {
  const KycBottomSheet({super.key});

  @override
  State<KycBottomSheet> createState() => _KycBottomSheetState();
}

class _KycBottomSheetState extends State<KycBottomSheet> {
  String? requestID;
  final _formKey = GlobalKey<FormState>();
  TextEditingController addharNumber = TextEditingController();
  TextEditingController addharNumberOtp = TextEditingController();
  bool showOtpFieldAdhar = false;
  final kycBloc = locator<KycBloc>();

  @override
  void initState() {
    showOtpFieldAdhar=false;
    addharNumberOtp.clear();
    addharNumberOtp.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      hideDivider: false,
      body: _buildBody(),isCloseButton: false,
    title: "Verify Your KYC" ,);
  }
_buildBody(){
    return BlocConsumer(
      bloc: kycBloc,
      builder: (context, state) {
        final isLoading = state is AddharLoading;
        return showOtpFieldAdhar
            ? addharVerificationWidget(  isLoading)
            : addNumberInputWidget(  isLoading);
      },
      listener: (context, state) {
        if (state is AddharVerifyOtpSuccess) {
          showOtpFieldAdhar = false;
          print("success AddharVerifyOtpSuccess");


          setState(() {});
          context.pop();
          context.push(AppRouteName.kycScreen,extra: {"addharNumber":addharNumber.text}).then((v) {
            addharNumber.clear();
            addharNumberOtp.clear();
          });
        }
        if (state is AddharOtpSuccess) {
          print("success data");
          requestID = state.addharOtpResponse.data?.requestId;
          showOtpFieldAdhar = true;

          setState(() {});
        } else if (state is AddharOtpError) {
          ToastMessages.error(
            message: getErrorMsg(errorType: state.errorType),
          );
        }
      },
    );
}
  addNumberInputWidget( bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            Form(
              key: _formKey,
              child: AppTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                onChanged: (value) {
                  addharNumber.text = value;
                  setState(() {});

                },

                validator: (value) => Validator.fieldRequired(value),
                controller: addharNumber,
                decoration: commonInputDecoration(
                  hintText: "xxxx xxxx 9123",
                  fillColor: AppColors.white,
                ),
                keyboardType: TextInputType.number,

                labelText: "Enter Aadhar Card Number",
                labelTextStyle: AppTextStyle.textBlackColor16w400,
              ),
            ),

            20.height,

            AppButton(
              disableButton:
              addharNumber.text.length != 12 ? true : false,
              isLoading: isLoading,
              title: "Verify Aadhar",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  kycBloc.add(
                    AddharOtpRequested(
                      apiRequest: AddharOtpRequest(
                        force: false,
                        aadhaar: addharNumber.text,
                      ),
                    ),
                  );
                  // All validations passed
                }
              },
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "I’ll do it later",
                  style: AppTextStyle.primaryColor16w400.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  addharVerificationWidget(  bool isLoading) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          color: AppColors.textBlackColor.withOpacity(0.4),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      "Verify Your KYC",
                      style: AppTextStyle.textBlackColor20w500,
                    ),
                    15.height,
                    Text(
                      "Enter the OTP sent to your registered Mobile number",
                      style: AppTextStyle.textBlackColor16w400,
                    ),
                    20.height,
                    Center(
                      child: OtpTextField(
                        borderRadius: BorderRadius.circular(10),
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        fieldWidth: 50.w,
                        borderColor: AppColors.borderDisableColor,
                        onCodeChanged: (String code) {},

                        onSubmit: (String verificationCode) {
                          addharNumberOtp.text = verificationCode;

                          setState(() {});
                        }, // end
                      ),
                    ),

                    20.height,
                    AppButton(
                      disableButton:
                      addharNumberOtp.text.length != 6 ? true : false,
                      isLoading: isLoading,
                      title: "Verify OTP",
                      onPressed: () {
                        kycBloc.add(
                          AddharVerifyOtpRequested(
                            apiRequest: AddharVerifyOtpRequest(
                              requestId: requestID ?? "",
                              otp: addharNumberOtp.text,
                              aadhaar: addharNumber.text,
                            ),
                          ),
                        );
                      },
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
