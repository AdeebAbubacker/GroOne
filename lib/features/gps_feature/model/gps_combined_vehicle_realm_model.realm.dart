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
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
