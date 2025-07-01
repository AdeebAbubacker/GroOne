part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UIState<ProfileDetailModel>? profileDetailUIState;
  final UIState<LogOutModel>? logoutUIState;
  final bool showSuccessKyc;
  final String? blueId;
  const ProfileState({
    this.profileDetailUIState,
    this.logoutUIState,
    this.showSuccessKyc = false,
    this.blueId,
  });

  ProfileState copyWith({
    UIState<ProfileDetailModel>? profileDetailUIState,
    UIState<LogOutModel>? logoutUIState,
    bool? showSuccessKyc,
    String? blueId,

  }) {
    return ProfileState(
      profileDetailUIState: profileDetailUIState ?? this.profileDetailUIState,
      logoutUIState: logoutUIState ?? this.logoutUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      blueId: blueId ?? this.blueId,
    );
  }

  @override
  List<Object?> get props => [profileDetailUIState, logoutUIState, showSuccessKyc, blueId];
}
