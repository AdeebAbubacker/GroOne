import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';

import '../model/gps_login_model.dart';
import '../model/gps_user_details_model.dart';
import '../repository/gps_login_repository.dart';

part 'gps_login_state.dart';

class GpsLoginCubit extends BaseCubit<GpsLoginState> {
  final GpsLoginRepository _repository;
  String? _authToken;
  bool _hasLoadedData = false; // Guard against repeated API calls

  GpsLoginCubit(this._repository) : super(GpsLoginState());

  // Expose repository for access from UI
  GpsLoginRepository get repository => _repository;

  void _setLoginUIState(UIState<GpsLoginResponseModel>? uiState) {
    emit(state.copyWith(loginState: uiState));
  }

  void _setDataFetchUIState(UIState<String>? uiState) {
    emit(state.copyWith(dataFetchState: uiState));
  }

  /// Main login method that performs login and then fetches all data sequentially
  /// Only calls APIs if data hasn't been loaded yet
  Future<void> loginAndFetchAllData() async {
    // Guard against repeated API calls
    if (_hasLoadedData && state.loginState?.status == Status.SUCCESS) {
      return;
    }

    _setLoginUIState(UIState.loading());

    // Step 1: Login
    final loginResult = await _repository.login();

    if (loginResult is Success<GpsLoginResponseModel>) {
      _authToken = loginResult.value.token;
      AppConstants.token = _authToken;
      _setLoginUIState(UIState.success(loginResult.value));

      // Store login response in Realm
      await _repository.saveLoginResponse(loginResult.value);

      // Step 2: Fetch all data sequentially after successful login
      if (loginResult.value.token != null) {
        await _fetchAllDataSequentially(loginResult.value.token!);
      }
    } else if (loginResult is Error) {
      _setLoginUIState(UIState.error((loginResult as Error).type));
    }
  }

  /// Fetch all data sequentially after successful login
  Future<void> _fetchAllDataSequentially(String token) async {
    _setDataFetchUIState(UIState.loading());

    try {
      // Step 2.1: Get user config
      await _repository.fetchAndStoreUserConfig(token);

      // Step 2.2: Get device fuel data
      await _repository.fetchAndStoreDeviceFuel(token);

      // Step 2.3: Get geofences
      await _repository.fetchAndStoreGeofences(token);

      // Step 2.4: Get mobile config (requires user ID)
      final userDetails = await _repository.getUserDetails(token);
      if (userDetails is Success<GpsUserDetailsModel> &&
          userDetails.value.id != null) {
        await _repository.fetchAndStoreMobileConfig(
          token,
          userDetails.value.id!,
        );
      }

      // Step 2.5: Get user configuration (requires user ID)
      if (userDetails is Success<GpsUserDetailsModel> &&
          userDetails.value.id != null) {
        await _repository.fetchAndStoreUserConfiguration(
          token,
          userDetails.value.id!,
        );
      }

      // Step 2.6: Get all vehicle data (includes devices and positions)
      final vehicleDataResult = await _repository.getAllVehicleData(token);
      if (vehicleDataResult is Success) {
        _setDataFetchUIState(UIState.success("All data loaded successfully"));
        _hasLoadedData = true; // Mark as loaded to prevent future API calls
      } else {
        _setDataFetchUIState(UIState.error(GenericError()));
      }
    } catch (e) {
      _setDataFetchUIState(UIState.error(GenericError()));
    }
  }

  /// Legacy login method (kept for backward compatibility)
  Future<void> login() async {
    await loginAndFetchAllData();
  }

  void resetLoginState() {
    emit(
      state.copyWith(
        loginState: resetUIState<GpsLoginResponseModel>(state.loginState),
        dataFetchState: resetUIState<String>(state.dataFetchState),
      ),
    );
  }

  void resetState() {
    _hasLoadedData = false; // Reset the guard flag
    emit(
      state.copyWith(
        loginState: resetUIState<GpsLoginResponseModel>(state.loginState),
        dataFetchState: resetUIState<String>(state.dataFetchState),
        hasStoredCredentials: false,
      ),
    );
  }

  /// Initialize GPS feature - performs login and data fetch
  Future<void> initializeGpsFeature() async {
    await loginAndFetchAllData();
  }

  /// Refresh all data - resets state and reinitializes
  Future<void> refreshData() async {
    resetState();
    await initializeGpsFeature();
  }

  /// Check if data has been loaded
  bool get hasLoadedData => _hasLoadedData;
}
