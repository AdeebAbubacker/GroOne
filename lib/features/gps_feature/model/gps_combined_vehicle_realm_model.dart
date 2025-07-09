import 'package:realm/realm.dart';

import 'gps_combined_vehicle_model.dart';

part 'gps_combined_vehicle_realm_model.realm.dart';

@RealmModel()
class _GpsCombinedVehicleRealmData {
  @PrimaryKey()
  int? deviceId;
  String? vehicleNumber;
  String? status;
  String? statusDuration;
  String? location;
  int? networkSignal;
  bool? hasGPS;
  String? odoReading;
  String? todayDistance;
  String? lastSpeed;
  DateTime? lastUpdate;
  bool? isExpiringSoon;
}

extension GpsCombinedVehicleRealmDataMapper on GpsCombinedVehicleRealmData {
  GpsCombinedVehicleData toDomain() => GpsCombinedVehicleData(
    deviceId: deviceId,
    vehicleNumber: vehicleNumber,
    status: status,
    statusDuration: statusDuration,
    location: location,
    networkSignal: networkSignal,
    hasGPS: hasGPS,
    odoReading: odoReading,
    todayDistance: todayDistance,
    lastSpeed: lastSpeed,
    lastUpdate: lastUpdate,
    isExpiringSoon: isExpiringSoon,
  );

  static GpsCombinedVehicleRealmData fromDomain(GpsCombinedVehicleData data) {
    final obj = GpsCombinedVehicleRealmData(
      data.deviceId,
      vehicleNumber: data.vehicleNumber,
      status: data.status,
      statusDuration: data.statusDuration,
      location: data.location,
      networkSignal: data.networkSignal,
      hasGPS: data.hasGPS,
      odoReading: data.odoReading,
      todayDistance: data.todayDistance,
      lastSpeed: data.lastSpeed,
      lastUpdate: data.lastUpdate,
      isExpiringSoon: data.isExpiringSoon,
    );
    return obj;
  }
}
