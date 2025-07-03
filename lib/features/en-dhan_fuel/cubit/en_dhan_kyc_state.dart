
import 'package:equatable/equatable.dart';

import '../../../data/ui_state/ui_state.dart';
import '../model/en_dhan_kyc_model.dart';

class EnDhanKycState extends Equatable {
  // UI States
  final UIState<EnDhanKycModel>? uploadKycState;
  final UIState<EnDhanKycCheckModel>? kycCheckState;
  final UIState<AadhaarSendOtpResponse>? aadhaarSendOtpState;
  final UIState<AadhaarVerifyOtpResponse>? aadhaarVerifyOtpState;
  final UIState<PanVerificationResponse>? panVerificationState;

  // KYC Form fields
  final String aadhaar;
  final String pan;

  // KYC Check results
  final bool hasKycDocuments;
  final EnDhanKycData? kycData;

  // Aadhaar Verification
  final bool isAadhaarVerified;
  final String? aadhaarRequestId;

  // PAN Verification
  final bool isPanVerified;

  // Validation states
  final bool isAadhaarValid;
  final bool isPanValid;
  final bool isPanImageUploaded;
  final bool isIdentityFrontUploaded;
  final bool isIdentityBackUploaded;
  final bool isAddressFrontUploaded;
  final bool isAddressBackUploaded;

  // Document lists
  final List panDocuments;
  final List identityFrontDocuments;
  final List identityBackDocuments;
  final List addressFrontDocuments;
  final List addressBackDocuments;

  // Form submission tracking
  final bool hasAttemptedSubmit;

  const EnDhanKycState({
    this.uploadKycState,
    this.kycCheckState,
    this.aadhaarSendOtpState,
    this.aadhaarVerifyOtpState,
    this.panVerificationState,
    this.aadhaar = '',
    this.pan = '',
    this.hasKycDocuments = false,
    this.kycData,
    this.isAadhaarVerified = false,
    this.aadhaarRequestId,
    this.isPanVerified = false,
    this.isAadhaarValid = false,
    this.isPanValid = false,
    this.isPanImageUploaded = false,
    this.isIdentityFrontUploaded = false,
    this.isIdentityBackUploaded = false,
    this.isAddressFrontUploaded = false,
    this.isAddressBackUploaded = false,
    this.panDocuments = const [],
    this.identityFrontDocuments = const [],
    this.identityBackDocuments = const [],
    this.addressFrontDocuments = const [],
    this.addressBackDocuments = const [],
    this.hasAttemptedSubmit = false,
  });

  /// Factory constructor for initial state with mutable document lists
  factory EnDhanKycState.initial() {
    return EnDhanKycState(
      panDocuments: [],
      identityFrontDocuments: [],
      identityBackDocuments: [],
      addressFrontDocuments: [],
      addressBackDocuments: [],
    );
  }

  EnDhanKycState copyWith({
    UIState<EnDhanKycModel>? uploadKycState,
    UIState<EnDhanKycCheckModel>? kycCheckState,
    UIState<AadhaarSendOtpResponse>? aadhaarSendOtpState,
    UIState<AadhaarVerifyOtpResponse>? aadhaarVerifyOtpState,
    UIState<PanVerificationResponse>? panVerificationState,
    String? aadhaar,
    String? pan,
    bool? hasKycDocuments,
    EnDhanKycData? kycData,
    bool? isAadhaarVerified,
    String? aadhaarRequestId,
    bool? isPanVerified,
    bool? isAadhaarValid,
    bool? isPanValid,
    bool? isPanImageUploaded,
    bool? isIdentityFrontUploaded,
    bool? isIdentityBackUploaded,
    bool? isAddressFrontUploaded,
    bool? isAddressBackUploaded,
    List? panDocuments,
    List? identityFrontDocuments,
    List? identityBackDocuments,
    List? addressFrontDocuments,
    List? addressBackDocuments,
    bool? hasAttemptedSubmit,
  }) {
    return EnDhanKycState(
      uploadKycState: uploadKycState ?? this.uploadKycState,
      kycCheckState: kycCheckState ?? this.kycCheckState,
      aadhaarSendOtpState: aadhaarSendOtpState ?? this.aadhaarSendOtpState,
      aadhaarVerifyOtpState: aadhaarVerifyOtpState ?? this.aadhaarVerifyOtpState,
      panVerificationState: panVerificationState ?? this.panVerificationState,
      aadhaar: aadhaar ?? this.aadhaar,
      pan: pan ?? this.pan,
      hasKycDocuments: hasKycDocuments ?? this.hasKycDocuments,
      kycData: kycData ?? this.kycData,
      isAadhaarVerified: isAadhaarVerified ?? this.isAadhaarVerified,
      aadhaarRequestId: aadhaarRequestId ?? this.aadhaarRequestId,
      isPanVerified: isPanVerified ?? this.isPanVerified,
      isAadhaarValid: isAadhaarValid ?? this.isAadhaarValid,
      isPanValid: isPanValid ?? this.isPanValid,
      isPanImageUploaded: isPanImageUploaded ?? this.isPanImageUploaded,
      isIdentityFrontUploaded: isIdentityFrontUploaded ?? this.isIdentityFrontUploaded,
      isIdentityBackUploaded: isIdentityBackUploaded ?? this.isIdentityBackUploaded,
      isAddressFrontUploaded: isAddressFrontUploaded ?? this.isAddressFrontUploaded,
      isAddressBackUploaded: isAddressBackUploaded ?? this.isAddressBackUploaded,
      panDocuments: panDocuments ?? List.from(this.panDocuments),
      identityFrontDocuments: identityFrontDocuments ?? List.from(this.identityFrontDocuments),
      identityBackDocuments: identityBackDocuments ?? List.from(this.identityBackDocuments),
      addressFrontDocuments: addressFrontDocuments ?? List.from(this.addressFrontDocuments),
      addressBackDocuments: addressBackDocuments ?? List.from(this.addressBackDocuments),
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
    );
  }

  // Computed property for form validation
  bool get isFormValid {
    return isAadhaarValid &&
           isPanValid &&
           isPanImageUploaded &&
           isIdentityFrontUploaded &&
           isIdentityBackUploaded &&
           isAddressFrontUploaded &&
           isAddressBackUploaded;
  }

  @override
  List<Object?> get props => [
    uploadKycState,
    kycCheckState,
    aadhaarSendOtpState,
    aadhaarVerifyOtpState,
    panVerificationState,
    aadhaar,
    pan,
    hasKycDocuments,
    kycData,
    isAadhaarVerified,
    aadhaarRequestId,
    isPanVerified,
    isAadhaarValid,
    isPanValid,
    isPanImageUploaded,
    isIdentityFrontUploaded,
    isIdentityBackUploaded,
    isAddressFrontUploaded,
    isAddressBackUploaded,
    panDocuments,
    identityFrontDocuments,
    identityBackDocuments,
    addressFrontDocuments,
    addressBackDocuments,
    hasAttemptedSubmit,
  ];
} 