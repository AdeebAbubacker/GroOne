import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/district_autocomplete_textfield.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/state_autocomplete_textfield.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/helper/kyc_helper.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
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
  final String? pdfPath;
  const KycUploadDocumentScreen({super.key, this.aadhaarNumber,this.pdfPath});

  @override
  State<KycUploadDocumentScreen> createState() => _KycUploadDocumentScreenState();
}

class _KycUploadDocumentScreenState extends BaseState<KycUploadDocumentScreen> {

  final _formKey = GlobalKey<FormState>();
  final dropDownStateKey = GlobalKey<DropdownSearchState>();
  final dropDownCityKey = GlobalKey<DropdownSearchState>();

  final kycCubit = locator<KycCubit>();
  final profileCubit = locator<ProfileCubit>();
   final endhancubit = locator<EnDhanCubit>();
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
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final FocusNode gstFocusNode = FocusNode();
  final FocusNode tanFocusNode = FocusNode();
  final FocusNode panFocusNode = FocusNode();

  List<dynamic> gstDoc = [];
  List<dynamic> panDoc = [];
  List<dynamic> tanDoc = [];
  List<dynamic> checkDocLink = [];
  List<dynamic> tdsDocLink = [];
  List<dynamic> tds = [];

  String? uploadLink;
  String? gstDocId;
  String? panDocId;
  String? tdsDocId;
  String? tanDocId;
  String? cancelledChequeDocId;
  String? selectedState;
  String? selectedCity;

  dynamic companyId;
  dynamic kycUserInfo;



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
    await  endhancubit.fetchStates();
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
         gstDoc.first['path'] = url;
        return Success(true);
      }
    }
    if (status == Status.ERROR) {
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
        panDoc.first['path'] = url;
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
      final url = data?.url ?? '';
      if (url.isNotEmpty) {
        checkDocLink.first['path'] = url;
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
      ToastMessages.success(message:  context.appText.panVerifiedSuccessfully);
    }
    if (kycCubit.state.panState?.status == Status.ERROR) {
      ToastMessages.alert(message: context.appText.invalidTANNumber);
    }
  }


// Submit KYC Validation
  bool validateDocs({
    required int userRole, // "2" for VP, anything else for LP
    required int companyId, // 1 = sole, 2 = individual
    required List gstDoc,
    required List panDoc,
    required List tanDoc,
    required List checkDocLink,
    required List tdsDocLink,
  }) {
    bool need(String msg, bool ok) {
      if (!ok) ToastMessages.alert(message: '${context.appText.pleaseUpload} $msg');
      return ok;
    }

    bool checkId(String? id, String label) {
      final ok = id != null;
      if (!ok) ToastMessages.alert(message: '${context.appText.somethingWentWrong} ($label ID)');
      return ok;
    }

    bool gstValid() {
      final uploaded = gstDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedGst ?? false;
      return need(context.appText.gstDocument, uploaded) &
      checkId(gstDocId, "GST") &
      need('${context.appText.gstDocument} ${context.appText.notVerified}', verified);
    }

    bool panValid() {
      final uploaded = panDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedPan ?? false;
      return need(context.appText.panDocument, uploaded) &
      checkId(panDocId, "PAN") &
      need('${context.appText.panDocument} ${context.appText.notVerified}', verified);
    }

    bool tanValid() {
      final uploaded = tanDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedTan ?? false;
      return need(context.appText.tanDocument, uploaded) &
      checkId(tanDocId, "TAN") &
      need('${context.appText.tanDocument} ${context.appText.notVerified}', verified);
    }

    // VP FLOW
    if (userRole != 1) {
      if (companyId == 2) {
        final chkOk = need(context.appText.cancelledCheque, checkDocLink.isNotEmpty) &
        checkId(cancelledChequeDocId, "Cancelled Cheque");
        return need(context.appText.aadhaar, true) & chkOk;
      }

      final gstOk  = gstValid();
      final panOk  = panValid();
      final chkOk  = need(context.appText.cancelledCheque, checkDocLink.isNotEmpty) &
      checkId(cancelledChequeDocId, "Cancelled Cheque");
      final tdsOk  = need(context.appText.tdsCertificate, tdsDocLink.isNotEmpty) &
      checkId(tdsDocId, "TDS");
      return gstOk & panOk & chkOk & tdsOk;
    }

    // LP FLOW
    if (companyId == 2) {
      return true; // Only Aadhaar needed
    }

    if (companyId == 1) {
      final gstOk = gstValid();
      final panOk = panValid();
      final tanOk = tanValid();
      return gstOk & panOk & tanOk;
    }

    final gstOk = gstValid();
    final panOk = panValid();
    final tanOk = tanValid();
    return gstOk & panOk & tanOk;
  }


  // bool validateDocs({
  //   required int userRole, // "2" for VP, anything else for LP
  //   required int companyId, // 1=sole, 2=individual,
  //   // document lists
  //   required List gstDoc,
  //   required List panDoc,
  //   required List tanDoc,
  //   required List checkDocLink,
  //   required List tdsDocLink,
  // }) {
  //   // helper to toast & fail fast
  //   bool need(String msg, bool ok) {
  //     if (!ok) ToastMessages.alert(message: '${context.appText.pleaseUpload} $msg');
  //     return ok;
  //   }
  //
  //   // VP FLOW
  //   if (userRole == 2) {
  //     if (companyId == 2) {
  //       return need(context.appText.aadhaar, true) & need(context.appText.cancelledCheque, checkDocLink.isNotEmpty); // always true – already taken on previous screen
  //     }
  //
  //     final gstOk  = need(context.appText.gstDocument,   gstDoc.isNotEmpty);
  //     final panOk  = need(context.appText.panDocument,   panDoc.isNotEmpty);
  //     final chkOk  = need(context.appText.cancelledCheque, checkDocLink.isNotEmpty);
  //     final tdsOk  = need(context.appText.tdsCertificate, tdsDocLink.isNotEmpty);
  //     return gstOk & panOk & chkOk & tdsOk;  // for Sole + Others
  //   }
  //
  //   // LP FLOW
  //   if (companyId == 2) {
  //     return true; // only Aadhaar needed
  //   }
  //   if (companyId == 1) {
  //     final gstOk = need(context.appText.gstDocument, gstDoc.isNotEmpty);
  //     final panOk = need(context.appText.panDocument, panDoc.isNotEmpty);
  //     final tanOk = need(context.appText.tanDocument, tanDoc.isNotEmpty);
  //     return gstOk & panOk & tanOk; // Aadhaar already present
  //   }
  //
  //   // all other company types for LP
  //   final gstOk = need(context.appText.gstDocument, gstDoc.isNotEmpty);
  //   final panOk = need(context.appText.panDocument, panDoc.isNotEmpty);
  //   final tanOk = need(context.appText.tanDocument, tanDoc.isNotEmpty);
  //   return gstOk & panOk & tanOk;
  // }


  // Verify KYC Api Call
  Future verifyKycApiCall() async {
    debugPrint("cancelledChequeDocId : $cancelledChequeDocId");
    debugPrint("tdsDocId : $tdsDocId");
    debugPrint("gstDocId : $gstDocId");
    debugPrint("panDocId : $panDocId");
    debugPrint("tanDocId : $tanDocId");
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
        addressName: addressNameTextController.text.trim(),
        fullAddress: fullAddressTextController.text.trim(),
        pincode: pinCodeTextController.text,
        bankAccount: accountNumberTextController.text,
        bankName: bankNameTextController.text.trim(),
        branchName: branchNameTextController.text.trim(),
        chequeDocLink: cancelledChequeDocId ?? "",
        tdsDocLink: tdsDocId ?? "",
        gstin: gstInTextController.text,
        gstinDocLink: gstDocId ?? "",
        ifscCode: ifscCodeTextController.text,
        isAadhar: true,
        isGstin: kycCubit.state.verifiedGst,
        isPan:  kycCubit.state.verifiedPan,
        isTan:  kycCubit.state.verifiedTan,
        pan: panTextController.text,
        panDocLink:  panDocId ?? "",
        tan: tanTextController.text,
        tanDocLink: tanDocId ?? "",
        state: selectedState,
        city: selectedCity,
      );
      kycUserInfo = kycRequest.toJson();
      kycCubit.submitKyc(kycRequest, "${await kycCubit.fetchUserId()}");
    }
  }


  // Create Document Api Call
  Future<Result<bool>> createDocumentApiCall(CreateDocumentApiRequest request) async {
    await kycCubit.createDocument(request);
    final status = kycCubit.state.createDocumentUIState?.status;
    if (status == Status.SUCCESS) {
      return Success(true);
    }
    if (status == Status.ERROR) {
      final error = kycCubit.state.createDocumentUIState?.errorType;
      return Error(error ?? GenericError());
    }
    return Error(GenericError());
  }



  // Navigate to home screen when kyc is done
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.kycSubmittedForVerification,
        heading: context.appText.willGetBackToYouWithin48Hours,
        onContinue: (){
          analyticsHelper.logEvent(AnalyticEventName.KYC_FORM_SUBMITTED, kycUserInfo);
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
                final userRole = kycCubit.userRole;
                final isVP = userRole == 2 || userRole == 3 || userRole == 4;
                final isLP = userRole == 1 || userRole == 3;
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Builder(
                            builder: (context) {

                              if (userRole == null) {
                                return SizedBox();
                              }

                              CustomLog.debug(this, "User Role: $userRole");

                              List<Widget> children = [];

                              if (companyId == 1) {
                                children.addAll([
                                  _buildAadhaarWidget(context),
                                  25.height,
                                  _buildGstWidget(),
                                  25.height,
                                  _buildPanWidget(),
                                  25.height,
                                  if (isVP) ...[
                                    buildCancelledCheckWidget(),
                                    25.height,
                                    buildTDSCertificationWidget(),
                                  ],
                                  if (isLP) ...[
                                    25.height,
                                   _buildTanWidget(),
                                  ],
                                  50.height,
                                ]);
                              } else if (companyId == 2) {
                                children.addAll([
                                  25.height,
                                  _buildAadhaarWidget(context),
                                  25.height,
                                  if (isVP)
                                    ...[
                                      buildCancelledCheckWidget(),
                                      50.height,
                                    ]
                                ]);
                              } else {
                                children.addAll([
                                  _buildGstWidget(),
                                  25.height,
                                  _buildPanWidget(),
                                  25.height,
                                  if (isLP)
                                    ...[
                                      _buildTanWidget(),
                                      25.height,
                                    ],
                                  if (isVP)
                                    ...[
                                      buildTDSCertificationWidget(),
                                      25.height,
                                      buildCancelledCheckWidget(),
                                      50.height,
                                    ]
                                ]);
                              }

                              return Column(children: children);
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
                           16.height,
                         // State Dropdown
                         BlocBuilder<EnDhanCubit, EnDhanState>(
                          bloc: endhancubit,
                             builder: (context, state) {
                              return Column(children: [
                                 StateAutoCompleteTextField(
                                controller: stateController,
                                labelText: '${context.appText.state} *',
                                onSelected: (value) {
                                  // The widget will handle setting the text
                                },
                                onStateSelected: (stateId) {
                                  endhancubit.setSelectedStateId(stateId);
                                  endhancubit.fetchDistricts(stateId);
                                  // Clear district selection when state changes
                                  districtController.clear();
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return context.appText.pleaseSelectState;
                                  }
                                  return null;
                                },
                              ),
                               16.height,
                               // District Dropdown
                          DistrictAutoCompleteTextField(
                            controller: districtController,
                            labelText: '${context.appText.district} *',
                            stateId: state.selectedStateId,
                            onSelected: (value) {
                              // The widget will handle setting the text
                            },
                            onDistrictSelected: (districtId) {
                              endhancubit.setSelectedDistrictId(districtId);
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select a district';
                              }
                              return null;
                            },
                          ),

                              ],);


                            }
                          ),
                          16.height,


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
                                validator: (value) => isVP ? Validator.fieldRequired(value) : null,
                                controller: accountNumberTextController,
                                mandatoryStar: isVP,
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
                                validator: (value) => isVP ? Validator.fieldRequired(value) : null,
                                controller: bankNameTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.bankName,
                                hintText: context.appText.enterBankName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator: (value) => isVP ? Validator.fieldRequired(value) : null,
                                controller: branchNameTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.branchName,
                                hintText: context.appText.enterBranchName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                  UpperCaseTextFormatter()
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator: (value) =>  isVP ? Validator.fieldRequired(value) : null,
                                controller: ifscCodeTextController,
                                mandatoryStar: isVP,
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


  // GST Text Field & Upload GST
  Widget _buildGstWidget(){
    return BlocBuilder<KycCubit, KycState>(
        bloc: kycCubit,
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
                    if (gstDoc.isEmpty) {
                      ToastMessages.alert(message: context.appText.uploadGSTDocument);
                      return;
                    }
                    if(!context.mounted) return;
                    await verifyGstApiCall(gstInTextController.text, context);
                  }
              ),
              10.height,

              // Upload GST
              UploadAttachmentFiles(
                title: context.appText.uploadGSTDocument,
                multiFilesList: gstDoc,
                isSingleFile: true,
                isLoading: state.uploadGSTDocUIState?.status == Status.LOADING,
                hideDeleteButton: verified,
                allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
                thenUploadFileToSever: () async {
                  final Result result = await uploadGSTDocumentApiCall(gstDoc);
                  if(result is Success) {
                    final gstData = kycCubit.state.uploadGSTDocUIState?.data;
                    if(gstData != null &&  gstDoc.isNotEmpty){
                      final apiRequest =  CreateDocumentApiRequest(
                        documentTypeId : KycHelper.getDocumentTypeId(KycDocType.gstin),
                        title : KycHelper.getMeta(KycDocType.gstin).title,
                        description : KycHelper.getMeta(KycDocType.gstin).description,
                        originalFilename : gstData.originalName,
                        filePath : gstData.filePath,
                        fileSize : gstData.size,
                        mimeType : KycHelper.getMimeTypeFromExtension(gstDoc.first['extension']),
                        fileExtension : gstDoc.first['extension'],
                      );
                      await createDocumentApiCall(apiRequest);
                      if(kycCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                        if(kycCubit.state.createDocumentUIState?.data != null && kycCubit.state.createDocumentUIState?.data?.data != null){
                          gstDocId = kycCubit.state.createDocumentUIState!.data!.data!.documentId;
                        }
                      }
                      debugPrint("gstDocId : $gstDocId");
                    }
                  }
                },
                onDelete: (index) async {
                  if(gstDocId == null){
                    ToastMessages.alert(message: "Something went wrong, while delete this document");
                    return;
                  }
                  await kycCubit.deleteDocument(gstDocId ?? "").then((onValue){
                    gstDoc.clear();
                    gstDocId = null;
                    debugPrint("gstDocId : $gstDocId");
                  });
                },
              ),
            ],
          );
        }
    );
  }


  // TAN Text Field & Upload TAN
  Widget _buildTanWidget(){
    return BlocBuilder<KycCubit, KycState>(
        bloc: kycCubit,
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
                    if(tanDoc.isEmpty){
                      ToastMessages.alert(message: context.appText.uploadTANDocument);
                      return;
                    }
                    if (!isValidTAN(tanTextController.text)) {
                      ToastMessages.alert(message: context.appText.pleaseEnterAValidTANNumber);
                      return;
                    }
                    if(!context.mounted) return;
                    await verifyTANApiCall(tanTextController.text, context);
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
                thenUploadFileToSever: () async {
                  final Result result = await uploadTanDocumentApiCall(tanDoc);
                  if(result is Success) {
                    if(kycCubit.state.uploadTanDocUIState?.status == Status.SUCCESS){
                      final data = kycCubit.state.uploadTanDocUIState?.data;
                      if(data != null &&  tanDoc.isNotEmpty){
                        final apiRequest = CreateDocumentApiRequest(
                          documentTypeId : KycHelper.getDocumentTypeId(KycDocType.tan),
                          title : KycHelper.getMeta(KycDocType.tan).title,
                          description : KycHelper.getMeta(KycDocType.tan).description,
                          originalFilename : data.originalName,
                          filePath : data.filePath,
                          fileSize : data.size,
                          mimeType : KycHelper.getMimeTypeFromExtension(tanDoc.first['extension']),
                          fileExtension : tanDoc.first['extension'],
                        );
                        await createDocumentApiCall(apiRequest);
                        if(kycCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                          if(kycCubit.state.createDocumentUIState?.data != null && kycCubit.state.createDocumentUIState?.data?.data != null){
                            tanDocId = kycCubit.state.createDocumentUIState!.data!.data!.documentId;
                          }
                        }
                        debugPrint("tanDocId : $tanDocId");
                      }
                    }
                  }
                },
                onDelete: (index) async {
                  if(tanDocId == null){
                    ToastMessages.alert(message: "Something went wrong, while delete this document");
                    return;
                  }
                  await kycCubit.deleteDocument(tanDocId ?? "").then((onValue){
                    tanDoc.clear();
                    tanDocId = null;
                    debugPrint("tanDocId : $tanDocId");
                  });
                },
              ),

            ],
          );
        }
    );
  }


  // PAN Text Field & Upload PAN
  Widget _buildPanWidget(){
    return BlocBuilder<KycCubit, KycState>(
        bloc: kycCubit,
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
                    if(panDoc.isEmpty){
                      ToastMessages.alert(message: context.appText.uploadPANDocument);
                      return;
                    }
                    if(!context.mounted) return;
                    await verifyPANApiCall(panTextController.text, context);
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
                thenUploadFileToSever: () async {
                  final Result result = await uploadPanDocumentApiCall(panDoc);
                  if(result is Success) {
                    if(kycCubit.state.uploadPanDocUIState?.status == Status.SUCCESS){
                      final data = kycCubit.state.uploadPanDocUIState?.data;
                      if(data != null &&  panDoc.isNotEmpty){
                        final apiRequest = CreateDocumentApiRequest(
                          documentTypeId : KycHelper.getDocumentTypeId(KycDocType.pan),
                          title : KycHelper.getMeta(KycDocType.pan).title,
                          description : KycHelper.getMeta(KycDocType.pan).description,
                          originalFilename : data.originalName,
                          filePath : data.filePath,
                          fileSize : data.size,
                          mimeType : KycHelper.getMimeTypeFromExtension(panDoc.first['extension']),
                          fileExtension : panDoc.first['extension'],
                        );
                        await createDocumentApiCall(apiRequest);
                        if(kycCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                          if(kycCubit.state.createDocumentUIState?.data != null && kycCubit.state.createDocumentUIState?.data?.data != null){
                            panDocId = kycCubit.state.createDocumentUIState!.data!.data!.documentId;
                          }
                        }
                        debugPrint("panDocId : $panDocId");
                      }
                    }
                  }
                },
                onDelete: (index) async {
                  if(panDocId == null){
                    ToastMessages.alert(message: "Something went wrong, while delete this document");
                    return;
                  }
                  await kycCubit.deleteDocument(panDocId ?? "").then((onValue){
                    panDoc.clear();
                    panDocId = null;
                    debugPrint("panDocId : $panDocId");
                  });

                },
              ),
            ],
          );
        }
    );
  }


  // Upload Cancelled Check
  Widget buildCancelledCheckWidget(){
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
        builder: (context, state) {
          final cancelledCheckUploadState = state.uploadCancelledUIState?.status;
          if(kycCubit.userRole != null && kycCubit.userRole != 1) {
            return UploadAttachmentFiles(
              title: "${context.appText.cancelledCheque} *",
              multiFilesList: checkDocLink,
              isSingleFile: true,
              isLoading: cancelledCheckUploadState == Status.LOADING,
              thenUploadFileToSever: () async {
                final Result result = await uploadCancelledChequeDocumentApiCall(checkDocLink);
                if(result is Success) {
                  if(kycCubit.state.uploadCancelledUIState?.status == Status.SUCCESS){
                    final data = kycCubit.state.uploadCancelledUIState?.data;
                    if(data != null &&  checkDocLink.isNotEmpty){
                      final apiRequest = CreateDocumentApiRequest(
                        documentTypeId : KycHelper.getDocumentTypeId(KycDocType.cheque),
                        title : KycHelper.getMeta(KycDocType.cheque).title,
                        description : KycHelper.getMeta(KycDocType.cheque).description,
                        originalFilename : data.originalName,
                        filePath : data.filePath,
                        fileSize : data.size,
                        mimeType : KycHelper.getMimeTypeFromExtension(checkDocLink.first['extension']),
                        fileExtension : checkDocLink.first['extension'],
                      );
                     await  createDocumentApiCall(apiRequest);
                      if(kycCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                        if(kycCubit.state.createDocumentUIState?.data != null && kycCubit.state.createDocumentUIState?.data?.data != null){
                          cancelledChequeDocId = kycCubit.state.createDocumentUIState!.data!.data!.documentId;
                        }
                      }
                      debugPrint("cancelledChequeDocId : $cancelledChequeDocId");
                    }
                  }
                }
              },
              onDelete: (index) async {
                if(cancelledChequeDocId == null){
                  ToastMessages.alert(message: "Something went wrong, while delete this document");
                  return;
                }
                await kycCubit.deleteDocument(cancelledChequeDocId ?? "").then((onValue){
                  checkDocLink.clear();
                  cancelledChequeDocId = null;
                  debugPrint("cancelledChequeDocId : $cancelledChequeDocId");
                });
              },
            );
          } else {
            return Container();
          }
        },
    );
  }


  // Upload Tds
  Widget buildTDSCertificationWidget(){
    return  BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
          final tdsUploadState = state.uploadTDSDocUIState?.status;
          if(kycCubit.userRole != null && kycCubit.userRole != 1) {
            return UploadAttachmentFiles(
              title: "${context.appText.tdsCertificate} *",
              multiFilesList: tdsDocLink,
              isSingleFile: true,
              isLoading: tdsUploadState == Status.LOADING,
              thenUploadFileToSever: () async {
                final Result result = await uploadTdsDocumentApiCall(tdsDocLink);
                if(result is Success) {
                  if(kycCubit.state.uploadTDSDocUIState?.status == Status.SUCCESS){
                    final data = kycCubit.state.uploadTDSDocUIState?.data;
                    if(data != null &&  tdsDocLink.isNotEmpty){
                      final apiRequest = CreateDocumentApiRequest(
                        documentTypeId : KycHelper.getDocumentTypeId(KycDocType.tds),
                        title : KycHelper.getMeta(KycDocType.tds).title,
                        description : KycHelper.getMeta(KycDocType.tds).description,
                        originalFilename : data.originalName,
                        filePath : data.filePath,
                        fileSize : data.size,
                        mimeType : KycHelper.getMimeTypeFromExtension(tdsDocLink.first['extension']),
                        fileExtension : tdsDocLink.first['extension'],
                      );
                     await createDocumentApiCall(apiRequest);
                      if(kycCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                        if(kycCubit.state.createDocumentUIState?.data != null && kycCubit.state.createDocumentUIState?.data?.data != null){
                          tdsDocId = kycCubit.state.createDocumentUIState!.data!.data!.documentId;
                        }
                      }
                      debugPrint("tdsDocId : $tdsDocId");
                    }
                  }
                }
              },
              onDelete: (index) async {
                if(tdsDocId == null){
                  ToastMessages.alert(message: "Something went wrong, while delete this document");
                  return;
                }
                await kycCubit.deleteDocument(tdsDocId ?? "").then((onValue){
                  tdsDocLink.clear();
                  tdsDocId = null;
                  debugPrint("tdsDocId : $tdsDocId");
                });
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
