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
  final UIState<List<TicketMessageResponse>>? ticketMessageState;
  final TicketStatus? selectedTicketStatus;
  final TicketStatus? tempSelectedTicketStatus;
  final bool showSuccessKyc;
  final String? blueId;
  final UIState<List<LoadTruckTypeListModel>>? truckTypeUIState;
  final UIState<List<TruckLengthModel>>? truckLengths;
  final UIState<KavachVehicleDocumentUploadModel>? vehicleDocUpload;
  final UIState<KavachVehicleDocumentUploadModel>? licenseDocUpload;
  final UIState<UploadTicketResponse>? uploadTicketDocUIState;
  final UIState<CreateDocumentModel>? createDocumentUIState;
  final UIState<VehcileUpdatedStatusModel>? vehicleUpdateUIState;
  final UIState<List<BloodGroupResponseModel>>? bloodGroupResponseUIState;
  final UIState<List<LicenseCategoryResponseModel>>? licneseCategoryResponseUIState;
  final UIState<DeleteAccountModel>? deleteAccountUIState;
  final int? currentPage;
  final UIState<DocumentDetails>? documentById;
  final bool? switchToVp;

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
    this.faqUIState,
    this.ticketState,
    this.createTicketState,
    this.ticketMessageState,
    this.uploadTicketDocUIState,
    this.selectedTicketStatus,
    this.tempSelectedTicketStatus,
    this.createDocumentUIState,
    this.vehicleUpdateUIState,
    this.bloodGroupResponseUIState,
    this.licneseCategoryResponseUIState,
    this.deleteAccountUIState,
    this.currentPage,
    this.documentById,
    this.switchToVp
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
    UIState<TicketResponse>? ticketState,
    UIState<Ticket>? createTicketState,
    UIState<List<TicketMessageResponse>>? ticketMessageState,
    UIState<UploadTicketResponse>? uploadTicketDocUIState,
    UIState<CreateDocumentModel>? createDocumentUIState,
    TicketStatus? selectedTicketStatus,
    TicketStatus? tempSelectedTicketStatus,
    UIState<VehcileUpdatedStatusModel>? vehicleStatusUpdate,
    UIState<List<BloodGroupResponseModel>>? bloodGroupResponseUIState,
    UIState<List<LicenseCategoryResponseModel>>? licneseCategoryResponseUIState,
    UIState<DeleteAccountModel>? deleteAccountUIState,
    bool? showSuccessKyc,
    String? blueId,
    int? currentPage,
    UIState<DocumentDetails>? documentById,
     bool? switchToVp

  }) {
    return ProfileState(
      switchToVp: switchToVp??this.switchToVp,
      currentPage: currentPage ?? this.currentPage,
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
      faqUIState: faqUIState ?? this.faqUIState,
      ticketState: ticketState ?? this.ticketState,
      createTicketState: createTicketState ?? this.createTicketState,
      ticketMessageState: ticketMessageState ?? this.ticketMessageState,
      uploadTicketDocUIState: uploadTicketDocUIState ?? this.uploadTicketDocUIState,
      createDocumentUIState: createDocumentUIState ?? this.createDocumentUIState,
      selectedTicketStatus: selectedTicketStatus ?? this.selectedTicketStatus,
      tempSelectedTicketStatus: tempSelectedTicketStatus ?? this.tempSelectedTicketStatus,
      vehicleUpdateUIState: vehicleStatusUpdate ?? vehicleUpdateUIState,
      bloodGroupResponseUIState : bloodGroupResponseUIState ?? this.bloodGroupResponseUIState,
      licneseCategoryResponseUIState : licneseCategoryResponseUIState ?? this.licneseCategoryResponseUIState,
      deleteAccountUIState: deleteAccountUIState ?? this.deleteAccountUIState,
      documentById: documentById ?? this.documentById,
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
    ticketState,
    createTicketState,
    ticketMessageState,
    uploadTicketDocUIState,
    createDocumentUIState,
    selectedTicketStatus,
    tempSelectedTicketStatus,
    vehicleUpdateUIState,
    bloodGroupResponseUIState,
    licneseCategoryResponseUIState,
    deleteAccountUIState,
    currentPage,
    documentById,
    switchToVp
  ];
}
