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
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
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
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
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
  final TextEditingController addressNameTextController = TextEditingController();
  final TextEditingController fullAddressTextController = TextEditingController();
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
    addressNameTextController.dispose();
    fullAddressTextController.dispose();
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
    addressNameTextController.clear();
    fullAddressTextController.clear();
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

  bool isValidGSTIN(String gstIn) {
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstRegex.hasMatch(gstIn);
  }

  bool isValidPAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
  }

  bool isValidTAN(String tan) {
    final tanRegex = RegExp(r'^[A-Z]{4}[0-9]{5}[A-Z]{1}$');
    return tanRegex.hasMatch(tan);
  }





  // Upload GST Doc api call
  Future<Result<bool>> uploadGSTDocumentApiCall(List<dynamic> multiFilesList) async {
    await kycCubit.uploadGstDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadGSTDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = kycCubit.state.uploadGSTDocUIState?.data;
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
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
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
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
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
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
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
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
  Future<void> verifyGstApiCall(String gstNumber, BuildContext context) async {
    final apiRequest = VerifyGstApiRequest(gst: gstNumber, force: true);
    await kycCubit.verifyGst(apiRequest);
    if (kycCubit.state.gstState?.status == Status.SUCCESS && context.mounted) {
      ToastMessages.success(message: context.appText.gstVerifiedSuccessfully);
    }
    if (kycCubit.state.gstState?.status == Status.ERROR && context.mounted) {
      ToastMessages.alert(message: context.appText.invalidGSTNumber);
    }
  }


  // Verify TAN api call
  Future<void> verifyTANApiCall(String tanNumber, BuildContext context) async {
    final apiRequest = VerifyTanApiRequest(tan: tanNumber, force: true);
    await kycCubit.verifyTan(apiRequest);
    if (kycCubit.state.tanState?.status == Status.SUCCESS && context.mounted) {
      ToastMessages.success(message: context.appText.tanVerifiedSuccessfully);
    }
    if (kycCubit.state.tanState?.status == Status.ERROR  && context.mounted) {
      ToastMessages.alert(message: context.appText.invalidTANNumber);
    }
  }


  // Verify pan api call
  Future<void> verifyPANApiCall(String panNumber, BuildContext context) async {
    final apiRequest = VerifyPanApiRequest(pan: panNumber, force: true);
    await kycCubit.verifyPan(apiRequest);
    if(!context.mounted) return;
    if (kycCubit.state.panState?.status == Status.SUCCESS) {
      ToastMessages.success(message:  context.appText.tanVerifiedSuccessfully);
    }
    if (kycCubit.state.panState?.status == Status.ERROR) {
      ToastMessages.alert(message: context.appText.invalidTANNumber);
    }
  }


  bool validateDocs({
    required int userRole, // "2" for VP, anything else for LP
    required int companyId, // 1=sole, 2=individual …
    // document lists
    required List gstDoc,
    required List panDoc,
    required List tanDoc,
    required List checkDocLink,
    required List tdsDocLink,
  }) {
    // helper to toast & fail fast
    bool need(String msg, bool ok) {
      if (!ok) ToastMessages.alert(message: '${context.appText.pleaseUpload} $msg');
      return ok;
    }

    // VP FLOW
    if (userRole == 2) {
      if (companyId == 2) {
        return need(context.appText.aadhaar, true) & need(context.appText.cancelledCheque, checkDocLink.isNotEmpty); // always true – already taken on previous screen
      }

      final gstOk  = need(context.appText.gstDocument,   gstDoc.isNotEmpty);
      final panOk  = need(context.appText.panDocument,   panDoc.isNotEmpty);
      final chkOk  = need(context.appText.cancelledCheque, checkDocLink.isNotEmpty);
      final tdsOk  = need(context.appText.tdsCertificate, tdsDocLink.isNotEmpty);
      return gstOk & panOk & chkOk & tdsOk;  // for Sole + Others
    }

    // LP FLOW
    if (companyId == 2) {
      return true; // only Aadhaar needed
    }
    if (companyId == 1) {
      final gstOk = need(context.appText.gstDocument, gstDoc.isNotEmpty);
      final panOk = need(context.appText.panDocument, panDoc.isNotEmpty);
      final tanOk = need(context.appText.tanDocument, tanDoc.isNotEmpty);
      return gstOk & panOk & tanOk; // Aadhaar already present
    }

    // all other company types for LP
    final gstOk = need(context.appText.gstDocument, gstDoc.isNotEmpty);
    final panOk = need(context.appText.panDocument, panDoc.isNotEmpty);
    final tanOk = need(context.appText.tanDocument, tanDoc.isNotEmpty);
    return gstOk & panOk & tanOk;
  }


  // Verify KYC Api Call
  Future verifyKycApiCall() async {
    if(_formKey.currentState!.validate()){

      final ok = validateDocs(
        userRole: kycCubit.userRole ?? 0,
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
        addressName: addressNameTextController.text,
        fullAddress: fullAddressTextController.text,
        pincode: pinCodeTextController.text,
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
        state: selectedState,
        city: selectedCity,
      );
      kycCubit.submitKyc(kycRequest, "${await kycCubit.fetchUserId()}");
    }
  }



  // Navigate to home screen when kyc is done
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.kycSubmittedForVerification,
        heading: context.appText.willGetBackToYouWithin48Hours,
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
                if(lpHomeState.profileDetailUIState?.data?.customer?.companyTypeId != null){
                  companyId  = lpHomeState.profileDetailUIState?.data?.customer?.companyTypeId;
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
                              if(kycCubit.userRole == 2) {
                                return Column(
                                  children: [

                                    //  VP Individual Proprietor id 2
                                    if(companyId == 2)...[
                                      25.height,
                                      _buildAadhaarWidget(context),
                                      25.height,
                                      buildCancelledCheckWidget(),
                                      50.height,
                                    ],


                                    //  VP Sole Proprietor id = 1
                                    if(companyId == 1)...[
                                      _buildAadhaarWidget(context),
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
                                      _buildAadhaarWidget(context),
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
                                      _buildAadhaarWidget(context),
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
                            text: context.appText.primaryAddress,
                            children: [
                              10.height,

                              // Address Name
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: addressNameTextController,
                                mandatoryStar: true,
                                labelText: context.appText.addressName,
                                hintText: context.appText.enterAddressName1,
                              ),
                              20.height,

                              // Full Address
                              AppTextField(
                                validator: (value) => Validator.fieldRequired(value),
                                controller: fullAddressTextController,
                                mandatoryStar: true,
                                labelText: context.appText.fullAddress,
                                hintText: context.appText.enterFullAddress,
                              ),
                              20.height,


                              // State Dropdown
                              BlocConsumer<KycCubit, KycState>(
                                bloc: kycCubit,
                                listenWhen: (previous, current) => previous.stateUIState?.status != current.stateUIState?.status,
                                listener:  (context, state) {
                                  final status = state.stateUIState?.status;
                                  if (status == Status.ERROR) {
                                    final error = state.stateUIState?.errorType;
                                    ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                                  }
                                },
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(context.appText.state.toString().capitalizeFirst, style: AppTextStyle.body3),
                                          Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                        ],
                                      ),
                                      6.height,
                                      DropdownSearch<String>(
                                        validator: (value) => Validator.fieldRequired(value),
                                        key: dropDownStateKey,
                                        items: (String filter, _) async {
                                          final localList = kycCubit.state.stateUIState?.data ?? [];

                                          final localMatches = localList
                                              .where((e) => e.name.toLowerCase().contains(filter.toLowerCase()))
                                              .toList();

                                          if (localMatches.isNotEmpty || filter.trim().isEmpty) {
                                            return localMatches.map((e) => e.name).toList();
                                          } else {
                                            final result = await kycCubit.getFilteredStateList(filter: filter);
                                            if (result is Success<StateModel>) {
                                              final remoteList = result.value.data;
                                              return remoteList.map((e) => e.name).toList();
                                            } else {
                                              return [];
                                            }
                                          }
                                        },
                                        popupProps: PopupProps.modalBottomSheet(
                                          fit: FlexFit.loose,
                                          showSearchBox: true,
                                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                                          emptyBuilder: (context, searchEntry) => Center(child: Text(context.appText.noStateFound)).withHeight(MediaQuery.of(context).size.height * 0.5),
                                          loadingBuilder: (context, searchEntry) => const Center(child: CircularProgressIndicator()),
                                        ),
                                        decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration(hintText: context.appText.selectState)),
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
                                },
                              ),
                              20.height,

                              // CITY DROPDOWN
                              if (selectedState != null)
                                BlocConsumer<KycCubit, KycState>(
                                  bloc: kycCubit,
                                  listenWhen: (previous, current) => previous.cityUIState?.status != current.cityUIState?.status,
                                  listener: (context, state) {
                                    final status = state.cityUIState?.status;
                                    if (status == Status.ERROR) {
                                      final error = state.cityUIState?.errorType;
                                      ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                                    }
                                  },
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(context.appText.city.toString().capitalizeFirst, style: AppTextStyle.body3),
                                            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                          ],
                                        ),
                                        6.height,
                                        DropdownSearch<String>(
                                          validator: (value) => Validator.fieldRequired(value),
                                          key: dropDownCityKey,
                                          items: (String filter, _) async {
                                            final localList = kycCubit.state.cityUIState?.data ?? [];

                                            final localMatches = localList
                                                .where((e) => e.city.toLowerCase().contains(filter.toLowerCase()))
                                                .toList();

                                            if (localMatches.isNotEmpty || filter.trim().isEmpty) {
                                              return localMatches.map((e) => e.city).toList();
                                            } else {
                                              final result = await kycCubit.getFilteredCityList(stateName: selectedState!, filter: filter);
                                              if (result is Success<CityModel>) {
                                                final remoteList = result.value.data;
                                                return remoteList.map((e) => e.city).toList();
                                              } else {
                                                return [];
                                              }
                                            }
                                          },
                                          popupProps: PopupProps.modalBottomSheet(
                                            fit: FlexFit.loose,
                                            showSearchBox: true,
                                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                                            emptyBuilder: (context, searchEntry) => Center(child: Text(context.appText.noCityFound)).withHeight(MediaQuery.of(context).size.height * 0.5),
                                            loadingBuilder: (context, searchEntry) => const Center(child: CircularProgressIndicator()),
                                          ),
                                          decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration(hintText: context.appText.selectCity),
                                          ),
                                          selectedItem: selectedCity,
                                          onChanged: (value) {
                                            selectedCity = value;
                                          },
                                        ),
                                        20.height
                                      ],
                                    );
                                  },
                                )
                              else
                                0.height,

                              AppTextField(
                                validator: (value) => Validator.pincode(value),
                                controller: pinCodeTextController,
                                mandatoryStar: true,
                                labelText: context.appText.pinCode,
                                hintText: context.appText.enterPinCode,
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
                            text: context.appText.bankDetails,
                            children: [
                              10.height,
                              AppTextField(
                                validator: (value) => kycCubit.userRole == 1 ? null : Validator.fieldRequired(value),
                                controller: accountNumberTextController,
                                mandatoryStar: kycCubit.userRole == 1 ? false : true,
                                labelText: context.appText.accountNumber,
                                hintText: context.appText.enterAccountNumber,
                                keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  BankAccountNumberFormatter()
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator: (value) => kycCubit.userRole == 1 ? null : Validator.fieldRequired(value),
                                controller: bankNameTextController,
                                mandatoryStar: kycCubit.userRole == 1 ? false : true,
                                labelText: context.appText.bankName,
                                hintText: context.appText.enterBankName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                                ],
                              ),
                              20.height,

                              AppTextField(
                                  validator: (value) => kycCubit.userRole == 1 ? null : Validator.fieldRequired(value),
                                  controller: branchNameTextController,
                                  mandatoryStar: kycCubit.userRole == 1 ? false : true,
                                  labelText: context.appText.branchName,
                                  hintText: context.appText.enterBranchName,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                                  ],
                              ),
                              20.height,

                              AppTextField(
                                  validator: (value) => kycCubit.userRole == 1 ? null : Validator.fieldRequired(value),
                                  controller: ifscCodeTextController,
                                  mandatoryStar: kycCubit.userRole == 1 ? false : true,
                                  labelText: context.appText.ifscCode,
                                  hintText: context.appText.enterIFSCCode,
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
          if(kycCubit.userRole != null && kycCubit.userRole == 2) {
            return UploadAttachmentFiles(
              title: "${context.appText.cancelledCheque} *",
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
          if(kycCubit.userRole != null && kycCubit.userRole == 2) {
            return UploadAttachmentFiles(
              title: "${context.appText.tdsCertificate} *",
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
            isLoading: state.submitKycState?.status == Status.LOADING,
            onPressed: () async {
              verifyKycApiCall();
            },
          );
        }
    ).bottomNavigationPadding();
  }


  // Aadhaar Text Field
  Widget _buildAadhaarWidget(BuildContext context){
    return buildTextFieldWithLabelWidget(
      readOnly: true,
      rightText: context.appText.aadhaarNumber,
      leftText: context.appText.verified,
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
                leftText: verified ? context.appText.verified : context.appText.unVerified,
                readOnly: verified,
                rightText: "GSTIN",
                controller: gstInTextController,
                suffixOnTap:  state.verifiedGst != null && state.verifiedGst! ? (){} : () async {

                  if(gstInTextController.text.isEmpty){
                    ToastMessages.alert(message: context.appText.pleaseEnterGSTINNumber);
                    return;
                  }

                  if (!isValidGSTIN(gstInTextController.text)) {
                    ToastMessages.alert(message: context.appText.pleaseEnterAValidGSTINNumber);
                    return;
                  }

                  if (gstDoc.isNotEmpty) {
                    final Result result = await uploadGSTDocumentApiCall(gstDoc);
                    if(result is Success) {
                      if(!context.mounted) return;
                      await verifyGstApiCall(gstInTextController.text, context);
                    }
                  }  else {
                    ToastMessages.alert(message: context.appText.verified);
                  }
                }
            ),
            10.height,

            // Upload GST
            UploadAttachmentFiles(
               title: context.appText.uploadGSTDocument,
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
                leftText: verified ? context.appText.verified : context.appText.unVerified,
                readOnly: verified,
                rightText: "TAN",
                controller: tanTextController,
                suffixOnTap: () async {

                  if(tanTextController.text.isEmpty){
                    ToastMessages.alert(message: context.appText.pleaseEnterTAN);
                    return;
                  }

                  if (!isValidTAN(tanTextController.text)) {
                    ToastMessages.alert(message: context.appText.pleaseEnterAValidTANNumber);
                    return;
                  }


                  if (tanTextController.text.isNotEmpty && tanDoc.isNotEmpty) {
                    final Result result = await uploadTanDocumentApiCall(tanDoc);
                    if(result is Success) {
                      if(!context.mounted) return;
                      await verifyTANApiCall(tanTextController.text, context);
                    }
                  } else {
                    ToastMessages.alert(message: context.appText.pleaseEnterTANAndUploadDocument);
                  }
                }
            ),
            10.height,

            // Upload TAN Doc
            UploadAttachmentFiles(
              title: context.appText.uploadTANDocument,
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
                leftText: verified ? context.appText.verified : context.appText.unVerified,
                readOnly: verified,
                rightText: "PAN",
                controller: panTextController,
                suffixOnTap: () async {
                  if(panTextController.text.isEmpty){
                    ToastMessages.alert(message: context.appText.pleaseEnterPAN);
                    return;
                  }
                  if (!isValidPAN(panTextController.text)) {
                    ToastMessages.alert(message: context.appText.pleaseEnterAValidPAN);
                    return;
                  }
                  if (panTextController.text.isNotEmpty && panDoc.isNotEmpty) {
                    final Result result = await uploadGSTDocumentApiCall(panDoc);
                    if(result is Success) {
                      if(!context.mounted) return;
                      await verifyPANApiCall(panTextController.text, context);
                    }
                  } else {
                    ToastMessages.alert(message: context.appText.pleaseEnterPANAndUploadDocument);
                  }
                }
            ),
            10.height,

            // Upload PAN Doc
            UploadAttachmentFiles(
              title: context.appText.uploadPANDocument,
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
                  : Text(context.appText.verify, style: AppTextStyle.h6PrimaryColor),
              suffixOnTap: suffixOnTap ?? (){}
          ),
        ),
      ],
    );
  }


}
