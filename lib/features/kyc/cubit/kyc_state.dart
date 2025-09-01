part of 'kyc_cubit.dart';

class KycState extends Equatable {
  final Map<KycDocType, UIState<dynamic>> uploadStates;
  final UIState<AadhaarOtpModel>? aadhaarOtpState;
  final UIState<KycInitResponse>? kycInitResponse;
  final UIState<AadharVerificationResponse>? aadharVerificationState;
  final UIState<AadhaarVerifyOtpModel>? aadhaarVerifyOtpState;
  final UIState<UploadCancelledCheckedDocumentModel>? uploadCancelledUIState;
  final UIState<UploadGSTDocumentModel>? uploadGSTDocUIState;
  final UIState<UploadPANDocumentModel>? uploadPanDocUIState;
  final UIState<UploadTANDocumentModel>? uploadTanDocUIState;
  final UIState<UploadTDSDocumentModel>? uploadTDSDocUIState;
  final UIState<List<CityModelList>>? cityUIState;
  final UIState<List<StateModelList>>? stateUIState;
  final UIState<bool>? gstState;
  final UIState<bool>? tanState;
  final UIState<bool>? panState;
  final UIState<UploadFileModel>? fileUploadState;
  final UIState<SubmitKycModel>? submitKycState;
  final UIState<CreateDocumentModel>? createDocumentUIState;
  final UIState<DeleteDocumentModel>? deleteDocumentUIState;
  final UIState<UploadAadharDocumentModel>? uploadAadharDocumentModel;
  final UIState<DocVerificationModel>? docVerificationState;
  final UIState<DocVerificationModel>? panDocVerificationState;
  final bool? verifiedPan;
  final bool? verifiedGst;
  final bool? verifiedTan;

  const KycState({
    this.uploadStates = const {},
    this.aadhaarOtpState,
    this.aadhaarVerifyOtpState,
    this.kycInitResponse,
    this.uploadCancelledUIState,
    this.docVerificationState,


    this.uploadGSTDocUIState,
    this.uploadPanDocUIState,
    this.uploadTanDocUIState,
    this.uploadTDSDocUIState,
    this.cityUIState,
    this.stateUIState,
    this.gstState,
    this.tanState,
    this.panState,
    this.fileUploadState,
    this.submitKycState,
    this.createDocumentUIState,
    this.deleteDocumentUIState,
    this.verifiedPan,
    this.verifiedGst,
    this.verifiedTan,
    this.aadharVerificationState,
    this.uploadAadharDocumentModel,
    this.panDocVerificationState,

  });

  KycState copyWith({
    UIState<DocVerificationModel>? docVerificationState,
    Map<KycDocType, UIState<dynamic>>? uploadStates,
    UIState<AadhaarOtpModel>? aadhaarOtpState,
    UIState<AadharVerificationResponse>? aadharVerificationResponse,
    UIState<AadhaarVerifyOtpModel>? aadhaarVerifyOtpState,
    UIState<UploadCancelledCheckedDocumentModel>? uploadCancelledUIState,
    UIState<UploadGSTDocumentModel>? uploadGSTDocUIState,
    UIState<UploadPANDocumentModel>? uploadPanDocUIState,
    UIState<UploadAadharDocumentModel>? uploadAadharDocUIState,
    UIState<UploadTANDocumentModel>? uploadTanDocUIState,
    UIState<UploadTDSDocumentModel>? uploadTDSDocUIState,
    UIState<List<CityModelList>>? cityUIState,
    UIState<List<StateModelList>>? stateUIState,
    UIState<bool>? gstState,
    UIState<bool>? tanState,
    UIState<bool>? panState,
    UIState<UploadFileModel>? fileUploadState,
    UIState<SubmitKycModel>? submitKycState,
    UIState<CreateDocumentModel>? createDocumentUIState,
    UIState<DeleteDocumentModel>? deleteDocumentUIState,
    bool? verifiedPan,
    bool? verifiedGst,
    bool? verifiedTan,
    UIState<KycInitResponse>? kycInitResponse,
    UIState<DocVerificationModel>? panDocVerificationState

  }) {
    return KycState(
      panDocVerificationState: panDocVerificationState??this.panDocVerificationState,
      uploadAadharDocumentModel: uploadAadharDocUIState??uploadAadharDocumentModel,
      aadharVerificationState: aadharVerificationResponse ?? aadharVerificationState,
      docVerificationState: docVerificationState??this.docVerificationState,
      kycInitResponse: kycInitResponse??this.kycInitResponse,
      uploadStates: uploadStates ?? this.uploadStates,
      aadhaarOtpState: aadhaarOtpState ?? this.aadhaarOtpState,
      aadhaarVerifyOtpState: aadhaarVerifyOtpState ?? this.aadhaarVerifyOtpState,
      uploadCancelledUIState: uploadCancelledUIState ?? this.uploadCancelledUIState,
      uploadGSTDocUIState: uploadGSTDocUIState ?? this.uploadGSTDocUIState,
      uploadPanDocUIState: uploadPanDocUIState ?? this.uploadPanDocUIState,
      uploadTanDocUIState: uploadTanDocUIState ?? this.uploadTanDocUIState,
      uploadTDSDocUIState: uploadTDSDocUIState ?? this.uploadTDSDocUIState,
      cityUIState: cityUIState ?? this.cityUIState,
      stateUIState: stateUIState ?? this.stateUIState,
      gstState: gstState ?? this.gstState,
      tanState: tanState ?? this.tanState,
      panState: panState ?? this.panState,
      fileUploadState: fileUploadState ?? this.fileUploadState,
      submitKycState: submitKycState ?? this.submitKycState,
      createDocumentUIState: createDocumentUIState ?? this.createDocumentUIState,
      deleteDocumentUIState: deleteDocumentUIState ?? this.deleteDocumentUIState,
      verifiedPan: verifiedPan ?? this.verifiedPan,
      verifiedGst: verifiedGst ?? this.verifiedGst,
      verifiedTan: verifiedTan ?? this.verifiedTan,
    );
  }

  @override
  List<Object?> get props => [
    uploadStates,
    aadhaarOtpState,
    aadhaarVerifyOtpState,
    uploadCancelledUIState,
    uploadGSTDocUIState,
    uploadPanDocUIState,
    uploadTanDocUIState,
    uploadTDSDocUIState,
    cityUIState,
    stateUIState,
    gstState,
    tanState,
    panState,
    fileUploadState,
    submitKycState,
    createDocumentUIState,
    deleteDocumentUIState,
    verifiedPan,
    verifiedGst,
    verifiedTan,
    kycInitResponse,
    aadharVerificationState,
    uploadAadharDocumentModel,
    docVerificationState,
    panDocVerificationState
  ];
}

