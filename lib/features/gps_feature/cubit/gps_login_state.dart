part of 'gps_login_cubit.dart';

class GpsLoginState {
  final UIState<GpsLoginResponseModel>? loginState;
  final UIState<String>? dataFetchState;
  final bool hasStoredCredentials;

  GpsLoginState({
    this.loginState,
    this.dataFetchState,
    this.hasStoredCredentials = false,
  });

  GpsLoginState copyWith({
    UIState<GpsLoginResponseModel>? loginState,
    UIState<String>? dataFetchState,
    bool? hasStoredCredentials,
  }) {
    return GpsLoginState(
      loginState: loginState ?? this.loginState,
      dataFetchState: dataFetchState ?? this.dataFetchState,
      hasStoredCredentials: hasStoredCredentials ?? this.hasStoredCredentials,
    );
  }
}
