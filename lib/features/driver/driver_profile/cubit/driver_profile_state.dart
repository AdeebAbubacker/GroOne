part of 'driver_profile_cubit.dart';

class DriverProfileState extends Equatable {
  final UIState<DriverProfileDetailsModel>? profileDetailUIState;
  final UIState<DriverlogoutModel>? logoutUIState;
  final bool showSuccessKyc;
  final String? blueId;
  const DriverProfileState({
    this.profileDetailUIState,
    this.logoutUIState,
    this.showSuccessKyc = false,
    this.blueId,
  });

  DriverProfileState copyWith({
    UIState<DriverProfileDetailsModel>? profileDetailUIState,
    UIState<DriverlogoutModel>? logoutUIState,
    bool? showSuccessKyc,
    String? blueId,

  }) {
    return DriverProfileState(
      profileDetailUIState: profileDetailUIState ?? this.profileDetailUIState,
      logoutUIState: logoutUIState ?? this.logoutUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      blueId: blueId ?? this.blueId,
    );
  }

  @override
  List<Object?> get props => [profileDetailUIState, logoutUIState, showSuccessKyc, blueId];
}
