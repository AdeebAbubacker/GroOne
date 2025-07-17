import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';

import '../model/gps_login_model.dart';
import '../repository/gps_login_repository.dart';

part 'gps_login_state.dart';

class GpsLoginCubit extends BaseCubit<GpsLoginState> {
  final GpsLoginRepository _repository;
  String? _authToken;

  GpsLoginCubit(this._repository) : super(GpsLoginState());

  // Expose repository for access from UI
  GpsLoginRepository get repository => _repository;

  void _setLoginUIState(UIState<GpsLoginResponseModel>? uiState) {
    emit(state.copyWith(loginState: uiState));
  }

  Future<void> login() async {
    print("🚀 GpsLoginCubit.login() called");
    _setLoginUIState(UIState.loading());

    final result = await _repository.login();
    print("🔍 GpsLoginCubit.login() result type: ${result.runtimeType}");

    if (result is Success<GpsLoginResponseModel>) {
      print(
        "✅ GpsLoginCubit.login() successful, token: ${result.value.token?.substring(0, 20)}...",
      );
      _authToken = result.value.token;
      AppConstants.token = _authToken;
      _setLoginUIState(UIState.success(result.value));

      // Store login response in Realm
      await _repository.saveLoginResponse(result.value);
      print("💾 Login response stored in Realm");
    } else if (result is Error) {
      print("❌ GpsLoginCubit.login() failed: ${(result as Error).type}");
      _setLoginUIState(UIState.error((result as Error).type));
    }
  }

  void resetLoginState() {
    emit(
      state.copyWith(
        loginState: resetUIState<GpsLoginResponseModel>(state.loginState),
      ),
    );
  }

  void resetState() {
    emit(
      state.copyWith(
        loginState: resetUIState<GpsLoginResponseModel>(state.loginState),
        hasStoredCredentials: false,
      ),
    );
  }

  /// Initialize GPS feature - performs login
  Future<void> initializeGpsFeature() async {
    print("🚀 GpsLoginCubit.initializeGpsFeature() called");
    await login();
  }

  /// Refresh all data - resets state and reinitializes
  Future<void> refreshData() async {
    print("🔄 GpsLoginCubit.refreshData() called");
    resetState();
    await initializeGpsFeature();
  }
}
