import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/helper/kyc_helper.dart';
import 'package:gro_one_app/features/kyc/model/upload_aadhhar_document_model.dart';
import 'package:gro_one_app/features/master/widget/master_address_tab.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_string.dart';
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
import 'package:gro_one_app/utils/textFieldInputFormatter/remove_space_inpur_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/tan_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/upper_case_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';

class KycUploadDocumentScreen extends StatefulWidget {
  final String? aadhaarNumber;
  final String? pdfPath;
  const KycUploadDocumentScreen({super.key, this.aadhaarNumber, this.pdfPath});

  @override
  State<KycUploadDocumentScreen> createState() =>
      _KycUploadDocumentScreenState();
}

class _KycUploadDocumentScreenState extends BaseState<KycUploadDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final dropDownStateKey = GlobalKey<DropdownSearchState>();
  final dropDownCityKey = GlobalKey<DropdownSearchState>();

  final kycCubit = locator<KycCubit>();
  final profileCubit = locator<ProfileCubit>();
  final documentCubit = locator<DocumentTypeCubit>();
  final endhancubit = locator<EnDhanCubit>();
  final securePrefs = locator<SecuredSharedPreferences>();
  final TextEditingController aadhaarNumberTextController =
      TextEditingController();
  final TextEditingController gstInTextController = TextEditingController();
  final TextEditingController tanTextController = TextEditingController();
  final TextEditingController panTextController = TextEditingController();
  final TextEditingController addressNameTextController =
      TextEditingController();
  final TextEditingController fullAddressTextController =
      TextEditingController();
  final TextEditingController addressLine3TextController =
      TextEditingController();
  final TextEditingController pinCodeTextController = TextEditingController();
  final TextEditingController accountNumberTextController =
      TextEditingController();
  final TextEditingController bankNameTextController = TextEditingController();
  final TextEditingController branchNameTextController =
      TextEditingController();
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
  String? aadharDocId;
  String? panDocId;
  String? tdsDocId;
  String? tanDocId;
  String? cancelledChequeDocId;
  String? selectedState;
  String? selectedCity;
  String? selectedStateData;
  dynamic companyId;
  dynamic kycUserInfo;


  String? selectedCityID;

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
    getKycDetailsFromLocal();
    getKycVerified();
    getAllDocs();

    await kycCubit.fetchUserRole();
    await kycCubit.fetchUserId();
    await kycCubit.fetchCompanyTypeId();
    await kycCubit.fetchStateList();
    await endhancubit.fetchStates();
    if (widget.aadhaarNumber != null) {
      aadhaarNumberTextController.text = widget.aadhaarNumber!;
    } else {
      aadhaarNumberTextController.text = "";
    }
    uploadAadharDocument();
  });

  void getKycDetailsFromLocal() => frameCallback(() async {
    gstInTextController.text =
        await securePrefs.get(AppString.sessionKey.gtsinNumber) ?? "";

    tanTextController.text =
        await securePrefs.get(AppString.sessionKey.tanNumber) ?? "";
    panTextController.text =
        await securePrefs.get(AppString.sessionKey.panNumber) ?? "";
  });

  // set gst
  void setGstNumberIntoLocal(String gstNumber) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.gtsinNumber, gstNumber);
  });
  // Set Pan Number
  void setPanIntoLocal(String panNumber) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.panNumber, panNumber);
  });

  // Set Tan Number
  void setTanIntoLocal(String tanNumber) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.tanNumber, tanNumber);
  });

  // set gst doc and url
  void setGstDocIDAndUrl(String url, String docID) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.gstDocUrl, url);
    securePrefs.saveKey(AppString.sessionKey.gstDocID, docID);
  });

  // set pan doc and url
  void setPanDocAndUrl(String url, String docId) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.panDocUrl, url);
    securePrefs.saveKey(AppString.sessionKey.panDocId, docId);
  });

  // set tan doc and url
  void setTanDocAndUrl(String url, String docID) => frameCallback(() async {
    securePrefs.saveKey(AppString.sessionKey.tanDocUrl, url);
    securePrefs.saveKey(AppString.sessionKey.tanDocID, docID);
  });

  // get all from local
  Future getAllDocs() async {
    final gstDocUrl = await securePrefs.get(AppString.sessionKey.gstDocUrl);
    final gstDocIDLocal = await securePrefs.get(AppString.sessionKey.gstDocID);

    final panDocUrl = await securePrefs.get(AppString.sessionKey.panDocUrl);
    final panDocIDLocal = await securePrefs.get(AppString.sessionKey.panDocId);

    final tanDocUrl = await securePrefs.get(AppString.sessionKey.tanDocUrl);
    final tanDocIDLocal = await securePrefs.get(AppString.sessionKey.tanDocID);

    if ((gstDocUrl ?? "").isNotEmpty) gstDoc = [jsonDecode(gstDocUrl!)];
    if ((panDocUrl ?? "").isNotEmpty) panDoc = [jsonDecode(panDocUrl!)];
    if ((tanDocUrl ?? "").isNotEmpty) tanDoc = [jsonDecode(tanDocUrl!)];

    if ((gstDocIDLocal ?? "").isNotEmpty) gstDocId = gstDocIDLocal;
    if ((panDocIDLocal ?? "").isNotEmpty) panDocId = panDocIDLocal;
    if ((tanDocIDLocal ?? "").isNotEmpty) tanDocId = tanDocIDLocal;
  }

  // check from local
  void getKycVerified() {
    kycCubit.checkIsKycNumberVerified(securePrefs);
  }

  void disposeFunction() => frameCallback(() {
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

  void uploadAadharDocument() => frameCallback(() async {
    if (widget.pdfPath == null && (widget.pdfPath ?? "").isEmpty) {
      return;
    }
    await kycCubit.uploadAadharDoc(File(widget.pdfPath ?? ""));
    final status = kycCubit.state.uploadAadharDocumentModel?.status;
    UploadAadharDocumentModel? uploadAadharDocumentModel =
        kycCubit.state.uploadAadharDocumentModel?.data;
    if (status != null && status == Status.SUCCESS) {
      final apiRequest = CreateDocumentApiRequest(
        documentTypeId: await KycHelper.getDocumentTypeId(
          KycDocType.aadharCard,
          documentCubit,
        ),
        title: KycHelper.getMeta(KycDocType.aadharCard).title,
        description: KycHelper.getMeta(KycDocType.aadharCard).description,
        originalFilename: uploadAadharDocumentModel?.originalName,
        filePath: uploadAadharDocumentModel?.filePath,
        fileSize: uploadAadharDocumentModel?.size,
        mimeType: KycHelper.getMimeTypeFromExtension(
          uploadAadharDocumentModel?.filePath.split(".").last ?? "",
        ),
        fileExtension: uploadAadharDocumentModel?.filePath.split(".").last,
      );
      await createDocumentApiCall(apiRequest);
      if (kycCubit.state.createDocumentUIState?.status == Status.SUCCESS) {
        if (kycCubit.state.createDocumentUIState?.data != null &&
            kycCubit.state.createDocumentUIState?.data?.data != null) {
          aadharDocId =
              kycCubit.state.createDocumentUIState!.data!.data!.documentId;
        }
      }
    }
  });

  // Clear All Values
  void clearAllFormValues() => frameCallback(() {
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
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );
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
  Future<Result<bool>> uploadGSTDocumentApiCall(
    List<dynamic> multiFilesList,
  ) async {
    await kycCubit.uploadGstDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadGSTDocUIState?.status;
    if (status != null && status == Status.SUCCESS) {
      final data = kycCubit.state.uploadGSTDocUIState?.data;
      final url = data?.url ?? '';
      if (url.isNotEmpty) {
        gstDoc.first['path'] = url;
        return Success(true);
      }
    }
    if (status == Status.ERROR) {
      final errorType = kycCubit.state.uploadGSTDocUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  // Upload Pan Doc api call
  Future<Result<bool>> uploadPanDocumentApiCall(
    List<dynamic> multiFilesList,
  ) async {
    await kycCubit.uploadPanDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadPanDocUIState?.status;
    if (status != null && status == Status.SUCCESS) {
      final data = kycCubit.state.uploadPanDocUIState?.data;
      final url = data?.url ?? '';
      if (url.isNotEmpty) {
        panDoc.first['path'] = url;
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadPanDocUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  // Upload TAN Doc api call
  Future<Result<bool>> uploadTanDocumentApiCall(
    List<dynamic> multiFilesList,
  ) async {
    await kycCubit.uploadTanDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadTanDocUIState?.status;
    if (status != null && status == Status.SUCCESS) {
      final data = kycCubit.state.uploadTanDocUIState?.data;
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadTanDocUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  // Upload TDS Doc api call
  Future<Result<bool>> uploadTdsDocumentApiCall(
    List<dynamic> multiFilesList,
  ) async {
    await kycCubit.uploadTdsDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadTDSDocUIState?.status;
    if (status != null && status == Status.SUCCESS) {
      final data = kycCubit.state.uploadTDSDocUIState?.data;
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadTDSDocUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  // Upload Pan Doc api call
  Future<Result<bool>> uploadCancelledChequeDocumentApiCall(
    List<dynamic> multiFilesList,
  ) async {
    await kycCubit.uploadCancelledCheckDoc(File(multiFilesList.first['path']));
    final status = kycCubit.state.uploadCancelledUIState?.status;
    if (status != null && status == Status.SUCCESS) {
      final data = kycCubit.state.uploadCancelledUIState?.data;
      final url = data?.url ?? '';
      if (url.isNotEmpty) {
        checkDocLink.first['path'] = url;
        return Success(true);
      }
    }
    if (status != null && status == Status.ERROR) {
      final errorType = kycCubit.state.uploadCancelledUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  // Verify GST api call
  Future<void> verifyGstApiCall(String gstNumber, BuildContext context) async {
    final apiRequest = VerifyGstApiRequest(gst: gstNumber, force: true);

    await kycCubit.verifyGst(apiRequest, securePrefs);
    if (kycCubit.state.gstState?.status == Status.SUCCESS && context.mounted) {
      await kycCubit.verifyGstDocExistence(gstNumber);
    }

    if (kycCubit.state.gstDocVerificationState?.status == Status.SUCCESS) {
      kycCubit.updateGstVerificationState();
      ToastMessages.success(message: context.appText.gstVerifiedSuccessfully);
    }

    if (kycCubit.state.gstDocVerificationState?.status == Status.ERROR) {
      final error = kycCubit.state.gstDocVerificationState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }

    if (kycCubit.state.gstState?.status == Status.ERROR && context.mounted) {
      final error = kycCubit.state.gstState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }
  }

  // Verify TAN api call
  Future<void> verifyTANApiCall(String tanNumber, BuildContext context) async {
    final apiRequest = VerifyTanApiRequest(tan: tanNumber, force: true);
    await kycCubit.verifyTan(apiRequest);
    if (kycCubit.state.tanState?.status == Status.SUCCESS && context.mounted) {
      await kycCubit.verifyTanExistence(tanNumber);
    }

    if (kycCubit.state.tanDocVerificationState?.status == Status.SUCCESS) {
      kycCubit.updateTanVerificationState();
      ToastMessages.success(message: context.appText.tanVerifiedSuccessfully);
      securePrefs.saveBoolean(AppString.sessionKey.isTanNumberVerified, true);
    }

    if (kycCubit.state.tanDocVerificationState?.status == Status.ERROR) {
      final error = kycCubit.state.tanDocVerificationState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }

    if (kycCubit.state.tanState?.status == Status.ERROR && context.mounted) {
      final error = kycCubit.state.tanState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }
  }

  // Verify pan api call
  Future<void> verifyPANApiCall(String panNumber, BuildContext context) async {
    final apiRequest = VerifyPanApiRequest(pan: panNumber, force: true);
    await kycCubit.verifyPan(apiRequest);

    if (!context.mounted) return;
    if (kycCubit.state.panState?.status == Status.SUCCESS) {
      await kycCubit.verifyPanExistence(panNumber);
    }

    if (kycCubit.state.panDocVerificationState?.status == Status.SUCCESS) {
      kycCubit.updatePanVerificationState();
      ToastMessages.success(message: context.appText.panVerifiedSuccessfully);
      securePrefs.saveBoolean(AppString.sessionKey.isPanNumberVerified, true);
    }

    if (kycCubit.state.panDocVerificationState?.status == Status.ERROR) {
      final error = kycCubit.state.panDocVerificationState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }

    if (kycCubit.state.panState?.status == Status.ERROR) {
      final error = kycCubit.state.panState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
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
      if (!ok) {
        ToastMessages.alert(message: '${context.appText.pleaseUpload} $msg');
      }

      return ok;
    }

    bool checkId(String? id, String label) {
      final ok = id != null;
      if (!ok) {
        ToastMessages.alert(message: context.appText.errorMessage);
      }
      return ok;
    }

    bool gstValid() {
      if(companyId==1){
        return true;
      }

      final uploaded = gstDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedGst ?? false;
      return need(context.appText.gstDocument, uploaded) &&
          checkId(gstDocId, "GST") &
              need(
                '${context.appText.gstDocument} ${context.appText.notVerified}',
                verified,
              );
    }

    bool panValid() {
      final uploaded = panDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedPan ?? false;
      return need(context.appText.panDocument, uploaded) &&
          checkId(panDocId, "PAN") &
              need(
                '${context.appText.panDocument} ${context.appText.notVerified}',
                verified,
              );
    }

    bool tanValid() {
      /*    final uploaded = tanDoc.isNotEmpty;
      final verified = kycCubit.state.verifiedTan ?? false;
      return need(context.appText.tanDocument, uploaded) &&
          checkId(tanDocId, "TAN") &
          need(
            '${context.appText.tanDocument} ${context.appText.notVerified}',
            verified,
          );*/
      return true;
    }

    // VP FLOW
    if (userRole != 1) {
      if (companyId == 2) {
        final chkOk =
            need(context.appText.cancelledCheque, checkDocLink.isNotEmpty) &&
            checkId(cancelledChequeDocId, "Cancelled Cheque");
        return need(context.appText.aadhaar, true) && chkOk;
      }

      final gstOk = gstValid();
      final panOk = panValid();

      final chkOk =
          need(context.appText.cancelledCheque, checkDocLink.isNotEmpty) &&
          checkId(cancelledChequeDocId, "Cancelled Cheque");
      final tdsOk =
          need(context.appText.tdsCertificate, tdsDocLink.isNotEmpty) &&
          checkId(tdsDocId, "TDS");

      return gstOk && panOk && chkOk && tdsOk;
    }

    // LP FLOW
    if (companyId == 2) {
      return true; // Only Aadhaar needed
    }

    if (companyId == 1) {
      final gstOk = gstValid();
      final panOk = panValid();
      final tanOk = tanValid();
      return gstOk && panOk && tanOk;
    }

    final gstOk = gstValid();
    final panOk = panValid();
    final tanOk = tanValid();
    return gstOk && panOk && tanOk;
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
    if (_formKey.currentState!.validate()) {
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

      /// TODO:
      /// check if state is selected
      //add code for state and city required

      if (selectedState == null && (selectedState ?? "").isEmpty) {
        ToastMessages.error(message: context.appText.stateRequired);
        return;
      }

      if (selectedCity == null && (selectedCity ?? "").isEmpty) {
        ToastMessages.error(message: context.appText.cityRequired);
        return;
      }

      final kycRequest = SubmitKycApiRequest(
        adharDocLink: aadharDocId,
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
        isPan: kycCubit.state.verifiedPan,
        isTan: kycCubit.state.verifiedTan,
        pan: panTextController.text,
        panDocLink: panDocId ?? "",
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
  Future<Result<bool>> createDocumentApiCall(
    CreateDocumentApiRequest request,
  ) async {
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
        onContinue: () {
          analyticsHelper.logEvent(
            AnalyticEventName.KYC_FORM_SUBMITTED,
            kycUserInfo,
          );
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
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        title: context.appText.uploadDocument,
      ),
      body: _buildBodyWidget(),
    );
  }

  // Build Body
  Widget _buildBodyWidget() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: BlocConsumer<KycCubit, KycState>(
          bloc: kycCubit,
          listener: (context, state) {},
          builder: (context, kycState) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              buildWhen: (previous, current) {
                return previous != current;
              },
              builder: (context, lpHomeState) {
                if (lpHomeState
                        .profileDetailUIState
                        ?.data
                        ?.customer
                        ?.companyTypeId !=
                    null) {
                  companyId =
                      lpHomeState
                          .profileDetailUIState
                          ?.data
                          ?.customer
                          ?.companyTypeId;
                } else {
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
                                  if (isLP) ...[25.height, _buildTanWidget()],
                                  50.height,
                                ]);
                              } else if (companyId == 2) {
                                children.addAll([
                                  25.height,
                                  _buildAadhaarWidget(context),
                                  25.height,
                                  if (isVP) ...[
                                    buildCancelledCheckWidget(),
                                    50.height,
                                  ],
                                ]);
                              } else {
                                children.addAll([
                                  _buildGstWidget(),
                                  25.height,
                                  _buildPanWidget(),
                                  25.height,
                                  if (isLP) ...[_buildTanWidget(), 25.height],
                                  if (isVP) ...[
                                    buildTDSCertificationWidget(),
                                    25.height,
                                    buildCancelledCheckWidget(),
                                    50.height,
                                  ],
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
                                validator:
                                    (value) => Validator.fieldRequired(value),
                                controller: addressNameTextController,
                                mandatoryStar: true,
                                labelText: context.appText.addressName,
                                inputFormatters: [
                                  NoLeadingSpaceFormatter(),
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                hintText: context.appText.enterAddressName1,
                              ),
                              20.height,

                              // Full Address
                              AppTextField(
                                validator:
                                    (value) => Validator.fieldRequired(value),
                                controller: fullAddressTextController,
                                mandatoryStar: true,
                                labelText: context.appText.fullAddress,
                                hintText: context.appText.enterFullAddress,
                                inputFormatters: [
                                  NoLeadingSpaceFormatter(),
                                  LengthLimitingTextInputFormatter(100),
                                ],
                              ),
                              16.height,
                              FormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.appText.stateisRequired;
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StateDropdown(
                                        selectedStateId: selectedState,
                                        onStateChanged: (value) {
                                          setState(() {
                                            selectedStateData =
                                                value?.name.toString();
                                            selectedState =
                                                value?.name.toString();
                                            selectedCity = null;
                                          });
                                          field.didChange(
                                            value?.name.isNotEmpty == true
                                                ? value?.name
                                                : null,
                                          );
                                        },
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            left: 8,
                                          ),
                                          child: Text(
                                            field.errorText!,
                                            style:
                                                AppTextStyle
                                                    .textFieldHintRedColor,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              16.height,
                              FormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.appText.cityisRequired;
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CityDropdown(
                                        selectedState: selectedStateData,
                                        selectedCityId: selectedCityID,
                                        isStateSelected:
                                            selectedState != null &&
                                            selectedState!.isNotEmpty,
                                        onCityChanged: (value) {
                                          setState(() {
                                            selectedCity =
                                                value?.city.toString();
                                            selectedCityID =
                                                value?.id.toString();
                                          });
                                          field.didChange(
                                            value?.city.isNotEmpty == true
                                                ? value?.city
                                                : null,
                                          );
                                        },
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            left: 8,
                                          ),
                                          child: Text(
                                            field.errorText!,
                                            style:
                                                AppTextStyle
                                                    .textFieldHintRedColor,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              16.height,
                              AppTextField(
                                validator: (value) => Validator.pincode(value),
                                controller: pinCodeTextController,
                                mandatoryStar: true,
                                labelText: context.appText.pinCode,
                                hintText: context.appText.enterPinCode,
                                maxLength: 6,
                                keyboardType:
                                    isAndroid
                                        ? TextInputType.number
                                        : iosNumberKeyboard,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
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
                                validator: (value) {
                                  if (isVP) {
                                    // VP = mandatory
                                    final requiredError =
                                        Validator.fieldRequired(value);
                                    if (requiredError != null) {
                                      return requiredError;
                                    }

                                    final ifscError =
                                        Validator.bankAccountNumber(value);
                                    if (ifscError != null) return ifscError;

                                    return null;
                                  } else if (isLP) {
                                    // LP = optional
                                    if (value != null && value.isNotEmpty) {
                                      return Validator.bankAccountNumber(value);
                                    }
                                  }
                                  return null;
                                },
                                controller: accountNumberTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.accountNumber,
                                hintText: context.appText.enterAccountNumber,
                                keyboardType:
                                    isAndroid
                                        ? TextInputType.number
                                        : iosNumberKeyboard,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  BankAccountNumberFormatter(),
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator:
                                    (value) =>
                                        isVP
                                            ? Validator.fieldRequired(value)
                                            : null,
                                controller: bankNameTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.bankName,
                                hintText: context.appText.enterBankName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z ]"),
                                  ),
                                  UpperCaseTextFormatter(),
                                  LengthLimitingTextInputFormatter(50),
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator:
                                    (value) =>
                                        isVP
                                            ? Validator.fieldRequired(value)
                                            : null,
                                controller: branchNameTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.branchName,
                                hintText: context.appText.enterBranchName,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z ]"),
                                  ),
                                  UpperCaseTextFormatter(),
                                  LengthLimitingTextInputFormatter(30),
                                ],
                              ),
                              20.height,

                              AppTextField(
                                validator: (value) {
                                  if (isVP) {
                                    // VP = mandatory
                                    final requiredError =
                                        Validator.fieldRequired(value);
                                    if (requiredError != null) {
                                      return requiredError;
                                    }

                                    final ifscError = Validator.ifsc(value);
                                    if (ifscError != null) return ifscError;

                                    return null;
                                  } else if (isLP) {
                                    // LP = optional
                                    if (value != null && value.isNotEmpty) {
                                      return Validator.ifsc(value);
                                    }
                                  }
                                  return null;
                                },

                                controller: ifscCodeTextController,
                                mandatoryStar: isVP,
                                labelText: context.appText.ifscCode,
                                hintText: context.appText.enterIFSCCode,
                                inputFormatters: [IFSCCodeFormatter()],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    30.height,
                    buildSubmitKycButtonWidget(),
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
  Widget _buildGstWidget() {
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
        bool verified = state.verifiedGst != null && state.verifiedGst!;

        return Column(
          children: [
            // Enter GST Number
            buildTextFieldWithLabelWidget(
              maxLength: 15,
              isMandatory: companyId != 1,
              onChanged: (text) {
                setGstNumberIntoLocal(text ?? "");
              },
              inputFormatters: [UpperCaseTextFormatter(), GSTInputFormatter()],
              leftText:
                  verified
                      ? context.appText.verified
                      : context.appText.unVerified,
              readOnly: verified,
              rightText: "GSTIN",

              controller: gstInTextController,
              suffixOnTap:
                  state.verifiedGst != null && state.verifiedGst!
                      ? () {}
                      : () async {
                        if (gstInTextController.text.isEmpty) {
                          ToastMessages.alert(
                            message: context.appText.pleaseEnterGSTINNumber,
                          );
                          return;
                        }
                        if (!isValidGSTIN(gstInTextController.text)) {
                          ToastMessages.alert(
                            message:
                                context.appText.pleaseEnterAValidGSTINNumber,
                          );
                          return;
                        }
                        if (gstDoc.isEmpty) {
                          ToastMessages.alert(
                            message: context.appText.uploadGSTDocument,
                          );
                          return;
                        }
                        if (!context.mounted) return;
                        await verifyGstApiCall(
                          gstInTextController.text,
                          context,
                        );
                      },
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
                if (result is Success) {
                  final gstData = kycCubit.state.uploadGSTDocUIState?.data;
                  if (gstData != null && gstDoc.isNotEmpty) {
                    final apiRequest = CreateDocumentApiRequest(
                      documentTypeId: await KycHelper.getDocumentTypeId(
                        KycDocType.gstin,
                        documentCubit,
                      ),
                      title: KycHelper.getMeta(KycDocType.gstin).title,
                      description:
                          KycHelper.getMeta(KycDocType.gstin).description,
                      originalFilename: gstData.originalName,
                      filePath: gstData.filePath,
                      fileSize: gstData.size,
                      mimeType: KycHelper.getMimeTypeFromExtension(
                        gstDoc.first['extension'],
                      ),
                      fileExtension: gstDoc.first['extension'],
                    );
                    await createDocumentApiCall(apiRequest);
                    if (kycCubit.state.createDocumentUIState?.status ==
                        Status.SUCCESS) {
                      if (kycCubit.state.createDocumentUIState?.data != null &&
                          kycCubit.state.createDocumentUIState?.data?.data !=
                              null) {
                        gstDocId =
                            kycCubit
                                .state
                                .createDocumentUIState!
                                .data!
                                .data!
                                .documentId;

                        setGstDocIDAndUrl(
                          jsonEncode(gstDoc.first),
                          gstDocId ?? "",
                        );
                      }
                    }
                  }
                }
              },
              onDelete: (index) async {
                if (gstDocId == null) {
                  ToastMessages.alert(message: context.appText.errorMessage);
                  return;
                }
                await kycCubit.deleteDocument(gstDocId ?? "").then((onValue) {
                  gstDoc.clear();
                  gstDocId = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // TAN Text Field & Upload TAN
  Widget _buildTanWidget() {
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
        bool verified = state.verifiedTan != null && state.verifiedTan!;
        return Column(
          children: [
            // Enter TAN number
            buildTextFieldWithLabelWidget(
              maxLength: 10,
              onChanged: (text) {
                setTanIntoLocal(text ?? "");
              },
              inputFormatters: [UpperCaseTextFormatter(), TANInputFormatter()],
              leftText:
                  verified
                      ? context.appText.verified
                      : context.appText.unVerified,
              readOnly: verified,
              rightText: "TAN",
              isMandatory: false,
              controller: tanTextController,
              suffixOnTap: () async {
                if (tanTextController.text.isEmpty) {
                  ToastMessages.alert(message: context.appText.pleaseEnterTAN);
                  return;
                }
                if (tanDoc.isEmpty) {
                  ToastMessages.alert(
                    message: context.appText.uploadTANDocument,
                  );
                  return;
                }
                if (!isValidTAN(tanTextController.text)) {
                  ToastMessages.alert(
                    message: context.appText.pleaseEnterAValidTANNumber,
                  );
                  return;
                }
                if (!context.mounted) return;
                await verifyTANApiCall(tanTextController.text, context);
              },
            ),
            10.height,

            // Upload TAN Doc
            UploadAttachmentFiles(
              title: context.appText.uploadTANDocument,
              multiFilesList: tanDoc,
              isSingleFile: true,
              isLoading: state.uploadTanDocUIState?.status == Status.LOADING,
              hideDeleteButton: verified,
              allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
              thenUploadFileToSever: () async {
                final Result result = await uploadTanDocumentApiCall(tanDoc);
                if (result is Success) {
                  if (kycCubit.state.uploadTanDocUIState?.status ==
                      Status.SUCCESS) {
                    final data = kycCubit.state.uploadTanDocUIState?.data;
                    if (data != null && tanDoc.isNotEmpty) {
                      final apiRequest = CreateDocumentApiRequest(
                        documentTypeId: await KycHelper.getDocumentTypeId(
                          KycDocType.tan,
                          documentCubit,
                        ),
                        title: KycHelper.getMeta(KycDocType.tan).title,
                        description:
                            KycHelper.getMeta(KycDocType.tan).description,
                        originalFilename: data.originalName,
                        filePath: data.filePath,
                        fileSize: data.size,
                        mimeType: KycHelper.getMimeTypeFromExtension(
                          tanDoc.first['extension'],
                        ),
                        fileExtension: tanDoc.first['extension'],
                      );
                      await createDocumentApiCall(apiRequest);
                      if (kycCubit.state.createDocumentUIState?.status ==
                          Status.SUCCESS) {
                        if (kycCubit.state.createDocumentUIState?.data !=
                                null &&
                            kycCubit.state.createDocumentUIState?.data?.data !=
                                null) {
                          tanDocId =
                              kycCubit
                                  .state
                                  .createDocumentUIState!
                                  .data!
                                  .data!
                                  .documentId;
                          setTanDocAndUrl(
                            jsonEncode(tanDoc.first),
                            tanDocId ?? "",
                          );
                        }
                      }
                    }
                  }
                }
              },
              onDelete: (index) async {
                if (tanDocId == null) {
                  ToastMessages.alert(message: context.appText.errorMessage);
                  return;
                }
                await kycCubit.deleteDocument(tanDocId ?? "").then((onValue) {
                  tanDoc.clear();
                  tanDocId = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // PAN Text Field & Upload PAN
  Widget _buildPanWidget() {
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
        bool verified = state.verifiedPan != null && state.verifiedPan!;
        return Column(
          children: [
            // Enter PAN number
            buildTextFieldWithLabelWidget(
              onChanged: (text) {
                setPanIntoLocal(text ?? "");
              },
              inputFormatters: [
                UpperCaseTextFormatter(),
                PANCardInputFormatter(),
              ],
              maxLength: 10,
              leftText:
                  verified
                      ? context.appText.verified
                      : context.appText.unVerified,
              readOnly: verified,
              rightText: "PAN",
              controller: panTextController,
              suffixOnTap: () async {
                if (panTextController.text.isEmpty) {
                  ToastMessages.alert(message: context.appText.pleaseEnterPAN);
                  return;
                }
                if (!isValidPAN(panTextController.text)) {
                  ToastMessages.alert(
                    message: context.appText.pleaseEnterAValidPAN,
                  );
                  return;
                }
                if (panDoc.isEmpty) {
                  ToastMessages.alert(
                    message: context.appText.uploadPANDocument,
                  );
                  return;
                }
                if (!context.mounted) return;
                await verifyPANApiCall(panTextController.text, context);
              },
            ),
            10.height,

            // Upload PAN Doc
            UploadAttachmentFiles(
              title: context.appText.uploadPANDocument,
              multiFilesList: panDoc,
              isSingleFile: true,
              isLoading: state.uploadPanDocUIState?.status == Status.LOADING,
              hideDeleteButton: verified,
              allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
              thenUploadFileToSever: () async {
                final Result result = await uploadPanDocumentApiCall(panDoc);
                if (result is Success) {
                  if (kycCubit.state.uploadPanDocUIState?.status ==
                      Status.SUCCESS) {
                    final data = kycCubit.state.uploadPanDocUIState?.data;
                    if (data != null && panDoc.isNotEmpty) {
                      final apiRequest = CreateDocumentApiRequest(
                        documentTypeId: await KycHelper.getDocumentTypeId(
                          KycDocType.pan,

                          documentCubit,
                        ),
                        title: KycHelper.getMeta(KycDocType.pan).title,
                        description:
                            KycHelper.getMeta(KycDocType.pan).description,
                        originalFilename: data.originalName,
                        filePath: data.filePath,
                        fileSize: data.size,
                        mimeType: KycHelper.getMimeTypeFromExtension(
                          panDoc.first['extension'],
                        ),
                        fileExtension: panDoc.first['extension'],
                      );
                      await createDocumentApiCall(apiRequest);
                      if (kycCubit.state.createDocumentUIState?.status ==
                          Status.SUCCESS) {
                        if (kycCubit.state.createDocumentUIState?.data !=
                                null &&
                            kycCubit.state.createDocumentUIState?.data?.data !=
                                null) {
                          panDocId =
                              kycCubit
                                  .state
                                  .createDocumentUIState!
                                  .data!
                                  .data!
                                  .documentId;
                          setPanDocAndUrl(
                            jsonEncode(panDoc.first),
                            panDocId ?? "",
                          );
                        }
                      }
                    }
                  }
                }
              },
              onDelete: (index) async {
                if (panDocId == null) {
                  ToastMessages.alert(message: context.appText.errorMessage);
                  return;
                }
                await kycCubit.deleteDocument(panDocId ?? "").then((onValue) {
                  panDoc.clear();
                  panDocId = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Upload Cancelled Check
  Widget buildCancelledCheckWidget() {
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
        final cancelledCheckUploadState = state.uploadCancelledUIState?.status;
        if (kycCubit.userRole != null && kycCubit.userRole != 1) {
          return UploadAttachmentFiles(
            title: "${context.appText.cancelledCheque} ",
            multiFilesList: checkDocLink,
            isSingleFile: true,
            isMandatory: true,
            isLoading: cancelledCheckUploadState == Status.LOADING,
            allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
            thenUploadFileToSever: () async {
              final Result result = await uploadCancelledChequeDocumentApiCall(
                checkDocLink,
              );
              if (result is Success) {
                if (kycCubit.state.uploadCancelledUIState?.status ==
                    Status.SUCCESS) {
                  final data = kycCubit.state.uploadCancelledUIState?.data;
                  if (data != null && checkDocLink.isNotEmpty) {
                    final apiRequest = CreateDocumentApiRequest(
                      documentTypeId: await KycHelper.getDocumentTypeId(
                        KycDocType.cheque,
                        documentCubit,
                      ),
                      title: KycHelper.getMeta(KycDocType.cheque).title,
                      description:
                          KycHelper.getMeta(KycDocType.cheque).description,
                      originalFilename: data.originalName,
                      filePath: data.filePath,
                      fileSize: data.size,
                      mimeType: KycHelper.getMimeTypeFromExtension(
                        checkDocLink.first['extension'],
                      ),
                      fileExtension: checkDocLink.first['extension'],
                    );
                    await createDocumentApiCall(apiRequest);
                    if (kycCubit.state.createDocumentUIState?.status ==
                        Status.SUCCESS) {
                      if (kycCubit.state.createDocumentUIState?.data != null &&
                          kycCubit.state.createDocumentUIState?.data?.data !=
                              null) {
                        cancelledChequeDocId =
                            kycCubit
                                .state
                                .createDocumentUIState!
                                .data!
                                .data!
                                .documentId;
                      }
                    }
                  }
                }
              }
            },
            onDelete: (index) async {
              if (cancelledChequeDocId == null) {
                ToastMessages.alert(message: context.appText.errorMessage);
                return;
              }
              await kycCubit.deleteDocument(cancelledChequeDocId ?? "").then((
                onValue,
              ) {
                checkDocLink.clear();
                cancelledChequeDocId = null;
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
  Widget buildTDSCertificationWidget() {
    return BlocBuilder<KycCubit, KycState>(
      bloc: kycCubit,
      builder: (context, state) {
        final tdsUploadState = state.uploadTDSDocUIState?.status;
        if (kycCubit.userRole != null && kycCubit.userRole != 1) {
          return UploadAttachmentFiles(
            title: context.appText.tdsCertificate,
            multiFilesList: tdsDocLink,
            isMandatory: true,
            isSingleFile: true,
            isLoading: tdsUploadState == Status.LOADING,
            allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
            thenUploadFileToSever: () async {
              final Result result = await uploadTdsDocumentApiCall(tdsDocLink);
              if (result is Success) {
                if (kycCubit.state.uploadTDSDocUIState?.status ==
                    Status.SUCCESS) {
                  final data = kycCubit.state.uploadTDSDocUIState?.data;
                  if (data != null && tdsDocLink.isNotEmpty) {
                    final apiRequest = CreateDocumentApiRequest(
                      documentTypeId: await KycHelper.getDocumentTypeId(
                        KycDocType.tds,
                        documentCubit,
                      ),
                      title: KycHelper.getMeta(KycDocType.tds).title,
                      description:
                          KycHelper.getMeta(KycDocType.tds).description,
                      originalFilename: data.originalName,
                      filePath: data.filePath,
                      fileSize: data.size,
                      mimeType: KycHelper.getMimeTypeFromExtension(
                        tdsDocLink.first['extension'],
                      ),
                      fileExtension: tdsDocLink.first['extension'],
                    );
                    await createDocumentApiCall(apiRequest);
                    if (kycCubit.state.createDocumentUIState?.status ==
                        Status.SUCCESS) {
                      if (kycCubit.state.createDocumentUIState?.data != null &&
                          kycCubit.state.createDocumentUIState?.data?.data !=
                              null) {
                        tdsDocId =
                            kycCubit
                                .state
                                .createDocumentUIState!
                                .data!
                                .data!
                                .documentId;
                      }
                    }
                  }
                }
              }
            },
            onDelete: (index) async {
              if (tdsDocId == null) {
                ToastMessages.alert(message: context.appText.errorMessage);
                return;
              }
              await kycCubit.deleteDocument(tdsDocId ?? "").then((onValue) {
                tdsDocLink.clear();
                tdsDocId = null;
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
  Widget buildSubmitKycButtonWidget() {
    return BlocConsumer<KycCubit, KycState>(
      bloc: kycCubit,
      listenWhen:
          (previous, current) =>
              previous.submitKycState != current.submitKycState,
      listener: (context, state) async {
        final status = state.submitKycState?.status;
        if (status == Status.SUCCESS) {
          // Clear the Aadhaar KYC flag
          await securePrefs.deleteKey(AppString.sessionKey.iskycAdarWebview);
          clearAllFormValues();
          profileCubit.fetchProfileDetail();
          if (context.mounted) {
            navigateToHomeScreen(context);
          }
        }
        if (status == Status.ERROR) {
          final error = state.submitKycState?.errorType;
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        return AppButton(
          style: AppButtonStyle.primary,
          title: context.appText.submit,
          isLoading: state.submitKycState?.status == Status.LOADING,
          onPressed: () async {
            verifyKycApiCall();
          },
        );
      },
    ).paddingBottom(50);
  }

  // Aadhaar Text Field
  Widget _buildAadhaarWidget(BuildContext context) {
    return buildTextFieldWithLabelWidget(
      readOnly: true,
      isMandatory: true,
      rightText: context.appText.aadhaarNumber,
      leftText: context.appText.verified,
      controller: aadhaarNumberTextController,
      fillColor: AppColors.lightGreyBackgroundColor,
    );
  }

  // Multiple Text Field
  Widget _buildMultipleTextFieldWidget({
    required String text,
    required List<Widget> children,
  }) {
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

    Color? fillColor,
    bool? isMandatory,
    Function(String? text)? onChanged,
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
                if (isMandatory ?? true)
                  Text(
                    "*",
                    style: AppTextStyle.textFiled.copyWith(
                      color: AppColors.red,
                    ),
                  ),
              ],
            ),
            Text(
              leftText ?? "",
              style: AppTextStyle.textFiled.copyWith(
                color:
                    !readOnly
                        ? AppColors.activeRedColor
                        : AppColors.activeGreenColor,
              ),
            ),
          ],
        ),
        6.height,
        AppTextField(
          maxLength: maxLength,
          validator:
              (value) =>
                  (isMandatory ?? true) ? Validator.fieldRequired(value) : null,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          currentFocus: currentFocus,
          controller: controller,

          onChanged: (p0) => onChanged!(p0),
          decoration: commonInputDecoration(
            fillColor: fillColor ?? AppColors.white,
            suffixIcon:
                readOnly
                    ? 0.width
                    : Text(
                      context.appText.verify,
                      style: AppTextStyle.h6PrimaryColor,
                    ),
            suffixOnTap: suffixOnTap ?? () {},
          ),
        ),
      ],
    );
  }
}
