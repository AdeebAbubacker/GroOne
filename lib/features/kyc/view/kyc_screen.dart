import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/view/kyc_sucess_dialogue.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_file.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';

import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';

import 'package:gro_one_app/utils/validator.dart';

import '../../../data/storage/secured_shared_preferences.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/toast_messages.dart';
import '../api_request/verify_pan_request.dart';
import '../api_request/verify_tan_request.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key, required this.aadhaarNumber});
  final String aadhaarNumber;

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {

  final _formKey = GlobalKey<FormState>();

  final kycBloc = locator<KycCubit>();
  final lpHomeBloc = locator<LpHomeBloc>();

  final TextEditingController aadhaarNumberTextController = TextEditingController();
  final TextEditingController gstInTextController = TextEditingController();
  final TextEditingController tanTextController = TextEditingController();
  final TextEditingController panTextController = TextEditingController();
  final TextEditingController addressLine1TextController = TextEditingController();
  final TextEditingController addressLine2TextController = TextEditingController();
  final TextEditingController addressLine3TextController = TextEditingController();
  final TextEditingController pincodeTextController = TextEditingController();
  final TextEditingController accountNumberTextController = TextEditingController();
  final TextEditingController bankNameTextController = TextEditingController();
  final TextEditingController branchNameTextController = TextEditingController();
  final TextEditingController ifscCodeTextController = TextEditingController();

  final FocusNode gstFocusNode = FocusNode();
  final FocusNode tanFocusNode = FocusNode();
  final FocusNode panFocusNode = FocusNode();

  // bool verifiedPan = false;
  // bool verifiedGst = false;
  // bool verifiedTan = false;


  List<dynamic> gstDoc = [];
  List<dynamic> panDoc = [];
  List<dynamic> tanDoc = [];
  List<dynamic> checkDocLink = [];
  List<dynamic> tdsDocLink = [];
  List<dynamic> tds = [];
  String uploadLink = "";
  

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
  
  void initFunction()=> frameCallback(() async {
    await kycBloc.fetchUserRole();
    nodeManage();
    aadhaarNumberTextController.text = widget.aadhaarNumber;
  });
  
  void disposeFunction()=> frameCallback((){
    panFocusNode.dispose();
    tanFocusNode.dispose();
    gstFocusNode.dispose();
  });


  // Manage Node
  Future<void> nodeManage() async {
    await lpHomeBloc.getUserId();

    gstFocusNode.addListener(() async {
      if (!gstFocusNode.hasFocus) {
        final apiRequest = VerifyGstApiRequest(gst: gstInTextController.text, force: false);
        await kycBloc.verifyGst(apiRequest);
      }
    });

    tanFocusNode.addListener(() async {
      if (!tanFocusNode.hasFocus) {
        final apiRequest = VerifyTanApiRequest(tan: tanTextController.text, force: false);
        await kycBloc.verifyTan(apiRequest);
      }
    });

    panFocusNode.addListener(() async {
      if (!panFocusNode.hasFocus) {
        final apiRequest = VerifyPanApiRequest(pan: panTextController.text, force: false);
        await kycBloc.verifyPan(apiRequest);
      }
    });
  }


  // Upload Doc common api call
  Future<Result<bool>> uploadDocCommonApiCall(List<dynamic> multiFilesList) async {
    await kycBloc.uploadFile(File(multiFilesList.first['path']));
    if(kycBloc.state.fileUploadState?.status == Status.SUCCESS){
      if (kycBloc.state.fileUploadState?.data != null && kycBloc.state.fileUploadState?.data?.data != null){
        if (kycBloc.state.fileUploadState?.data?.data?.url != null || kycBloc.state.fileUploadState!.data!.data!.url.isNotEmpty){
          multiFilesList.first['path'] = kycBloc.state.fileUploadState?.data?.data?.url;
          ToastMessages.success(message: "File uploaded successfully");
          return Success(true);
        }
      }
    }
    if(kycBloc.state.fileUploadState?.status == Status.ERROR){
      if (kycBloc.state.fileUploadState?.errorType != null){
        ToastMessages.error(message: getErrorMsg(errorType: kycBloc.state.fileUploadState!.errorType!));
      }
    }
    return Error(GenericError());
  }


  // Verify GST api call
  Future<void> verifyGstApiCall(String gstNumber) async {
    final apiRequest = VerifyGstApiRequest(gst: gstNumber, force: false);
    await kycBloc.verifyGst(apiRequest);
    if (kycBloc.state.gstState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "GST verified successfully");
    }
    if (kycBloc.state.gstState?.status == Status.ERROR) {
      ToastMessages.error(message: getErrorMsg(errorType: kycBloc.state.gstState!.errorType!));
    }
  }


  // Verify TAN api call
  Future<void> verifyTANApiCall(String tanNumber) async {
    final apiRequest = VerifyTanApiRequest(tan: tanNumber, force: false);
    await kycBloc.verifyTan(apiRequest);
    if (kycBloc.state.tanState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "TAN verified successfully");
    }
    if (kycBloc.state.tanState?.status == Status.ERROR) {
      ToastMessages.error(message: getErrorMsg(errorType: kycBloc.state.tanState!.errorType!));
    }
  }


  // Verify pan api call
  Future<void> verifyPANApiCall(String panNumber) async {
    final apiRequest = VerifyPanApiRequest(pan: panNumber, force: false);
    await kycBloc.verifyPan(apiRequest);
    if (kycBloc.state.panState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "Pan verified successfully");
    }
    if (kycBloc.state.panState?.status == Status.ERROR) {
      ToastMessages.error(message: getErrorMsg(errorType: kycBloc.state.panState!.errorType!));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(backgroundColor: AppColors.white, title: context.appText.uploadDocument),
      body: _buildBodyWidget(),
    );
  }

  // List<dynamic> gstDoc = [];
  // List<dynamic> panDoc = [];
  // List<dynamic> tanDoc = [];
  // List<dynamic> checkDocLink = [];
  // List<dynamic> tdsDocLink = [];
  // List<dynamic> tds = [];
  // String uploadLink = "";
  //

  Widget _buildBodyWidget(){
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: BlocConsumer<KycCubit, KycState>(
          bloc: kycBloc,
          listener: (context, state) { },
          // listener: (context, state) {
          //   // if (state. == KycStatus.success) {
          //   //   commonBottomSheetWithBGBlur(
          //   //     context: context,
          //   //
          //   //     screen: KycSuccessDialogue(),
          //   //   ).then((value) {
          //   //     lpHomeBloc.add(
          //   //       ProfileDetailRequested(lpHomeBloc.userId ?? "0"),
          //   //     );
          //   //
          //   //     context.pop();
          //   //
          //   //   });
          //   // }
          //   // if (state is VerifyTanSuccess) {
          //   //   verifiedTan = true;
          //   //
          //   //   print("success VerifyTanSuccess");
          //   // }
          //   // if (state is VerifyPanSuccess) {
          //   //   verifiedPan = true;
          //   //   panTextController.text = "AABCM9984D";
          //   //
          //   //   print("success VerifyPanSuccess");
          //   // }
          //   // if (state is VerifyGstSuccess) {
          //   //   verifiedGst = true;
          //   //   gstInTextController.text = "27AABCM9984D1Z4";
          //   //
          //   //   print("success VerifyGstSuccess");
          //   // } else if (state is AddharOtpError) {
          //   //   ToastMessages.error(
          //   //     message: getErrorMsg(errorType: state.errorType),
          //   //   );
          //   // }
          // },

          builder: (context, state) {
            return Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Aadhaar Number
                      buildTextFieldWithLabelWidget(
                        readOnly: true,
                        rightText: "Aadhaar Number",
                        leftText: "Verified",
                        controller: aadhaarNumberTextController,
                      ),
                      20.height,

                      // Enter GST Number
                      buildTextFieldWithLabelWidget(
                        leftText: state.verifiedGst != null && state.verifiedGst! ? "Verified" : "Un-Verified",
                        readOnly: state.verifiedGst != null && state.verifiedGst!,
                        rightText: "GSTIN",
                        controller: gstInTextController,
                        suffixOnTap: () async {
                          if (gstDoc.isNotEmpty) {
                            final Result result = await uploadDocCommonApiCall(gstDoc);
                            if(result is Success) {
                              await verifyGstApiCall(gstInTextController.text);
                            }
                          }
                        }
                      ),
                      10.height,

                      // Upload GST
                      UploadAttachmentFiles(
                        multiFilesList: gstDoc,
                        isSingleFile: true,
                        isLoading: state.fileUploadState?.status == Status.LOADING
                      ),
                      20.height,


                      /// Tan section
                      // Column(
                      //   spacing: 15.h,
                      //   children: [
                      //     buildTextFieldWithLabelWidget(
                      //       readOnly: verifiedTan,
                      //       leftText: verifiedTan ? "Verified" : "Un-Verified",
                      //       rightText: "TAN",
                      //       controller: tanTextController,
                      //       currentFocus: tanFocusNode,
                      //     ),
                      //     upload(multiFilesList: tanDoc),
                      //   ],
                      // ),

                      // Enter TAN number
                      buildTextFieldWithLabelWidget(
                        leftText: state.verifiedTan != null && state.verifiedTan! ? "Verified" : "Un-Verified",
                        readOnly: state.verifiedTan != null && state.verifiedTan!,
                        rightText: "TAN",
                        controller: tanTextController,
                        suffixOnTap: () async {
                          if (tanTextController.text.isNotEmpty && tanDoc.isNotEmpty) {
                            final Result result = await uploadDocCommonApiCall(tanDoc);
                            if(result is Success) {
                              await verifyTANApiCall(tanTextController.text);
                            }
                          } else {
                            ToastMessages.alert(message: "Please enter TAN and upload document");
                          }
                        }
                      ),
                      10.height,

                      // Upload TAN Doc
                      UploadAttachmentFiles(
                        multiFilesList: tanDoc,
                        isSingleFile: true,
                        isLoading: state.fileUploadState?.status == Status.LOADING,
                      ),
                      20.height,

                      // Enter PAN number
                      buildTextFieldWithLabelWidget(
                          leftText: state.verifiedPan != null && state.verifiedPan! ? "Verified" : "Un-Verified",
                          readOnly: state.verifiedPan != null && state.verifiedPan!,
                          rightText: "PAN",
                          controller: panTextController,
                          suffixOnTap: () async {
                            if (panTextController.text.isNotEmpty && panDoc.isNotEmpty) {
                              final Result result = await uploadDocCommonApiCall(panDoc);
                              if(result is Success) {
                                await verifyPANApiCall(panTextController.text);
                              }
                            } else {
                              ToastMessages.alert(message: "Please enter PAN and upload document");
                            }
                          }
                      ),
                      10.height,

                      // Upload PAN Doc
                      UploadAttachmentFiles(
                        multiFilesList: panDoc,
                        isSingleFile: true,
                        isLoading: state.fileUploadState?.status == Status.LOADING,
                      ),
                      20.height,

                      Builder(
                        builder: (context){
                          if(kycBloc.userRole != null && kycBloc.userRole != "2") {
                            return Column(
                              children: [

                                // Upload Check Doc
                                UploadAttachmentFiles(
                                  title: "Upload Check Document",
                                  multiFilesList: checkDocLink,
                                  isSingleFile: true,
                                  isLoading: state.fileUploadState?.status == Status.LOADING,
                                  thenUploadFileToSever: () async {

                                  },
                                ),
                                20.height,

                                // Upload TDS Doc
                                UploadAttachmentFiles(
                                  title: "Upload TDS Certification",
                                  multiFilesList: tdsDocLink,
                                  isSingleFile: true,
                                  isLoading: state.fileUploadState?.status == Status.LOADING,
                                  thenUploadFileToSever: () async {

                                  },
                                ),
                                20.height,
                              ],
                            );
                          } else {
                            return Container();
                          }

                      }),

                      // int.parse(userRole ?? "0") == 2
                      //     ? Column(
                      //       spacing: 15.h,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         /// Cancelled cheque section
                      //         Text(
                      //           "Cancelled Cheque",
                      //           style: AppTextStyle.textBlackColor16w400,
                      //         ),
                      //         upload(multiFilesList: checkDocLink),
                      //
                      //         /// Tds Certificate section
                      //         Text(
                      //           "TDS Certificate",
                      //           style: AppTextStyle.textBlackColor16w400,
                      //         ),
                      //         upload(multiFilesList: tdsDocLink),
                      //       ],
                      //     )
                      //     : const SizedBox(),

                      multipleTextFieldWidget(
                        text: "Address",
                        children: [
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: addressLine1TextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Address Line 1",
                            ),
                          ),
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: addressLine2TextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Address Line 2",
                            ),
                          ),
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: addressLine3TextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Address Line 3",
                            ),
                          ),
                          AppTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            keyboardType: TextInputType.number,
                            validator: (value) => Validator.pincode(value),
                            controller: pincodeTextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Pin code",
                            ),
                          ),
                        ],
                      ),
                      20.height,



                      multipleTextFieldWidget(
                        text: "Bank Details",
                        children: [
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: accountNumberTextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Account Number",
                            ),
                          ),
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: bankNameTextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Bank Name",
                            ),
                          ),
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: branchNameTextController,
                            decoration: commonInputDecoration(
                              fillColor: AppColors.white,
                              hintText: "Branch Name",
                            ),
                          ),
                          AppTextField(
                            validator:
                                (value) => Validator.fieldRequired(value),
                            controller: ifscCodeTextController,
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
                // AppButton(
                //   style: (int.parse(userRole ?? "0") == 1 ? (gstDoc.isEmpty || tanDoc.isEmpty || panDoc.isEmpty) : (gstDoc.isEmpty || checkDocLink.isEmpty || panDoc.isEmpty || tdsDocLink.isNotEmpty))
                //           ? AppButtonStyle.disableButton
                //           : AppButtonStyle.primary,
                //   title: context.appText.submit,
                //   onPressed: () {
                //     if (int.parse(userRole ?? "0") == 1
                //         ? (gstDoc.isEmpty || tanDoc.isEmpty || panDoc.isEmpty)
                //         : (gstDoc.isEmpty || checkDocLink.isEmpty || panDoc.isEmpty || tdsDocLink.isNotEmpty)) {
                //     } else {
                //       if (verifiedGst && verifiedTan && verifiedPan) {
                //         if (_formKey.currentState!.validate()) {
                //           final kycRequest = SubmitKycApiRequest(
                //             aadhar: widget.addharNumber,
                //             address1: addressLine1TextController.text,
                //             address2: addressLine2TextController.text,
                //             address3: addressLine3TextController.text,
                //             bankAccount: accountNumberTextController.text,
                //             bankName: bankNameTextController.text,
                //             branchName: branchNameTextController.text,
                //             chequeDocLink: checkDocLink.isNotEmpty ? checkDocLink.first['path'] : null,
                //             tdsDocLink: tdsDocLink.isNotEmpty ? tdsDocLink.first['path'] : null,
                //             gstin: gstInTextController.text,
                //             gstinDocLink: gstDoc.first['path'],
                //             ifscCode: ifscCodeTextController.text,
                //             isAadhar: true,
                //             isGstin: verifiedGst,
                //             isPan: verifiedPan,
                //             isTan: verifiedTan,
                //             pan: panTextController.text,
                //             panDocLink: panDoc.first['path'],
                //             tan: tanTextController.text,
                //             tanDocLink: tanDoc.first['path'],
                //           );
                //
                //           kycBloc.add(
                //             SubmitKycRequested(
                //               apiRequest: kycRequest,
                //               userId: userID ?? "0",
                //             ),
                //           );
                //         }
                //       } else {
                //         ToastMessages.error(
                //           message: "Please verify all document before submit",
                //         );
                //       }
                //     }
                //   },
                // ),
                10.height,
              ],
            );
          },
        ),
      ),
    );
  }


  multipleTextFieldWidget({required String text, String? leftText, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.textBlackColor16w400),
        5.height,
        Column(spacing: 10.h, children: children),
      ],
    );
  }


  Widget buildTextFieldWithLabelWidget({required String rightText, String? leftText, bool readOnly = false, FocusNode? currentFocus, required TextEditingController controller, dynamic Function()? suffixOnTap}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rightText, style: AppTextStyle.textFiled),
            Text(
              leftText ?? "",
              style: AppTextStyle.textFiled.copyWith(color: !readOnly ? AppColors.activeRedColor : AppColors.activeGreenColor),
            ),
          ],
        ),
        6.height,
        AppTextField(
          validator: (value) => Validator.fieldRequired(value),
          readOnly: readOnly,
          currentFocus: currentFocus,
          controller: controller,
          decoration: commonInputDecoration(
              suffixIcon: Text("Verify", style: AppTextStyle.h6PrimaryColor),
              suffixOnTap: suffixOnTap ?? (){}
          ),
        ),
      ],
    );
  }
}
