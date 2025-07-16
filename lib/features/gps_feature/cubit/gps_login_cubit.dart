import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_user_details_model.dart';
import '../repository/gps_login_repository.dart';
import '../service/gps_realm_service.dart';

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
      print(
        "🚀 GpsLoginCubit.loginAndFetchAllData() - Data already loaded, skipping API calls",
      );
      return;
    }

    print("🚀 GpsLoginCubit.loginAndFetchAllData() called");
    _setLoginUIState(UIState.loading());

    // Step 1: Login
    final loginResult = await _repository.login();
    print("🔍 GpsLoginCubit.login() result type: ${loginResult.runtimeType}");

    if (loginResult is Success<GpsLoginResponseModel>) {
      print(
        "✅ GpsLoginCubit.login() successful, token: ${loginResult.value.token?.substring(0, 20)}...",
      );
      _authToken = loginResult.value.token;
      _setLoginUIState(UIState.success(loginResult.value));

      // Store login response in Realm
      await _repository.saveLoginResponse(loginResult.value);
      print("💾 Login response stored in Realm");

      // Step 2: Fetch all data sequentially after successful login
      if (loginResult.value.token != null) {
        await _fetchAllDataSequentially(loginResult.value.token!);
      }
    } else if (loginResult is Error) {
      print("❌ GpsLoginCubit.login() failed: ${(loginResult as Error).type}");
      _setLoginUIState(UIState.error((loginResult as Error).type));
    }
  }

  /// Fetch all data sequentially after successful login
  Future<void> _fetchAllDataSequentially(String token) async {
    print("🔄 Starting sequential data fetch...");
    _setDataFetchUIState(UIState.loading());

    try {
      // Step 2.1: Get user config
      print("📋 Step 2.1: Fetching user config...");
      await _repository.fetchAndStoreUserConfig(token);

      // Step 2.2: Get device fuel data
      print("⛽ Step 2.2: Fetching device fuel data...");
      await _repository.fetchAndStoreDeviceFuel(token);

      // Step 2.3: Get geofences
      print("📍 Step 2.3: Fetching geofences...");
      await _repository.fetchAndStoreGeofences(token);

      // Step 2.4: Get mobile config (requires user ID)
      print("📱 Step 2.4: Fetching mobile config...");
      final userDetails = await _repository.getUserDetails(token);
      if (userDetails is Success<GpsUserDetailsModel> &&
          userDetails.value.id != null) {
        await _repository.fetchAndStoreMobileConfig(
          token,
          userDetails.value.id!,
        );
      }

      // Step 2.5: Get user configuration (requires user ID)
      print("⚙️ Step 2.5: Fetching user configuration...");
      if (userDetails is Success<GpsUserDetailsModel> &&
          userDetails.value.id != null) {
        await _repository.fetchAndStoreUserConfiguration(
          token,
          userDetails.value.id!,
        );
      }

      // Step 2.6: Get all vehicle data (includes devices and positions)
      print("🚗 Step 2.6: Fetching all vehicle data...");
      final vehicleDataResult = await _repository.getAllVehicleData(token);
      if (vehicleDataResult is Success) {
        print("✅ All data fetched and stored successfully!");
        _setDataFetchUIState(UIState.success("All data loaded successfully"));
        _hasLoadedData = true; // Mark as loaded to prevent future API calls
      } else {
        print(
          "❌ Failed to fetch vehicle data: ${vehicleDataResult.runtimeType}",
        );
        _setDataFetchUIState(UIState.error(GenericError()));
      }
      if (vehicleDataResult is Success<List<GpsCombinedVehicleData>>) {
        final vehicles = vehicleDataResult.value;

        // Save distance for today
        for (var vehicle in vehicles) {
          if (vehicle.deviceId != null &&
              vehicle.vehicleNumber != null &&
              vehicle.todayDistance != null &&
              vehicle.todayDistance!.contains("km")) {
            final parsed = double.tryParse(
              vehicle.todayDistance!.replaceAll("km", "").trim(),
            );

            if (parsed != null) {
              await GpsRealmService().saveDistanceForToday(
                vehicle.deviceId!,
                vehicle.vehicleNumber!,
                parsed,
              );
            }
          }
        }

        print("✅ All data fetched and stored successfully!");
        _setDataFetchUIState(UIState.success("All data loaded successfully"));
        _hasLoadedData = true; // Mark as loaded to prevent future API calls
      }
    } catch (e) {
      print("❌ Error in sequential data fetch: $e");
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
    print("🚀 GpsLoginCubit.initializeGpsFeature() called");
    await loginAndFetchAllData();
  }

  /// Refresh all data - resets state and reinitializes
  Future<void> refreshData() async {
    print("🔄 GpsLoginCubit.refreshData() called");
    resetState();
    await initializeGpsFeature();
  }

  /// Check if data has been loaded
  bool get hasLoadedData => _hasLoadedData;
}
