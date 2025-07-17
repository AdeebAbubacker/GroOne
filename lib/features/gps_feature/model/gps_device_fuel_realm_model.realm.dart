// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_device_fuel_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsDeviceFuelRealmModel extends _GpsDeviceFuelRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsDeviceFuelRealmModel(
    ObjectId id,
    DateTime createdAt, {
    int? fuelId,
    String? amount,
    int? deviceId,
    String? fuelFilled,
    String? fuelType,
    String? imageName,
    String? mileage,
    String? paymentType,
    String? pricePerLitre,
    DateTime? timestamp,
    String? totalDistance,
    String? totalEngineSeconds,
    String? transactionId,
    DateTime? updateTime,
    int? userId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'fuelId', fuelId);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'fuelFilled', fuelFilled);
    RealmObjectBase.set(this, 'fuelType', fuelType);
    RealmObjectBase.set(this, 'imageName', imageName);
    RealmObjectBase.set(this, 'mileage', mileage);
    RealmObjectBase.set(this, 'paymentType', paymentType);
    RealmObjectBase.set(this, 'pricePerLitre', pricePerLitre);
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'totalDistance', totalDistance);
    RealmObjectBase.set(this, 'totalEngineSeconds', totalEngineSeconds);
    RealmObjectBase.set(this, 'transactionId', transactionId);
    RealmObjectBase.set(this, 'updateTime', updateTime);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsDeviceFuelRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get fuelId => RealmObjectBase.get<int>(this, 'fuelId') as int?;
  @override
  set fuelId(int? value) => RealmObjectBase.set(this, 'fuelId', value);

  @override
  String? get amount => RealmObjectBase.get<String>(this, 'amount') as String?;
  @override
  set amount(String? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  int? get deviceId => RealmObjectBase.get<int>(this, 'deviceId') as int?;
  @override
  set deviceId(int? value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String? get fuelFilled =>
      RealmObjectBase.get<String>(this, 'fuelFilled') as String?;
  @override
  set fuelFilled(String? value) =>
      RealmObjectBase.set(this, 'fuelFilled', value);

  @override
  String? get fuelType =>
      RealmObjectBase.get<String>(this, 'fuelType') as String?;
  @override
  set fuelType(String? value) => RealmObjectBase.set(this, 'fuelType', value);

  @override
  String? get imageName =>
      RealmObjectBase.get<String>(this, 'imageName') as String?;
  @override
  set imageName(String? value) => RealmObjectBase.set(this, 'imageName', value);

  @override
  String? get mileage =>
      RealmObjectBase.get<String>(this, 'mileage') as String?;
  @override
  set mileage(String? value) => RealmObjectBase.set(this, 'mileage', value);

  @override
  String? get paymentType =>
      RealmObjectBase.get<String>(this, 'paymentType') as String?;
  @override
  set paymentType(String? value) =>
      RealmObjectBase.set(this, 'paymentType', value);

  @override
  String? get pricePerLitre =>
      RealmObjectBase.get<String>(this, 'pricePerLitre') as String?;
  @override
  set pricePerLitre(String? value) =>
      RealmObjectBase.set(this, 'pricePerLitre', value);

  @override
  DateTime? get timestamp =>
      RealmObjectBase.get<DateTime>(this, 'timestamp') as DateTime?;
  @override
  set timestamp(DateTime? value) =>
      RealmObjectBase.set(this, 'timestamp', value);

  @override
  String? get totalDistance =>
      RealmObjectBase.get<String>(this, 'totalDistance') as String?;
  @override
  set totalDistance(String? value) =>
      RealmObjectBase.set(this, 'totalDistance', value);

  @override
  String? get totalEngineSeconds =>
      RealmObjectBase.get<String>(this, 'totalEngineSeconds') as String?;
  @override
  set totalEngineSeconds(String? value) =>
      RealmObjectBase.set(this, 'totalEngineSeconds', value);

  @override
  String? get transactionId =>
      RealmObjectBase.get<String>(this, 'transactionId') as String?;
  @override
  set transactionId(String? value) =>
      RealmObjectBase.set(this, 'transactionId', value);

  @override
  DateTime? get updateTime =>
      RealmObjectBase.get<DateTime>(this, 'updateTime') as DateTime?;
  @override
  set updateTime(DateTime? value) =>
      RealmObjectBase.set(this, 'updateTime', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsDeviceFuelRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsDeviceFuelRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsDeviceFuelRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsDeviceFuelRealmModel>(this, keyPaths);

  @override
  GpsDeviceFuelRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsDeviceFuelRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'fuelId': fuelId.toEJson(),
      'amount': amount.toEJson(),
      'deviceId': deviceId.toEJson(),
      'fuelFilled': fuelFilled.toEJson(),
      'fuelType': fuelType.toEJson(),
      'imageName': imageName.toEJson(),
      'mileage': mileage.toEJson(),
      'paymentType': paymentType.toEJson(),
      'pricePerLitre': pricePerLitre.toEJson(),
      'timestamp': timestamp.toEJson(),
      'totalDistance': totalDistance.toEJson(),
      'totalEngineSeconds': totalEngineSeconds.toEJson(),
      'transactionId': transactionId.toEJson(),
      'updateTime': updateTime.toEJson(),
      'userId': userId.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsDeviceFuelRealmModel value) => value.toEJson();
  static GpsDeviceFuelRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsDeviceFuelRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          fuelId: fromEJson(ejson['fuelId']),
          amount: fromEJson(ejson['amount']),
          deviceId: fromEJson(ejson['deviceId']),
          fuelFilled: fromEJson(ejson['fuelFilled']),
          fuelType: fromEJson(ejson['fuelType']),
          imageName: fromEJson(ejson['imageName']),
          mileage: fromEJson(ejson['mileage']),
          paymentType: fromEJson(ejson['paymentType']),
          pricePerLitre: fromEJson(ejson['pricePerLitre']),
          timestamp: fromEJson(ejson['timestamp']),
          totalDistance: fromEJson(ejson['totalDistance']),
          totalEngineSeconds: fromEJson(ejson['totalEngineSeconds']),
          transactionId: fromEJson(ejson['transactionId']),
          updateTime: fromEJson(ejson['updateTime']),
          userId: fromEJson(ejson['userId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsDeviceFuelRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsDeviceFuelRealmModel,
      'GpsDeviceFuelRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('fuelId', RealmPropertyType.int, optional: true),
        SchemaProperty('amount', RealmPropertyType.string, optional: true),
        SchemaProperty('deviceId', RealmPropertyType.int, optional: true),
        SchemaProperty('fuelFilled', RealmPropertyType.string, optional: true),
        SchemaProperty('fuelType', RealmPropertyType.string, optional: true),
        SchemaProperty('imageName', RealmPropertyType.string, optional: true),
        SchemaProperty('mileage', RealmPropertyType.string, optional: true),
        SchemaProperty('paymentType', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'pricePerLitre',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'timestamp',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty(
          'totalDistance',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'totalEngineSeconds',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'transactionId',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'updateTime',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty('userId', RealmPropertyType.int, optional: true),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
