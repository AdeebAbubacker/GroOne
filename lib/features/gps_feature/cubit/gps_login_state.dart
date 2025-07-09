part of 'gps_login_cubit.dart';

class GpsLoginState {
  final UIState<GpsLoginResponseModel>? loginState;
  final bool hasStoredCredentials;

  GpsLoginState({this.loginState, this.hasStoredCredentials = false});

  GpsLoginState copyWith({
    UIState<GpsLoginResponseModel>? loginState,
    bool? hasStoredCredentials,
  }) {
    return GpsLoginState(
      loginState: loginState ?? this.loginState,
      hasStoredCredentials: hasStoredCredentials ?? this.hasStoredCredentials,
    );
  }
}
