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

  // Card Creation Form fields
  final String customerName;
  final String mobile;
  final String address1;
  final String address2;
  final String pincode;
  final String shippingAddress;
  final bool saveAsShipping;
  final String regionalOffice;
  final String roAddress1;
  final String roAddress2;
  final String roState;
  final String roDistrict;
  final List<CardFormData> cards;

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
    this.customerName = '',
    this.mobile = '',
    this.address1 = '',
    this.address2 = '',
    this.pincode = '',
    this.shippingAddress = '',
    this.saveAsShipping = true,
    this.regionalOffice = 'Chennai',
    this.roAddress1 = '',
    this.roAddress2 = '',
    this.roState = '',
    this.roDistrict = '',
    this.cards = const [CardFormData()],
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
    String? customerName,
    String? mobile,
    String? address1,
    String? address2,
    String? pincode,
    String? shippingAddress,
    bool? saveAsShipping,
    String? regionalOffice,
    String? roAddress1,
    String? roAddress2,
    String? roState,
    String? roDistrict,
    List<CardFormData>? cards,
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
      customerName: customerName ?? this.customerName,
      mobile: mobile ?? this.mobile,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      pincode: pincode ?? this.pincode,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      saveAsShipping: saveAsShipping ?? this.saveAsShipping,
      regionalOffice: regionalOffice ?? this.regionalOffice,
      roAddress1: roAddress1 ?? this.roAddress1,
      roAddress2: roAddress2 ?? this.roAddress2,
      roState: roState ?? this.roState,
      roDistrict: roDistrict ?? this.roDistrict,
      cards: cards ?? this.cards,
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
    customerName,
    mobile,
    address1,
    address2,
    pincode,
    shippingAddress,
    saveAsShipping,
    regionalOffice,
    roAddress1,
    roAddress2,
    roState,
    roDistrict,
    cards,
  ];
}

class CardFormData extends Equatable {
  final String vehicleNumber;
  final String? vehicleType;
  final String vinNumber;
  final String mobile;
  final List<Map<String, dynamic>> rcDocuments;

  const CardFormData({
    this.vehicleNumber = '',
    this.vehicleType,
    this.vinNumber = '',
    this.mobile = '',
    this.rcDocuments = const [{"fileName": "rccopy.jpeg", "extension": "jpeg"}],
  });

  CardFormData copyWith({
    String? vehicleNumber,
    String? vehicleType,
    String? vinNumber,
    String? mobile,
    List<Map<String, dynamic>>? rcDocuments,
  }) {
    return CardFormData(
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vinNumber: vinNumber ?? this.vinNumber,
      mobile: mobile ?? this.mobile,
      rcDocuments: rcDocuments ?? this.rcDocuments,
    );
  }

  @override
  List<Object?> get props => [
    vehicleNumber,
    vehicleType,
    vinNumber,
    mobile,
    rcDocuments,
  ];
} 