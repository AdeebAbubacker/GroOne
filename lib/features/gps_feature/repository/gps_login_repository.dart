import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_login_model.dart';
import '../service/gps_login_service.dart';
import '../service/gps_realm_service.dart';

class GpsLoginRepository {
  final GpsLoginService _gpsLoginService;
  final GpsRealmService _realmService;

  GpsLoginRepository(this._gpsLoginService, this._realmService);

  Future<Result<GpsLoginResponseModel>> login() async {
    try {
      // Check if we have internet connection
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsLoginService.login();
      return result;
    } catch (e) {
      return Error(GenericError());
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final hasInternet = HasInternetConnection();
      await hasInternet.checkConnectivity();
      return HasInternetConnection.isInternet;
    } catch (e) {
      return false;
    }
  }

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
