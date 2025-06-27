part of 'en_dhan_cubit.dart';

class EnDhanState extends Equatable {
  // UI States
  final UIState<EnDhanKycModel>? uploadKycState;
  final UIState<EnDhanKycCheckModel>? kycCheckState;

  // KYC Form fields
  final String aadhaar;
  final String pan;
  final String addressProofFront;
  final String addressProofBack;
  final String identityProofFront;
  final String identityProofBack;
  final String panImage;
  final int? customerId;

  // KYC Check results
  final bool hasKycDocuments;
  final EnDhanKycData? kycData;

  const EnDhanState({
    this.uploadKycState,
    this.kycCheckState,
    this.aadhaar = '',
    this.pan = '',
    this.addressProofFront = '',
    this.addressProofBack = '',
    this.identityProofFront = '',
    this.identityProofBack = '',
    this.panImage = '',
    this.customerId,
    this.hasKycDocuments = false,
    this.kycData,
  });

  EnDhanState copyWith({
    UIState<EnDhanKycModel>? uploadKycState,
    UIState<EnDhanKycCheckModel>? kycCheckState,
    String? aadhaar,
    String? pan,
    String? addressProofFront,
    String? addressProofBack,
    String? identityProofFront,
    String? identityProofBack,
    String? panImage,
    int? customerId,
    bool? hasKycDocuments,
    EnDhanKycData? kycData,
  }) {
    return EnDhanState(
      uploadKycState: uploadKycState ?? this.uploadKycState,
      kycCheckState: kycCheckState ?? this.kycCheckState,
      aadhaar: aadhaar ?? this.aadhaar,
      pan: pan ?? this.pan,
      addressProofFront: addressProofFront ?? this.addressProofFront,
      addressProofBack: addressProofBack ?? this.addressProofBack,
      identityProofFront: identityProofFront ?? this.identityProofFront,
      identityProofBack: identityProofBack ?? this.identityProofBack,
      panImage: panImage ?? this.panImage,
      customerId: customerId ?? this.customerId,
      hasKycDocuments: hasKycDocuments ?? this.hasKycDocuments,
      kycData: kycData ?? this.kycData,
    );
  }

  @override
  List<Object?> get props => [
    uploadKycState,
    kycCheckState,
    aadhaar,
    pan,
    addressProofFront,
    addressProofBack,
    identityProofFront,
    identityProofBack,
    panImage,
    customerId,
    hasKycDocuments,
    kycData,
  ];
} 