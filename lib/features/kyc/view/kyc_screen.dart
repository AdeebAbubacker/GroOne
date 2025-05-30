import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/features/kyc/view/widgets/kyc_upload_file.dart';

import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import 'package:gro_one_app/utils/validator.dart';

import '../../../data/storage/secured_shared_preferences.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/toast_messages.dart';
import '../api_request/verify_pan_request.dart';
import '../api_request/verify_tan_request.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key, required this.addharNumber});

  final String addharNumber;

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final kycBloc = locator<KycBloc>();

  TextEditingController addharNumber = TextEditingController();
  TextEditingController gstIn = TextEditingController();
  TextEditingController tan = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController addressLine3 = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController branchName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  final FocusNode _gstNode = FocusNode();
  bool verifiedGst = false;
  final FocusNode _tanNode = FocusNode();
  bool verifiedTan = false;
  final FocusNode _panNode = FocusNode();
  bool verifiedPan = false;

  nodeManage() {
    _gstNode.addListener(() {
      if (_gstNode.hasFocus) {
      } else {
        kycBloc.add(
          VerifyGstRequested(
            apiRequest: VerifyGstRequest(gst: gstIn.text, force: false),
          ),
        );
      }
    });
    _tanNode.addListener(() {
      if (_tanNode.hasFocus) {
        print('Field 1 focused');
      } else {
        kycBloc.add(
          VerifyTanRequested(
            apiRequest: VerifyTanRequest(tan: tan.text, force: false),
          ),
        );
      }
    });

    _panNode.addListener(() {
      if (_panNode.hasFocus) {
        print('Field 2 focused');
      } else {
        kycBloc.add(
          VerifyPanRequested(
            apiRequest: VerifyPanRequest(pan: pan.text, force: false),
          ),
        );
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? userRole;
  String? userID;

  takeKey() async {
    userID = await SecuredSharedPreferences(
      FlutterSecureStorage(),
    ).get(AppString.sessionKey.userId);
    userRole = await SecuredSharedPreferences(
      FlutterSecureStorage(),
    ).get(AppString.sessionKey.userRole);
    debugPrint("user Id $userRole}");
  }

  @override
  void initState() {
    takeKey();

    super.initState();
    nodeManage();
    addharNumber.text = widget.addharNumber;
  }

  @override
  void dispose() {
    _panNode.dispose();
    _tanNode.dispose();
    _gstNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        title: "Upload Your Documents",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: BlocConsumer(
            bloc: kycBloc,
            listener: (context, state) {
              if (state is SubmitKycSuccess) {
                showSuccessDialog(
                  onTap: () {
                    context.pop();
                    context.pop();
                  },
                  context,
                  text: "KYC Submitted for\nverification",
                  subheading: "Will get back to you within\n48 hours.",
                );
              }
              if (state is VerifyTanSuccess) {
                verifiedTan = true;

                print("success VerifyTanSuccess");
              }
              if (state is VerifyPanSuccess) {
                verifiedPan = true;
                pan.text = "AABCM9984D";

                print("success VerifyPanSuccess");
              }
              if (state is VerifyGstSuccess) {
                verifiedGst = true;
                gstIn.text = "27AABCM9984D1Z4";

                print("success VerifyGstSuccess");
              } else if (state is AddharOtpError) {
                ToastMessages.error(
                  message: getErrorMsg(errorType: state.errorType),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15.h,
                      children: [
                        textFieldWithLabel(
                          readOnly: true,
                          rightText: "Aadhaar Number",
                          leftText: "Verified",
                          controller: addharNumber,
                        ),

                        /// GST section
                        textFieldWithLabel(
                          leftText: verifiedGst ? "Verified" : "Un-Verified",
                          readOnly: verifiedGst,
                          currentFocus: _gstNode,
                          rightText: "GSTIN",
                          controller: gstIn,
                        ),
                        upload(multiFilesList: gstDoc),

                        /// Tan section
                        Column(
                          spacing: 15.h,
                          children: [
                            textFieldWithLabel(
                              readOnly: verifiedTan,
                              leftText:
                                  verifiedTan ? "Verified" : "Un-Verified",
                              rightText: "TAN",
                              controller: tan,
                              currentFocus: _tanNode,
                            ),
                            upload(multiFilesList: tanDoc),
                          ],
                        ),

                        /// PAN section
                        textFieldWithLabel(
                          readOnly: verifiedPan,
                          leftText: verifiedPan ? "Verified" : "Un-Verified",
                          rightText: "PAN",
                          controller: pan,
                          currentFocus: _panNode,
                        ),
                        upload(multiFilesList: panDoc),

                        int.parse(userRole ?? "0") == 2
                            ? Column(
                              spacing: 15.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Cancelled cheque section
                                Text(
                                  "Cancelled Cheque",
                                  style: AppTextStyle.textBlackColor16w400,
                                ),
                                upload(multiFilesList: checkDocLink),

                                /// Tds Certificate section
                                Text(
                                  "TDS Certificate",
                                  style: AppTextStyle.textBlackColor16w400,
                                ),
                                upload(multiFilesList: tdsDocLink),
                              ],
                            )
                            : const SizedBox(),

                        multipleTextFieldWidget(
                          text: "Address",
                          children: [
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: addressLine1,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Address Line 1",
                              ),
                            ),
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: addressLine2,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Address Line 2",
                              ),
                            ),
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: addressLine3,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Address Line 3",
                              ),
                            ),
                            AppTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
keyboardType: TextInputType.number,
                              validator: (value) => Validator.pincode(value),
                              controller: pincode,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Pin code",
                              ),
                            ),
                          ],
                        ),
                        multipleTextFieldWidget(
                          text: "Bank Details",
                          children: [
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: accountNumber,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Account Number",
                              ),
                            ),
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: bankName,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Bank Name",
                              ),
                            ),
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: branchName,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "Branch Name",
                              ),
                            ),
                            AppTextField(
                              validator:
                                  (value) => Validator.fieldRequired(value),
                              controller: ifscCode,
                              decoration: commonInputDecoration(
                                fillColor: AppColors.white,
                                hintText: "IFSC code",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  10.height,
                  AppButton(
                    style:
                        (int.parse(userRole ?? "0") == 1
                                ? (gstDoc.isEmpty ||
                                    tanDoc.isEmpty ||
                                    panDoc.isEmpty)
                                : (gstDoc.isEmpty ||
                                    checkDocLink.isEmpty ||
                                    panDoc.isEmpty ||
                                    tdsDocLink.isNotEmpty))
                            ? AppButtonStyle.disableButton
                            : AppButtonStyle.primary,
                    title: "Submit",
                    onPressed: () {
                      if (int.parse(userRole ?? "0") == 1
                          ? (gstDoc.isEmpty || tanDoc.isEmpty || panDoc.isEmpty)
                          : (gstDoc.isEmpty ||
                              checkDocLink.isEmpty ||
                              panDoc.isEmpty ||
                              tdsDocLink.isNotEmpty)) {
                      } else {
                        if (verifiedGst && verifiedTan && verifiedPan) {
                          if (_formKey.currentState!.validate()) {
                            final kycRequest = SubmitKycRequestLp(
                              aadhar: widget.addharNumber,
                              address1: addressLine1.text,
                              address2: addressLine2.text,
                              address3: addressLine3.text,
                              bankAccount: accountNumber.text,
                              bankName: bankName.text,
                              branchName: branchName.text,
                              chequeDocLink:
                                  checkDocLink.isNotEmpty
                                      ? checkDocLink.first['path']
                                      : null,
                              tdsDocLink:
                                  tdsDocLink.isNotEmpty
                                      ? tdsDocLink.first['path']
                                      : null,
                              gstin: gstIn.text,
                              gstinDocLink: gstDoc.first['path'],
                              ifscCode: ifscCode.text,
                              isAadhar: true,
                              isGstin: verifiedGst,
                              isPan: verifiedPan,
                              isTan: verifiedTan,
                              pan: pan.text,
                              panDocLink: panDoc.first['path'],
                              tan: tan.text,
                              tanDocLink: tanDoc.first['path'],
                            );

                            debugPrint(
                              "kycRequest ${kycRequest.toJson()}",
                              wrapWidth: 1000,
                            );

                            kycBloc.add(
                              SubmitKycRequested(
                                apiRequest: kycRequest,
                                userId: userID ?? "0",
                              ),
                            );
                          }
                        } else {
                          ToastMessages.error(
                            message: "Please verify all document before submit",
                          );
                        }
                      }
                    },
                  ),
                  10.height,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<dynamic> gstDoc = [];
  List<dynamic> panDoc = [];
  List<dynamic> tanDoc = [];
  List<dynamic> checkDocLink = [];
  List<dynamic> tdsDocLink = [];
  List<dynamic> tds = [];
  String uploadLink = "";

  upload({required List<dynamic> multiFilesList}) {
    return BlocConsumer<KycBloc, KycState>(
      bloc: kycBloc,
      listener: (context, state) {
        if (state is UploadFileSuccess) {
          if (state.uploadFileModel.data != null &&
              state.uploadFileModel.data!.url.isNotEmpty) {
            if (multiFilesList.isNotEmpty) {
              multiFilesList.first['path'] = state.uploadFileModel.data!.url;
            }
          } else {
            multiFilesList.clear();
          }
          ToastMessages.success(message: "File uploaded successfully");
        } else if (state is AddharOtpError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (BuildContext context, KycState state) {
        return KycUploadFile(
          onPressedDeleteButton: () {
            {
              multiFilesList.clear();
              commonHapticFeedback();
              commonHideKeyboard(context);
              setState(() {});
            }
          },
          multiFilesList: multiFilesList,

          isSingleFile: true,
          thenUploadFileToSever: () {
            if (multiFilesList.isNotEmpty) {
              kycBloc.add(
                UploadFileRequested(file: File(multiFilesList.first['path'])),
              );
              if (state is UploadFileSuccess) {}
              if (state is AddharOtpError) {
                multiFilesList.clear();
                ToastMessages.error(
                  message: getErrorMsg(errorType: state.errorType),
                );
              }
            }
          },
        );
      },
    );
  }

  multipleTextFieldWidget({
    required String text,
    String? leftText,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.textBlackColor16w400),

        5.height,
        Column(spacing: 10.h, children: children),
      ],
    );
  }

  Widget textFieldWithLabel({
    required String rightText,
    String? leftText,
    bool readOnly = false,
    FocusNode? currentFocus,
    required TextEditingController controller,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rightText, style: AppTextStyle.textBlackColor16w400),
            Text(
              leftText ?? "",
              style: AppTextStyle.textBlackColor16w500.copyWith(
                color: !readOnly ? Colors.red : Color(0xFF018800),
              ),
            ),
          ],
        ),
        5.height,
        AppTextField(
          validator: (value) => Validator.fieldRequired(value),
          readOnly: readOnly,
          currentFocus: currentFocus,
          controller: controller,
          decoration: commonInputDecoration(fillColor: AppColors.white),
        ),
      ],
    );
  }
}
