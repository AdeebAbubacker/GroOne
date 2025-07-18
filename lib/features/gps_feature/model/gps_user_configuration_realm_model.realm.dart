// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_user_configuration_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsUserConfigurationRealmModel extends _GpsUserConfigurationRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsUserConfigurationRealmModel(
    ObjectId id,
    DateTime createdAt, {
    int? userId,
    String? name,
    String? defaultMap,
    String? alternateEmail,
    int? companyId,
    int? deviceLimitTotal,
    int? deviceLimitUsed,
    int? userLimitTotal,
    int? userLimitUsed,
    String? webMenuDashboardUrl,
    String? webMenuGeofenceUrl,
    String? webMenuReportsUrl,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'defaultMap', defaultMap);
    RealmObjectBase.set(this, 'alternateEmail', alternateEmail);
    RealmObjectBase.set(this, 'companyId', companyId);
    RealmObjectBase.set(this, 'deviceLimitTotal', deviceLimitTotal);
    RealmObjectBase.set(this, 'deviceLimitUsed', deviceLimitUsed);
    RealmObjectBase.set(this, 'userLimitTotal', userLimitTotal);
    RealmObjectBase.set(this, 'userLimitUsed', userLimitUsed);
    RealmObjectBase.set(this, 'webMenuDashboardUrl', webMenuDashboardUrl);
    RealmObjectBase.set(this, 'webMenuGeofenceUrl', webMenuGeofenceUrl);
    RealmObjectBase.set(this, 'webMenuReportsUrl', webMenuReportsUrl);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsUserConfigurationRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get defaultMap =>
      RealmObjectBase.get<String>(this, 'defaultMap') as String?;
  @override
  set defaultMap(String? value) =>
      RealmObjectBase.set(this, 'defaultMap', value);

  @override
  String? get alternateEmail =>
      RealmObjectBase.get<String>(this, 'alternateEmail') as String?;
  @override
  set alternateEmail(String? value) =>
      RealmObjectBase.set(this, 'alternateEmail', value);

  @override
  int? get companyId => RealmObjectBase.get<int>(this, 'companyId') as int?;
  @override
  set companyId(int? value) => RealmObjectBase.set(this, 'companyId', value);

  @override
  int? get deviceLimitTotal =>
      RealmObjectBase.get<int>(this, 'deviceLimitTotal') as int?;
  @override
  set deviceLimitTotal(int? value) =>
      RealmObjectBase.set(this, 'deviceLimitTotal', value);

  @override
  int? get deviceLimitUsed =>
      RealmObjectBase.get<int>(this, 'deviceLimitUsed') as int?;
  @override
  set deviceLimitUsed(int? value) =>
      RealmObjectBase.set(this, 'deviceLimitUsed', value);

  @override
  int? get userLimitTotal =>
      RealmObjectBase.get<int>(this, 'userLimitTotal') as int?;
  @override
  set userLimitTotal(int? value) =>
      RealmObjectBase.set(this, 'userLimitTotal', value);

  @override
  int? get userLimitUsed =>
      RealmObjectBase.get<int>(this, 'userLimitUsed') as int?;
  @override
  set userLimitUsed(int? value) =>
      RealmObjectBase.set(this, 'userLimitUsed', value);

  @override
  String? get webMenuDashboardUrl =>
      RealmObjectBase.get<String>(this, 'webMenuDashboardUrl') as String?;
  @override
  set webMenuDashboardUrl(String? value) =>
      RealmObjectBase.set(this, 'webMenuDashboardUrl', value);

  @override
  String? get webMenuGeofenceUrl =>
      RealmObjectBase.get<String>(this, 'webMenuGeofenceUrl') as String?;
  @override
  set webMenuGeofenceUrl(String? value) =>
      RealmObjectBase.set(this, 'webMenuGeofenceUrl', value);

  @override
  String? get webMenuReportsUrl =>
      RealmObjectBase.get<String>(this, 'webMenuReportsUrl') as String?;
  @override
  set webMenuReportsUrl(String? value) =>
      RealmObjectBase.set(this, 'webMenuReportsUrl', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsUserConfigurationRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsUserConfigurationRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsUserConfigurationRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsUserConfigurationRealmModel>(
    this,
    keyPaths,
  );

  @override
  GpsUserConfigurationRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsUserConfigurationRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'name': name.toEJson(),
      'defaultMap': defaultMap.toEJson(),
      'alternateEmail': alternateEmail.toEJson(),
      'companyId': companyId.toEJson(),
      'deviceLimitTotal': deviceLimitTotal.toEJson(),
      'deviceLimitUsed': deviceLimitUsed.toEJson(),
      'userLimitTotal': userLimitTotal.toEJson(),
      'userLimitUsed': userLimitUsed.toEJson(),
      'webMenuDashboardUrl': webMenuDashboardUrl.toEJson(),
      'webMenuGeofenceUrl': webMenuGeofenceUrl.toEJson(),
      'webMenuReportsUrl': webMenuReportsUrl.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsUserConfigurationRealmModel value) =>
      value.toEJson();
  static GpsUserConfigurationRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsUserConfigurationRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          userId: fromEJson(ejson['userId']),
          name: fromEJson(ejson['name']),
          defaultMap: fromEJson(ejson['defaultMap']),
          alternateEmail: fromEJson(ejson['alternateEmail']),
          companyId: fromEJson(ejson['companyId']),
          deviceLimitTotal: fromEJson(ejson['deviceLimitTotal']),
          deviceLimitUsed: fromEJson(ejson['deviceLimitUsed']),
          userLimitTotal: fromEJson(ejson['userLimitTotal']),
          userLimitUsed: fromEJson(ejson['userLimitUsed']),
          webMenuDashboardUrl: fromEJson(ejson['webMenuDashboardUrl']),
          webMenuGeofenceUrl: fromEJson(ejson['webMenuGeofenceUrl']),
          webMenuReportsUrl: fromEJson(ejson['webMenuReportsUrl']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsUserConfigurationRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsUserConfigurationRealmModel,
      'GpsUserConfigurationRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('userId', RealmPropertyType.int, optional: true),
        SchemaProperty('name', RealmPropertyType.string, optional: true),
        SchemaProperty('defaultMap', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'alternateEmail',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('companyId', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'deviceLimitTotal',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'deviceLimitUsed',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty('userLimitTotal', RealmPropertyType.int, optional: true),
        SchemaProperty('userLimitUsed', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'webMenuDashboardUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'webMenuGeofenceUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'webMenuReportsUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
