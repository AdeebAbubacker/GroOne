// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_distance_history_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsDistanceHistoryRealmModel extends _GpsDistanceHistoryRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsDistanceHistoryRealmModel(
    ObjectId id,
    int deviceId,
    String vehicleNumber,
    double distance,
    DateTime date,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'vehicleNumber', vehicleNumber);
    RealmObjectBase.set(this, 'distance', distance);
    RealmObjectBase.set(this, 'date', date);
  }

  GpsDistanceHistoryRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get deviceId => RealmObjectBase.get<int>(this, 'deviceId') as int;
  @override
  set deviceId(int value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String get vehicleNumber =>
      RealmObjectBase.get<String>(this, 'vehicleNumber') as String;
  @override
  set vehicleNumber(String value) =>
      RealmObjectBase.set(this, 'vehicleNumber', value);

  @override
  double get distance =>
      RealmObjectBase.get<double>(this, 'distance') as double;
  @override
  set distance(double value) => RealmObjectBase.set(this, 'distance', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  Stream<RealmObjectChanges<GpsDistanceHistoryRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsDistanceHistoryRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsDistanceHistoryRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsDistanceHistoryRealmModel>(
    this,
    keyPaths,
  );

  @override
  GpsDistanceHistoryRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsDistanceHistoryRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'deviceId': deviceId.toEJson(),
      'vehicleNumber': vehicleNumber.toEJson(),
      'distance': distance.toEJson(),
      'date': date.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsDistanceHistoryRealmModel value) =>
      value.toEJson();
  static GpsDistanceHistoryRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'deviceId': EJsonValue deviceId,
        'vehicleNumber': EJsonValue vehicleNumber,
        'distance': EJsonValue distance,
        'date': EJsonValue date,
      } =>
        GpsDistanceHistoryRealmModel(
          fromEJson(id),
          fromEJson(deviceId),
          fromEJson(vehicleNumber),
          fromEJson(distance),
          fromEJson(date),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsDistanceHistoryRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsDistanceHistoryRealmModel,
      'GpsDistanceHistoryRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('deviceId', RealmPropertyType.int),
        SchemaProperty('vehicleNumber', RealmPropertyType.string),
        SchemaProperty('distance', RealmPropertyType.double),
        SchemaProperty('date', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
