part of 'driver_profile_cubit.dart';

class DriverProfileState extends Equatable {
  final UIState<DriverProfileDetailsModel>? profileDetailUIState;
  final UIState<DriverlogoutModel>? logoutUIState;
  final bool showSuccessKyc;
  final String? blueId;
  final UIState<DeleteAccountModel>? deleteAccountUIState;
  const DriverProfileState({
    this.profileDetailUIState,
    this.logoutUIState,
    this.showSuccessKyc = false,
    this.blueId,
    this.deleteAccountUIState,
  });

  DriverProfileState copyWith({
    UIState<DriverProfileDetailsModel>? profileDetailUIState,
    UIState<DriverlogoutModel>? logoutUIState,
    bool? showSuccessKyc,
    String? blueId,
    UIState<DeleteAccountModel>? deleteAccountUIState,
  }) {
    return DriverProfileState(
      profileDetailUIState: profileDetailUIState ?? this.profileDetailUIState,
      logoutUIState: logoutUIState ?? this.logoutUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      blueId: blueId ?? this.blueId,
      deleteAccountUIState: deleteAccountUIState ?? this.deleteAccountUIState,
    );
  }

  @override
  List<Object?> get props => [
    profileDetailUIState,
    logoutUIState,
    showSuccessKyc,
    blueId,
    deleteAccountUIState,
  ];
}
