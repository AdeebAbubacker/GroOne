import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';


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
  final TextEditingController pinCodeTextController = TextEditingController();
  final TextEditingController accountNumberTextController = TextEditingController();
  final TextEditingController bankNameTextController = TextEditingController();
  final TextEditingController branchNameTextController = TextEditingController();
  final TextEditingController ifscCodeTextController = TextEditingController();

  final FocusNode gstFocusNode = FocusNode();
  final FocusNode tanFocusNode = FocusNode();
  final FocusNode panFocusNode = FocusNode();


  List<dynamic> gstDoc = [];
  List<dynamic> panDoc = [];
  List<dynamic> tanDoc = [];
  List<dynamic> checkDocLink = [];
  List<dynamic> tdsDocLink = [];
  List<dynamic> tds = [];

  String uploadLink = "";

  String? selectedState;
  String? selectedCity;

  final List<String> stateList = [
    "Maharashtra",
    "Madhya Pradesh",
    "Karnataka",
    "Tamil Nadu",
    "Gujarat",
    "Rajasthan",
    "Uttar Pradesh"
  ];

  final Map<String, List<String>> cityMap = {
    "Maharashtra": [
      "Mumbai",
      "Pune",
      "Nagpur",
      "Nashik",
      "Aurangabad",
      "Thane"
    ],
    "Madhya Pradesh": [
      "Indore",
      "Bhopal",
      "Jabalpur",
      "Gwalior",
      "Ujjain",
      "Sagar"
    ],
    "Karnataka": [
      "Bangalore",
      "Mysore",
      "Hubli",
      "Mangalore",
      "Belgaum",
      "Tumkur"
    ],
    "Tamil Nadu": [
      "Chennai",
      "Coimbatore",
      "Madurai",
      "Salem",
      "Tirunelveli",
      "Vellore"
    ],
    "Gujarat": [
      "Ahmedabad",
      "Surat",
      "Vadodara",
      "Rajkot",
      "Gandhinagar",
      "Bhavnagar"
    ],
    "Rajasthan": [
      "Jaipur",
      "Udaipur",
      "Jodhpur",
      "Kota",
      "Bikaner",
      "Ajmer"
    ],
    "Uttar Pradesh": [
      "Lucknow",
      "Kanpur",
      "Varanasi",
      "Agra",
      "Noida",
      "Meerut"
    ],
  };



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
    await kycBloc.fetchUserId();
    await kycBloc.fetchCompanyTypeId();
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
        final apiRequest = VerifyGstApiRequest(gst: gstInTextController.text, force: true);
        await kycBloc.verifyGst(apiRequest);
      }
    });

    tanFocusNode.addListener(() async {
      if (!tanFocusNode.hasFocus) {
        final apiRequest = VerifyTanApiRequest(tan: tanTextController.text, force: true);
        await kycBloc.verifyTan(apiRequest);
      }
    });

    panFocusNode.addListener(() async {
      if (!panFocusNode.hasFocus) {
        final apiRequest = VerifyPanApiRequest(pan: panTextController.text, force: true);
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
    final apiRequest = VerifyGstApiRequest(gst: gstNumber, force: true);
    await kycBloc.verifyGst(apiRequest);
    if (kycBloc.state.gstState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "GST verified successfully");
    }
    if (kycBloc.state.gstState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid GST Number");
    }
  }


  // Verify TAN api call
  Future<void> verifyTANApiCall(String tanNumber) async {
    final apiRequest = VerifyTanApiRequest(tan: tanNumber, force: true);
    await kycBloc.verifyTan(apiRequest);
    if (kycBloc.state.tanState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "TAN verified successfully");
    }
    if (kycBloc.state.tanState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid TAN Number");
    }
  }


  // Verify pan api call
  Future<void> verifyPANApiCall(String panNumber) async {
    final apiRequest = VerifyPanApiRequest(pan: panNumber, force: true);
    await kycBloc.verifyPan(apiRequest);
    if (kycBloc.state.panState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "Pan verified successfully");
    }
    if (kycBloc.state.panState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid PAN Number");
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


  Widget _buildBodyWidget(){
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: BlocConsumer<KycCubit, KycState>(
          bloc: kycBloc,
          listener: (context, state) { },
          builder: (context, kycState) {
            return BlocBuilder<LpHomeBloc, HomeState>(
              bloc: lpHomeBloc,
              builder: (context, lpHomeState){
                dynamic companyId;
                if(lpHomeState is ProfileDetailSuccess){
                  companyId  = lpHomeState.profileDetailResponse.data?.details?.companyTypeId;
                }else{
                  companyId = 0;
                }
                CustomLog.info(this, "companyId: $companyId");
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          //companyTypeId:1=Sole Proprietor-GST, PAN, TAN, Aadhaar
                          if(companyId == 1)...[
                            _buildAadhaarWidget(kycState),
                            10.height,
                            _buildGstWidget(kycState),
                            10.height,
                            _buildTanWidget(kycState),
                            10.height,
                            _buildPanWidget(kycState),
                          ],

                          // companyTypeId:2=Privated Proprietor-only Aadhaar
                          if(companyId == 2)...[
                            _buildAadhaarWidget(kycState),
                            10.height,
                          ],


                          // companyTypeId:3=Limited Proprietor-GST, PAN, TAN
                          // companyTypeId:4=LLC Proprietor-GST, PAN, TAN
                          if(companyId == 3 || companyId == 4)...[
                            _buildGstWidget(kycState),
                            10.height,
                            _buildTanWidget(kycState),
                            10.height,
                            _buildPanWidget(kycState),
                          ],

                          // Primary Address
                          _buildMultipleTextFieldWidget(
                            text: "Primary Address",
                            children: [
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: addressLine1TextController,
                                mandatoryStar: true,
                                labelText: "Address Name",
                                hintText: "Enter Address name 1",
                              ),

                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: addressLine2TextController,
                                mandatoryStar: true,
                                labelText: "Full Address",
                                hintText: "Enter full address",
                              ),

                              // AppTextField(
                              //   controller: addressLine3TextController,
                              //   labelText: "Address Line 3",
                              //   hintText: "Enter Address Line 3",
                              // ),

                              // STATE DROPDOWN
                              AppDropdown(
                                validator: (value) => Validator.fieldRequired(value),
                                labelText: "State",
                                hintText: "Select State",
                                mandatoryStar: true,
                                dropdownValue: selectedState,
                                decoration: commonInputDecoration(fillColor: Colors.white),
                                dropDownList: stateList.map((state) {
                                  return DropdownMenuItem(
                                    value: state,
                                    child: Text(state, style: AppTextStyle.body),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedState = value;
                                  selectedCity = null; // Reset city when state changes
                                  setState(() {});
                                },
                              ),

                              // CITY DROPDOWN
                              AppDropdown(
                                validator: (value) => Validator.fieldRequired(value),
                                labelText: "City",
                                hintText: "Select City",
                                mandatoryStar: true,
                                dropdownValue: selectedCity,
                                decoration: commonInputDecoration(fillColor: Colors.white),
                                dropDownList: (selectedState != null) ? cityMap[selectedState]!.map((city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Text(city, style: AppTextStyle.body),
                                  );
                                }).toList() : [],
                                onChanged: (value) {
                                  selectedCity = value;
                                  setState(() {});
                                },
                              ),

                              AppTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: iosNumberKeyboard,
                                validator: (value) => Validator.pincode(value),
                                controller: pinCodeTextController,
                                mandatoryStar: true,
                                labelText: "Pin Code",
                                hintText: "Enter Pin Code",
                              ),
                            ],
                          ),
                          30.height,

                          // Bank Details
                          _buildMultipleTextFieldWidget(
                            text: "Bank Details",
                            children: [
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: accountNumberTextController,
                                mandatoryStar: true,
                                labelText: "Account Number",
                                hintText: "Enter Account Number",
                              ),

                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: bankNameTextController,
                                mandatoryStar: true,
                                labelText: "Bank Name",
                                hintText: "Enter Bank Name",
                              ),

                              AppTextField(
                                  validator: (value) => Validator.fieldRequired(value),
                                  controller: branchNameTextController,
                                  mandatoryStar: true,
                                  labelText: "Branch Name",
                                  hintText: "Enter Branch Name"
                              ),

                              AppTextField(
                                  validator: (value) => Validator.fieldRequired(value),
                                  controller: ifscCodeTextController,
                                  mandatoryStar: true,
                                  labelText: "IFSC Code",
                                  hintText: "Enter IFSC code"
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    30.height,

                    AppButton(
                      style:  AppButtonStyle.primary,
                      title: context.appText.submit,
                      onPressed: () async {
                        if (int.parse(kycBloc.userRole ?? "0") == 1
                            ? (gstDoc.isEmpty || tanDoc.isEmpty || panDoc.isEmpty)
                            : (gstDoc.isEmpty || checkDocLink.isEmpty || panDoc.isEmpty || tdsDocLink.isNotEmpty)) {
                        } else {
                          if (kycBloc.state.verifiedGst! && kycBloc.state.verifiedTan! && kycBloc.state.verifiedPan!) {
                            if (_formKey.currentState!.validate()) {

                              final kycRequest = SubmitKycApiRequest(
                                aadhar: widget.aadhaarNumber,
                                address1: addressLine1TextController.text,
                                address2: addressLine2TextController.text,
                                address3: addressLine3TextController.text,
                                bankAccount: accountNumberTextController.text,
                                bankName: bankNameTextController.text,
                                branchName: branchNameTextController.text,
                                chequeDocLink: checkDocLink.isNotEmpty ? checkDocLink.first['path'] : null,
                                tdsDocLink: tdsDocLink.isNotEmpty ? tdsDocLink.first['path'] : null,
                                gstin: gstInTextController.text,
                                gstinDocLink: gstDoc.first['path'],
                                ifscCode: ifscCodeTextController.text,
                                isAadhar: true,
                                isGstin: kycBloc.state.verifiedGst!,
                                isPan:  kycBloc.state.verifiedPan!,
                                isTan:  kycBloc.state.verifiedTan!,
                                pan: panTextController.text,
                                panDocLink: panDoc.first['path'],
                                tan: tanTextController.text,
                                tanDocLink: tanDoc.first['path'],
                              );

                              kycBloc.submitKyc(kycRequest, "${await kycBloc.fetchUserId()}");
                            }
                          } else {
                            ToastMessages.error(
                              message: "Please verify all document before submit",
                            );
                          }
                        }
                      },
                    ),
                    30.height,
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAadhaarWidget(KycState kycState){
    return Column(
      children: [
        buildTextFieldWithLabelWidget(
          readOnly: true,
          rightText: "Aadhaar Number",
          leftText: "Verified",
          controller: aadhaarNumberTextController,
        ),


      ],
    );
  }

  Widget _buildGstWidget(KycState kycState){
    return Column(
      children: [

        // Enter GST Number
        buildTextFieldWithLabelWidget(
            leftText: kycState.verifiedGst != null && kycState.verifiedGst! ? "Verified" : "Un-Verified",
            readOnly: kycState.verifiedGst != null && kycState.verifiedGst!,
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
           title: "Upload GST Document",
            multiFilesList: gstDoc,
            isSingleFile: true,
            isLoading: kycState.fileUploadState?.status == Status.LOADING
        ),

        20.height,

      ],
    );
  }


  Widget _buildTanWidget(KycState kycState){
    return Column(
      children: [


        // Enter TAN number
        buildTextFieldWithLabelWidget(
            leftText: kycState.verifiedTan != null && kycState.verifiedTan! ? "Verified" : "Un-Verified",
            readOnly: kycState.verifiedTan != null && kycState.verifiedTan!,
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
          title: "Upload TAN Document",
          multiFilesList: tanDoc,
          isSingleFile: true,
          isLoading: kycState.fileUploadState?.status == Status.LOADING,
        ),
        20.height,

      ],
    );
  }


  Widget _buildPanWidget(KycState kycState){
    return Column(
      children: [

        // Enter PAN number
        buildTextFieldWithLabelWidget(
            leftText: kycState.verifiedPan != null && kycState.verifiedPan! ? "Verified" : "Un-Verified",
            readOnly: kycState.verifiedPan != null && kycState.verifiedPan!,
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
          title: "Upload PAN Document",
          multiFilesList: panDoc,
          isSingleFile: true,
          isLoading: kycState.fileUploadState?.status == Status.LOADING,
        ),


        30.height,

        Builder(
            builder: (context){
              if(kycBloc.userRole != null && kycBloc.userRole == "2") {
                return Column(
                  children: [

                    // Upload Check Doc
                    UploadAttachmentFiles(
                      title: "Upload Check Document",
                      multiFilesList: checkDocLink,
                      isSingleFile: true,
                      isLoading: kycState.fileUploadState?.status == Status.LOADING,
                      thenUploadFileToSever: () async {

                      },
                    ),
                    20.height,

                    // Upload TDS Doc
                    UploadAttachmentFiles(
                      title: "Upload TDS Certification",
                      multiFilesList: tdsDocLink,
                      isSingleFile: true,
                      isLoading: kycState.fileUploadState?.status == Status.LOADING,
                      thenUploadFileToSever: () async {

                      },
                    ),
                    30.height,
                  ],
                );
              } else {
                return Container();
              }

            }),
      ],
    );
  }


  Widget  _buildMultipleTextFieldWidget({required String text, String? leftText, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.body1),
        10.height,
        Column(spacing: 20.h, children: children),
      ],
    );
  }


  Widget buildTextFieldWithLabelWidget({required String rightText, String? leftText, bool readOnly = false, FocusNode? currentFocus, required TextEditingController controller, dynamic Function()? suffixOnTap}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(rightText, style: AppTextStyle.textFiled),
                5.width,
                Text("*", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
              ],
            ),
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
