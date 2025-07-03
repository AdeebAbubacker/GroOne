import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/bank_account_number_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/gst_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/ifsc_code_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/pan_card_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/tan_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/upper_case_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';


class KycUploadDocumentScreen extends StatefulWidget {
  final String? aadhaarNumber;
  const KycUploadDocumentScreen({super.key, this.aadhaarNumber});

  @override
  State<KycUploadDocumentScreen> createState() => _KycUploadDocumentScreenState();
}

class _KycUploadDocumentScreenState extends State<KycUploadDocumentScreen> {

  final _formKey = GlobalKey<FormState>();
  final dropDownStateKey = GlobalKey<DropdownSearchState>();
  final dropDownCityKey = GlobalKey<DropdownSearchState>();

  final kycCubit = locator<KycCubit>();
  final profileCubit = locator<ProfileCubit>();

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

  dynamic companyId;



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
    await kycCubit.fetchUserRole();
    await kycCubit.fetchUserId();
    await kycCubit.fetchCompanyTypeId();
    await kycCubit.fetchStateList();
    if (widget.aadhaarNumber != null) {
      aadhaarNumberTextController.text = widget.aadhaarNumber!;
    } else {
      aadhaarNumberTextController.text = "";
    }
  });
  
  void disposeFunction()=> frameCallback((){
    gstInTextController.dispose();
    tanTextController.dispose();
    panTextController.dispose();
    addressLine1TextController.dispose();
    addressLine2TextController.dispose();
    addressLine3TextController.dispose();
    pinCodeTextController.dispose();
    accountNumberTextController.dispose();
    bankNameTextController.dispose();
    branchNameTextController.dispose();
    ifscCodeTextController.dispose();
    gstFocusNode.dispose();
    tanFocusNode.dispose();
    panFocusNode.dispose();
    kycCubit.resetState();
  });


  // Clear All Values
  void clearAllFormValues()=> frameCallback(() {
    aadhaarNumberTextController.clear();
    gstInTextController.clear();
    tanTextController.clear();
    panTextController.clear();
    addressLine1TextController.clear();
    addressLine2TextController.clear();
    addressLine3TextController.clear();
    pinCodeTextController.clear();
    accountNumberTextController.clear();
    bankNameTextController.clear();
    branchNameTextController.clear();
    ifscCodeTextController.clear();
    selectedState = null;
    selectedCity = null;
    gstDoc.clear();
    panDoc.clear();
    tanDoc.clear();
    checkDocLink.clear();
    tdsDocLink.clear();
    tds.clear();
    uploadLink = "";
  });




  // Upload GST Doc api call
  Future<Result<bool>> uploadGSTDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadGstDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadGSTDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadGSTDocUIState?.data;
      final url = data?.data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadGSTDocUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }


  // Upload Pan Doc api call
  Future<Result<bool>> uploadPanDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadPanDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadPanDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadPanDocUIState?.data;
      final url = data?.data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadPanDocUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }


  // Upload TAN Doc api call
  Future<Result<bool>> uploadTanDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadTanDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadTanDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadTanDocUIState?.data;
      final url = data?.data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadTanDocUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }


  // Upload TDS Doc api call
  Future<Result<bool>> uploadTdsDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadTdsDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadTDSDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadTDSDocUIState?.data;
      final url = data?.data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadTDSDocUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }


  // Upload Pan Doc api call
  Future<Result<bool>> uploadCancelledChequeDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadCancelledCheckDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadCancelledUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadCancelledUIState?.data;
      final url = data?.data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadCancelledUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }



  // Verify GST api call
  Future<void> verifyGstApiCall(String gstNumber) async {
    final apiRequest = VerifyGstApiRequest(gst: gstNumber, force: true);
    await kycCubit.verifyGst(apiRequest);
    if (kycCubit.state.gstState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "GST verified successfully");
    }
    if (kycCubit.state.gstState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid GST Number");
    }
  }


  // Verify TAN api call
  Future<void> verifyTANApiCall(String tanNumber) async {
    final apiRequest = VerifyTanApiRequest(tan: tanNumber, force: true);
    await kycCubit.verifyTan(apiRequest);
    if (kycCubit.state.tanState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "TAN verified successfully");
    }
    if (kycCubit.state.tanState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid TAN Number");
    }
  }


  // Verify pan api call
  Future<void> verifyPANApiCall(String panNumber) async {
    final apiRequest = VerifyPanApiRequest(pan: panNumber, force: true);
    await kycCubit.verifyPan(apiRequest);
    if (kycCubit.state.panState?.status == Status.SUCCESS) {
      ToastMessages.success(message: "Pan verified successfully");
    }
    if (kycCubit.state.panState?.status == Status.ERROR) {
      ToastMessages.alert(message: "Invalid PAN Number");
    }
  }


  bool validateDocs({
    required String userRole,          // "2" for VP, anything else for LP
    required int companyId,            // 1=sole, 2=individual …
    // document lists
    required List gstDoc,
    required List panDoc,
    required List tanDoc,
    required List checkDocLink,
    required List tdsDocLink,
  }) {
    // helper to toast & fail fast
    bool need(String msg, bool ok) {
      if (!ok) ToastMessages.alert(message: 'Please upload $msg');
      return ok;
    }

    // VP FLOW
    if (userRole == "2") {
      if (companyId == 2) {
        return need('Aadhaar', true) &                     // always true – already taken on previous screen
        need('Cancelled Cheque', checkDocLink.isNotEmpty);
      }

      final gstOk  = need('GST document',   gstDoc.isNotEmpty);
      final panOk  = need('PAN document',   panDoc.isNotEmpty);
      final chkOk  = need('Cancelled Cheque', checkDocLink.isNotEmpty);
      final tdsOk  = need('TDS certificate', tdsDocLink.isNotEmpty);
      return gstOk & panOk & chkOk & tdsOk;                 // for Sole + Others
    }

    // LP FLOW
    if (companyId == 2) {
      return true;                                         // only Aadhaar needed
    }
    if (companyId == 1) {
      final gstOk = need('GST document', gstDoc.isNotEmpty);
      final panOk = need('PAN document', panDoc.isNotEmpty);
      final tanOk = need('TAN document', tanDoc.isNotEmpty);
      return gstOk & panOk & tanOk;                        // Aadhaar already present
    }

    // all other company types for LP
    final gstOk = need('GST document', gstDoc.isNotEmpty);
    final panOk = need('PAN document', panDoc.isNotEmpty);
    final tanOk = need('TAN document', tanDoc.isNotEmpty);
    return gstOk & panOk & tanOk;
  }


  // Verify KYC Api Call
  Future verifyKycApiCall() async {
    if(_formKey.currentState!.validate()){

      final ok = validateDocs(
        userRole: kycCubit.userRole ?? '',
        companyId: companyId,
        gstDoc: gstDoc,
        panDoc: panDoc,
        tanDoc: tanDoc,
        checkDocLink: checkDocLink,
        tdsDocLink: tdsDocLink,
      );
      if (!ok) return;

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
        gstinDocLink: gstDoc.isNotEmpty ?  gstDoc.first['path'] : null,
        ifscCode: ifscCodeTextController.text,
        isAadhar: true,
        isGstin: kycCubit.state.verifiedGst,
        isPan:  kycCubit.state.verifiedPan,
        isTan:  kycCubit.state.verifiedTan,
        pan: panTextController.text,
        panDocLink:  panDoc.isNotEmpty ?  panDoc.first['path'] : null,
        tan: tanTextController.text,
        tanDocLink:  tanDoc.isNotEmpty ? tanDoc.first['path'] : null,
      );
      kycCubit.submitKyc(kycRequest, "${await kycCubit.fetchUserId()}");
    }
  }



  // Navigate to home screen when kyc is done
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: "KYC submitted for verification",
        heading: "Will get back to you within 48 hours.",
        onContinue: (){
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          kycCubit.resetState();
        },
      ),
    );
  });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(backgroundColor: AppColors.white, title: context.appText.uploadDocument),
      body: _buildBodyWidget(),
      bottomNavigationBar: buildSubmitKycButtonWidget(),
    );
  }


  // Build Body
  Widget _buildBodyWidget(){
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: BlocConsumer<KycCubit, KycState>(
          bloc: kycCubit,
          listener: (context, state) { },
          builder: (context, kycState) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              buildWhen: (previous, current) {
                return previous != current;
              },
              builder: (context, lpHomeState){
                if(lpHomeState.profileDetailUIState?.data?.data?.details?.companyTypeId != null){
                  companyId  = lpHomeState.profileDetailUIState?.data?.data?.details?.companyTypeId;
                }else{
                  companyId = null;
                }
                CustomLog.info(this, "companyId: $companyId");
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Builder(
                            builder: (context){

                              if(kycCubit.userRole == null){
                                return Container();
                              }

                              CustomLog.debug(this, "User Role: ${kycCubit.userRole}");

                              // For VP
                              if(kycCubit.userRole == "2") {
                                return Column(
                                  children: [

                                    //  VP Individual Proprietor id 2
                                    if(companyId == 2)...[
                                      25.height,
                                      _buildAadhaarWidget(),
                                      25.height,
                                      buildCancelledCheckWidget(),
                                      50.height,
                                    ],


                                    //  VP Sole Proprietor id = 1
                                    if(companyId == 1)...[
                                      _buildAadhaarWidget(),
                                      25.height,
                                      _buildGstWidget(),
                                      25.height,
                                      _buildPanWidget(),
                                      25.height,
                                      buildCancelledCheckWidget(),
                                      25.height,
                                      buildTDSCertificationWidget(),
                                      50.height,
                                    ],

                                    // VP All Others
                                    if(companyId != 1 && companyId != 2)...[
                                      _buildGstWidget(),
                                      25.height,
                                      _buildPanWidget(),
                                      25.height,
                                      buildTDSCertificationWidget(),
                                      25.height,
                                      buildCancelledCheckWidget(),
                                      50.height,
                                    ],
                                  ],
                                );
                              }else{

                                // For LP
                                return Column(
                                  children: [
                                    // LP Sole Proprietor id = 1
                                    if(companyId == 1)...[
                                      _buildAadhaarWidget(),
                                      25.height,
                                      _buildGstWidget(),
                                      25.height,
                                      _buildPanWidget(),
                                      25.height,
                                      _buildTanWidget(),
                                      50.height,
                                    ],

                                    // LP Individual Proprietor id = 2
                                    if(companyId == 2)...[
                                      _buildAadhaarWidget(),
                                      50.height,
                                    ],

                                    // VP All Others
                                    if(companyId != 1 && companyId != 2)...[
                                      _buildGstWidget(),
                                      25.height,
                                      _buildPanWidget(),
                                      25.height,
                                      _buildTanWidget(),
                                      50.height,
                                    ],
                                  ],
                                );
                              }

                            },
                          ),


                          // Primary Address
                          _buildMultipleTextFieldWidget(
                            text: "Primary Address",
                            children: [
                              10.height,

                              // Address Name
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: addressLine1TextController,
                                mandatoryStar: true,
                                labelText: "Address Name",
                                hintText: "Enter Address name 1",
                              ),
                              20.height,

                              // Full Address
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: addressLine2TextController,
                                mandatoryStar: true,
                                labelText: "Full Address",
                                hintText: "Enter full address",
                              ),
                              20.height,


                              // State Dropdown
                              BlocConsumer<KycCubit, KycState>(
                                bloc: kycCubit,
                                listenWhen: (previous, current) => previous.stateUIState?.status != current.stateUIState?.status,
                                listener:  (context, state) async {
                                  final status = state.stateUIState?.status;

                                  if (status == Status.ERROR) {
                                    final error = state.stateUIState?.errorType;
                                    ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                                  }
                                },
                                builder: (context, state) {
                                  final status = state.stateUIState?.status;

                                  if (status == Status.SUCCESS &&
                                      state.stateUIState?.data != null &&
                                      state.stateUIState!.data!.data != null &&
                                      state.stateUIState!.data!.data!.response.isNotEmpty) {

                                    final stateList = state.stateUIState!.data!.data!.response;

                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(" State", style: AppTextStyle.body3),
                                            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                          ],
                                        ),
                                        6.height,
                                        DropdownSearch<String>(
                                          validator: (value) => Validator.fieldRequired(value),
                                          key: dropDownStateKey,
                                          items: (filter, infiniteScrollProps) => stateList.where((element) => element.toLowerCase().contains(filter.toLowerCase())).toList(),
                                          popupProps: PopupProps.modalBottomSheet(
                                            fit: FlexFit.loose,
                                            showSearchBox: true,
                                            constraints: BoxConstraints(maxHeight: 400),
                                          ),
                                          decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration(hintText: "Select State")),
                                          selectedItem: selectedState,
                                          onChanged: (value) {
                                            selectedState = value;
                                            selectedCity = null;
                                            if (value != null) {
                                              kycCubit.fetchCityList(value);
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                  return 0.height; // Return empty if no data
                                },
                              ),
                              20.height,


                              // AppDropdown(
                              //   validator: (value) => Validator.fieldRequired(value),
                              //   labelText: "State",
                              //   hintText: "Select State",
                              //   mandatoryStar: true,
                              //   dropdownValue: selectedState,
                              //   decoration: commonInputDecoration(fillColor: Colors.white),
                              //   dropDownList: stateList.map((state) {
                              //     return DropdownMenuItem(
                              //       value: state,
                              //       child: Text(state, style: AppTextStyle.body),
                              //     );
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     selectedState = value;
                              //     selectedCity = null; // Reset city when state changes
                              //     setState(() {});
                              //   },
                              // ),

                              // CITY DROPDOWN
                              BlocConsumer<KycCubit, KycState>(
                                bloc: kycCubit,
                                listenWhen: (previous, current) => previous.cityUIState?.status != current.cityUIState?.status,
                                listener:  (context, state) async {
                                  final status = state.cityUIState?.status;

                                  if (status == Status.ERROR) {
                                    final error = state.cityUIState?.errorType;
                                    ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                                  }
                                },
                                builder: (context, state) {
                                  final status = state.cityUIState?.status;

                                  if (status == Status.SUCCESS &&
                                      state.cityUIState?.data != null &&
                                      state.cityUIState!.data!.data != null &&
                                      state.cityUIState!.data!.data!.response.isNotEmpty) {

                                    final cityList = state.cityUIState!.data!.data!.response;

                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(" City", style: AppTextStyle.body3),
                                            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                          ],
                                        ),
                                        6.height,
                                        DropdownSearch<String>(
                                          validator: (value) => Validator.fieldRequired(value),
                                          key: dropDownCityKey,
                                          items: (filter, infiniteScrollProps) => selectedState != null
                                              ? cityList.where((element) => element.toLowerCase().contains(filter.toLowerCase())).toList()
                                              : [],
                                          popupProps: PopupProps.modalBottomSheet(
                                            fit: FlexFit.loose,
                                            showSearchBox: true,
                                            constraints: BoxConstraints(maxHeight: 400),
                                          ),
                                          decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration(hintText: "Select City")),
                                          selectedItem: selectedCity,
                                          onChanged: (value) {
                                            selectedCity = value;
                                          },
                                        ),
                                        20.height
                                      ],
                                    );
                                  }
                                  return 0.height; // Return empty if no data
                                },
                              ),
                              // AppDropdown(
                              //   validator: (value) => Validator.fieldRequired(value),
                              //   labelText: "City",
                              //   hintText: "Select City",
                              //   mandatoryStar: true,
                              //   dropdownValue: selectedCity,
                              //   decoration: commonInputDecoration(fillColor: Colors.white),
                              //   dropDownList: (selectedState != null) ? cityMap[selectedState]!.map((city) {
                              //     return DropdownMenuItem(
                              //       value: city,
                              //       child: Text(city, style: AppTextStyle.body),
                              //     );
                              //   }).toList() : [],
                              //   onChanged: (value) {
                              //     selectedCity = value;
                              //     setState(() {});
                              //   },
                              // ),

                              AppTextField(
                                validator: (value) => Validator.pincode(value),
                                controller: pinCodeTextController,
                                mandatoryStar: true,
                                labelText: "Pin Code",
                                hintText: "Enter Pin Code",
                                maxLength: 6,
                                keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ],
                          ),
                          50.height,

                          // Bank Details
                          _buildMultipleTextFieldWidget(
                            text: "Bank Details",
                            children: [
                              10.height,
                              AppTextField(
                                validator: (value) => kycCubit.userRole == "1" ? null : Validator.fieldRequired(value),
                                controller: accountNumberTextController,
                                mandatoryStar: kycCubit.userRole == "1" ? false : true,
                                labelText: "Account Number",
                                hintText: "Enter Account Number",
                                keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  BankAccountNumberFormatter()
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator: (value) => kycCubit.userRole == "1" ? null : Validator.fieldRequired(value),
                                controller: bankNameTextController,
                                mandatoryStar: kycCubit.userRole == "1" ? false : true,
                                labelText: "Bank Name",
                                hintText: "Enter Bank Name",
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                                ],
                              ),
                              20.height,

                              AppTextField(
                                  validator: (value) => kycCubit.userRole == "1" ? null : Validator.fieldRequired(value),
                                  controller: branchNameTextController,
                                  mandatoryStar: kycCubit.userRole == "1" ? false : true,
                                  labelText: "Branch Name",
                                  hintText: "Enter Branch Name",
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                                  ],
                              ),
                              20.height,

                              AppTextField(
                                  validator: (value) => kycCubit.userRole == "1" ? null : Validator.fieldRequired(value),
                                  controller: ifscCodeTextController,
                                  mandatoryStar: kycCubit.userRole == "1" ? false : true,
                                  labelText: "IFSC Code",
                                  hintText: "Enter IFSC code",
                                  inputFormatters: [
                                    IFSCCodeFormatter()
                                  ],

                              ),

                            ],
                          ),
                        ],
                      ),
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


  // Upload TDS
  Widget buildCancelledCheckWidget(){
    return BlocConsumer<KycCubit, KycState>(
      bloc: kycCubit,
      buildWhen: (previous, current) =>  previous.uploadCancelledUIState != current.uploadCancelledUIState,
      listener: (context, state) {},
        builder: (context, state) {
          final cancelledCheckUploadState = state.uploadCancelledUIState?.status;
          if(kycCubit.userRole != null && kycCubit.userRole == "2") {
            return UploadAttachmentFiles(
              title: "Cancelled Cheque *",
              multiFilesList: checkDocLink,
              isSingleFile: true,
              isLoading: cancelledCheckUploadState == Status.LOADING,
              thenUploadFileToSever: () async {
                await uploadGSTDocumentApiCall(checkDocLink);
              },
            );
          } else {
            return Container();
          }
        },
    );
  }


  // Upload Cancelled Check
  Widget buildTDSCertificationWidget(){
    return  BlocConsumer<KycCubit, KycState>(
      bloc: kycCubit,
      buildWhen: (previous, current) =>  previous.uploadTDSDocUIState != current.uploadTDSDocUIState,
      listener: (context, state) {},
        builder: (context, state) {
          final tdsUploadState = state.uploadTDSDocUIState?.status;
          if(kycCubit.userRole != null && kycCubit.userRole == "2") {
            return UploadAttachmentFiles(
              title: "TDS Certificate *",
              multiFilesList: tdsDocLink,
              isSingleFile: true,
              isLoading: tdsUploadState == Status.LOADING,
              thenUploadFileToSever: () async {
                await uploadGSTDocumentApiCall(tdsDocLink);
              },
            );
          } else {
            return Container();
          }
        },
    );
  }


  // Submit KYC Button
  Widget buildSubmitKycButtonWidget(){
    return  BlocConsumer<KycCubit, KycState>(
        bloc: kycCubit,
        listenWhen: (previous, current) =>  previous.submitKycState != current.submitKycState,
        listener:  (context, state) async {
          final status = state.submitKycState?.status;
          if (status == Status.SUCCESS) {
            clearAllFormValues();
            profileCubit.fetchProfileDetail();
            navigateToHomeScreen(context);
          }
          if (status == Status.ERROR) {
            final error = state.submitKycState?.errorType;
            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
          }
        },
        builder: (context, state) {
          return AppButton(
            style:  AppButtonStyle.primary,
            title: context.appText.submit,
            onPressed: () async {
              verifyKycApiCall();
            },
          );
        }
    ).bottomNavigationPadding();
  }


  // Aadhaar Text Field
  Widget _buildAadhaarWidget(){
    return buildTextFieldWithLabelWidget(
      readOnly: true,
      rightText: "Aadhaar Number",
      leftText: "Verified",
      controller: aadhaarNumberTextController,
      fillColor: AppColors.lightGreyBackgroundColor
    );
  }


  // GST Text Field & Upload GST
  Widget _buildGstWidget(){
    return BlocConsumer<KycCubit, KycState>(
      bloc: kycCubit,
      listener: (context, state) {},
      builder: (context, state) {
        bool verified = state.verifiedGst != null && state.verifiedGst!;
        return Column(
          children: [
            // Enter GST Number
            buildTextFieldWithLabelWidget(
              maxLength: 15,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  GSTInputFormatter()
                ],
                leftText: verified ? "Verified" : "Un-Verified",
                readOnly: verified,
                rightText: "GSTIN",
                controller: gstInTextController,
                suffixOnTap:  state.verifiedGst != null && state.verifiedGst! ? (){} : () async {
                  if (gstDoc.isNotEmpty) {
                    final Result result = await uploadGSTDocumentApiCall(gstDoc);
                    if(result is Success) {
                      await verifyGstApiCall(gstInTextController.text);
                    }
                  }  else {
                    ToastMessages.alert(message: "Please enter GSTIN and upload document");
                  }
                }
            ),
            10.height,

            // Upload GST
            UploadAttachmentFiles(
               title: "Upload GST Document",
                multiFilesList: gstDoc,
                isSingleFile: true,
                isLoading: state.uploadGSTDocUIState?.status == Status.LOADING,
                hideDeleteButton: verified
            ),
          ],
        );
      }
    );
  }


  // TAN Text Field & Upload TAN
  Widget _buildTanWidget(){
    return BlocConsumer<KycCubit, KycState>(
        bloc: kycCubit,
        listener: (context, state) {},
        builder: (context, state) {
          bool verified = state.verifiedTan != null && state.verifiedTan!;
        return Column(
          children: [
            // Enter TAN number
            buildTextFieldWithLabelWidget(
              maxLength: 10,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  TANInputFormatter(),
                ],
                leftText: verified ? "Verified" : "Un-Verified",
                readOnly: verified,
                rightText: "TAN",
                controller: tanTextController,
                suffixOnTap: () async {
                  if (tanTextController.text.isNotEmpty && tanDoc.isNotEmpty) {
                    final Result result = await uploadTanDocumentApiCall(tanDoc);
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
              isLoading: state.uploadTanDocUIState?.status == Status.LOADING,
              hideDeleteButton: verified,
            ),

          ],
        );
      }
    );
  }


  // PAN Text Field & Upload PAN
  Widget _buildPanWidget(){
    return BlocConsumer<KycCubit, KycState>(
        bloc: kycCubit,
        listener: (context, state) {},
        builder: (context, state) {
          bool verified = state.verifiedPan != null && state.verifiedPan!;
        return Column(
          children: [
            // Enter PAN number
            buildTextFieldWithLabelWidget(
              inputFormatters: [
                UpperCaseTextFormatter(),
                PANCardInputFormatter(),
              ],
              maxLength: 10,
                leftText: verified ? "Verified" : "Un-Verified",
                readOnly: verified,
                rightText: "PAN",
                controller: panTextController,
                suffixOnTap: () async {
                  if (panTextController.text.isNotEmpty && panDoc.isNotEmpty) {
                    final Result result = await uploadGSTDocumentApiCall(panDoc);
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
              isLoading: state.uploadPanDocUIState?.status == Status.LOADING,
              hideDeleteButton: verified,
            ),
          ],
        );
      }
    );
  }


  // Multiple Text Field
  Widget  _buildMultipleTextFieldWidget({required String text, required List<Widget> children }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.body1),
        10.height,
        Column(children: children),
      ],
    );
  }


  // Text Field With Label
  Widget buildTextFieldWithLabelWidget({
    int? maxLength,
    required String rightText,
    List<TextInputFormatter>? inputFormatters,
    String? leftText,
    bool readOnly = false,
    FocusNode? currentFocus,
    required TextEditingController controller,
    dynamic Function()? suffixOnTap,
    Color? fillColor
  }) {
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
          maxLength:maxLength ,
          validator: (value) => Validator.fieldRequired(value),
          readOnly: readOnly,
          inputFormatters:inputFormatters,
          currentFocus: currentFocus,
          controller: controller,
          decoration: commonInputDecoration(
              fillColor : fillColor ?? AppColors.white,
              suffixIcon: readOnly
                  ?  0.width
                  : Text("Verify", style: AppTextStyle.h6PrimaryColor),
              suffixOnTap: suffixOnTap ?? (){}
          ),
        ),
      ],
    );
  }


}
