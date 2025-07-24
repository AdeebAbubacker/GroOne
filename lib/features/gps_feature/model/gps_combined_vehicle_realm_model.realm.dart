// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_combined_vehicle_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsCombinedVehicleRealmData extends _GpsCombinedVehicleRealmData
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsCombinedVehicleRealmData(
    int? deviceId, {
    String? vehicleNumber,
    String? status,
    String? statusDuration,
    String? location,
    int? networkSignal,
    bool? hasGPS,
    String? odoReading,
    String? todayDistance,
    String? lastSpeed,
    DateTime? lastUpdate,
    bool? isExpiringSoon,
    String? address,
    String? category,
    String? course,
    bool? expired,
    String? externalId,
    int? filterStatus,
    String? idleFixTimeKey,
    String? ignition,
    String? lastRenewalDate,
    String? posAttr,
    String? prevOdometer,
    String? protocol,
    String? subscriptionExpiryDate,
    String? totalDistance,
    String? tripName,
    String? uniqueId,
    String? valid,
    String? alarm,
    String? deviceStatus,
    String? fixTime,
    String? geofenceIds,
    String? harshAccelerations,
    String? harshBrakings,
    String? harshCornerings,
    String? idleFixTime,
    String? lastIgnitionOffFixTime,
    String? lastIgnitionOnFixTime,
    String? latitude,
    String? longitude,
    String? network,
    String? overSpeeds,
    String? pushedtoServer,
    String? serverTime,
    String? tmp,
    String? contact,
    String? dateAdded,
    int? disabled,
    int? groupId,
    String? lastUpdateRfc3339,
    String? model,
    String? phone,
    int? positionId,
    int? statusCode,
    String? batteryPercent,
    String? idleTime,
    GpsDeviceAttributesRealm? attributes,
  }) {
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'vehicleNumber', vehicleNumber);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'statusDuration', statusDuration);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'networkSignal', networkSignal);
    RealmObjectBase.set(this, 'hasGPS', hasGPS);
    RealmObjectBase.set(this, 'odoReading', odoReading);
    RealmObjectBase.set(this, 'todayDistance', todayDistance);
    RealmObjectBase.set(this, 'lastSpeed', lastSpeed);
    RealmObjectBase.set(this, 'lastUpdate', lastUpdate);
    RealmObjectBase.set(this, 'isExpiringSoon', isExpiringSoon);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'course', course);
    RealmObjectBase.set(this, 'expired', expired);
    RealmObjectBase.set(this, 'externalId', externalId);
    RealmObjectBase.set(this, 'filterStatus', filterStatus);
    RealmObjectBase.set(this, 'idleFixTimeKey', idleFixTimeKey);
    RealmObjectBase.set(this, 'ignition', ignition);
    RealmObjectBase.set(this, 'lastRenewalDate', lastRenewalDate);
    RealmObjectBase.set(this, 'posAttr', posAttr);
    RealmObjectBase.set(this, 'prevOdometer', prevOdometer);
    RealmObjectBase.set(this, 'protocol', protocol);
    RealmObjectBase.set(this, 'subscriptionExpiryDate', subscriptionExpiryDate);
    RealmObjectBase.set(this, 'totalDistance', totalDistance);
    RealmObjectBase.set(this, 'tripName', tripName);
    RealmObjectBase.set(this, 'uniqueId', uniqueId);
    RealmObjectBase.set(this, 'valid', valid);
    RealmObjectBase.set(this, 'alarm', alarm);
    RealmObjectBase.set(this, 'deviceStatus', deviceStatus);
    RealmObjectBase.set(this, 'fixTime', fixTime);
    RealmObjectBase.set(this, 'geofenceIds', geofenceIds);
    RealmObjectBase.set(this, 'harshAccelerations', harshAccelerations);
    RealmObjectBase.set(this, 'harshBrakings', harshBrakings);
    RealmObjectBase.set(this, 'harshCornerings', harshCornerings);
    RealmObjectBase.set(this, 'idleFixTime', idleFixTime);
    RealmObjectBase.set(this, 'lastIgnitionOffFixTime', lastIgnitionOffFixTime);
    RealmObjectBase.set(this, 'lastIgnitionOnFixTime', lastIgnitionOnFixTime);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'network', network);
    RealmObjectBase.set(this, 'overSpeeds', overSpeeds);
    RealmObjectBase.set(this, 'pushedtoServer', pushedtoServer);
    RealmObjectBase.set(this, 'serverTime', serverTime);
    RealmObjectBase.set(this, 'tmp', tmp);
    RealmObjectBase.set(this, 'contact', contact);
    RealmObjectBase.set(this, 'dateAdded', dateAdded);
    RealmObjectBase.set(this, 'disabled', disabled);
    RealmObjectBase.set(this, 'groupId', groupId);
    RealmObjectBase.set(this, 'lastUpdateRfc3339', lastUpdateRfc3339);
    RealmObjectBase.set(this, 'model', model);
    RealmObjectBase.set(this, 'phone', phone);
    RealmObjectBase.set(this, 'positionId', positionId);
    RealmObjectBase.set(this, 'statusCode', statusCode);
    RealmObjectBase.set(this, 'batteryPercent', batteryPercent);
    RealmObjectBase.set(this, 'idleTime', idleTime);
    RealmObjectBase.set(this, 'attributes', attributes);
  }

  GpsCombinedVehicleRealmData._();

  @override
  int? get deviceId => RealmObjectBase.get<int>(this, 'deviceId') as int?;
  @override
  set deviceId(int? value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String? get vehicleNumber =>
      RealmObjectBase.get<String>(this, 'vehicleNumber') as String?;
  @override
  set vehicleNumber(String? value) =>
      RealmObjectBase.set(this, 'vehicleNumber', value);

  @override
  String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
  @override
  set status(String? value) => RealmObjectBase.set(this, 'status', value);

  @override
  String? get statusDuration =>
      RealmObjectBase.get<String>(this, 'statusDuration') as String?;
  @override
  set statusDuration(String? value) =>
      RealmObjectBase.set(this, 'statusDuration', value);

  @override
  String? get location =>
      RealmObjectBase.get<String>(this, 'location') as String?;
  @override
  set location(String? value) => RealmObjectBase.set(this, 'location', value);

  @override
  int? get networkSignal =>
      RealmObjectBase.get<int>(this, 'networkSignal') as int?;
  @override
  set networkSignal(int? value) =>
      RealmObjectBase.set(this, 'networkSignal', value);

  @override
  bool? get hasGPS => RealmObjectBase.get<bool>(this, 'hasGPS') as bool?;
  @override
  set hasGPS(bool? value) => RealmObjectBase.set(this, 'hasGPS', value);

  @override
  String? get odoReading =>
      RealmObjectBase.get<String>(this, 'odoReading') as String?;
  @override
  set odoReading(String? value) =>
      RealmObjectBase.set(this, 'odoReading', value);

  @override
  String? get todayDistance =>
      RealmObjectBase.get<String>(this, 'todayDistance') as String?;
  @override
  set todayDistance(String? value) =>
      RealmObjectBase.set(this, 'todayDistance', value);

  @override
  String? get lastSpeed =>
      RealmObjectBase.get<String>(this, 'lastSpeed') as String?;
  @override
  set lastSpeed(String? value) => RealmObjectBase.set(this, 'lastSpeed', value);

  @override
  DateTime? get lastUpdate =>
      RealmObjectBase.get<DateTime>(this, 'lastUpdate') as DateTime?;
  @override
  set lastUpdate(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUpdate', value);

  @override
  bool? get isExpiringSoon =>
      RealmObjectBase.get<bool>(this, 'isExpiringSoon') as bool?;
  @override
  set isExpiringSoon(bool? value) =>
      RealmObjectBase.set(this, 'isExpiringSoon', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

  @override
  String? get category =>
      RealmObjectBase.get<String>(this, 'category') as String?;
  @override
  set category(String? value) => RealmObjectBase.set(this, 'category', value);

  @override
  String? get course => RealmObjectBase.get<String>(this, 'course') as String?;
  @override
  set course(String? value) => RealmObjectBase.set(this, 'course', value);

  @override
  bool? get expired => RealmObjectBase.get<bool>(this, 'expired') as bool?;
  @override
  set expired(bool? value) => RealmObjectBase.set(this, 'expired', value);

  @override
  String? get externalId =>
      RealmObjectBase.get<String>(this, 'externalId') as String?;
  @override
  set externalId(String? value) =>
      RealmObjectBase.set(this, 'externalId', value);

  @override
  int? get filterStatus =>
      RealmObjectBase.get<int>(this, 'filterStatus') as int?;
  @override
  set filterStatus(int? value) =>
      RealmObjectBase.set(this, 'filterStatus', value);

  @override
  String? get idleFixTimeKey =>
      RealmObjectBase.get<String>(this, 'idleFixTimeKey') as String?;
  @override
  set idleFixTimeKey(String? value) =>
      RealmObjectBase.set(this, 'idleFixTimeKey', value);

  @override
  String? get ignition =>
      RealmObjectBase.get<String>(this, 'ignition') as String?;
  @override
  set ignition(String? value) => RealmObjectBase.set(this, 'ignition', value);

  @override
  String? get lastRenewalDate =>
      RealmObjectBase.get<String>(this, 'lastRenewalDate') as String?;
  @override
  set lastRenewalDate(String? value) =>
      RealmObjectBase.set(this, 'lastRenewalDate', value);

  @override
  String? get posAttr =>
      RealmObjectBase.get<String>(this, 'posAttr') as String?;
  @override
  set posAttr(String? value) => RealmObjectBase.set(this, 'posAttr', value);

  @override
  String? get prevOdometer =>
      RealmObjectBase.get<String>(this, 'prevOdometer') as String?;
  @override
  set prevOdometer(String? value) =>
      RealmObjectBase.set(this, 'prevOdometer', value);

  @override
  String? get protocol =>
      RealmObjectBase.get<String>(this, 'protocol') as String?;
  @override
  set protocol(String? value) => RealmObjectBase.set(this, 'protocol', value);

  @override
  String? get subscriptionExpiryDate =>
      RealmObjectBase.get<String>(this, 'subscriptionExpiryDate') as String?;
  @override
  set subscriptionExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'subscriptionExpiryDate', value);

  @override
  String? get totalDistance =>
      RealmObjectBase.get<String>(this, 'totalDistance') as String?;
  @override
  set totalDistance(String? value) =>
      RealmObjectBase.set(this, 'totalDistance', value);

  @override
  String? get tripName =>
      RealmObjectBase.get<String>(this, 'tripName') as String?;
  @override
  set tripName(String? value) => RealmObjectBase.set(this, 'tripName', value);

  @override
  String? get uniqueId =>
      RealmObjectBase.get<String>(this, 'uniqueId') as String?;
  @override
  set uniqueId(String? value) => RealmObjectBase.set(this, 'uniqueId', value);

  @override
  String? get valid => RealmObjectBase.get<String>(this, 'valid') as String?;
  @override
  set valid(String? value) => RealmObjectBase.set(this, 'valid', value);

  @override
  String? get alarm => RealmObjectBase.get<String>(this, 'alarm') as String?;
  @override
  set alarm(String? value) => RealmObjectBase.set(this, 'alarm', value);

  @override
  String? get deviceStatus =>
      RealmObjectBase.get<String>(this, 'deviceStatus') as String?;
  @override
  set deviceStatus(String? value) =>
      RealmObjectBase.set(this, 'deviceStatus', value);

  @override
  String? get fixTime =>
      RealmObjectBase.get<String>(this, 'fixTime') as String?;
  @override
  set fixTime(String? value) => RealmObjectBase.set(this, 'fixTime', value);

  @override
  String? get geofenceIds =>
      RealmObjectBase.get<String>(this, 'geofenceIds') as String?;
  @override
  set geofenceIds(String? value) =>
      RealmObjectBase.set(this, 'geofenceIds', value);

  @override
  String? get harshAccelerations =>
      RealmObjectBase.get<String>(this, 'harshAccelerations') as String?;
  @override
  set harshAccelerations(String? value) =>
      RealmObjectBase.set(this, 'harshAccelerations', value);

  @override
  String? get harshBrakings =>
      RealmObjectBase.get<String>(this, 'harshBrakings') as String?;
  @override
  set harshBrakings(String? value) =>
      RealmObjectBase.set(this, 'harshBrakings', value);

  @override
  String? get harshCornerings =>
      RealmObjectBase.get<String>(this, 'harshCornerings') as String?;
  @override
  set harshCornerings(String? value) =>
      RealmObjectBase.set(this, 'harshCornerings', value);

  @override
  String? get idleFixTime =>
      RealmObjectBase.get<String>(this, 'idleFixTime') as String?;
  @override
  set idleFixTime(String? value) =>
      RealmObjectBase.set(this, 'idleFixTime', value);

  @override
  String? get lastIgnitionOffFixTime =>
      RealmObjectBase.get<String>(this, 'lastIgnitionOffFixTime') as String?;
  @override
  set lastIgnitionOffFixTime(String? value) =>
      RealmObjectBase.set(this, 'lastIgnitionOffFixTime', value);

  @override
  String? get lastIgnitionOnFixTime =>
      RealmObjectBase.get<String>(this, 'lastIgnitionOnFixTime') as String?;
  @override
  set lastIgnitionOnFixTime(String? value) =>
      RealmObjectBase.set(this, 'lastIgnitionOnFixTime', value);

  @override
  String? get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String?;
  @override
  set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  String? get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String?;
  @override
  set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String? get network =>
      RealmObjectBase.get<String>(this, 'network') as String?;
  @override
  set network(String? value) => RealmObjectBase.set(this, 'network', value);

  @override
  String? get overSpeeds =>
      RealmObjectBase.get<String>(this, 'overSpeeds') as String?;
  @override
  set overSpeeds(String? value) =>
      RealmObjectBase.set(this, 'overSpeeds', value);

  @override
  String? get pushedtoServer =>
      RealmObjectBase.get<String>(this, 'pushedtoServer') as String?;
  @override
  set pushedtoServer(String? value) =>
      RealmObjectBase.set(this, 'pushedtoServer', value);

  @override
  String? get serverTime =>
      RealmObjectBase.get<String>(this, 'serverTime') as String?;
  @override
  set serverTime(String? value) =>
      RealmObjectBase.set(this, 'serverTime', value);

  @override
  String? get tmp => RealmObjectBase.get<String>(this, 'tmp') as String?;
  @override
  set tmp(String? value) => RealmObjectBase.set(this, 'tmp', value);

  @override
  String? get contact =>
      RealmObjectBase.get<String>(this, 'contact') as String?;
  @override
  set contact(String? value) => RealmObjectBase.set(this, 'contact', value);

  @override
  String? get dateAdded =>
      RealmObjectBase.get<String>(this, 'dateAdded') as String?;
  @override
  set dateAdded(String? value) => RealmObjectBase.set(this, 'dateAdded', value);

  @override
  int? get disabled => RealmObjectBase.get<int>(this, 'disabled') as int?;
  @override
  set disabled(int? value) => RealmObjectBase.set(this, 'disabled', value);

  @override
  int? get groupId => RealmObjectBase.get<int>(this, 'groupId') as int?;
  @override
  set groupId(int? value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  String? get lastUpdateRfc3339 =>
      RealmObjectBase.get<String>(this, 'lastUpdateRfc3339') as String?;
  @override
  set lastUpdateRfc3339(String? value) =>
      RealmObjectBase.set(this, 'lastUpdateRfc3339', value);

  @override
  String? get model => RealmObjectBase.get<String>(this, 'model') as String?;
  @override
  set model(String? value) => RealmObjectBase.set(this, 'model', value);

  @override
  String? get phone => RealmObjectBase.get<String>(this, 'phone') as String?;
  @override
  set phone(String? value) => RealmObjectBase.set(this, 'phone', value);

  @override
  int? get positionId => RealmObjectBase.get<int>(this, 'positionId') as int?;
  @override
  set positionId(int? value) => RealmObjectBase.set(this, 'positionId', value);

  @override
  int? get statusCode => RealmObjectBase.get<int>(this, 'statusCode') as int?;
  @override
  set statusCode(int? value) => RealmObjectBase.set(this, 'statusCode', value);

  @override
  String? get batteryPercent =>
      RealmObjectBase.get<String>(this, 'batteryPercent') as String?;
  @override
  set batteryPercent(String? value) =>
      RealmObjectBase.set(this, 'batteryPercent', value);

  @override
  String? get idleTime =>
      RealmObjectBase.get<String>(this, 'idleTime') as String?;
  @override
  set idleTime(String? value) => RealmObjectBase.set(this, 'idleTime', value);

  @override
  GpsDeviceAttributesRealm? get attributes =>
      RealmObjectBase.get<GpsDeviceAttributesRealm>(this, 'attributes')
          as GpsDeviceAttributesRealm?;
  @override
  set attributes(covariant GpsDeviceAttributesRealm? value) =>
      RealmObjectBase.set(this, 'attributes', value);

  @override
  Stream<RealmObjectChanges<GpsCombinedVehicleRealmData>> get changes =>
      RealmObjectBase.getChanges<GpsCombinedVehicleRealmData>(this);

  @override
  Stream<RealmObjectChanges<GpsCombinedVehicleRealmData>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsCombinedVehicleRealmData>(
    this,
    keyPaths,
  );

  @override
  GpsCombinedVehicleRealmData freeze() =>
      RealmObjectBase.freezeObject<GpsCombinedVehicleRealmData>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'deviceId': deviceId.toEJson(),
      'vehicleNumber': vehicleNumber.toEJson(),
      'status': status.toEJson(),
      'statusDuration': statusDuration.toEJson(),
      'location': location.toEJson(),
      'networkSignal': networkSignal.toEJson(),
      'hasGPS': hasGPS.toEJson(),
      'odoReading': odoReading.toEJson(),
      'todayDistance': todayDistance.toEJson(),
      'lastSpeed': lastSpeed.toEJson(),
      'lastUpdate': lastUpdate.toEJson(),
      'isExpiringSoon': isExpiringSoon.toEJson(),
      'address': address.toEJson(),
      'category': category.toEJson(),
      'course': course.toEJson(),
      'expired': expired.toEJson(),
      'externalId': externalId.toEJson(),
      'filterStatus': filterStatus.toEJson(),
      'idleFixTimeKey': idleFixTimeKey.toEJson(),
      'ignition': ignition.toEJson(),
      'lastRenewalDate': lastRenewalDate.toEJson(),
      'posAttr': posAttr.toEJson(),
      'prevOdometer': prevOdometer.toEJson(),
      'protocol': protocol.toEJson(),
      'subscriptionExpiryDate': subscriptionExpiryDate.toEJson(),
      'totalDistance': totalDistance.toEJson(),
      'tripName': tripName.toEJson(),
      'uniqueId': uniqueId.toEJson(),
      'valid': valid.toEJson(),
      'alarm': alarm.toEJson(),
      'deviceStatus': deviceStatus.toEJson(),
      'fixTime': fixTime.toEJson(),
      'geofenceIds': geofenceIds.toEJson(),
      'harshAccelerations': harshAccelerations.toEJson(),
      'harshBrakings': harshBrakings.toEJson(),
      'harshCornerings': harshCornerings.toEJson(),
      'idleFixTime': idleFixTime.toEJson(),
      'lastIgnitionOffFixTime': lastIgnitionOffFixTime.toEJson(),
      'lastIgnitionOnFixTime': lastIgnitionOnFixTime.toEJson(),
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
      'network': network.toEJson(),
      'overSpeeds': overSpeeds.toEJson(),
      'pushedtoServer': pushedtoServer.toEJson(),
      'serverTime': serverTime.toEJson(),
      'tmp': tmp.toEJson(),
      'contact': contact.toEJson(),
      'dateAdded': dateAdded.toEJson(),
      'disabled': disabled.toEJson(),
      'groupId': groupId.toEJson(),
      'lastUpdateRfc3339': lastUpdateRfc3339.toEJson(),
      'model': model.toEJson(),
      'phone': phone.toEJson(),
      'positionId': positionId.toEJson(),
      'statusCode': statusCode.toEJson(),
      'batteryPercent': batteryPercent.toEJson(),
      'idleTime': idleTime.toEJson(),
      'attributes': attributes.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsCombinedVehicleRealmData value) =>
      value.toEJson();
  static GpsCombinedVehicleRealmData _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'deviceId': EJsonValue deviceId} => GpsCombinedVehicleRealmData(
        fromEJson(ejson['deviceId']),
        vehicleNumber: fromEJson(ejson['vehicleNumber']),
        status: fromEJson(ejson['status']),
        statusDuration: fromEJson(ejson['statusDuration']),
        location: fromEJson(ejson['location']),
        networkSignal: fromEJson(ejson['networkSignal']),
        hasGPS: fromEJson(ejson['hasGPS']),
        odoReading: fromEJson(ejson['odoReading']),
        todayDistance: fromEJson(ejson['todayDistance']),
        lastSpeed: fromEJson(ejson['lastSpeed']),
        lastUpdate: fromEJson(ejson['lastUpdate']),
        isExpiringSoon: fromEJson(ejson['isExpiringSoon']),
        address: fromEJson(ejson['address']),
        category: fromEJson(ejson['category']),
        course: fromEJson(ejson['course']),
        expired: fromEJson(ejson['expired']),
        externalId: fromEJson(ejson['externalId']),
        filterStatus: fromEJson(ejson['filterStatus']),
        idleFixTimeKey: fromEJson(ejson['idleFixTimeKey']),
        ignition: fromEJson(ejson['ignition']),
        lastRenewalDate: fromEJson(ejson['lastRenewalDate']),
        posAttr: fromEJson(ejson['posAttr']),
        prevOdometer: fromEJson(ejson['prevOdometer']),
        protocol: fromEJson(ejson['protocol']),
        subscriptionExpiryDate: fromEJson(ejson['subscriptionExpiryDate']),
        totalDistance: fromEJson(ejson['totalDistance']),
        tripName: fromEJson(ejson['tripName']),
        uniqueId: fromEJson(ejson['uniqueId']),
        valid: fromEJson(ejson['valid']),
        alarm: fromEJson(ejson['alarm']),
        deviceStatus: fromEJson(ejson['deviceStatus']),
        fixTime: fromEJson(ejson['fixTime']),
        geofenceIds: fromEJson(ejson['geofenceIds']),
        harshAccelerations: fromEJson(ejson['harshAccelerations']),
        harshBrakings: fromEJson(ejson['harshBrakings']),
        harshCornerings: fromEJson(ejson['harshCornerings']),
        idleFixTime: fromEJson(ejson['idleFixTime']),
        lastIgnitionOffFixTime: fromEJson(ejson['lastIgnitionOffFixTime']),
        lastIgnitionOnFixTime: fromEJson(ejson['lastIgnitionOnFixTime']),
        latitude: fromEJson(ejson['latitude']),
        longitude: fromEJson(ejson['longitude']),
        network: fromEJson(ejson['network']),
        overSpeeds: fromEJson(ejson['overSpeeds']),
        pushedtoServer: fromEJson(ejson['pushedtoServer']),
        serverTime: fromEJson(ejson['serverTime']),
        tmp: fromEJson(ejson['tmp']),
        contact: fromEJson(ejson['contact']),
        dateAdded: fromEJson(ejson['dateAdded']),
        disabled: fromEJson(ejson['disabled']),
        groupId: fromEJson(ejson['groupId']),
        lastUpdateRfc3339: fromEJson(ejson['lastUpdateRfc3339']),
        model: fromEJson(ejson['model']),
        phone: fromEJson(ejson['phone']),
        positionId: fromEJson(ejson['positionId']),
        statusCode: fromEJson(ejson['statusCode']),
        batteryPercent: fromEJson(ejson['batteryPercent']),
        idleTime: fromEJson(ejson['idleTime']),
        attributes: fromEJson(ejson['attributes']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsCombinedVehicleRealmData._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsCombinedVehicleRealmData,
      'GpsCombinedVehicleRealmData',
      [
        SchemaProperty(
          'deviceId',
          RealmPropertyType.int,
          optional: true,
          primaryKey: true,
        ),
        SchemaProperty(
          'vehicleNumber',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('status', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'statusDuration',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('location', RealmPropertyType.string, optional: true),
        SchemaProperty('networkSignal', RealmPropertyType.int, optional: true),
        SchemaProperty('hasGPS', RealmPropertyType.bool, optional: true),
        SchemaProperty('odoReading', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'todayDistance',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('lastSpeed', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'lastUpdate',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty(
          'isExpiringSoon',
          RealmPropertyType.bool,
          optional: true,
        ),
        SchemaProperty('address', RealmPropertyType.string, optional: true),
        SchemaProperty('category', RealmPropertyType.string, optional: true),
        SchemaProperty('course', RealmPropertyType.string, optional: true),
        SchemaProperty('expired', RealmPropertyType.bool, optional: true),
        SchemaProperty('externalId', RealmPropertyType.string, optional: true),
        SchemaProperty('filterStatus', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'idleFixTimeKey',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('ignition', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'lastRenewalDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('posAttr', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'prevOdometer',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('protocol', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'subscriptionExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'totalDistance',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('tripName', RealmPropertyType.string, optional: true),
        SchemaProperty('uniqueId', RealmPropertyType.string, optional: true),
        SchemaProperty('valid', RealmPropertyType.string, optional: true),
        SchemaProperty('alarm', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'deviceStatus',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('fixTime', RealmPropertyType.string, optional: true),
        SchemaProperty('geofenceIds', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'harshAccelerations',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'harshBrakings',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'harshCornerings',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('idleFixTime', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'lastIgnitionOffFixTime',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'lastIgnitionOnFixTime',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('latitude', RealmPropertyType.string, optional: true),
        SchemaProperty('longitude', RealmPropertyType.string, optional: true),
        SchemaProperty('network', RealmPropertyType.string, optional: true),
        SchemaProperty('overSpeeds', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'pushedtoServer',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('serverTime', RealmPropertyType.string, optional: true),
        SchemaProperty('tmp', RealmPropertyType.string, optional: true),
        SchemaProperty('contact', RealmPropertyType.string, optional: true),
        SchemaProperty('dateAdded', RealmPropertyType.string, optional: true),
        SchemaProperty('disabled', RealmPropertyType.int, optional: true),
        SchemaProperty('groupId', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'lastUpdateRfc3339',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('model', RealmPropertyType.string, optional: true),
        SchemaProperty('phone', RealmPropertyType.string, optional: true),
        SchemaProperty('positionId', RealmPropertyType.int, optional: true),
        SchemaProperty('statusCode', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'batteryPercent',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('idleTime', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'attributes',
          RealmPropertyType.object,
          optional: true,
          linkTarget: 'GpsDeviceAttributesRealm',
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class GpsDeviceAttributesRealm extends _GpsDeviceAttributesRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsDeviceAttributesRealm({
    int? prevHours,
    double? prevOdometer,
    String? resetDate,
    String? speedLimit,
  }) {
    RealmObjectBase.set(this, 'prevHours', prevHours);
    RealmObjectBase.set(this, 'prevOdometer', prevOdometer);
    RealmObjectBase.set(this, 'resetDate', resetDate);
    RealmObjectBase.set(this, 'speedLimit', speedLimit);
  }

  GpsDeviceAttributesRealm._();

  @override
  int? get prevHours => RealmObjectBase.get<int>(this, 'prevHours') as int?;
  @override
  set prevHours(int? value) => RealmObjectBase.set(this, 'prevHours', value);

  @override
  double? get prevOdometer =>
      RealmObjectBase.get<double>(this, 'prevOdometer') as double?;
  @override
  set prevOdometer(double? value) =>
      RealmObjectBase.set(this, 'prevOdometer', value);

  @override
  String? get resetDate =>
      RealmObjectBase.get<String>(this, 'resetDate') as String?;
  @override
  set resetDate(String? value) => RealmObjectBase.set(this, 'resetDate', value);

  @override
  String? get speedLimit =>
      RealmObjectBase.get<String>(this, 'speedLimit') as String?;
  @override
  set speedLimit(String? value) =>
      RealmObjectBase.set(this, 'speedLimit', value);

  @override
  Stream<RealmObjectChanges<GpsDeviceAttributesRealm>> get changes =>
      RealmObjectBase.getChanges<GpsDeviceAttributesRealm>(this);

  @override
  Stream<RealmObjectChanges<GpsDeviceAttributesRealm>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsDeviceAttributesRealm>(this, keyPaths);

  @override
  GpsDeviceAttributesRealm freeze() =>
      RealmObjectBase.freezeObject<GpsDeviceAttributesRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'prevHours': prevHours.toEJson(),
      'prevOdometer': prevOdometer.toEJson(),
      'resetDate': resetDate.toEJson(),
      'speedLimit': speedLimit.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsDeviceAttributesRealm value) => value.toEJson();
  static GpsDeviceAttributesRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return GpsDeviceAttributesRealm(
      prevHours: fromEJson(ejson['prevHours']),
      prevOdometer: fromEJson(ejson['prevOdometer']),
      resetDate: fromEJson(ejson['resetDate']),
      speedLimit: fromEJson(ejson['speedLimit']),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsDeviceAttributesRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsDeviceAttributesRealm,
      'GpsDeviceAttributesRealm',
      [
        SchemaProperty('prevHours', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'prevOdometer',
          RealmPropertyType.double,
          optional: true,
        ),
        SchemaProperty('resetDate', RealmPropertyType.string, optional: true),
        SchemaProperty('speedLimit', RealmPropertyType.string, optional: true),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
