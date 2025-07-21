// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_report_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class DistanceReportRealmModel extends _DistanceReportRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  DistanceReportRealmModel(
    ObjectId id,
    String deviceId,
    int dateTime,
    double distance,
    String deviceName,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'dateTime', dateTime);
    RealmObjectBase.set(this, 'distance', distance);
    RealmObjectBase.set(this, 'deviceName', deviceName);
  }

  DistanceReportRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get deviceId =>
      RealmObjectBase.get<String>(this, 'deviceId') as String;
  @override
  set deviceId(String value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  int get dateTime => RealmObjectBase.get<int>(this, 'dateTime') as int;
  @override
  set dateTime(int value) => RealmObjectBase.set(this, 'dateTime', value);

  @override
  double get distance =>
      RealmObjectBase.get<double>(this, 'distance') as double;
  @override
  set distance(double value) => RealmObjectBase.set(this, 'distance', value);

  @override
  String get deviceName =>
      RealmObjectBase.get<String>(this, 'deviceName') as String;
  @override
  set deviceName(String value) =>
      RealmObjectBase.set(this, 'deviceName', value);

  @override
  Stream<RealmObjectChanges<DistanceReportRealmModel>> get changes =>
      RealmObjectBase.getChanges<DistanceReportRealmModel>(this);

  @override
  Stream<RealmObjectChanges<DistanceReportRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<DistanceReportRealmModel>(this, keyPaths);

  @override
  DistanceReportRealmModel freeze() =>
      RealmObjectBase.freezeObject<DistanceReportRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'deviceId': deviceId.toEJson(),
      'dateTime': dateTime.toEJson(),
      'distance': distance.toEJson(),
      'deviceName': deviceName.toEJson(),
    };
  }

  static EJsonValue _toEJson(DistanceReportRealmModel value) => value.toEJson();
  static DistanceReportRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'deviceId': EJsonValue deviceId,
        'dateTime': EJsonValue dateTime,
        'distance': EJsonValue distance,
        'deviceName': EJsonValue deviceName,
      } =>
        DistanceReportRealmModel(
          fromEJson(id),
          fromEJson(deviceId),
          fromEJson(dateTime),
          fromEJson(distance),
          fromEJson(deviceName),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DistanceReportRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      DistanceReportRealmModel,
      'DistanceReportRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('deviceId', RealmPropertyType.string),
        SchemaProperty('dateTime', RealmPropertyType.int),
        SchemaProperty('distance', RealmPropertyType.double),
        SchemaProperty('deviceName', RealmPropertyType.string),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
