import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

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
nodeManage(){
  _gstNode.addListener(() {
    if (_gstNode.hasFocus) {
    } else {
      kycBloc.add(
        VerifyGstRequested(
          apiRequest: VerifyGstRequest(gst: "27AABCM9984D1Z4", force: false),
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
          apiRequest: VerifyTanRequest(tan: "PNEM19000C", force: false),
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
          apiRequest: VerifyPanRequest(pan: "AABCM9984D", force: false),
        ),
      );
    }
  });
}
  @override
  void initState() {
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
              if (state is VerifyTanSuccess) {
                verifiedTan = true;
                tan.text = "PNEM19000C";
                setState(() {});
                print("success VerifyTanSuccess");
              }
              if (state is VerifyPanSuccess) {
                verifiedPan = true;
                pan.text = "AABCM9984D";
                setState(() {});
                print("success VerifyPanSuccess");
              }
              if (state is VerifyGstSuccess) {
                verifiedGst = true;
                gstIn.text = "27AABCM9984D1Z4";
                setState(() {});
                print("success VerifyGstSuccess");
              } else if (state is AddharOtpError) {
                ToastMessages.error(
                  message: getErrorMsg(errorType: state.errorType),
                );
              }
            },
            builder: (context, state) {
              return Column(
                spacing: 15.h,
                children: [
                  textFieldWithLabel(
                    readOnly: true,
                    rightText: "Aadhaar Number",
                    leftText: "Verified",
                    controller: addharNumber,
                  ),
                  textFieldWithLabel(
                    leftText: verifiedGst ? "Verified" : null,
                    readOnly: verifiedGst,
                    currentFocus: _gstNode,
                    rightText: "GSTIN",
                    controller: gstIn,
                  ),
                  dottedButton(onTap: () {}),
                  editAndDeleteButton(
                    fileName: 'GST Registration Certificate.PDF',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  textFieldWithLabel(
                    readOnly: verifiedTan,
                    leftText: verifiedTan ? "Verified" : null,
                    rightText: "TAN",
                    controller: tan,
                    currentFocus: _tanNode,
                  ),
                  dottedButton(onTap: () {}),
                  editAndDeleteButton(
                    fileName: 'TAN Registration Certificate.PDF',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  textFieldWithLabel(
                    readOnly: verifiedPan,
                    leftText: verifiedPan ? "Verified" : null,
                    rightText: "PAN",
                    controller: pan,
                    currentFocus: _panNode,
                  ),
                  dottedButton(onTap: () {}),
                  editAndDeleteButton(
                    fileName: 'PAN Card.PNG',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  multipleTextFieldWidget(
                    text: "Address",
                    children: [
                      AppTextField(
                        controller: addressLine1,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "Address Line 1",
                        ),
                      ),
                      AppTextField(
                        controller: addressLine2,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "Address Line 2",
                        ),
                      ),
                      AppTextField(
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
                        controller: accountNumber,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "Account Number",
                        ),
                      ),
                      AppTextField(
                        controller: bankName,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "Bank Name",
                        ),
                      ),
                      AppTextField(
                        controller: branchName,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "Branch Name",
                        ),
                      ),
                      AppTextField(
                        controller: ifscCode,
                        decoration: commonInputDecoration(
                          fillColor: AppColors.white,
                          hintText: "IFSC code",
                        ),
                      ),
                    ],
                  ),

                  10.height,
                  AppButton(
                    title: "Submit",
                    onPressed: () {
                      showSuccessDialog(
                        onTap: () {
                          context.pop();
                          context.pop();
                        },
                        context,
                        text: "KYC Submitted for\nverification",
                        subheading: "Will get back to you within\n48 hours.",
                      );
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

  Widget editAndDeleteButton({
    required String fileName,
    required Function() onEdit,
    required Function() onDelete,
  }) {
    return Container(
      height: 40.h,
      color: const Color(0xFFF5F7FF),
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              fileName,
              style: AppTextStyle.textBlackColor12w400.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            onPressed: () {
              // Edit file logic
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: AppColors.iconRed,
              size: 20,
            ),
            onPressed: () {
              // Delete file logic
            },
          ),
        ],
      ),
    );
  }

  Widget dottedButton({required Function() onTap}) {
    return DottedBorder(
      color: Colors.grey,
      dashPattern: [6, 3],
      strokeWidth: 1,
      child: SizedBox(
        height: 44.h,
        width: double.infinity,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Upload document",
              style: AppTextStyle.textBlackColor14w400.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            10.width,
            Icon(Icons.file_upload_outlined, color: AppColors.black, size: 20),
          ],
        ),
      ),
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
                color: Color(0xFF018800),
              ),
            ),
          ],
        ),
        5.height,
        AppTextField(
          readOnly: readOnly,
          currentFocus: currentFocus,
          controller: controller,
          decoration: commonInputDecoration(fillColor: AppColors.white),
        ),
      ],
    );
  }
}
