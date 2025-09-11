part of 'en_dhan_cubit.dart';

class EnDhanState extends Equatable {
  // UI States
  final UIState<EnDhanKycModel>? uploadKycState;
  final UIState<EnDhanKycCheckModel>? kycCheckState;
  final UIState<api_models.EnDhanCustomerCreationResponse>?
  customerCreationState;
  final UIState<api_models.EnDhanStateResponse>? statesState;
  final UIState<api_models.EnDhanDistrictResponse>? districtsState;
  final UIState<api_models.EnDhanZonalResponse>? zonalOfficesState;
  final UIState<api_models.EnDhanRegionalResponse>? regionalOfficesState;
  final UIState<api_models.EnDhanVehicleTypeResponse>? vehicleTypesState;
  final UIState<DocumentUploadResponse>? documentUploadState;
  final UIState<api_models.EnDhanCardListModel>? cardsState;
  final UIState<api_models.EnDhanCardBalanceResponse>? cardBalanceState;
  final UIState<AadhaarSendOtpResponse>? aadhaarSendOtpState;
  final UIState<AadhaarVerifyOtpResponse>? aadhaarVerifyOtpState;
  final UIState<PanVerificationResponse>? panVerificationState;
  final UIState<VehicleVerificationResponse>? vehicleVerificationState;
  final UIState<PincodeResponse>? pincodeState;
  final String? aadhaarDocLink;
  final UIState<Map<String, dynamic>>? endhanServerStatusState;
  final UIState<FleetPincodeVerifyModel?>? pincodeVerifyUIState;

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

  // Aadhaar Verification
  final bool isAadhaarVerified;
  final String? aadhaarRequestId;

  // PAN Verification
  final bool isPanVerified;

  // Vehicle Verification
  final Map<int, bool> verifiedVehicleNumbers; // cardIndex -> isVerified

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

  // Card Creation Form fields
  final String customerName;
  final String title;
  final String mobile;
  final String email;
  final String address1;
  final String address2;
  final String cityName;
  final String pincode;
  final String referralCode; // Added referral code field
  final String shippingAddress;
  final bool saveAsShipping;
  final String regionalOffice;
  final String roAddress1;
  final String roAddress2;
  final String roState;
  final String roDistrict;
  final int? selectedStateId;
  final int? selectedDistrictId;
  final String?
  selectedDistrictName; // For displaying district name from pincode API
  final int? selectedZonalOfficeId;
  final int? selectedRegionalOfficeId;
  final List<CardFormData> cards;
  final String? selectedStateName; // For showing state name in UI
  final String? selectedZonalOfficeName; // For showing zonal name in UI
  final String? selectedRegionalOfficeName; // Optional, if you want same for RO

  // Master Data
  final List<dynamic> states;
  final List<dynamic> districts;
  final List<dynamic> zonalOffices;
  final List<dynamic> regionalOffices;
  final List<String> vehicleTypes;

  const EnDhanState({
    this.uploadKycState,
    this.endhanServerStatusState,
    this.kycCheckState,
    this.customerCreationState,
    this.statesState,
    this.districtsState,
    this.zonalOfficesState,
    this.regionalOfficesState,
    this.vehicleTypesState,
    this.documentUploadState,
    this.cardsState,
    this.cardBalanceState,
    this.aadhaarSendOtpState,
    this.aadhaarVerifyOtpState,
    this.panVerificationState,
    this.vehicleVerificationState,
    this.pincodeState,
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
    this.isAadhaarVerified = false,
    this.aadhaarRequestId,
    this.isPanVerified = false,
    this.verifiedVehicleNumbers = const {},
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
    this.customerName = '',
    this.title = '',
    this.mobile = '',
    this.email = '',
    this.address1 = '',
    this.address2 = '',
    this.cityName = '',
    this.pincode = '',
    this.referralCode = '', // Added referral code with default value
    this.shippingAddress = '',
    this.saveAsShipping = true,
    this.regionalOffice = 'Chennai',
    this.roAddress1 = '',
    this.roAddress2 = '',
    this.roState = '',
    this.roDistrict = '',
    this.selectedStateId,
    this.selectedDistrictId,
    this.selectedDistrictName,
    this.selectedZonalOfficeId,
    this.selectedRegionalOfficeId,
    this.cards = const [CardFormData()],
    this.states = const [],
    this.districts = const [],
    this.zonalOffices = const [],
    this.regionalOffices = const [],
    this.vehicleTypes = const [],
    this.aadhaarDocLink,
    this.selectedStateName,
    this.selectedZonalOfficeName,
    this.selectedRegionalOfficeName,
    this.pincodeVerifyUIState,
  });

  /// Factory constructor for initial state with mutable document lists
  factory EnDhanState.initial() {
    return EnDhanState(
      // Reset all verification states
      isAadhaarVerified: false,
      isPanVerified: false,
      isAadhaarValid: false,
      isPanValid: false,
      isPanImageUploaded: false,
      isIdentityFrontUploaded: false,
      isIdentityBackUploaded: false,
      isAddressFrontUploaded: false,
      isAddressBackUploaded: false,
      hasAttemptedSubmit: false,

      // Clear all form fields
      aadhaar: '',
      pan: '',
      addressProofFront: '',
      addressProofBack: '',
      identityProofFront: '',
      identityProofBack: '',
      panImage: '',

      // Clear all document lists
      panDocuments: [],
      identityFrontDocuments: [],
      identityBackDocuments: [],
      addressFrontDocuments: [],
      addressBackDocuments: [],

      // Reset all UI states
      uploadKycState: null,
      kycCheckState: null,
      aadhaarSendOtpState: null,
      aadhaarVerifyOtpState: null,
      panVerificationState: null,
      vehicleVerificationState: null,
      pincodeState: null,
      endhanServerStatusState: null,

      // Clear verification data
      aadhaarRequestId: null,
      verifiedVehicleNumbers: const {},
    );
  }

  EnDhanState copyWith({
    UIState<EnDhanKycModel>? uploadKycState,
    UIState<EnDhanKycCheckModel>? kycCheckState,
    UIState<api_models.EnDhanCustomerCreationResponse>? customerCreationState,
    UIState<api_models.EnDhanStateResponse>? statesState,
    UIState<api_models.EnDhanDistrictResponse>? districtsState,
    UIState<api_models.EnDhanZonalResponse>? zonalOfficesState,
    UIState<api_models.EnDhanRegionalResponse>? regionalOfficesState,
    UIState<api_models.EnDhanVehicleTypeResponse>? vehicleTypesState,
    UIState<DocumentUploadResponse>? documentUploadState,
    UIState<api_models.EnDhanCardListModel>? cardsState,
    UIState<api_models.EnDhanCardBalanceResponse>? cardBalanceState,
    UIState<AadhaarSendOtpResponse>? aadhaarSendOtpState,
    UIState<AadhaarVerifyOtpResponse>? aadhaarVerifyOtpState,
    UIState<PanVerificationResponse>? panVerificationState,
    UIState<VehicleVerificationResponse>? vehicleVerificationState,
    UIState<PincodeResponse>? pincodeState,
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
    bool? isAadhaarVerified,
    String? aadhaarRequestId,
    bool? isPanVerified,
    Map<int, bool>? verifiedVehicleNumbers,
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
    String? customerName,
    String? title,
    String? mobile,
    String? email,
    String? address1,
    String? address2,
    String? cityName,
    String? pincode,
    String? referralCode, // Added referral code parameter
    String? shippingAddress,
    bool? saveAsShipping,
    String? regionalOffice,
    String? roAddress1,
    String? roAddress2,
    String? roState,
    String? roDistrict,
    int? selectedStateId,
    int? selectedDistrictId,
    String? selectedDistrictName,
    int? selectedZonalOfficeId,
    int? selectedRegionalOfficeId,
    List<CardFormData>? cards,
    List<dynamic>? states,
    List<dynamic>? districts,
    List<dynamic>? zonalOffices,
    List<dynamic>? regionalOffices,
    List<String>? vehicleTypes,
    String? aadhaarDocLink,
    UIState<Map<String, dynamic>>? endhanServerStatusState,
    UIState<FleetPincodeVerifyModel?>? pincodeVerifyUIState,
    String? selectedStateName,
    String? selectedZonalOfficeName,
    String? selectedRegionalOfficeName,
  }) {
    return EnDhanState(
      uploadKycState: uploadKycState ?? this.uploadKycState,
      kycCheckState: kycCheckState ?? this.kycCheckState,
      customerCreationState:
          customerCreationState ?? this.customerCreationState,
      statesState: statesState ?? this.statesState,
      districtsState: districtsState ?? this.districtsState,
      zonalOfficesState: zonalOfficesState ?? this.zonalOfficesState,
      regionalOfficesState: regionalOfficesState ?? this.regionalOfficesState,
      vehicleTypesState: vehicleTypesState ?? this.vehicleTypesState,
      documentUploadState: documentUploadState ?? this.documentUploadState,
      cardsState: cardsState ?? this.cardsState,
      cardBalanceState: cardBalanceState ?? this.cardBalanceState,
      aadhaarSendOtpState: aadhaarSendOtpState ?? this.aadhaarSendOtpState,
      aadhaarVerifyOtpState:
          aadhaarVerifyOtpState ?? this.aadhaarVerifyOtpState,
      panVerificationState: panVerificationState ?? this.panVerificationState,
      vehicleVerificationState:
          vehicleVerificationState ?? this.vehicleVerificationState,
      pincodeState: pincodeState ?? this.pincodeState,
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
      isAadhaarVerified: isAadhaarVerified ?? this.isAadhaarVerified,
      aadhaarRequestId: aadhaarRequestId ?? this.aadhaarRequestId,
      isPanVerified: isPanVerified ?? this.isPanVerified,
      verifiedVehicleNumbers:
          verifiedVehicleNumbers ?? this.verifiedVehicleNumbers,
      isAadhaarValid: isAadhaarValid ?? this.isAadhaarValid,
      isPanValid: isPanValid ?? this.isPanValid,
      isPanImageUploaded: isPanImageUploaded ?? this.isPanImageUploaded,
      isIdentityFrontUploaded:
          isIdentityFrontUploaded ?? this.isIdentityFrontUploaded,
      isIdentityBackUploaded:
          isIdentityBackUploaded ?? this.isIdentityBackUploaded,
      isAddressFrontUploaded:
          isAddressFrontUploaded ?? this.isAddressFrontUploaded,
      isAddressBackUploaded:
          isAddressBackUploaded ?? this.isAddressBackUploaded,
      panDocuments: panDocuments ?? List.from(this.panDocuments),
      identityFrontDocuments:
          identityFrontDocuments ?? List.from(this.identityFrontDocuments),
      identityBackDocuments:
          identityBackDocuments ?? List.from(this.identityBackDocuments),
      addressFrontDocuments:
          addressFrontDocuments ?? List.from(this.addressFrontDocuments),
      addressBackDocuments:
          addressBackDocuments ?? List.from(this.addressBackDocuments),
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
      customerName: customerName ?? this.customerName,
      title: title ?? this.title,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      cityName: cityName ?? this.cityName,
      pincode: pincode ?? this.pincode,
      referralCode: referralCode ?? this.referralCode,
      // Added referral code
      shippingAddress: shippingAddress ?? this.shippingAddress,
      saveAsShipping: saveAsShipping ?? this.saveAsShipping,
      regionalOffice: regionalOffice ?? this.regionalOffice,
      roAddress1: roAddress1 ?? this.roAddress1,
      roAddress2: roAddress2 ?? this.roAddress2,
      roState: roState ?? this.roState,
      roDistrict: roDistrict ?? this.roDistrict,
      selectedStateId: selectedStateId ?? this.selectedStateId,
      selectedDistrictId: selectedDistrictId ?? this.selectedDistrictId,
      selectedDistrictName: selectedDistrictName ?? this.selectedDistrictName,
      selectedZonalOfficeId:
          selectedZonalOfficeId ?? this.selectedZonalOfficeId,
      selectedRegionalOfficeId:
          selectedRegionalOfficeId ?? this.selectedRegionalOfficeId,
      cards: cards ?? this.cards,
      states: states ?? this.states,
      districts: districts ?? this.districts,
      zonalOffices: zonalOffices ?? this.zonalOffices,
      regionalOffices: regionalOffices ?? this.regionalOffices,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      aadhaarDocLink: aadhaarDocLink ?? this.aadhaarDocLink,
      endhanServerStatusState:
          endhanServerStatusState ?? this.endhanServerStatusState,
      selectedStateName: selectedStateName ?? this.selectedStateName,
      selectedZonalOfficeName:
          selectedZonalOfficeName ?? this.selectedZonalOfficeName,
      selectedRegionalOfficeName:
          selectedRegionalOfficeName ?? this.selectedRegionalOfficeName,
      pincodeVerifyUIState: pincodeVerifyUIState ?? this.pincodeVerifyUIState,
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
    customerCreationState,
    statesState,
    districtsState,
    zonalOfficesState,
    regionalOfficesState,
    vehicleTypesState,
    documentUploadState,
    cardsState,
    cardBalanceState,
    aadhaarSendOtpState,
    aadhaarVerifyOtpState,
    panVerificationState,
    vehicleVerificationState,
    pincodeState,
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
    isAadhaarVerified,
    aadhaarRequestId,
    isPanVerified,
    verifiedVehicleNumbers,
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
    customerName,
    mobile,
    email,
    address1,
    address2,
    cityName,
    pincode,
    referralCode, // Added referral code
    shippingAddress,
    saveAsShipping,
    regionalOffice,
    roAddress1,
    roAddress2,
    roState,
    roDistrict,
    selectedStateId,
    selectedDistrictId,
    selectedZonalOfficeId,
    selectedRegionalOfficeId,
    cards,
    states,
    districts,
    zonalOffices,
    regionalOffices,
    vehicleTypes,
    aadhaarDocLink,
    endhanServerStatusState,
    selectedStateName,
    selectedZonalOfficeName,
    selectedRegionalOfficeName,
    pincodeVerifyUIState,
  ];
}

class CardFormData extends Equatable {
  final String vehicleNumber;
  final String? vehicleType;
  final String vinNumber;
  final String mobile;
  final String rcNumber;
  final List<Map<String, dynamic>> rcDocuments;

  const CardFormData({
    this.vehicleNumber = '',
    this.vehicleType,
    this.vinNumber = '',
    this.mobile = '',
    this.rcNumber = '',
    this.rcDocuments = const [],
  });

  CardFormData copyWith({
    String? vehicleNumber,
    String? vehicleType,
    String? vinNumber,
    String? mobile,
    String? rcNumber,
    List<Map<String, dynamic>>? rcDocuments,
  }) {
    return CardFormData(
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vinNumber: vinNumber ?? this.vinNumber,
      mobile: mobile ?? this.mobile,
      rcNumber: rcNumber ?? this.rcNumber,
      rcDocuments: rcDocuments ?? this.rcDocuments,
    );
  }

  @override
  List<Object?> get props => [
    vehicleNumber,
    vehicleType,
    vinNumber,
    mobile,
    rcNumber,
    rcDocuments,
  ];
}
