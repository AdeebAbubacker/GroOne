// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_mobile_config_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsMobileConfigRealmModel extends _GpsMobileConfigRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsMobileConfigRealmModel(
    ObjectId id,
    DateTime createdAt, {
    String? faqUrl,
    String? whiteLabelUrl,
    bool? reportActive,
    bool? subscriptionActive,
    String? freshChatId,
    String? freshChatKey,
    String? supportEmail,
    String? supportMobile,
    String? supportWebsiteUrl,
    String? supportWhatsapp,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'faqUrl', faqUrl);
    RealmObjectBase.set(this, 'whiteLabelUrl', whiteLabelUrl);
    RealmObjectBase.set(this, 'reportActive', reportActive);
    RealmObjectBase.set(this, 'subscriptionActive', subscriptionActive);
    RealmObjectBase.set(this, 'freshChatId', freshChatId);
    RealmObjectBase.set(this, 'freshChatKey', freshChatKey);
    RealmObjectBase.set(this, 'supportEmail', supportEmail);
    RealmObjectBase.set(this, 'supportMobile', supportMobile);
    RealmObjectBase.set(this, 'supportWebsiteUrl', supportWebsiteUrl);
    RealmObjectBase.set(this, 'supportWhatsapp', supportWhatsapp);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsMobileConfigRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get faqUrl => RealmObjectBase.get<String>(this, 'faqUrl') as String?;
  @override
  set faqUrl(String? value) => RealmObjectBase.set(this, 'faqUrl', value);

  @override
  String? get whiteLabelUrl =>
      RealmObjectBase.get<String>(this, 'whiteLabelUrl') as String?;
  @override
  set whiteLabelUrl(String? value) =>
      RealmObjectBase.set(this, 'whiteLabelUrl', value);

  @override
  bool? get reportActive =>
      RealmObjectBase.get<bool>(this, 'reportActive') as bool?;
  @override
  set reportActive(bool? value) =>
      RealmObjectBase.set(this, 'reportActive', value);

  @override
  bool? get subscriptionActive =>
      RealmObjectBase.get<bool>(this, 'subscriptionActive') as bool?;
  @override
  set subscriptionActive(bool? value) =>
      RealmObjectBase.set(this, 'subscriptionActive', value);

  @override
  String? get freshChatId =>
      RealmObjectBase.get<String>(this, 'freshChatId') as String?;
  @override
  set freshChatId(String? value) =>
      RealmObjectBase.set(this, 'freshChatId', value);

  @override
  String? get freshChatKey =>
      RealmObjectBase.get<String>(this, 'freshChatKey') as String?;
  @override
  set freshChatKey(String? value) =>
      RealmObjectBase.set(this, 'freshChatKey', value);

  @override
  String? get supportEmail =>
      RealmObjectBase.get<String>(this, 'supportEmail') as String?;
  @override
  set supportEmail(String? value) =>
      RealmObjectBase.set(this, 'supportEmail', value);

  @override
  String? get supportMobile =>
      RealmObjectBase.get<String>(this, 'supportMobile') as String?;
  @override
  set supportMobile(String? value) =>
      RealmObjectBase.set(this, 'supportMobile', value);

  @override
  String? get supportWebsiteUrl =>
      RealmObjectBase.get<String>(this, 'supportWebsiteUrl') as String?;
  @override
  set supportWebsiteUrl(String? value) =>
      RealmObjectBase.set(this, 'supportWebsiteUrl', value);

  @override
  String? get supportWhatsapp =>
      RealmObjectBase.get<String>(this, 'supportWhatsapp') as String?;
  @override
  set supportWhatsapp(String? value) =>
      RealmObjectBase.set(this, 'supportWhatsapp', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsMobileConfigRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsMobileConfigRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsMobileConfigRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) =>
      RealmObjectBase.getChangesFor<GpsMobileConfigRealmModel>(this, keyPaths);

  @override
  GpsMobileConfigRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsMobileConfigRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'faqUrl': faqUrl.toEJson(),
      'whiteLabelUrl': whiteLabelUrl.toEJson(),
      'reportActive': reportActive.toEJson(),
      'subscriptionActive': subscriptionActive.toEJson(),
      'freshChatId': freshChatId.toEJson(),
      'freshChatKey': freshChatKey.toEJson(),
      'supportEmail': supportEmail.toEJson(),
      'supportMobile': supportMobile.toEJson(),
      'supportWebsiteUrl': supportWebsiteUrl.toEJson(),
      'supportWhatsapp': supportWhatsapp.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsMobileConfigRealmModel value) =>
      value.toEJson();
  static GpsMobileConfigRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsMobileConfigRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          faqUrl: fromEJson(ejson['faqUrl']),
          whiteLabelUrl: fromEJson(ejson['whiteLabelUrl']),
          reportActive: fromEJson(ejson['reportActive']),
          subscriptionActive: fromEJson(ejson['subscriptionActive']),
          freshChatId: fromEJson(ejson['freshChatId']),
          freshChatKey: fromEJson(ejson['freshChatKey']),
          supportEmail: fromEJson(ejson['supportEmail']),
          supportMobile: fromEJson(ejson['supportMobile']),
          supportWebsiteUrl: fromEJson(ejson['supportWebsiteUrl']),
          supportWhatsapp: fromEJson(ejson['supportWhatsapp']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsMobileConfigRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsMobileConfigRealmModel,
      'GpsMobileConfigRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('faqUrl', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'whiteLabelUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('reportActive', RealmPropertyType.bool, optional: true),
        SchemaProperty(
          'subscriptionActive',
          RealmPropertyType.bool,
          optional: true,
        ),
        SchemaProperty('freshChatId', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'freshChatKey',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'supportEmail',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'supportMobile',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'supportWebsiteUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'supportWhatsapp',
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
