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
  String? address;

  // Additional fields from position data
  String? category;
  String? course;
  bool? expired;
  String? externalId;
  int? filterStatus;
  String? idleFixTimeKey;
  String? ignition;
  String? lastRenewalDate;
  String? posAttr;
  String? prevOdometer;
  String? protocol;
  String? subscriptionExpiryDate;
  String? totalDistance;
  String? tripName;
  String? uniqueId;
  String? valid;
  String? alarm;
  String? deviceStatus;
  String? fixTime;
  String? geofenceIds;
  String? harshAccelerations;
  String? harshBrakings;
  String? harshCornerings;
  String? idleFixTime;
  String? lastIgnitionOffFixTime;
  String? lastIgnitionOnFixTime;
  String? latitude;
  String? longitude;
  String? network;
  String? overSpeeds;
  String? pushedtoServer;
  String? serverTime;
  String? tmp;

  // Additional fields from expiry data
  String? contact;
  String? dateAdded;
  int? disabled;
  int? groupId;
  String? lastUpdateRfc3339;
  String? model;
  String? phone;
  int? positionId;
  int? statusCode;
  String? batteryPercent;
  String? idleTime;
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
    address: address,
    category: category,
    course: course,
    expired: expired,
    externalId: externalId,
    filterStatus: filterStatus,
    idleFixTimeKey: idleFixTimeKey,
    ignition: ignition,
    lastRenewalDate: lastRenewalDate,
    posAttr: posAttr,
    prevOdometer: prevOdometer,
    protocol: protocol,
    subscriptionExpiryDate: subscriptionExpiryDate,
    totalDistance: totalDistance,
    tripName: tripName,
    uniqueId: uniqueId,
    valid: valid,
    alarm: alarm,
    deviceStatus: deviceStatus,
    fixTime: fixTime,
    geofenceIds: geofenceIds,
    harshAccelerations: harshAccelerations,
    harshBrakings: harshBrakings,
    harshCornerings: harshCornerings,
    idleFixTime: idleFixTime,
    lastIgnitionOffFixTime: lastIgnitionOffFixTime,
    lastIgnitionOnFixTime: lastIgnitionOnFixTime,
    latitude: latitude,
    longitude: longitude,
    network: network,
    overSpeeds: overSpeeds,
    pushedtoServer: pushedtoServer,
    serverTime: serverTime,
    tmp: tmp,
    contact: contact,
    dateAdded: dateAdded,
    disabled: disabled,
    groupId: groupId,
    lastUpdateRfc3339: lastUpdateRfc3339,
    model: model,
    phone: phone,
    positionId: positionId,
    statusCode: statusCode,
    batteryPercent: batteryPercent,
    idleTime: idleTime,
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
      category: data.category,
      course: data.course,
      expired: data.expired,
      externalId: data.externalId,
      filterStatus: data.filterStatus,
      idleFixTimeKey: data.idleFixTimeKey,
      ignition: data.ignition,
      lastRenewalDate: data.lastRenewalDate,
      posAttr: data.posAttr,
      prevOdometer: data.prevOdometer,
      protocol: data.protocol,
      subscriptionExpiryDate: data.subscriptionExpiryDate,
      totalDistance: data.totalDistance,
      tripName: data.tripName,
      uniqueId: data.uniqueId,
      valid: data.valid,
      alarm: data.alarm,
      deviceStatus: data.deviceStatus,
      fixTime: data.fixTime,
      geofenceIds: data.geofenceIds,
      harshAccelerations: data.harshAccelerations,
      harshBrakings: data.harshBrakings,
      harshCornerings: data.harshCornerings,
      idleFixTime: data.idleFixTime,
      lastIgnitionOffFixTime: data.lastIgnitionOffFixTime,
      lastIgnitionOnFixTime: data.lastIgnitionOnFixTime,
      latitude: data.latitude,
      longitude: data.longitude,
      network: data.network,
      overSpeeds: data.overSpeeds,
      pushedtoServer: data.pushedtoServer,
      serverTime: data.serverTime,
      tmp: data.tmp,
      contact: data.contact,
      dateAdded: data.dateAdded,
      disabled: data.disabled,
      groupId: data.groupId,
      lastUpdateRfc3339: data.lastUpdateRfc3339,
      model: data.model,
      phone: data.phone,
      positionId: data.positionId,
      statusCode: data.statusCode,
      batteryPercent: data.batteryPercent,
      idleTime: data.idleTime,
    );
    obj.address = data.address;
    return obj;
  }
}
