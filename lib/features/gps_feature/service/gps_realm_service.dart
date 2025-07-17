import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_combined_vehicle_realm_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_login_realm_model.dart';
import '../model/gps_vehicle_extra_info_realm_model.dart';

class GpsRealmService {
  static const String _realmName = 'gps_vehicle_data.realm';
  Realm? _realm;
  RealmResults<GpsCombinedVehicleRealmData>? _vehicleData;
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
        GpsVehicleExtraInfoRealm.schema,
      ], path: realmPath);

      _realm = Realm(config);
      _vehicleData = _realm!.all<GpsCombinedVehicleRealmData>();
    } catch (e) {
      throw Exception('Failed to initialize Realm: $e');
    }
  }

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
    } catch (e) {
      throw Exception('Failed to save vehicle data to Realm: $e');
    }
  }

  /// Get all vehicle data from Realm
  Future<List<GpsCombinedVehicleData>> getAllVehicleData() async {
    await _ensureInitialized();
    try {
      return _vehicleData!.map((realmData) => realmData.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to read vehicle data from Realm: $e');
    }
  }

  /// Get vehicle data by device ID
  Future<GpsCombinedVehicleData?> getVehicleDataById(int deviceId) async {
    await _ensureInitialized();
    try {
      final realmData =
          _vehicleData!.query('deviceId == \$0', [deviceId]).firstOrNull;
      return realmData?.toDomain();
    } catch (e) {
      throw Exception('Failed to read vehicle data from Realm: $e');
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
    } catch (e) {
      throw Exception('Failed to clear vehicle data from Realm: $e');
    }
  }

  /// Close the Realm instance
  void close() {
    _realm?.close();
    _isInitialized = false;
  }

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
  Future<void> saveVehicleExtraInfo(List<GpsVehicleExtraInfoRealm> extraInfoList) async {
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
      print("💾 Vehicle extra info saved to Realm: ${extraInfoList.length} records");
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
}
