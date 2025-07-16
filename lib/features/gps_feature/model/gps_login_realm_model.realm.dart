// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_login_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsLoginResponseRealmModel extends _GpsLoginResponseRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsLoginResponseRealmModel(
    ObjectId id,
    String token,
    String refreshToken,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'token', token);
    RealmObjectBase.set(this, 'refreshToken', refreshToken);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsLoginResponseRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get token => RealmObjectBase.get<String>(this, 'token') as String;
  @override
  set token(String value) => RealmObjectBase.set(this, 'token', value);

  @override
  String get refreshToken =>
      RealmObjectBase.get<String>(this, 'refreshToken') as String;
  @override
  set refreshToken(String value) =>
      RealmObjectBase.set(this, 'refreshToken', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsLoginResponseRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsLoginResponseRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsLoginResponseRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) =>
      RealmObjectBase.getChangesFor<GpsLoginResponseRealmModel>(this, keyPaths);

  @override
  GpsLoginResponseRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsLoginResponseRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'token': token.toEJson(),
      'refreshToken': refreshToken.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsLoginResponseRealmModel value) =>
      value.toEJson();
  static GpsLoginResponseRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'token': EJsonValue token,
        'refreshToken': EJsonValue refreshToken,
        'createdAt': EJsonValue createdAt,
      } =>
        GpsLoginResponseRealmModel(
          fromEJson(id),
          fromEJson(token),
          fromEJson(refreshToken),
          fromEJson(createdAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsLoginResponseRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsLoginResponseRealmModel,
      'GpsLoginResponseRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('token', RealmPropertyType.string),
        SchemaProperty('refreshToken', RealmPropertyType.string),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
