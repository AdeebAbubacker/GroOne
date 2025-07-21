// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_vehicle_extra_info_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsVehicleExtraInfoRealm extends _GpsVehicleExtraInfoRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsVehicleExtraInfoRealm(
    String deviceId,
    String vehicleRegistrationNumber, {
    String? dateAdded,
    String? vehicleRegCertificateUrl,
    String? vehicleBrand,
    String? vehicleModel,
    String? insuranceExpiryDate,
    String? pollutionExpiryDate,
    String? subscriptionExpiryDate,
    String? insuranceCertificateUrl,
    String? pollutionCertificateUrl,
    String? deviceRCUrl,
    String? fitnessExpiryDate,
    String? fitnessCertificateUrl,
    String? nationalPermitExpiryDate,
    String? nationalPermitCertificateUrl,
    String? yearExpiryDate,
    String? yearPermitCertificateUrl,
    String? taxExpiryDate,
    String? taxCertificateUrl,
    String? chasisNumber,
    String? plateNumber,
    String? nextServiceDate,
    String? id,
  }) {
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(
      this,
      'vehicleRegistrationNumber',
      vehicleRegistrationNumber,
    );
    RealmObjectBase.set(this, 'dateAdded', dateAdded);
    RealmObjectBase.set(
      this,
      'vehicleRegCertificateUrl',
      vehicleRegCertificateUrl,
    );
    RealmObjectBase.set(this, 'vehicleBrand', vehicleBrand);
    RealmObjectBase.set(this, 'vehicleModel', vehicleModel);
    RealmObjectBase.set(this, 'insuranceExpiryDate', insuranceExpiryDate);
    RealmObjectBase.set(this, 'pollutionExpiryDate', pollutionExpiryDate);
    RealmObjectBase.set(this, 'subscriptionExpiryDate', subscriptionExpiryDate);
    RealmObjectBase.set(
      this,
      'insuranceCertificateUrl',
      insuranceCertificateUrl,
    );
    RealmObjectBase.set(
      this,
      'pollutionCertificateUrl',
      pollutionCertificateUrl,
    );
    RealmObjectBase.set(this, 'deviceRCUrl', deviceRCUrl);
    RealmObjectBase.set(this, 'fitnessExpiryDate', fitnessExpiryDate);
    RealmObjectBase.set(this, 'fitnessCertificateUrl', fitnessCertificateUrl);
    RealmObjectBase.set(
      this,
      'nationalPermitExpiryDate',
      nationalPermitExpiryDate,
    );
    RealmObjectBase.set(
      this,
      'nationalPermitCertificateUrl',
      nationalPermitCertificateUrl,
    );
    RealmObjectBase.set(this, 'yearExpiryDate', yearExpiryDate);
    RealmObjectBase.set(
      this,
      'yearPermitCertificateUrl',
      yearPermitCertificateUrl,
    );
    RealmObjectBase.set(this, 'taxExpiryDate', taxExpiryDate);
    RealmObjectBase.set(this, 'taxCertificateUrl', taxCertificateUrl);
    RealmObjectBase.set(this, 'chasisNumber', chasisNumber);
    RealmObjectBase.set(this, 'plateNumber', plateNumber);
    RealmObjectBase.set(this, 'nextServiceDate', nextServiceDate);
    RealmObjectBase.set(this, 'id', id);
  }

  GpsVehicleExtraInfoRealm._();

  @override
  String get deviceId =>
      RealmObjectBase.get<String>(this, 'deviceId') as String;
  @override
  set deviceId(String value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String get vehicleRegistrationNumber =>
      RealmObjectBase.get<String>(this, 'vehicleRegistrationNumber') as String;
  @override
  set vehicleRegistrationNumber(String value) =>
      RealmObjectBase.set(this, 'vehicleRegistrationNumber', value);

  @override
  String? get dateAdded =>
      RealmObjectBase.get<String>(this, 'dateAdded') as String?;
  @override
  set dateAdded(String? value) => RealmObjectBase.set(this, 'dateAdded', value);

  @override
  String? get vehicleRegCertificateUrl =>
      RealmObjectBase.get<String>(this, 'vehicleRegCertificateUrl') as String?;
  @override
  set vehicleRegCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'vehicleRegCertificateUrl', value);

  @override
  String? get vehicleBrand =>
      RealmObjectBase.get<String>(this, 'vehicleBrand') as String?;
  @override
  set vehicleBrand(String? value) =>
      RealmObjectBase.set(this, 'vehicleBrand', value);

  @override
  String? get vehicleModel =>
      RealmObjectBase.get<String>(this, 'vehicleModel') as String?;
  @override
  set vehicleModel(String? value) =>
      RealmObjectBase.set(this, 'vehicleModel', value);

  @override
  String? get insuranceExpiryDate =>
      RealmObjectBase.get<String>(this, 'insuranceExpiryDate') as String?;
  @override
  set insuranceExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'insuranceExpiryDate', value);

  @override
  String? get pollutionExpiryDate =>
      RealmObjectBase.get<String>(this, 'pollutionExpiryDate') as String?;
  @override
  set pollutionExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'pollutionExpiryDate', value);

  @override
  String? get subscriptionExpiryDate =>
      RealmObjectBase.get<String>(this, 'subscriptionExpiryDate') as String?;
  @override
  set subscriptionExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'subscriptionExpiryDate', value);

  @override
  String? get insuranceCertificateUrl =>
      RealmObjectBase.get<String>(this, 'insuranceCertificateUrl') as String?;
  @override
  set insuranceCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'insuranceCertificateUrl', value);

  @override
  String? get pollutionCertificateUrl =>
      RealmObjectBase.get<String>(this, 'pollutionCertificateUrl') as String?;
  @override
  set pollutionCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'pollutionCertificateUrl', value);

  @override
  String? get deviceRCUrl =>
      RealmObjectBase.get<String>(this, 'deviceRCUrl') as String?;
  @override
  set deviceRCUrl(String? value) =>
      RealmObjectBase.set(this, 'deviceRCUrl', value);

  @override
  String? get fitnessExpiryDate =>
      RealmObjectBase.get<String>(this, 'fitnessExpiryDate') as String?;
  @override
  set fitnessExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'fitnessExpiryDate', value);

  @override
  String? get fitnessCertificateUrl =>
      RealmObjectBase.get<String>(this, 'fitnessCertificateUrl') as String?;
  @override
  set fitnessCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'fitnessCertificateUrl', value);

  @override
  String? get nationalPermitExpiryDate =>
      RealmObjectBase.get<String>(this, 'nationalPermitExpiryDate') as String?;
  @override
  set nationalPermitExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'nationalPermitExpiryDate', value);

  @override
  String? get nationalPermitCertificateUrl =>
      RealmObjectBase.get<String>(this, 'nationalPermitCertificateUrl')
          as String?;
  @override
  set nationalPermitCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'nationalPermitCertificateUrl', value);

  @override
  String? get yearExpiryDate =>
      RealmObjectBase.get<String>(this, 'yearExpiryDate') as String?;
  @override
  set yearExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'yearExpiryDate', value);

  @override
  String? get yearPermitCertificateUrl =>
      RealmObjectBase.get<String>(this, 'yearPermitCertificateUrl') as String?;
  @override
  set yearPermitCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'yearPermitCertificateUrl', value);

  @override
  String? get taxExpiryDate =>
      RealmObjectBase.get<String>(this, 'taxExpiryDate') as String?;
  @override
  set taxExpiryDate(String? value) =>
      RealmObjectBase.set(this, 'taxExpiryDate', value);

  @override
  String? get taxCertificateUrl =>
      RealmObjectBase.get<String>(this, 'taxCertificateUrl') as String?;
  @override
  set taxCertificateUrl(String? value) =>
      RealmObjectBase.set(this, 'taxCertificateUrl', value);

  @override
  String? get chasisNumber =>
      RealmObjectBase.get<String>(this, 'chasisNumber') as String?;
  @override
  set chasisNumber(String? value) =>
      RealmObjectBase.set(this, 'chasisNumber', value);

  @override
  String? get plateNumber =>
      RealmObjectBase.get<String>(this, 'plateNumber') as String?;
  @override
  set plateNumber(String? value) =>
      RealmObjectBase.set(this, 'plateNumber', value);

  @override
  String? get nextServiceDate =>
      RealmObjectBase.get<String>(this, 'nextServiceDate') as String?;
  @override
  set nextServiceDate(String? value) =>
      RealmObjectBase.set(this, 'nextServiceDate', value);

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  Stream<RealmObjectChanges<GpsVehicleExtraInfoRealm>> get changes =>
      RealmObjectBase.getChanges<GpsVehicleExtraInfoRealm>(this);

  @override
  Stream<RealmObjectChanges<GpsVehicleExtraInfoRealm>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsVehicleExtraInfoRealm>(this, keyPaths);

  @override
  GpsVehicleExtraInfoRealm freeze() =>
      RealmObjectBase.freezeObject<GpsVehicleExtraInfoRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'deviceId': deviceId.toEJson(),
      'vehicleRegistrationNumber': vehicleRegistrationNumber.toEJson(),
      'dateAdded': dateAdded.toEJson(),
      'vehicleRegCertificateUrl': vehicleRegCertificateUrl.toEJson(),
      'vehicleBrand': vehicleBrand.toEJson(),
      'vehicleModel': vehicleModel.toEJson(),
      'insuranceExpiryDate': insuranceExpiryDate.toEJson(),
      'pollutionExpiryDate': pollutionExpiryDate.toEJson(),
      'subscriptionExpiryDate': subscriptionExpiryDate.toEJson(),
      'insuranceCertificateUrl': insuranceCertificateUrl.toEJson(),
      'pollutionCertificateUrl': pollutionCertificateUrl.toEJson(),
      'deviceRCUrl': deviceRCUrl.toEJson(),
      'fitnessExpiryDate': fitnessExpiryDate.toEJson(),
      'fitnessCertificateUrl': fitnessCertificateUrl.toEJson(),
      'nationalPermitExpiryDate': nationalPermitExpiryDate.toEJson(),
      'nationalPermitCertificateUrl': nationalPermitCertificateUrl.toEJson(),
      'yearExpiryDate': yearExpiryDate.toEJson(),
      'yearPermitCertificateUrl': yearPermitCertificateUrl.toEJson(),
      'taxExpiryDate': taxExpiryDate.toEJson(),
      'taxCertificateUrl': taxCertificateUrl.toEJson(),
      'chasisNumber': chasisNumber.toEJson(),
      'plateNumber': plateNumber.toEJson(),
      'nextServiceDate': nextServiceDate.toEJson(),
      'id': id.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsVehicleExtraInfoRealm value) => value.toEJson();
  static GpsVehicleExtraInfoRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'deviceId': EJsonValue deviceId,
        'vehicleRegistrationNumber': EJsonValue vehicleRegistrationNumber,
      } =>
        GpsVehicleExtraInfoRealm(
          fromEJson(deviceId),
          fromEJson(vehicleRegistrationNumber),
          dateAdded: fromEJson(ejson['dateAdded']),
          vehicleRegCertificateUrl: fromEJson(
            ejson['vehicleRegCertificateUrl'],
          ),
          vehicleBrand: fromEJson(ejson['vehicleBrand']),
          vehicleModel: fromEJson(ejson['vehicleModel']),
          insuranceExpiryDate: fromEJson(ejson['insuranceExpiryDate']),
          pollutionExpiryDate: fromEJson(ejson['pollutionExpiryDate']),
          subscriptionExpiryDate: fromEJson(ejson['subscriptionExpiryDate']),
          insuranceCertificateUrl: fromEJson(ejson['insuranceCertificateUrl']),
          pollutionCertificateUrl: fromEJson(ejson['pollutionCertificateUrl']),
          deviceRCUrl: fromEJson(ejson['deviceRCUrl']),
          fitnessExpiryDate: fromEJson(ejson['fitnessExpiryDate']),
          fitnessCertificateUrl: fromEJson(ejson['fitnessCertificateUrl']),
          nationalPermitExpiryDate: fromEJson(
            ejson['nationalPermitExpiryDate'],
          ),
          nationalPermitCertificateUrl: fromEJson(
            ejson['nationalPermitCertificateUrl'],
          ),
          yearExpiryDate: fromEJson(ejson['yearExpiryDate']),
          yearPermitCertificateUrl: fromEJson(
            ejson['yearPermitCertificateUrl'],
          ),
          taxExpiryDate: fromEJson(ejson['taxExpiryDate']),
          taxCertificateUrl: fromEJson(ejson['taxCertificateUrl']),
          chasisNumber: fromEJson(ejson['chasisNumber']),
          plateNumber: fromEJson(ejson['plateNumber']),
          nextServiceDate: fromEJson(ejson['nextServiceDate']),
          id: fromEJson(ejson['id']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsVehicleExtraInfoRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsVehicleExtraInfoRealm,
      'GpsVehicleExtraInfoRealm',
      [
        SchemaProperty('deviceId', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('vehicleRegistrationNumber', RealmPropertyType.string),
        SchemaProperty('dateAdded', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'vehicleRegCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'vehicleBrand',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'vehicleModel',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'insuranceExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'pollutionExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'subscriptionExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'insuranceCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'pollutionCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('deviceRCUrl', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'fitnessExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'fitnessCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'nationalPermitExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'nationalPermitCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'yearExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'yearPermitCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'taxExpiryDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'taxCertificateUrl',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'chasisNumber',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('plateNumber', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'nextServiceDate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('id', RealmPropertyType.string, optional: true),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
