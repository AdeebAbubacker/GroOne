part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UIState<ProfileDetailModel>? profileDetailUIState;
  final UIState<LogOutModel>? logoutUIState;
  final UIState<KycDocumentResponse>? documentState;
  final UIState<PaginatedAddressList>? addressState;
  final UIState<SetPrimaryAddressResponse>? primaryAddressState;
  final UIState<PaginatedVehicleList>? vehicleState;
  final UIState<PaginatedDriverList>? driverState;
  final UIState<BlueMemberShipResponse>? memberShipState;
  final UIState<CustomerAddress>? createAddressState;
  final UIState<VehicleNewModel>? createVehicleState;
  final UIState<DriverNewModel>? createDriverState;
  final UIState<CustomerSettingsResponse>? customerSettingsState;
  final UIState<List<SettingsResponse>>? settingsState;
  final UIState<FaqResponse>? faqUIState;
  final UIState<TicketResponse>? ticketState;
  final UIState<Ticket>? createTicketState;
  final TicketStatus? selectedTicketStatus;
  final TicketStatus? tempSelectedTicketStatus;
  final bool showSuccessKyc;
  final String? blueId;
  final UIState<List<LoadTruckTypeListModel>>? truckTypeUIState;
  final UIState<List<TruckLengthModel>>? truckLengths;
  final UIState<KavachVehicleDocumentUploadModel>? vehicleDocUpload;
  final UIState<KavachVehicleDocumentUploadModel>? licenseDocUpload;
  final UIState<VehicleVerificationSuccess>? vehicleVerificationState;
  final UIState<VehicleVerificationSuccess>? licenseVerficationState;
  final UIState<VerifedLicenseVahanData>? verifiedLicenseVahanState;
  const ProfileState({
    this.profileDetailUIState,
    this.logoutUIState,
    this.showSuccessKyc = false,
    this.blueId,
    this.documentState,
    this.addressState,  
    this.primaryAddressState,
    this.memberShipState,
    this.createAddressState,
    this.vehicleState,
     this.createVehicleState,
    this.driverState,
    this.createDriverState,
    this.customerSettingsState,
    this.settingsState,
    this.truckTypeUIState,
    this.truckLengths,
    this.vehicleDocUpload,
    this.licenseDocUpload,
    this.vehicleVerificationState,
    this.licenseVerficationState,
    this.faqUIState,
    this.ticketState,
    this.createTicketState,
    this.selectedTicketStatus,
    this.tempSelectedTicketStatus,
    this.verifiedLicenseVahanState,
  });

  ProfileState copyWith({
    UIState<ProfileDetailModel>? profileDetailUIState,
    UIState<LogOutModel>? logoutUIState,
    UIState<KycDocumentResponse>? documentState,
    UIState<PaginatedAddressList>? addressState,
    UIState<SetPrimaryAddressResponse>? primaryAddressState,
    UIState<CustomerSettingsResponse>? customerSettingsState,
    UIState<List<SettingsResponse>>? settingsState,
    UIState<BlueMemberShipResponse>? memberShipState,
    UIState<CustomerAddress>? createAddressState,
    UIState<VehicleNewModel>? createVehicleState,
    UIState<DriverNewModel>? createDriverState,
    UIState<PaginatedVehicleList>? vehicleState,
    UIState<PaginatedDriverList>? driverState,
    UIState<bool>? deleteVehicleState,
    UIState<List<LoadTruckTypeListModel>>? truckTypeUIState,
    UIState<List<TruckLengthModel>>? truckLengths,
    UIState<KavachVehicleDocumentUploadModel>? vehicleDocUpload,
    UIState<KavachVehicleDocumentUploadModel>? licenseDocUpload,
    UIState<FaqResponse>? faqUIState,
    UIState<VehicleVerificationSuccess>? vehicleVerificationState,
    UIState<VehicleVerificationSuccess>? licenseVerficationState,
    UIState<VerifedLicenseVahanData>? verifiedLicenseVahanState,
    UIState<TicketResponse>? ticketState,
    UIState<Ticket>? createTicketState,
    TicketStatus? selectedTicketStatus,
    TicketStatus? tempSelectedTicketStatus,
    bool? showSuccessKyc,
    String? blueId,

  }) {
    return ProfileState(
      profileDetailUIState: profileDetailUIState ?? this.profileDetailUIState,
      logoutUIState: logoutUIState ?? this.logoutUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      blueId: blueId ?? this.blueId,
      documentState: documentState ?? this.documentState,
      addressState: addressState ?? this.addressState,
      primaryAddressState: primaryAddressState ?? this.primaryAddressState,
      memberShipState: memberShipState ?? this.memberShipState,
      createAddressState: createAddressState ?? this.createAddressState,
      createVehicleState: createVehicleState ?? this.createVehicleState,
      createDriverState: createDriverState ?? this.createDriverState,
      vehicleState: vehicleState ?? this.vehicleState,
      truckTypeUIState: truckTypeUIState ?? this.truckTypeUIState,
      truckLengths: truckLengths ?? this.truckLengths,
      driverState: driverState ?? this.driverState,
      settingsState: settingsState ?? this.settingsState,
      customerSettingsState: customerSettingsState ?? this.customerSettingsState,
      vehicleDocUpload: vehicleDocUpload ?? this.vehicleDocUpload,
      licenseDocUpload: licenseDocUpload ?? this.licenseDocUpload,
      vehicleVerificationState: vehicleVerificationState ?? this.vehicleVerificationState,
      licenseVerficationState: licenseVerficationState ?? this.licenseVerficationState,
      faqUIState: faqUIState ?? this.faqUIState,
      ticketState: ticketState ?? this.ticketState,
      createTicketState: createTicketState ?? this.createTicketState,
      selectedTicketStatus: selectedTicketStatus ?? this.selectedTicketStatus,
      tempSelectedTicketStatus: tempSelectedTicketStatus ?? this.tempSelectedTicketStatus,
      verifiedLicenseVahanState: verifiedLicenseVahanState ?? this.verifiedLicenseVahanState,
    );
  }

  @override
  List<Object?> get props => [
    profileDetailUIState,
    logoutUIState,
    documentState,
    addressState,
    memberShipState,
    primaryAddressState,
    showSuccessKyc,
    blueId,
    createAddressState,
    truckTypeUIState,
    truckLengths,
    createVehicleState,
    createDriverState,
    vehicleState,
    driverState,
    settingsState,
    customerSettingsState,
    vehicleDocUpload,
    licenseDocUpload,
    faqUIState,
    vehicleVerificationState,
    licenseVerficationState,
    ticketState,
    createTicketState,
    selectedTicketStatus,
    tempSelectedTicketStatus,
    verifiedLicenseVahanState,
  ];
}
