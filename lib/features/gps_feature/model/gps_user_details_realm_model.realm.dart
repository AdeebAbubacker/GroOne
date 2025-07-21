// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_user_details_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsUserDetailsRealmModel extends _GpsUserDetailsRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsUserDetailsRealmModel(
    ObjectId id,
    DateTime createdAt, {
    int? userId,
    String? name,
    String? email,
    int? disabled,
    String? attributesEmail,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'disabled', disabled);
    RealmObjectBase.set(this, 'attributesEmail', attributesEmail);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsUserDetailsRealmModel._();

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
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  int? get disabled => RealmObjectBase.get<int>(this, 'disabled') as int?;
  @override
  set disabled(int? value) => RealmObjectBase.set(this, 'disabled', value);

  @override
  String? get attributesEmail =>
      RealmObjectBase.get<String>(this, 'attributesEmail') as String?;
  @override
  set attributesEmail(String? value) =>
      RealmObjectBase.set(this, 'attributesEmail', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsUserDetailsRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsUserDetailsRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsUserDetailsRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsUserDetailsRealmModel>(this, keyPaths);

  @override
  GpsUserDetailsRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsUserDetailsRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'name': name.toEJson(),
      'email': email.toEJson(),
      'disabled': disabled.toEJson(),
      'attributesEmail': attributesEmail.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsUserDetailsRealmModel value) => value.toEJson();
  static GpsUserDetailsRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsUserDetailsRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          userId: fromEJson(ejson['userId']),
          name: fromEJson(ejson['name']),
          email: fromEJson(ejson['email']),
          disabled: fromEJson(ejson['disabled']),
          attributesEmail: fromEJson(ejson['attributesEmail']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsUserDetailsRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsUserDetailsRealmModel,
      'GpsUserDetailsRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('userId', RealmPropertyType.int, optional: true),
        SchemaProperty('name', RealmPropertyType.string, optional: true),
        SchemaProperty('email', RealmPropertyType.string, optional: true),
        SchemaProperty('disabled', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'attributesEmail',
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
