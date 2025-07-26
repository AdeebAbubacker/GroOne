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
  final UIState<CustomerSettingsResponse>? customerSettingsState;
  final bool showSuccessKyc;
  final String? blueId;
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
    this.driverState,
    this.customerSettingsState,
  });

  ProfileState copyWith({
    UIState<ProfileDetailModel>? profileDetailUIState,
    UIState<LogOutModel>? logoutUIState,
    UIState<KycDocumentResponse>? documentState,
    UIState<PaginatedAddressList>? addressState,
    UIState<SetPrimaryAddressResponse>? primaryAddressState,
    UIState<CustomerSettingsResponse>? customerSettingsState,
    UIState<BlueMemberShipResponse>? memberShipState,
    UIState<CustomerAddress>? createAddressState,
    UIState<PaginatedVehicleList>? vehicleState,
    UIState<PaginatedDriverList>? driverState,
    UIState<bool>? deleteVehicleState,
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
      vehicleState: vehicleState ?? this.vehicleState,
      driverState: driverState ?? this.driverState,
      customerSettingsState: customerSettingsState ?? this.customerSettingsState,
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
    vehicleState,
    driverState,
    customerSettingsState
  ];
}
