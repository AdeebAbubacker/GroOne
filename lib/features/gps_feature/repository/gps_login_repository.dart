import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_device_fuel_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_mobile_config_model.dart';
import '../model/gps_user_config_model.dart';
import '../model/gps_user_configuration_model.dart';
import '../model/gps_user_details_model.dart';
import '../models/gps_geofence_model.dart';
import '../service/gps_login_service.dart';
import '../service/gps_realm_service.dart';

class GpsLoginRepository {
  final GpsLoginService _gpsLoginService;
  final GpsRealmService _realmService;
  final HasInternetConnection _internetConnection;

  GpsLoginRepository(
    this._gpsLoginService,
    this._realmService,
    this._internetConnection,
  );

  Future<bool> _checkInternetConnection() async {
    try {
      await _internetConnection.checkConnectivity();
      return HasInternetConnection.isInternet;
    } catch (e) {
      return false;
    }
  }

  /// Login to GPS system
  Future<Result<GpsLoginResponseModel>> login() async {
    return await _gpsLoginService.login();
  }

  /// Get user details
  Future<Result<GpsUserDetailsModel>> getUserDetails(String token) async {
    return await _gpsLoginService.getUserDetails(token);
  }

  /// Get user config
  Future<Result<GpsUserConfigModel>> getUserConfig(String token) async {
    return await _gpsLoginService.getUserConfig(token);
  }

  /// Get all vehicle data with automatic login and user config fetch
  Future<Result<List<GpsCombinedVehicleData>>> getAllVehicleData([
    String? token,
  ]) async {
    try {
      // Check if we have internet connection
      final hasInternet = await _checkInternetConnection();

      if (!hasInternet) {
        // If offline, try to get data from Realm
        if (await _realmService.hasVehicleData()) {
          final offlineData = await _realmService.getAllVehicleData();
          return Success(offlineData);
        } else {
          return Error(InternetNetworkError());
        }
      }

      // If online, fetch from API and save to Realm
      final result = await _gpsLoginService.getAllVehicleData(token);

      if (result is Success<List<GpsCombinedVehicleData>>) {
        // Save to Realm for offline access
        await _realmService.saveVehicleData(result.value);

        // Fetch addresses for vehicles that don't have them
        await fetchAndUpdateAddresses(result.value);

        return result;
      } else {
        // If API fails but we have offline data, return offline data
        if (await _realmService.hasVehicleData()) {
          final offlineData = await _realmService.getAllVehicleData();
          return Success(offlineData);
        }
        return result;
      }
    } catch (e) {
      // If exception occurs but we have offline data, return offline data
      if (await _realmService.hasVehicleData()) {
        final offlineData = await _realmService.getAllVehicleData();
        return Success(offlineData);
      }
      return Error(GenericError());
    }
  }

  /// Get device fuel data
  Future<Result<GpsDeviceFuelModel>> getDeviceFuel(String token) async {
    return await _gpsLoginService.getDeviceFuel(token);
  }

  /// Get vehicle data from Realm only (for offline access)
  Future<List<GpsCombinedVehicleData>> getOfflineVehicleData() async {
    return await _realmService.getAllVehicleData();
  }

  /// Check if offline data is available
  Future<bool> hasOfflineData() async {
    return await _realmService.hasVehicleData();
  }

  /// Clear offline data
  Future<void> clearOfflineData() async {
    await _realmService.clearVehicleData();
  }

  /// Save login response to Realm
  Future<void> saveLoginResponse(GpsLoginResponseModel loginResponse) async {
    await _realmService.saveLoginResponse(loginResponse);
  }

  /// Get stored login response from Realm
  Future<GpsLoginResponseModel?> getStoredLoginResponse() async {
    return await _realmService.getLoginResponse();
  }

  /// Save vehicle data to Realm
  Future<void> saveVehicleData(List<GpsCombinedVehicleData> vehicles) async {
    await _realmService.saveVehicleData(vehicles);
  }


  /// Save Set
  Future<void> saveUserDataGps(List<GpsCombinedVehicleData> vehicles) async {
    await _realmService.saveVehicleData(vehicles);
  }

  /// Get userId
  Future<GpsLoginResponseModel?> getUserDataGps() async {
    return await _realmService.getLoginResponse();
  }

  /// Save user config to Realm
  Future<void> saveUserConfig(GpsUserConfigModel userConfig) async {
    await _realmService.saveUserConfig(userConfig);
  }

  /// Get stored user config from Realm
  Future<GpsUserConfigModel?> getStoredUserConfig() async {
    return await _realmService.getUserConfig();
  }

  /// Fetch and store user config after login
  Future<void> fetchAndStoreUserConfig(String token) async {
    try {
      final userConfigResult = await getUserConfig(token);
      if (userConfigResult is Success<GpsUserConfigModel>) {
        await saveUserConfig(userConfigResult.value);
        print("💾 User config fetched and stored successfully");
      } else {
        print("❌ Failed to fetch user config: ${userConfigResult.runtimeType}");
      }
    } catch (e) {
      print("❌ Error fetching user config: $e");
    }
  }

  /// Save device fuel data to Realm
  Future<void> saveDeviceFuel(GpsDeviceFuelModel deviceFuel) async {
    await _realmService.saveDeviceFuel(deviceFuel);
  }

  /// Get stored device fuel data from Realm
  Future<GpsDeviceFuelModel?> getStoredDeviceFuel() async {
    return await _realmService.getDeviceFuel();
  }

  /// Fetch and store device fuel data after login
  Future<void> fetchAndStoreDeviceFuel(String token) async {
    try {
      final deviceFuelResult = await getDeviceFuel(token);
      if (deviceFuelResult is Success<GpsDeviceFuelModel>) {
        await saveDeviceFuel(deviceFuelResult.value);
        print("💾 Device fuel data fetched and stored successfully");
      } else {
        print(
          "❌ Failed to fetch device fuel data: ${deviceFuelResult.runtimeType}",
        );
      }
    } catch (e) {
      print("❌ Error fetching device fuel data: $e");
    }
  }

  /// Get mobile config
  Future<Result<GpsMobileConfigModel>> getMobileConfig(
    String token,
    int userId,
  ) async {
    return await _gpsLoginService.getMobileConfig(token, userId);
  }

  /// Save mobile config to Realm
  Future<void> saveMobileConfig(GpsMobileConfigData mobileConfig) async {
    await _realmService.saveMobileConfig(mobileConfig);
  }

  /// Get stored mobile config from Realm
  Future<GpsMobileConfigData?> getStoredMobileConfig() async {
    return await _realmService.getMobileConfig();
  }

  /// Fetch and store mobile config after login
  Future<void> fetchAndStoreMobileConfig(String token, int userId) async {
    try {
      final result = await getMobileConfig(token, userId);
      if (result is Success<GpsMobileConfigModel> &&
          result.value.data != null) {
        await saveMobileConfig(result.value.data!);
        print("💾 Mobile config fetched and stored successfully");
      } else {
        print("❌ Failed to fetch mobile config: ${result.runtimeType}");
      }
    } catch (e) {
      print("❌ Error fetching mobile config: $e");
    }
  }

  /// Get user configuration
  Future<Result<GpsUserConfigurationModel>> getUserConfiguration(
    String token,
    int userId,
  ) async {
    return await _gpsLoginService.getUserConfiguration(token, userId);
  }

  /// Save user configuration to Realm
  Future<void> saveUserConfiguration(
    GpsUserConfigurationData userConfig,
  ) async {
    await _realmService.saveUserConfiguration(userConfig);
  }

  /// Get stored user configuration from Realm
  Future<GpsUserConfigurationData?> getStoredUserConfiguration() async {
    return await _realmService.getUserConfiguration();
  }

  /// Fetch and store user configuration after login
  Future<void> fetchAndStoreUserConfiguration(String token, int userId) async {
    try {
      final result = await getUserConfiguration(token, userId);
      if (result is Success<GpsUserConfigurationModel> &&
          result.value.data != null &&
          result.value.data!.isNotEmpty) {
        await saveUserConfiguration(result.value.data!.first);
        print("💾 User configuration fetched and stored successfully");
      } else {
        print("❌ Failed to fetch user configuration: ${result.runtimeType}");
      }
    } catch (e) {
      print("❌ Error fetching user configuration: $e");
    }
  }

  /// Get geofences
  Future<Result<List<GpsGeofenceModel>>> getGeofences(String token) async {
    return await _gpsLoginService.getGeofences(token);
  }

  /// Save geofences to Realm
  Future<void> saveGeofences(List<GpsGeofenceModel> geofences) async {
    await _realmService.saveGeofences(geofences);
  }

  /// Get stored geofences from Realm
  Future<List<GpsGeofenceModel>> getStoredGeofences() async {
    return await _realmService.getGeofences();
  }

  /// Fetch and store geofences after login
  Future<void> fetchAndStoreGeofences(String token) async {
    try {
      final geofencesResult = await getGeofences(token);
      if (geofencesResult is Success<List<GpsGeofenceModel>>) {
        await saveGeofences(geofencesResult.value);
        print(
          "💾 Geofences fetched and stored successfully: ${geofencesResult.value.length} geofences",
        );
      } else {
        print("❌ Failed to fetch geofences: ${geofencesResult.runtimeType}");
      }
    } catch (e) {
      print("❌ Error fetching geofences: $e");
    }
  }

  /// Fetch addresses for vehicles and update realm data
  Future<void> fetchAndUpdateAddresses(
    List<GpsCombinedVehicleData> vehicles,
  ) async {
    try {
      // Check if we have internet connection
      final hasInternet = await _checkInternetConnection();

      if (!hasInternet) {
        return; // Skip address fetching if offline
      }

      for (final vehicle in vehicles) {
        if (vehicle.address == null &&
            vehicle.location != null &&
            vehicle.location!.contains(',')) {
          try {
            final parts = vehicle.location!.split(',');
            final lat = double.tryParse(parts[0].trim());
            final lng = double.tryParse(parts[1].trim());

            if (lat != null && lng != null) {
              final address = await MapHelper.getAddressFromLatLngDoubles(
                lat,
                lng,
              );

              // Create updated vehicle with address
              final updatedVehicle = vehicle.copyWith(address: address);

              // Update in realm
              await _realmService.updateVehicleData(updatedVehicle);
            }
          } catch (e) {
            // Log error but continue with other vehicles
            print(
              "Failed to fetch address for vehicle ${vehicle.vehicleNumber}: $e",
            );
          }
        }
      }
    } catch (e) {
      print("Error in fetchAndUpdateAddresses: $e");
    }
  }
}
