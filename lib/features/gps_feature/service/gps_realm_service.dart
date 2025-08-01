import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../model/distance_report_realm_model.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_combined_vehicle_realm_model.dart';
import '../model/gps_device_fuel_model.dart';
import '../model/gps_device_fuel_realm_model.dart';
import '../model/gps_distance_data_model.dart';
import '../model/gps_distance_history_realm_model.dart';
import '../model/gps_geofence_realm_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_login_realm_model.dart';
import '../model/gps_mobile_config_model.dart';
import '../model/gps_mobile_config_realm_model.dart';
import '../model/gps_user_config_model.dart';
import '../model/gps_user_config_realm_model.dart';
import '../model/gps_user_configuration_model.dart';
import '../model/gps_user_configuration_realm_model.dart';
import '../model/gps_user_details_model.dart';
import '../model/gps_user_details_realm_model.dart';
import '../model/gps_vehicle_extra_info_realm_model.dart';
import '../models/gps_device_distance_model.dart';
import '../models/gps_geofence_model.dart';

class GpsRealmService {
  static const String _realmName = 'gps_vehicle_data.realm';
  Realm? _realm;
  RealmResults<GpsCombinedVehicleRealmData>? _vehicleData;
  RealmResults<GpsUserDetailsRealmModel>? _userDetailsData;
  RealmResults<GpsUserConfigRealmModel>? _userConfigData;
  RealmResults<GpsDeviceFuelRealmModel>? _deviceFuelData;
  RealmResults<GpsMobileConfigRealmModel>? _mobileConfigData;
  RealmResults<GpsUserConfigurationRealmModel>? _userConfigurationData;
  RealmResults<GpsGeofenceRealmModel>? _geofenceData;
  bool _isInitialized = false;

  GpsRealmService() {
    // Initialize will be called when needed
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeRealm();
      _isInitialized = true;
    }
  }

  Future<void> _initializeRealm() async {
    try {
      // Get the app's documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final realmPath = '${documentsDir.path}/$_realmName';

      final config = Configuration.local(
        [
          GpsCombinedVehicleRealmData.schema,
          GpsDeviceAttributesRealm.schema,
          GpsLoginResponseRealmModel.schema,
          GpsUserDetailsRealmModel.schema,
          GpsUserConfigRealmModel.schema,
          GpsDeviceFuelRealmModel.schema,
          GpsMobileConfigRealmModel.schema,
          GpsUserConfigurationRealmModel.schema,
          GpsGeofenceRealmModel.schema,
          GpsDistanceHistoryRealmModel.schema,
          GpsVehicleExtraInfoRealm.schema,
          DistanceReportRealmModel.schema,
        ],
        path: realmPath,
        schemaVersion: 5,
      );

      _realm = Realm(config);
      _vehicleData = _realm!.all<GpsCombinedVehicleRealmData>();
      _userDetailsData = _realm!.all<GpsUserDetailsRealmModel>();
      _userConfigData = _realm!.all<GpsUserConfigRealmModel>();
      _deviceFuelData = _realm!.all<GpsDeviceFuelRealmModel>();
      _mobileConfigData = _realm!.all<GpsMobileConfigRealmModel>();
      _userConfigurationData = _realm!.all<GpsUserConfigurationRealmModel>();
      _geofenceData = _realm!.all<GpsGeofenceRealmModel>();
    } catch (e) {
      // If migration fails, clear the database and try again
      if (e.toString().contains('Migration required') ||
          e.toString().contains('schema mismatch')) {
        print("🔄 Migration required, clearing database and retrying...");
        await clearEntireDatabase();

        // Try again with fresh database
        final documentsDir = await getApplicationDocumentsDirectory();
        final realmPath = '${documentsDir.path}/$_realmName';

        final config = Configuration.local(
          [
            GpsCombinedVehicleRealmData.schema,
            GpsDeviceAttributesRealm.schema,
            GpsLoginResponseRealmModel.schema,
            GpsUserDetailsRealmModel.schema,
            GpsUserConfigRealmModel.schema,
            GpsDeviceFuelRealmModel.schema,
            GpsMobileConfigRealmModel.schema,
            GpsUserConfigurationRealmModel.schema,
            GpsGeofenceRealmModel.schema,
            GpsDistanceHistoryRealmModel.schema,
            DistanceReportRealmModel.schema,
            GpsVehicleExtraInfoRealm.schema,
          ],
          path: realmPath,
          schemaVersion: 4,
        );

        _realm = Realm(config);
        _vehicleData = _realm!.all<GpsCombinedVehicleRealmData>();
        _userDetailsData = _realm!.all<GpsUserDetailsRealmModel>();
        _userConfigData = _realm!.all<GpsUserConfigRealmModel>();
        _deviceFuelData = _realm!.all<GpsDeviceFuelRealmModel>();
        _mobileConfigData = _realm!.all<GpsMobileConfigRealmModel>();
        _userConfigurationData = _realm!.all<GpsUserConfigurationRealmModel>();
        _geofenceData = _realm!.all<GpsGeofenceRealmModel>();
        print("✅ Database initialized successfully after migration");
      } else {
        throw Exception('Failed to initialize Realm: $e');
      }
    }
  }

  // ==================== VEHICLE DATA OPERATIONS ====================

  /// Save vehicle data to Realm
  Future<void> saveVehicleData(List<GpsCombinedVehicleData> vehicles) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing data
        _realm!.deleteAll<GpsCombinedVehicleRealmData>();

        // Add new data
        for (final vehicle in vehicles) {
          final realmData = GpsCombinedVehicleRealmDataMapper.fromDomain(
            vehicle,
          );
          _realm!.add(realmData);
        }
      });
      print("💾 Vehicle data saved to Realm: ${vehicles.length} vehicles");
    } catch (e) {
      print("❌ Failed to save vehicle data to Realm: $e");
      throw Exception('Failed to save vehicle data to Realm: $e');
    }
  }

  /// Get all vehicle data from Realm
  Future<List<GpsCombinedVehicleData>> getAllVehicleData() async {
    await _ensureInitialized();
    try {
      return _vehicleData!.map((realmData) => realmData.toDomain()).toList();
    } catch (e) {
      print("❌ Failed to read vehicle data from Realm: $e");
      throw Exception('Failed to read vehicle data from Realm: $e');
    }
  }

  /// Get vehicle data by device ID
  Future<GpsCombinedVehicleData?> getVehicleDataById(int deviceId) async {
    await _ensureInitialized();
    try {
      final realmData =
          _vehicleData!.query('deviceId == \$0', [
            deviceId as Object,
          ]).firstOrNull;
      return realmData?.toDomain();
    } catch (e) {
      print("❌ Failed to read vehicle data by ID from Realm: $e");
      throw Exception('Failed to read vehicle data by ID from Realm: $e');
    }
  }

  /// Update specific vehicle data
  Future<void> updateVehicleData(GpsCombinedVehicleData vehicle) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Find existing vehicle by device ID
        if (vehicle.deviceId != null) {
          final existingVehicle =
              _vehicleData!.query('deviceId == \$0', [
                vehicle.deviceId as Object,
              ]).firstOrNull;

          if (existingVehicle != null) {
            // Update existing vehicle
            existingVehicle.vehicleNumber = vehicle.vehicleNumber;
            existingVehicle.status = vehicle.status;
            existingVehicle.statusDuration = vehicle.statusDuration;
            existingVehicle.location = vehicle.location;
            existingVehicle.networkSignal = vehicle.networkSignal;
            existingVehicle.hasGPS = vehicle.hasGPS;
            existingVehicle.odoReading = vehicle.odoReading;
            existingVehicle.todayDistance = vehicle.todayDistance;
            existingVehicle.lastSpeed = vehicle.lastSpeed;
            existingVehicle.lastUpdate = vehicle.lastUpdate;
            existingVehicle.isExpiringSoon = vehicle.isExpiringSoon;
            existingVehicle.address = vehicle.address;
          } else {
            // Add new vehicle
            final realmData = GpsCombinedVehicleRealmDataMapper.fromDomain(
              vehicle,
            );
            _realm!.add(realmData);
          }
        } else {
          // Add new vehicle without device ID
          final realmData = GpsCombinedVehicleRealmDataMapper.fromDomain(
            vehicle,
          );
          _realm!.add(realmData);
        }
      });
      print(
        "💾 Vehicle data updated in Realm for device ID: ${vehicle.deviceId}",
      );
    } catch (e) {
      print("❌ Failed to update vehicle data in Realm: $e");
      throw Exception('Failed to update vehicle data in Realm: $e');
    }
  }

  /// Check if Realm has any vehicle data
  Future<bool> hasVehicleData() async {
    await _ensureInitialized();
    return _vehicleData!.isNotEmpty;
  }

  /// Get the count of vehicles in Realm
  Future<int> getVehicleCount() async {
    await _ensureInitialized();
    return _vehicleData!.length;
  }

  /// Clear all vehicle data from Realm
  Future<void> clearVehicleData() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsCombinedVehicleRealmData>();
      });
      print("🗑️ Vehicle data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear vehicle data from Realm: $e");
      throw Exception('Failed to clear vehicle data from Realm: $e');
    }
  }

  /// Clear entire Realm database (use for migration issues)
  Future<void> clearEntireDatabase() async {
    try {
      if (_realm != null) {
        _realm!.close();
      }

      final documentsDir = await getApplicationDocumentsDirectory();
      final realmPath = '${documentsDir.path}/$_realmName';

      // Delete the realm file
      final file = File(realmPath);
      if (await file.exists()) {
        await file.delete();
        print("🗑️ Entire Realm database cleared");
      }

      // Reset initialization flag
      _isInitialized = false;
    } catch (e) {
      print("❌ Failed to clear entire database: $e");
      throw Exception('Failed to clear entire database: $e');
    }
  }

  // ==================== LOGIN DATA OPERATIONS ====================

  /// Save login response to Realm
  Future<void> saveLoginResponse(GpsLoginResponseModel loginResponse) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing login data
        _realm!.deleteAll<GpsLoginResponseRealmModel>();

        // Add new login data
        final realmData = GpsLoginResponseRealmModel(
          ObjectId(),
          loginResponse.token ?? '',
          loginResponse.refreshToken ?? '',
          DateTime.now(),
        );
        _realm!.add(realmData);
      });
      print("💾 Login response saved to Realm");
    } catch (e) {
      print("❌ Failed to save login response to Realm: $e");
      throw Exception('Failed to save login response to Realm: $e');
    }
  }

  /// Get stored login response from Realm
  Future<GpsLoginResponseModel?> getLoginResponse() async {
    await _ensureInitialized();
    try {
      final realmData = _realm!.all<GpsLoginResponseRealmModel>().firstOrNull;
      if (realmData != null) {
        return GpsLoginResponseModel(
          token: realmData.token,
          refreshToken: realmData.refreshToken,
        );
      }
      return null;
    } catch (e) {
      print("❌ Failed to read login response from Realm: $e");
      return null;
    }
  }

  /// Save vehicle extra info data to Realm
  Future<void> saveVehicleExtraInfo(
    List<GpsVehicleExtraInfoRealm> extraInfoList,
  ) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing extra info data
        _realm!.deleteAll<GpsVehicleExtraInfoRealm>();

        // Add new extra info data
        for (final extraInfo in extraInfoList) {
          _realm!.add(extraInfo);
        }
      });
      print(
        "💾 Vehicle extra info saved to Realm: ${extraInfoList.length} records",
      );
    } catch (e) {
      print("❌ Failed to save vehicle extra info to Realm: $e");
      throw Exception('Failed to save vehicle extra info to Realm: $e');
    }
  }

  /// Get all vehicle extra info from Realm
  Future<List<GpsVehicleExtraInfoRealm>> getAllVehicleExtraInfo() async {
    await _ensureInitialized();
    try {
      return _realm!.all<GpsVehicleExtraInfoRealm>().toList();
    } catch (e) {
      print("❌ Failed to read vehicle extra info from Realm: $e");
      throw Exception('Failed to read vehicle extra info from Realm: $e');
    }
  }

  /// Update login response in Realm
  Future<void> updateLoginResponse(GpsLoginResponseModel loginResponse) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Find existing login data
        final existingLogin =
            _realm!.all<GpsLoginResponseRealmModel>().firstOrNull;

        if (existingLogin != null) {
          // Update existing login data
          existingLogin.token = loginResponse.token ?? '';
          existingLogin.refreshToken = loginResponse.refreshToken ?? '';
          existingLogin.createdAt = DateTime.now();
        } else {
          // Add new login data
          final realmData = GpsLoginResponseRealmModel(
            ObjectId(),
            loginResponse.token ?? '',
            loginResponse.refreshToken ?? '',
            DateTime.now(),
          );
          _realm!.add(realmData);
        }
      });
      print("💾 Login response updated in Realm");
    } catch (e) {
      print("❌ Failed to update login response in Realm: $e");
      throw Exception('Failed to update login response in Realm: $e');
    }
  }

  /// Clear login data from Realm
  Future<void> clearLoginData() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsLoginResponseRealmModel>();
      });
      print("🗑️ Login data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear login data from Realm: $e");
      throw Exception('Failed to clear login data from Realm: $e');
    }
  }

  // ==================== USER DETAILS OPERATIONS ====================

  /// Save user details to Realm
  Future<void> saveUserDetails(GpsUserDetailsModel userDetails) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing user details
        _realm!.deleteAll<GpsUserDetailsRealmModel>();

        // Add new user details
        final realmData = GpsUserDetailsRealmModelMapper.fromDomain(
          userDetails,
        );
        _realm!.add(realmData);
      });
      print("💾 User details saved to Realm");
    } catch (e) {
      print("❌ Failed to save user details to Realm: $e");
      throw Exception('Failed to save user details to Realm: $e');
    }
  }

  /// Get stored user details from Realm
  Future<GpsUserDetailsModel?> getUserDetails() async {
    await _ensureInitialized();
    try {
      final realmData = _userDetailsData!.firstOrNull;
      if (realmData != null) {
        return realmData.toDomain();
      }
      return null;
    } catch (e) {
      print("❌ Failed to read user details from Realm: $e");
      return null;
    }
  }

  /// Update user details in Realm
  Future<void> updateUserDetails(GpsUserDetailsModel userDetails) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Find existing user details
        final existingUser = _userDetailsData!.firstOrNull;

        if (existingUser != null) {
          // Update existing user details
          final firstUser = userDetails.firstUser;
          if (firstUser != null) {
            existingUser.userId = firstUser.id;
            existingUser.name = firstUser.name ?? '';
            existingUser.email = firstUser.email ?? '';
            existingUser.disabled = firstUser.disabled;
            existingUser.attributesEmail =
                null; // No longer used in new structure
            existingUser.createdAt = DateTime.now();
          }
        } else {
          // Add new user details
          final realmData = GpsUserDetailsRealmModelMapper.fromDomain(
            userDetails,
          );
          _realm!.add(realmData);
        }
      });
      print("💾 User details updated in Realm");
    } catch (e) {
      print("❌ Failed to update user details in Realm: $e");
      throw Exception('Failed to update user details in Realm: $e');
    }
  }

  /// Clear user details from Realm
  Future<void> clearUserDetails() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsUserDetailsRealmModel>();
      });
      print("🗑️ User details cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear user details from Realm: $e");
      throw Exception('Failed to clear user details from Realm: $e');
    }
  }

  // ==================== USER CONFIG OPERATIONS ====================

  /// Save user config to Realm
  Future<void> saveUserConfig(GpsUserConfigModel userConfig) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing user config data
        _realm!.deleteAll<GpsUserConfigRealmModel>();

        // Add new user config data
        if (userConfig.data != null) {
          for (final configData in userConfig.data!) {
            final realmData = GpsUserConfigRealmModelMapper.fromDomain(
              configData,
            );
            _realm!.add(realmData);
          }
        }
      });
      print("💾 User config saved to Realm");
    } catch (e) {
      print("❌ Failed to save user config to Realm: $e");
      throw Exception('Failed to save user config to Realm: $e');
    }
  }

  /// Get stored user config from Realm
  Future<GpsUserConfigModel?> getUserConfig() async {
    await _ensureInitialized();
    try {
      final realmDataList = _userConfigData!.toList();
      if (realmDataList.isNotEmpty) {
        final configDataList =
            realmDataList.map((realmData) => realmData.toDomain()).toList();
        return GpsUserConfigModel(data: configDataList);
      }
      return null;
    } catch (e) {
      print("❌ Failed to read user config from Realm: $e");
      return null;
    }
  }

  /// Update user config in Realm
  Future<void> updateUserConfig(GpsUserConfigModel userConfig) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing user config data
        _realm!.deleteAll<GpsUserConfigRealmModel>();

        // Add new user config data
        if (userConfig.data != null) {
          for (final configData in userConfig.data!) {
            final realmData = GpsUserConfigRealmModelMapper.fromDomain(
              configData,
            );
            _realm!.add(realmData);
          }
        }
      });
      print("💾 User config updated in Realm");
    } catch (e) {
      print("❌ Failed to update user config in Realm: $e");
      throw Exception('Failed to update user config in Realm: $e');
    }
  }

  /// Clear user config from Realm
  Future<void> clearUserConfig() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsUserConfigRealmModel>();
      });
      print("🗑️ User config cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear user config from Realm: $e");
      throw Exception('Failed to clear user config from Realm: $e');
    }
  }

  // ==================== DEVICE FUEL OPERATIONS ====================

  /// Save device fuel data to Realm
  Future<void> saveDeviceFuel(GpsDeviceFuelModel deviceFuel) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing device fuel data
        _realm!.deleteAll<GpsDeviceFuelRealmModel>();

        // Add new device fuel data
        if (deviceFuel.data != null) {
          for (final fuelData in deviceFuel.data!) {
            final realmData = GpsDeviceFuelRealmModelMapper.fromDomain(
              fuelData,
            );
            _realm!.add(realmData);
          }
        }
      });
      print("💾 Device fuel data saved to Realm");
    } catch (e) {
      print("❌ Failed to save device fuel data to Realm: $e");
      throw Exception('Failed to save device fuel data to Realm: $e');
    }
  }

  /// Get stored device fuel data from Realm
  Future<GpsDeviceFuelModel?> getDeviceFuel() async {
    await _ensureInitialized();
    try {
      final realmDataList = _deviceFuelData!.toList();
      if (realmDataList.isNotEmpty) {
        final fuelDataList =
            realmDataList.map((realmData) => realmData.toDomain()).toList();
        return GpsDeviceFuelModel(
          data: fuelDataList,
          success: true,
          total: fuelDataList.length,
        );
      }
      return null;
    } catch (e) {
      print("❌ Failed to read device fuel data from Realm: $e");
      return null;
    }
  }

  /// Update device fuel data in Realm
  Future<void> updateDeviceFuel(GpsDeviceFuelModel deviceFuel) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing device fuel data
        _realm!.deleteAll<GpsDeviceFuelRealmModel>();

        // Add new device fuel data
        if (deviceFuel.data != null) {
          for (final fuelData in deviceFuel.data!) {
            final realmData = GpsDeviceFuelRealmModelMapper.fromDomain(
              fuelData,
            );
            _realm!.add(realmData);
          }
        }
      });
      print("💾 Device fuel data updated in Realm");
    } catch (e) {
      print("❌ Failed to update device fuel data in Realm: $e");
      throw Exception('Failed to update device fuel data in Realm: $e');
    }
  }

  /// Clear device fuel data from Realm
  Future<void> clearDeviceFuel() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsDeviceFuelRealmModel>();
      });
      print("🗑️ Device fuel data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear device fuel data from Realm: $e");
      throw Exception('Failed to clear device fuel data from Realm: $e');
    }
  }

  // ==================== MOBILE CONFIG OPERATIONS ====================
  Future<void> saveMobileConfig(GpsMobileConfigData mobileConfig) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsMobileConfigRealmModel>();
        final realmData = GpsMobileConfigRealmModelMapper.fromDomain(
          mobileConfig,
        );
        _realm!.add(realmData);
      });
      print("💾 Mobile config saved to Realm");
    } catch (e) {
      print("❌ Failed to save mobile config to Realm: $e");
      throw Exception('Failed to save mobile config to Realm: $e');
    }
  }

  Future<GpsMobileConfigData?> getMobileConfig() async {
    await _ensureInitialized();
    try {
      final realmData = _mobileConfigData!.firstOrNull;
      return realmData?.toDomain();
    } catch (e) {
      print("❌ Failed to read mobile config from Realm: $e");
      return null;
    }
  }

  // ==================== USER CONFIGURATION OPERATIONS ====================
  Future<void> saveUserConfiguration(
    GpsUserConfigurationData userConfig,
  ) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsUserConfigurationRealmModel>();
        final realmData = GpsUserConfigurationRealmModelMapper.fromDomain(
          userConfig,
        );
        _realm!.add(realmData);
      });
      print("💾 User configuration saved to Realm");
    } catch (e) {
      print("❌ Failed to save user configuration to Realm: $e");
      throw Exception('Failed to save user configuration to Realm: $e');
    }
  }

  Future<GpsUserConfigurationData?> getUserConfiguration() async {
    await _ensureInitialized();
    try {
      final realmData = _userConfigurationData!.firstOrNull;
      return realmData?.toDomain();
    } catch (e) {
      print("❌ Failed to read user configuration from Realm: $e");
      return null;
    }
  }

  // ==================== GEOFENCE OPERATIONS ====================
  Future<void> saveGeofences(List<GpsGeofenceModel> geofences) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing geofence data
        _realm!.deleteAll<GpsGeofenceRealmModel>();

        // Add new geofence data
        for (final geofence in geofences) {
          final realmData = GpsGeofenceRealmModelMapper.fromDomain(geofence);
          _realm!.add(realmData);
        }
      });
      print("💾 Geofence data saved to Realm: ${geofences.length} geofences");
    } catch (e) {
      print("❌ Failed to save geofence data to Realm: $e");
      throw Exception('Failed to save geofence data to Realm: $e');
    }
  }

  Future<List<GpsGeofenceModel>> getGeofences() async {
    await _ensureInitialized();
    try {
      return _geofenceData!.map((realmData) => realmData.toDomain()).toList();
    } catch (e) {
      print("❌ Failed to read geofence data from Realm: $e");
      throw Exception('Failed to read geofence data from Realm: $e');
    }
  }

  Future<void> clearGeofences() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsGeofenceRealmModel>();
      });
      print("🗑️ Geofence data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear geofence data from Realm: $e");
      throw Exception('Failed to clear geofence data from Realm: $e');
    }
  }

  // ==================== DISTANCE REPORT OPERATIONS ====================

  /// Save distance report data to Realm
  Future<void> saveDistanceReportData(
    List<DeviceDistancePojo> distanceData,
  ) async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        // Clear existing distance report data
        _realm!.deleteAll<DistanceReportRealmModel>();

        // Add new distance report data
        for (final pojo in distanceData) {
          final deviceId = pojo.deviceId.toString();

          // Get device name from vehicle data
          String? deviceName;
          final vehicleData =
              _vehicleData!.query('deviceId == \$0', [
                pojo.deviceId as Object,
              ]).firstOrNull;
          if (vehicleData != null) {
            deviceName = vehicleData.vehicleNumber ?? 'Unknown Device';
          } else {
            deviceName = 'Unknown Device';
          }

          if (pojo.nested != null) {
            for (final nested in pojo.nested!) {
              final unix = _parseUnix(nested.date);
              final distance = nested.distance;

              final model = DistanceReportRealmModel(
                ObjectId(),
                deviceId,
                unix,
                distance,
                deviceName,
              );

              _realm!.add(model, update: true);
            }
          }
        }
      });
      print(
        "💾 Distance report data saved to Realm: ${distanceData.length} devices",
      );
    } catch (e) {
      print("❌ Failed to save distance report data to Realm: $e");
      throw Exception('Failed to save distance report data to Realm: $e');
    }
  }

  /// Get all distance report data from Realm
  Future<List<DistanceReportRealmModel>> getAllDistanceReportData() async {
    await _ensureInitialized();
    try {
      return _realm!.all<DistanceReportRealmModel>().toList();
    } catch (e) {
      print("❌ Failed to read distance report data from Realm: $e");
      throw Exception('Failed to read distance report data from Realm: $e');
    }
  }

  /// Get distance report data by device ID
  Future<List<DistanceReportRealmModel>> getDistanceReportDataByDeviceId(
    String deviceId,
  ) async {
    await _ensureInitialized();
    try {
      return _realm!.query<DistanceReportRealmModel>('deviceId == \$0', [
        deviceId,
      ]).toList();
    } catch (e) {
      print(
        "❌ Failed to read distance report data by device ID from Realm: $e",
      );
      throw Exception(
        'Failed to read distance report data by device ID from Realm: $e',
      );
    }
  }

  /// Get monthly distance for a device
  String getMonthlyDistance(String deviceId) {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final fromMillis = firstDayOfMonth.millisecondsSinceEpoch;

      final results = _realm!.query<DistanceReportRealmModel>(
        'deviceId == \$0 AND dateTime >= \$1',
        [deviceId, fromMillis],
      );

      double total = results.fold(0.0, (sum, e) => sum + (e.distance ?? 0));
      return '${total.toStringAsFixed(2)} Km';
    } catch (e) {
      print("❌ Failed to get monthly distance: $e");
      return '0.0';
    }
  }

  /// Get weekly distance for a device
  String getWeeklyDistance(String deviceId) {
    try {
      final fromMillis =
          DateTime.now()
              .subtract(const Duration(days: 8))
              .millisecondsSinceEpoch;

      final results = _realm!.query<DistanceReportRealmModel>(
        'deviceId == \$0 AND dateTime >= \$1',
        [deviceId, fromMillis],
      );

      double total = results.fold(0.0, (sum, e) => sum + (e.distance ?? 0));
      return '${total.toStringAsFixed(2)} Km';
    } catch (e) {
      print("❌ Failed to get weekly distance: $e");
      return '0.0';
    }
  }

  /// Get 7-day daily distance list for a device
  List<DistanceData> getWeekDistanceList(String deviceId, String? deviceName) {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 6));
      final startDateUnix = startDate.millisecondsSinceEpoch;

      final results = _realm!.query<DistanceReportRealmModel>(
        'deviceId == \$0 AND dateTime >= \$1',
        [deviceId, startDateUnix],
      );

      final distanceMap = <String, double>{};

      for (final entry in results) {
        final date = DateTime.fromMillisecondsSinceEpoch(entry.dateTime);
        final dateKey = '${date.day}/${date.month}';
        distanceMap[dateKey] = (distanceMap[dateKey] ?? 0) + entry.distance;
      }

      // Fill missing dates with 0
      final fullWeek = List.generate(7, (i) {
        final date = startDate.add(Duration(days: i));
        final key = '${date.day}/${date.month}';
        return DistanceData(startTime: key, distance: distanceMap[key] ?? 0.0);
      });

      return fullWeek;
    } catch (e) {
      print("❌ Failed to get week distance list: $e");
      return [];
    }
  }

  /// Clear distance report data from Realm
  Future<void> clearDistanceReportData() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<DistanceReportRealmModel>();
      });
      print("🗑️ Distance report data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear distance report data from Realm: $e");
      throw Exception('Failed to clear distance report data from Realm: $e');
    }
  }

  /// Helper method to parse Unix timestamp
  int _parseUnix(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return date.millisecondsSinceEpoch;
    } catch (e) {
      print("❌ Failed to parse date: $dateString");
      return DateTime.now().millisecondsSinceEpoch;
    }
  }

  // ==================== GENERAL OPERATIONS ====================

  /// Check if user is logged in (has valid login data)
  Future<bool> isUserLoggedIn() async {
    await _ensureInitialized();
    try {
      final loginData = _realm!.all<GpsLoginResponseRealmModel>().firstOrNull;
      return loginData != null && loginData.token.isNotEmpty;
    } catch (e) {
      print("❌ Failed to check login status: $e");
      return false;
    }
  }

  /// Get all stored data summary
  Future<Map<String, dynamic>> getDataSummary() async {
    await _ensureInitialized();
    try {
      final vehicleCount = _vehicleData!.length;
      final hasLoginData = _realm!.all<GpsLoginResponseRealmModel>().isNotEmpty;
      final hasUserDetails = _userDetailsData!.isNotEmpty;
      final hasUserConfig = _userConfigData!.isNotEmpty;
      final hasDeviceFuel = _deviceFuelData!.isNotEmpty;
      final hasMobileConfig = _mobileConfigData!.isNotEmpty;
      final hasUserConfiguration = _userConfigurationData!.isNotEmpty;
      final hasGeofences = _geofenceData!.isNotEmpty;

      return {
        'vehicleCount': vehicleCount,
        'hasLoginData': hasLoginData,
        'hasUserDetails': hasUserDetails,
        'hasUserConfig': hasUserConfig,
        'hasDeviceFuel': hasDeviceFuel,
        'hasMobileConfig': hasMobileConfig,
        'hasUserConfiguration': hasUserConfiguration,
        'hasGeofences': hasGeofences,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print("❌ Failed to get data summary: $e");
      return {};
    }
  }

  /// Clear all data from Realm
  Future<void> clearAllData() async {
    await _ensureInitialized();
    try {
      _realm!.write(() {
        _realm!.deleteAll<GpsCombinedVehicleRealmData>();
        _realm!.deleteAll<GpsLoginResponseRealmModel>();
        _realm!.deleteAll<GpsUserDetailsRealmModel>();
        _realm!.deleteAll<GpsUserConfigRealmModel>();
        _realm!.deleteAll<GpsDeviceFuelRealmModel>();
        _realm!.deleteAll<GpsMobileConfigRealmModel>();
        _realm!.deleteAll<GpsUserConfigurationRealmModel>();
        _realm!.deleteAll<GpsGeofenceRealmModel>();
        _realm!.deleteAll<DistanceReportRealmModel>();
      });
      print("🗑️ All GPS data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear all data from Realm: $e");
      throw Exception('Failed to clear all data from Realm: $e');
    }
  }

  Future<void> saveDistanceForToday(
    int deviceId,
    String vehicleNumber,
    double distance,
  ) async {
    await _ensureInitialized();

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final existing =
        _realm!.query<GpsDistanceHistoryRealmModel>(
          r'deviceId == $0 AND date == $1',
          [deviceId, today],
        ).firstOrNull;

    _realm!.write(() {
      if (existing != null) {
        existing.distance = distance;
      } else {
        _realm!.add(
          GpsDistanceHistoryRealmModel(
            ObjectId(),
            deviceId,
            vehicleNumber,
            distance,
            today,
          ),
        );
      }
    });
  }

  Future<List<DistanceData>> getLast7DaysDistance(int deviceId) async {
    await _ensureInitialized();

    final start = DateTime.now().subtract(const Duration(days: 6));
    final startDate = DateTime(start.year, start.month, start.day);

    final results = _realm!.query<GpsDistanceHistoryRealmModel>(
      r'deviceId == $0 AND date >= $1 SORT(date ASC)',
      [deviceId, startDate],
    );

    return results.map((e) {
      return DistanceData(
        distance: e.distance,
        startTime: '${e.date.day}/${e.date.month}',
      );
    }).toList();
  }

  Future<List<DistanceData>> getWeeklyDistanceGraph(int deviceId) async {
    await _ensureInitialized();

    final now = DateTime.now();
    final fromDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 6));

    final results = _realm!.query<GpsDistanceHistoryRealmModel>(
      r'deviceId == $0 AND date >= $1',
      [deviceId, fromDate],
    );

    final distanceMap = <String, double>{};

    for (var entry in results) {
      final dateKey = '${entry.date.day}/${entry.date.month}';
      distanceMap[dateKey] = (distanceMap[dateKey] ?? 0) + entry.distance;
    }

    // Fill missing dates with 0
    final fullWeek = List.generate(7, (i) {
      final date = fromDate.add(Duration(days: i));
      final key = '${date.day}/${date.month}';
      return DistanceData(startTime: key, distance: distanceMap[key] ?? 0.0);
    });

    return fullWeek;
  }

  /// Close the Realm instance
  void close() {
    _realm?.close();
    _isInitialized = false;
    print("🔒 Realm instance closed");
  }
}
