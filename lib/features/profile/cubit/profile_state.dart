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
  final UIState<CustomerSettingsResponse>? customerSettingsState;
  final bool showSuccessKyc;
  final String? blueId;
  final UIState<List<TruckTypeModel>>? truckTypeUIState;
  final UIState<List<TruckLengthModel>>? truckLengths;
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
    this.customerSettingsState,
    this.truckTypeUIState,
    this.truckLengths,
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
    UIState<VehicleNewModel>? createVehicleState,
    UIState<PaginatedVehicleList>? vehicleState,
    UIState<PaginatedDriverList>? driverState,
    UIState<bool>? deleteVehicleState,
    UIState<List<TruckTypeModel>>? truckTypeUIState,
    UIState<List<TruckLengthModel>>? truckLengths,
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
      vehicleState: vehicleState ?? this.vehicleState,
      truckTypeUIState: truckTypeUIState ?? this.truckTypeUIState,
      truckLengths: truckLengths ?? this.truckLengths,
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
    truckTypeUIState,
    truckLengths,
    createVehicleState,
    vehicleState,
    driverState,
    customerSettingsState
  ];
}
