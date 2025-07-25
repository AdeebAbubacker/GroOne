part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UIState<ProfileDetailModel>? profileDetailUIState;
  final UIState<LogOutModel>? logoutUIState;
  final UIState<KycDocumentResponse>? documentState;
  final UIState<AddressResponse>? addressState;
  final UIState<SetPrimaryAddressResponse>? primaryAddressState;
  final UIState<BlueMemberShipResponse>? memberShipState;
  final UIState<ProfileAddress>? createAddressState;
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
    this.customerSettingsState,
  });

  ProfileState copyWith({
    UIState<ProfileDetailModel>? profileDetailUIState,
    UIState<LogOutModel>? logoutUIState,
    UIState<KycDocumentResponse>? documentState,
    UIState<AddressResponse>? addressState,
    UIState<SetPrimaryAddressResponse>? primaryAddressState,
    UIState<CustomerSettingsResponse>? customerSettingsState,
    UIState<BlueMemberShipResponse>? memberShipState,
    UIState<ProfileAddress>? createAddressState,
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
    customerSettingsState
  ];
}
