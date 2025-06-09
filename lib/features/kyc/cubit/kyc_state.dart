part of 'kyc_cubit.dart';

class KycState extends Equatable {
  final UIState<AadhaarOtpModel>? aadhaarOtpState;
  final UIState<AadhaarVerifyOtpModel>? aadhaarVerifyOtpState;
  final UIState<VerifyGstModel>? gstState;
  final UIState<VerifyTanModel>? tanState;
  final UIState<VerifyPanModel>? panState;
  final UIState<UploadFileModel>? fileUploadState;
  final UIState<SubmitKycModel>? submitKycState;
  final bool? verifiedPan;
  final bool? verifiedGst;
  final bool? verifiedTan;

  const KycState({
    this.aadhaarOtpState,
    this.aadhaarVerifyOtpState,
    this.gstState,
    this.tanState,
    this.panState,
    this.fileUploadState,
    this.submitKycState,
    this.verifiedPan,
    this.verifiedGst,
    this.verifiedTan,
  });

  KycState copyWith({
    UIState<AadhaarOtpModel>? aadhaarOtpState,
    UIState<AadhaarVerifyOtpModel>? aadhaarVerifyOtpState,
    UIState<VerifyGstModel>? gstState,
    UIState<VerifyTanModel>? tanState,
    UIState<VerifyPanModel>? panState,
    UIState<UploadFileModel>? fileUploadState,
    UIState<SubmitKycModel>? submitKycState,
    bool? verifiedPan,
    bool? verifiedGst,
    bool? verifiedTan,
  }) {
    return KycState(
      aadhaarOtpState: aadhaarOtpState ?? this.aadhaarOtpState,
      aadhaarVerifyOtpState: aadhaarVerifyOtpState ?? this.aadhaarVerifyOtpState,
      gstState: gstState ?? this.gstState,
      tanState: tanState ?? this.tanState,
      panState: panState ?? this.panState,
      fileUploadState: fileUploadState ?? this.fileUploadState,
      submitKycState: submitKycState ?? this.submitKycState,
      verifiedPan: verifiedPan ?? false,
      verifiedGst: verifiedGst ?? false,
      verifiedTan: verifiedTan ?? false,
    );
  }

  @override
  List<Object?> get props => [
    aadhaarOtpState,
    aadhaarVerifyOtpState,
    gstState,
    tanState,
    panState,
    fileUploadState,
    submitKycState,
    verifiedPan,
    verifiedGst,
    verifiedTan,
  ];
}

