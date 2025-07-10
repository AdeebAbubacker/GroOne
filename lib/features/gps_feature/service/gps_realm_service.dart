import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_combined_vehicle_realm_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_login_realm_model.dart';
import '../model/gps_user_details_model.dart';
import '../model/gps_user_details_realm_model.dart';

class GpsRealmService {
  static const String _realmName = 'gps_vehicle_data.realm';
  Realm? _realm;
  RealmResults<GpsCombinedVehicleRealmData>? _vehicleData;
  RealmResults<GpsUserDetailsRealmModel>? _userDetailsData;
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

      final config = Configuration.local([
        GpsCombinedVehicleRealmData.schema,
        GpsLoginResponseRealmModel.schema,
        GpsUserDetailsRealmModel.schema,
      ], path: realmPath);

      _realm = Realm(config);
      _vehicleData = _realm!.all<GpsCombinedVehicleRealmData>();
      _userDetailsData = _realm!.all<GpsUserDetailsRealmModel>();
    } catch (e) {
      throw Exception('Failed to initialize Realm: $e');
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
          existingUser.userId = userDetails.id;
          existingUser.name = userDetails.name ?? '';
          existingUser.email = userDetails.email ?? '';
          existingUser.disabled = userDetails.disabled;
          existingUser.attributesEmail = userDetails.attributes?.email;
          existingUser.createdAt = DateTime.now();
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

      return {
        'vehicleCount': vehicleCount,
        'hasLoginData': hasLoginData,
        'hasUserDetails': hasUserDetails,
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
      });
      print("🗑️ All GPS data cleared from Realm");
    } catch (e) {
      print("❌ Failed to clear all data from Realm: $e");
      throw Exception('Failed to clear all data from Realm: $e');
    }
  }

  /// Close the Realm instance
  void close() {
    _realm?.close();
    _isInitialized = false;
    print("🔒 Realm instance closed");
  }
}
