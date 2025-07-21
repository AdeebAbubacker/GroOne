// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_geofence_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsGeofenceRealmModel extends _GpsGeofenceRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsGeofenceRealmModel(
    ObjectId id,
    DateTime createdAt, {
    String? geofenceId,
    String? name,
    String? area,
    String? shapeType,
    String? coveredArea,
    double? centerLatitude,
    double? centerLongitude,
    double? radius,
    Iterable<String> polygonPoints = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'geofenceId', geofenceId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'area', area);
    RealmObjectBase.set(this, 'shapeType', shapeType);
    RealmObjectBase.set(this, 'coveredArea', coveredArea);
    RealmObjectBase.set(this, 'centerLatitude', centerLatitude);
    RealmObjectBase.set(this, 'centerLongitude', centerLongitude);
    RealmObjectBase.set(this, 'radius', radius);
    RealmObjectBase.set<RealmList<String>>(
      this,
      'polygonPoints',
      RealmList<String>(polygonPoints),
    );
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsGeofenceRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get geofenceId =>
      RealmObjectBase.get<String>(this, 'geofenceId') as String?;
  @override
  set geofenceId(String? value) =>
      RealmObjectBase.set(this, 'geofenceId', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get area => RealmObjectBase.get<String>(this, 'area') as String?;
  @override
  set area(String? value) => RealmObjectBase.set(this, 'area', value);

  @override
  String? get shapeType =>
      RealmObjectBase.get<String>(this, 'shapeType') as String?;
  @override
  set shapeType(String? value) => RealmObjectBase.set(this, 'shapeType', value);

  @override
  String? get coveredArea =>
      RealmObjectBase.get<String>(this, 'coveredArea') as String?;
  @override
  set coveredArea(String? value) =>
      RealmObjectBase.set(this, 'coveredArea', value);

  @override
  double? get centerLatitude =>
      RealmObjectBase.get<double>(this, 'centerLatitude') as double?;
  @override
  set centerLatitude(double? value) =>
      RealmObjectBase.set(this, 'centerLatitude', value);

  @override
  double? get centerLongitude =>
      RealmObjectBase.get<double>(this, 'centerLongitude') as double?;
  @override
  set centerLongitude(double? value) =>
      RealmObjectBase.set(this, 'centerLongitude', value);

  @override
  double? get radius => RealmObjectBase.get<double>(this, 'radius') as double?;
  @override
  set radius(double? value) => RealmObjectBase.set(this, 'radius', value);

  @override
  RealmList<String> get polygonPoints =>
      RealmObjectBase.get<String>(this, 'polygonPoints') as RealmList<String>;
  @override
  set polygonPoints(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsGeofenceRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsGeofenceRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsGeofenceRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsGeofenceRealmModel>(this, keyPaths);

  @override
  GpsGeofenceRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsGeofenceRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'geofenceId': geofenceId.toEJson(),
      'name': name.toEJson(),
      'area': area.toEJson(),
      'shapeType': shapeType.toEJson(),
      'coveredArea': coveredArea.toEJson(),
      'centerLatitude': centerLatitude.toEJson(),
      'centerLongitude': centerLongitude.toEJson(),
      'radius': radius.toEJson(),
      'polygonPoints': polygonPoints.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsGeofenceRealmModel value) => value.toEJson();
  static GpsGeofenceRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsGeofenceRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          geofenceId: fromEJson(ejson['geofenceId']),
          name: fromEJson(ejson['name']),
          area: fromEJson(ejson['area']),
          shapeType: fromEJson(ejson['shapeType']),
          coveredArea: fromEJson(ejson['coveredArea']),
          centerLatitude: fromEJson(ejson['centerLatitude']),
          centerLongitude: fromEJson(ejson['centerLongitude']),
          radius: fromEJson(ejson['radius']),
          polygonPoints: fromEJson(
            ejson['polygonPoints'],
            defaultValue: const [],
          ),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsGeofenceRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsGeofenceRealmModel,
      'GpsGeofenceRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('geofenceId', RealmPropertyType.string, optional: true),
        SchemaProperty('name', RealmPropertyType.string, optional: true),
        SchemaProperty('area', RealmPropertyType.string, optional: true),
        SchemaProperty('shapeType', RealmPropertyType.string, optional: true),
        SchemaProperty('coveredArea', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'centerLatitude',
          RealmPropertyType.double,
          optional: true,
        ),
        SchemaProperty(
          'centerLongitude',
          RealmPropertyType.double,
          optional: true,
        ),
        SchemaProperty('radius', RealmPropertyType.double, optional: true),
        SchemaProperty(
          'polygonPoints',
          RealmPropertyType.string,
          collectionType: RealmCollectionType.list,
        ),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
