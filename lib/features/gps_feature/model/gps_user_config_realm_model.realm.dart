// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_user_config_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class GpsUserConfigRealmModel extends _GpsUserConfigRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GpsUserConfigRealmModel(
    ObjectId id,
    DateTime createdAt, {
    int? userId,
    String? userType,
    String? userProfilePic,
    String? defaultMap,
    int? customZoom,
    int? markerAnimate,
    int? markerCluster,
    int? markerInfobox,
    int? markerLabel,
    int? markerLabelWithSpeed,
    int? markerRouteDirection,
    int? poiLabel,
    int? imageMarkers,
    int? showGeofences,
    int? showGeofenceReport,
    int? autoPanMapGeofenceLoop,
    int? autoPanMapGeofenceTime,
    int? autoRptEmail,
    String? autoRptEmailList,
    int? maintenanceNotifEnable,
    String? maintenanceNotifReceivers,
    String? maintenanceReminders,
    int? stockMgmt,
    int? isThirdParty,
    int? isWasteMgmtVisible,
    int? isloadUnloadVisible,
    int? totalDistAlerts,
    String? totalDistDistanceInterval,
    String? totalDistEmailList,
    String? stopTime,
    String? ignitionOffTime,
    int? callsCount,
    int? lastTenMins,
    String? deviceToken,
    String? deviceType,
    String? emailConfig,
    String? smsConfig,
    String? sendMailFromEmail,
    String? lastUpdateSmsMailConfig,
    String? cngNotif,
    String? fitnessNotif,
    String? fiveYearPermitNotif,
    String? hbtNotif,
    String? insuranceNotif,
    String? nationalPermitNotif,
    String? pollutionNotif,
    String? serviceNotif,
    String? tokenTaxNotif,
    String? customFilterUpdate,
    String? thirdPartyValue,
    String? appName,
    String? alarmAlarm,
    String? alarmName,
    String? alarmType,
    String? deviceDetailsAndroidVersion,
    String? deviceDetailsAppVersion,
    String? deviceDetailsDeviceType,
    String? deviceDetailsManufacturer,
    String? deviceDetailsModel,
    int? deviceDetailsSdk,
    Iterable<String> listViewColumns = const [],
    String? listViewTimeFormat,
    String? privacyPolicyDevId,
    String? privacyPolicyDevName,
    String? privacyPolicyDevTstamp,
    DateTime? activationDate,
    DateTime? lastLogin,
    DateTime? registerDate,
    double? variation,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'userType', userType);
    RealmObjectBase.set(this, 'userProfilePic', userProfilePic);
    RealmObjectBase.set(this, 'defaultMap', defaultMap);
    RealmObjectBase.set(this, 'customZoom', customZoom);
    RealmObjectBase.set(this, 'markerAnimate', markerAnimate);
    RealmObjectBase.set(this, 'markerCluster', markerCluster);
    RealmObjectBase.set(this, 'markerInfobox', markerInfobox);
    RealmObjectBase.set(this, 'markerLabel', markerLabel);
    RealmObjectBase.set(this, 'markerLabelWithSpeed', markerLabelWithSpeed);
    RealmObjectBase.set(this, 'markerRouteDirection', markerRouteDirection);
    RealmObjectBase.set(this, 'poiLabel', poiLabel);
    RealmObjectBase.set(this, 'imageMarkers', imageMarkers);
    RealmObjectBase.set(this, 'showGeofences', showGeofences);
    RealmObjectBase.set(this, 'showGeofenceReport', showGeofenceReport);
    RealmObjectBase.set(this, 'autoPanMapGeofenceLoop', autoPanMapGeofenceLoop);
    RealmObjectBase.set(this, 'autoPanMapGeofenceTime', autoPanMapGeofenceTime);
    RealmObjectBase.set(this, 'autoRptEmail', autoRptEmail);
    RealmObjectBase.set(this, 'autoRptEmailList', autoRptEmailList);
    RealmObjectBase.set(this, 'maintenanceNotifEnable', maintenanceNotifEnable);
    RealmObjectBase.set(
      this,
      'maintenanceNotifReceivers',
      maintenanceNotifReceivers,
    );
    RealmObjectBase.set(this, 'maintenanceReminders', maintenanceReminders);
    RealmObjectBase.set(this, 'stockMgmt', stockMgmt);
    RealmObjectBase.set(this, 'isThirdParty', isThirdParty);
    RealmObjectBase.set(this, 'isWasteMgmtVisible', isWasteMgmtVisible);
    RealmObjectBase.set(this, 'isloadUnloadVisible', isloadUnloadVisible);
    RealmObjectBase.set(this, 'totalDistAlerts', totalDistAlerts);
    RealmObjectBase.set(
      this,
      'totalDistDistanceInterval',
      totalDistDistanceInterval,
    );
    RealmObjectBase.set(this, 'totalDistEmailList', totalDistEmailList);
    RealmObjectBase.set(this, 'stopTime', stopTime);
    RealmObjectBase.set(this, 'ignitionOffTime', ignitionOffTime);
    RealmObjectBase.set(this, 'callsCount', callsCount);
    RealmObjectBase.set(this, 'lastTenMins', lastTenMins);
    RealmObjectBase.set(this, 'deviceToken', deviceToken);
    RealmObjectBase.set(this, 'deviceType', deviceType);
    RealmObjectBase.set(this, 'emailConfig', emailConfig);
    RealmObjectBase.set(this, 'smsConfig', smsConfig);
    RealmObjectBase.set(this, 'sendMailFromEmail', sendMailFromEmail);
    RealmObjectBase.set(
      this,
      'lastUpdateSmsMailConfig',
      lastUpdateSmsMailConfig,
    );
    RealmObjectBase.set(this, 'cngNotif', cngNotif);
    RealmObjectBase.set(this, 'fitnessNotif', fitnessNotif);
    RealmObjectBase.set(this, 'fiveYearPermitNotif', fiveYearPermitNotif);
    RealmObjectBase.set(this, 'hbtNotif', hbtNotif);
    RealmObjectBase.set(this, 'insuranceNotif', insuranceNotif);
    RealmObjectBase.set(this, 'nationalPermitNotif', nationalPermitNotif);
    RealmObjectBase.set(this, 'pollutionNotif', pollutionNotif);
    RealmObjectBase.set(this, 'serviceNotif', serviceNotif);
    RealmObjectBase.set(this, 'tokenTaxNotif', tokenTaxNotif);
    RealmObjectBase.set(this, 'customFilterUpdate', customFilterUpdate);
    RealmObjectBase.set(this, 'thirdPartyValue', thirdPartyValue);
    RealmObjectBase.set(this, 'appName', appName);
    RealmObjectBase.set(this, 'alarmAlarm', alarmAlarm);
    RealmObjectBase.set(this, 'alarmName', alarmName);
    RealmObjectBase.set(this, 'alarmType', alarmType);
    RealmObjectBase.set(
      this,
      'deviceDetailsAndroidVersion',
      deviceDetailsAndroidVersion,
    );
    RealmObjectBase.set(
      this,
      'deviceDetailsAppVersion',
      deviceDetailsAppVersion,
    );
    RealmObjectBase.set(
      this,
      'deviceDetailsDeviceType',
      deviceDetailsDeviceType,
    );
    RealmObjectBase.set(
      this,
      'deviceDetailsManufacturer',
      deviceDetailsManufacturer,
    );
    RealmObjectBase.set(this, 'deviceDetailsModel', deviceDetailsModel);
    RealmObjectBase.set(this, 'deviceDetailsSdk', deviceDetailsSdk);
    RealmObjectBase.set<RealmList<String>>(
      this,
      'listViewColumns',
      RealmList<String>(listViewColumns),
    );
    RealmObjectBase.set(this, 'listViewTimeFormat', listViewTimeFormat);
    RealmObjectBase.set(this, 'privacyPolicyDevId', privacyPolicyDevId);
    RealmObjectBase.set(this, 'privacyPolicyDevName', privacyPolicyDevName);
    RealmObjectBase.set(this, 'privacyPolicyDevTstamp', privacyPolicyDevTstamp);
    RealmObjectBase.set(this, 'activationDate', activationDate);
    RealmObjectBase.set(this, 'lastLogin', lastLogin);
    RealmObjectBase.set(this, 'registerDate', registerDate);
    RealmObjectBase.set(this, 'variation', variation);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  GpsUserConfigRealmModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get userType =>
      RealmObjectBase.get<String>(this, 'userType') as String?;
  @override
  set userType(String? value) => RealmObjectBase.set(this, 'userType', value);

  @override
  String? get userProfilePic =>
      RealmObjectBase.get<String>(this, 'userProfilePic') as String?;
  @override
  set userProfilePic(String? value) =>
      RealmObjectBase.set(this, 'userProfilePic', value);

  @override
  String? get defaultMap =>
      RealmObjectBase.get<String>(this, 'defaultMap') as String?;
  @override
  set defaultMap(String? value) =>
      RealmObjectBase.set(this, 'defaultMap', value);

  @override
  int? get customZoom => RealmObjectBase.get<int>(this, 'customZoom') as int?;
  @override
  set customZoom(int? value) => RealmObjectBase.set(this, 'customZoom', value);

  @override
  int? get markerAnimate =>
      RealmObjectBase.get<int>(this, 'markerAnimate') as int?;
  @override
  set markerAnimate(int? value) =>
      RealmObjectBase.set(this, 'markerAnimate', value);

  @override
  int? get markerCluster =>
      RealmObjectBase.get<int>(this, 'markerCluster') as int?;
  @override
  set markerCluster(int? value) =>
      RealmObjectBase.set(this, 'markerCluster', value);

  @override
  int? get markerInfobox =>
      RealmObjectBase.get<int>(this, 'markerInfobox') as int?;
  @override
  set markerInfobox(int? value) =>
      RealmObjectBase.set(this, 'markerInfobox', value);

  @override
  int? get markerLabel => RealmObjectBase.get<int>(this, 'markerLabel') as int?;
  @override
  set markerLabel(int? value) =>
      RealmObjectBase.set(this, 'markerLabel', value);

  @override
  int? get markerLabelWithSpeed =>
      RealmObjectBase.get<int>(this, 'markerLabelWithSpeed') as int?;
  @override
  set markerLabelWithSpeed(int? value) =>
      RealmObjectBase.set(this, 'markerLabelWithSpeed', value);

  @override
  int? get markerRouteDirection =>
      RealmObjectBase.get<int>(this, 'markerRouteDirection') as int?;
  @override
  set markerRouteDirection(int? value) =>
      RealmObjectBase.set(this, 'markerRouteDirection', value);

  @override
  int? get poiLabel => RealmObjectBase.get<int>(this, 'poiLabel') as int?;
  @override
  set poiLabel(int? value) => RealmObjectBase.set(this, 'poiLabel', value);

  @override
  int? get imageMarkers =>
      RealmObjectBase.get<int>(this, 'imageMarkers') as int?;
  @override
  set imageMarkers(int? value) =>
      RealmObjectBase.set(this, 'imageMarkers', value);

  @override
  int? get showGeofences =>
      RealmObjectBase.get<int>(this, 'showGeofences') as int?;
  @override
  set showGeofences(int? value) =>
      RealmObjectBase.set(this, 'showGeofences', value);

  @override
  int? get showGeofenceReport =>
      RealmObjectBase.get<int>(this, 'showGeofenceReport') as int?;
  @override
  set showGeofenceReport(int? value) =>
      RealmObjectBase.set(this, 'showGeofenceReport', value);

  @override
  int? get autoPanMapGeofenceLoop =>
      RealmObjectBase.get<int>(this, 'autoPanMapGeofenceLoop') as int?;
  @override
  set autoPanMapGeofenceLoop(int? value) =>
      RealmObjectBase.set(this, 'autoPanMapGeofenceLoop', value);

  @override
  int? get autoPanMapGeofenceTime =>
      RealmObjectBase.get<int>(this, 'autoPanMapGeofenceTime') as int?;
  @override
  set autoPanMapGeofenceTime(int? value) =>
      RealmObjectBase.set(this, 'autoPanMapGeofenceTime', value);

  @override
  int? get autoRptEmail =>
      RealmObjectBase.get<int>(this, 'autoRptEmail') as int?;
  @override
  set autoRptEmail(int? value) =>
      RealmObjectBase.set(this, 'autoRptEmail', value);

  @override
  String? get autoRptEmailList =>
      RealmObjectBase.get<String>(this, 'autoRptEmailList') as String?;
  @override
  set autoRptEmailList(String? value) =>
      RealmObjectBase.set(this, 'autoRptEmailList', value);

  @override
  int? get maintenanceNotifEnable =>
      RealmObjectBase.get<int>(this, 'maintenanceNotifEnable') as int?;
  @override
  set maintenanceNotifEnable(int? value) =>
      RealmObjectBase.set(this, 'maintenanceNotifEnable', value);

  @override
  String? get maintenanceNotifReceivers =>
      RealmObjectBase.get<String>(this, 'maintenanceNotifReceivers') as String?;
  @override
  set maintenanceNotifReceivers(String? value) =>
      RealmObjectBase.set(this, 'maintenanceNotifReceivers', value);

  @override
  String? get maintenanceReminders =>
      RealmObjectBase.get<String>(this, 'maintenanceReminders') as String?;
  @override
  set maintenanceReminders(String? value) =>
      RealmObjectBase.set(this, 'maintenanceReminders', value);

  @override
  int? get stockMgmt => RealmObjectBase.get<int>(this, 'stockMgmt') as int?;
  @override
  set stockMgmt(int? value) => RealmObjectBase.set(this, 'stockMgmt', value);

  @override
  int? get isThirdParty =>
      RealmObjectBase.get<int>(this, 'isThirdParty') as int?;
  @override
  set isThirdParty(int? value) =>
      RealmObjectBase.set(this, 'isThirdParty', value);

  @override
  int? get isWasteMgmtVisible =>
      RealmObjectBase.get<int>(this, 'isWasteMgmtVisible') as int?;
  @override
  set isWasteMgmtVisible(int? value) =>
      RealmObjectBase.set(this, 'isWasteMgmtVisible', value);

  @override
  int? get isloadUnloadVisible =>
      RealmObjectBase.get<int>(this, 'isloadUnloadVisible') as int?;
  @override
  set isloadUnloadVisible(int? value) =>
      RealmObjectBase.set(this, 'isloadUnloadVisible', value);

  @override
  int? get totalDistAlerts =>
      RealmObjectBase.get<int>(this, 'totalDistAlerts') as int?;
  @override
  set totalDistAlerts(int? value) =>
      RealmObjectBase.set(this, 'totalDistAlerts', value);

  @override
  String? get totalDistDistanceInterval =>
      RealmObjectBase.get<String>(this, 'totalDistDistanceInterval') as String?;
  @override
  set totalDistDistanceInterval(String? value) =>
      RealmObjectBase.set(this, 'totalDistDistanceInterval', value);

  @override
  String? get totalDistEmailList =>
      RealmObjectBase.get<String>(this, 'totalDistEmailList') as String?;
  @override
  set totalDistEmailList(String? value) =>
      RealmObjectBase.set(this, 'totalDistEmailList', value);

  @override
  String? get stopTime =>
      RealmObjectBase.get<String>(this, 'stopTime') as String?;
  @override
  set stopTime(String? value) => RealmObjectBase.set(this, 'stopTime', value);

  @override
  String? get ignitionOffTime =>
      RealmObjectBase.get<String>(this, 'ignitionOffTime') as String?;
  @override
  set ignitionOffTime(String? value) =>
      RealmObjectBase.set(this, 'ignitionOffTime', value);

  @override
  int? get callsCount => RealmObjectBase.get<int>(this, 'callsCount') as int?;
  @override
  set callsCount(int? value) => RealmObjectBase.set(this, 'callsCount', value);

  @override
  int? get lastTenMins => RealmObjectBase.get<int>(this, 'lastTenMins') as int?;
  @override
  set lastTenMins(int? value) =>
      RealmObjectBase.set(this, 'lastTenMins', value);

  @override
  String? get deviceToken =>
      RealmObjectBase.get<String>(this, 'deviceToken') as String?;
  @override
  set deviceToken(String? value) =>
      RealmObjectBase.set(this, 'deviceToken', value);

  @override
  String? get deviceType =>
      RealmObjectBase.get<String>(this, 'deviceType') as String?;
  @override
  set deviceType(String? value) =>
      RealmObjectBase.set(this, 'deviceType', value);

  @override
  String? get emailConfig =>
      RealmObjectBase.get<String>(this, 'emailConfig') as String?;
  @override
  set emailConfig(String? value) =>
      RealmObjectBase.set(this, 'emailConfig', value);

  @override
  String? get smsConfig =>
      RealmObjectBase.get<String>(this, 'smsConfig') as String?;
  @override
  set smsConfig(String? value) => RealmObjectBase.set(this, 'smsConfig', value);

  @override
  String? get sendMailFromEmail =>
      RealmObjectBase.get<String>(this, 'sendMailFromEmail') as String?;
  @override
  set sendMailFromEmail(String? value) =>
      RealmObjectBase.set(this, 'sendMailFromEmail', value);

  @override
  String? get lastUpdateSmsMailConfig =>
      RealmObjectBase.get<String>(this, 'lastUpdateSmsMailConfig') as String?;
  @override
  set lastUpdateSmsMailConfig(String? value) =>
      RealmObjectBase.set(this, 'lastUpdateSmsMailConfig', value);

  @override
  String? get cngNotif =>
      RealmObjectBase.get<String>(this, 'cngNotif') as String?;
  @override
  set cngNotif(String? value) => RealmObjectBase.set(this, 'cngNotif', value);

  @override
  String? get fitnessNotif =>
      RealmObjectBase.get<String>(this, 'fitnessNotif') as String?;
  @override
  set fitnessNotif(String? value) =>
      RealmObjectBase.set(this, 'fitnessNotif', value);

  @override
  String? get fiveYearPermitNotif =>
      RealmObjectBase.get<String>(this, 'fiveYearPermitNotif') as String?;
  @override
  set fiveYearPermitNotif(String? value) =>
      RealmObjectBase.set(this, 'fiveYearPermitNotif', value);

  @override
  String? get hbtNotif =>
      RealmObjectBase.get<String>(this, 'hbtNotif') as String?;
  @override
  set hbtNotif(String? value) => RealmObjectBase.set(this, 'hbtNotif', value);

  @override
  String? get insuranceNotif =>
      RealmObjectBase.get<String>(this, 'insuranceNotif') as String?;
  @override
  set insuranceNotif(String? value) =>
      RealmObjectBase.set(this, 'insuranceNotif', value);

  @override
  String? get nationalPermitNotif =>
      RealmObjectBase.get<String>(this, 'nationalPermitNotif') as String?;
  @override
  set nationalPermitNotif(String? value) =>
      RealmObjectBase.set(this, 'nationalPermitNotif', value);

  @override
  String? get pollutionNotif =>
      RealmObjectBase.get<String>(this, 'pollutionNotif') as String?;
  @override
  set pollutionNotif(String? value) =>
      RealmObjectBase.set(this, 'pollutionNotif', value);

  @override
  String? get serviceNotif =>
      RealmObjectBase.get<String>(this, 'serviceNotif') as String?;
  @override
  set serviceNotif(String? value) =>
      RealmObjectBase.set(this, 'serviceNotif', value);

  @override
  String? get tokenTaxNotif =>
      RealmObjectBase.get<String>(this, 'tokenTaxNotif') as String?;
  @override
  set tokenTaxNotif(String? value) =>
      RealmObjectBase.set(this, 'tokenTaxNotif', value);

  @override
  String? get customFilterUpdate =>
      RealmObjectBase.get<String>(this, 'customFilterUpdate') as String?;
  @override
  set customFilterUpdate(String? value) =>
      RealmObjectBase.set(this, 'customFilterUpdate', value);

  @override
  String? get thirdPartyValue =>
      RealmObjectBase.get<String>(this, 'thirdPartyValue') as String?;
  @override
  set thirdPartyValue(String? value) =>
      RealmObjectBase.set(this, 'thirdPartyValue', value);

  @override
  String? get appName =>
      RealmObjectBase.get<String>(this, 'appName') as String?;
  @override
  set appName(String? value) => RealmObjectBase.set(this, 'appName', value);

  @override
  String? get alarmAlarm =>
      RealmObjectBase.get<String>(this, 'alarmAlarm') as String?;
  @override
  set alarmAlarm(String? value) =>
      RealmObjectBase.set(this, 'alarmAlarm', value);

  @override
  String? get alarmName =>
      RealmObjectBase.get<String>(this, 'alarmName') as String?;
  @override
  set alarmName(String? value) => RealmObjectBase.set(this, 'alarmName', value);

  @override
  String? get alarmType =>
      RealmObjectBase.get<String>(this, 'alarmType') as String?;
  @override
  set alarmType(String? value) => RealmObjectBase.set(this, 'alarmType', value);

  @override
  String? get deviceDetailsAndroidVersion =>
      RealmObjectBase.get<String>(this, 'deviceDetailsAndroidVersion')
          as String?;
  @override
  set deviceDetailsAndroidVersion(String? value) =>
      RealmObjectBase.set(this, 'deviceDetailsAndroidVersion', value);

  @override
  String? get deviceDetailsAppVersion =>
      RealmObjectBase.get<String>(this, 'deviceDetailsAppVersion') as String?;
  @override
  set deviceDetailsAppVersion(String? value) =>
      RealmObjectBase.set(this, 'deviceDetailsAppVersion', value);

  @override
  String? get deviceDetailsDeviceType =>
      RealmObjectBase.get<String>(this, 'deviceDetailsDeviceType') as String?;
  @override
  set deviceDetailsDeviceType(String? value) =>
      RealmObjectBase.set(this, 'deviceDetailsDeviceType', value);

  @override
  String? get deviceDetailsManufacturer =>
      RealmObjectBase.get<String>(this, 'deviceDetailsManufacturer') as String?;
  @override
  set deviceDetailsManufacturer(String? value) =>
      RealmObjectBase.set(this, 'deviceDetailsManufacturer', value);

  @override
  String? get deviceDetailsModel =>
      RealmObjectBase.get<String>(this, 'deviceDetailsModel') as String?;
  @override
  set deviceDetailsModel(String? value) =>
      RealmObjectBase.set(this, 'deviceDetailsModel', value);

  @override
  int? get deviceDetailsSdk =>
      RealmObjectBase.get<int>(this, 'deviceDetailsSdk') as int?;
  @override
  set deviceDetailsSdk(int? value) =>
      RealmObjectBase.set(this, 'deviceDetailsSdk', value);

  @override
  RealmList<String> get listViewColumns =>
      RealmObjectBase.get<String>(this, 'listViewColumns') as RealmList<String>;
  @override
  set listViewColumns(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get listViewTimeFormat =>
      RealmObjectBase.get<String>(this, 'listViewTimeFormat') as String?;
  @override
  set listViewTimeFormat(String? value) =>
      RealmObjectBase.set(this, 'listViewTimeFormat', value);

  @override
  String? get privacyPolicyDevId =>
      RealmObjectBase.get<String>(this, 'privacyPolicyDevId') as String?;
  @override
  set privacyPolicyDevId(String? value) =>
      RealmObjectBase.set(this, 'privacyPolicyDevId', value);

  @override
  String? get privacyPolicyDevName =>
      RealmObjectBase.get<String>(this, 'privacyPolicyDevName') as String?;
  @override
  set privacyPolicyDevName(String? value) =>
      RealmObjectBase.set(this, 'privacyPolicyDevName', value);

  @override
  String? get privacyPolicyDevTstamp =>
      RealmObjectBase.get<String>(this, 'privacyPolicyDevTstamp') as String?;
  @override
  set privacyPolicyDevTstamp(String? value) =>
      RealmObjectBase.set(this, 'privacyPolicyDevTstamp', value);

  @override
  DateTime? get activationDate =>
      RealmObjectBase.get<DateTime>(this, 'activationDate') as DateTime?;
  @override
  set activationDate(DateTime? value) =>
      RealmObjectBase.set(this, 'activationDate', value);

  @override
  DateTime? get lastLogin =>
      RealmObjectBase.get<DateTime>(this, 'lastLogin') as DateTime?;
  @override
  set lastLogin(DateTime? value) =>
      RealmObjectBase.set(this, 'lastLogin', value);

  @override
  DateTime? get registerDate =>
      RealmObjectBase.get<DateTime>(this, 'registerDate') as DateTime?;
  @override
  set registerDate(DateTime? value) =>
      RealmObjectBase.set(this, 'registerDate', value);

  @override
  double? get variation =>
      RealmObjectBase.get<double>(this, 'variation') as double?;
  @override
  set variation(double? value) => RealmObjectBase.set(this, 'variation', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<GpsUserConfigRealmModel>> get changes =>
      RealmObjectBase.getChanges<GpsUserConfigRealmModel>(this);

  @override
  Stream<RealmObjectChanges<GpsUserConfigRealmModel>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<GpsUserConfigRealmModel>(this, keyPaths);

  @override
  GpsUserConfigRealmModel freeze() =>
      RealmObjectBase.freezeObject<GpsUserConfigRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'userType': userType.toEJson(),
      'userProfilePic': userProfilePic.toEJson(),
      'defaultMap': defaultMap.toEJson(),
      'customZoom': customZoom.toEJson(),
      'markerAnimate': markerAnimate.toEJson(),
      'markerCluster': markerCluster.toEJson(),
      'markerInfobox': markerInfobox.toEJson(),
      'markerLabel': markerLabel.toEJson(),
      'markerLabelWithSpeed': markerLabelWithSpeed.toEJson(),
      'markerRouteDirection': markerRouteDirection.toEJson(),
      'poiLabel': poiLabel.toEJson(),
      'imageMarkers': imageMarkers.toEJson(),
      'showGeofences': showGeofences.toEJson(),
      'showGeofenceReport': showGeofenceReport.toEJson(),
      'autoPanMapGeofenceLoop': autoPanMapGeofenceLoop.toEJson(),
      'autoPanMapGeofenceTime': autoPanMapGeofenceTime.toEJson(),
      'autoRptEmail': autoRptEmail.toEJson(),
      'autoRptEmailList': autoRptEmailList.toEJson(),
      'maintenanceNotifEnable': maintenanceNotifEnable.toEJson(),
      'maintenanceNotifReceivers': maintenanceNotifReceivers.toEJson(),
      'maintenanceReminders': maintenanceReminders.toEJson(),
      'stockMgmt': stockMgmt.toEJson(),
      'isThirdParty': isThirdParty.toEJson(),
      'isWasteMgmtVisible': isWasteMgmtVisible.toEJson(),
      'isloadUnloadVisible': isloadUnloadVisible.toEJson(),
      'totalDistAlerts': totalDistAlerts.toEJson(),
      'totalDistDistanceInterval': totalDistDistanceInterval.toEJson(),
      'totalDistEmailList': totalDistEmailList.toEJson(),
      'stopTime': stopTime.toEJson(),
      'ignitionOffTime': ignitionOffTime.toEJson(),
      'callsCount': callsCount.toEJson(),
      'lastTenMins': lastTenMins.toEJson(),
      'deviceToken': deviceToken.toEJson(),
      'deviceType': deviceType.toEJson(),
      'emailConfig': emailConfig.toEJson(),
      'smsConfig': smsConfig.toEJson(),
      'sendMailFromEmail': sendMailFromEmail.toEJson(),
      'lastUpdateSmsMailConfig': lastUpdateSmsMailConfig.toEJson(),
      'cngNotif': cngNotif.toEJson(),
      'fitnessNotif': fitnessNotif.toEJson(),
      'fiveYearPermitNotif': fiveYearPermitNotif.toEJson(),
      'hbtNotif': hbtNotif.toEJson(),
      'insuranceNotif': insuranceNotif.toEJson(),
      'nationalPermitNotif': nationalPermitNotif.toEJson(),
      'pollutionNotif': pollutionNotif.toEJson(),
      'serviceNotif': serviceNotif.toEJson(),
      'tokenTaxNotif': tokenTaxNotif.toEJson(),
      'customFilterUpdate': customFilterUpdate.toEJson(),
      'thirdPartyValue': thirdPartyValue.toEJson(),
      'appName': appName.toEJson(),
      'alarmAlarm': alarmAlarm.toEJson(),
      'alarmName': alarmName.toEJson(),
      'alarmType': alarmType.toEJson(),
      'deviceDetailsAndroidVersion': deviceDetailsAndroidVersion.toEJson(),
      'deviceDetailsAppVersion': deviceDetailsAppVersion.toEJson(),
      'deviceDetailsDeviceType': deviceDetailsDeviceType.toEJson(),
      'deviceDetailsManufacturer': deviceDetailsManufacturer.toEJson(),
      'deviceDetailsModel': deviceDetailsModel.toEJson(),
      'deviceDetailsSdk': deviceDetailsSdk.toEJson(),
      'listViewColumns': listViewColumns.toEJson(),
      'listViewTimeFormat': listViewTimeFormat.toEJson(),
      'privacyPolicyDevId': privacyPolicyDevId.toEJson(),
      'privacyPolicyDevName': privacyPolicyDevName.toEJson(),
      'privacyPolicyDevTstamp': privacyPolicyDevTstamp.toEJson(),
      'activationDate': activationDate.toEJson(),
      'lastLogin': lastLogin.toEJson(),
      'registerDate': registerDate.toEJson(),
      'variation': variation.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GpsUserConfigRealmModel value) => value.toEJson();
  static GpsUserConfigRealmModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt} =>
        GpsUserConfigRealmModel(
          fromEJson(id),
          fromEJson(createdAt),
          userId: fromEJson(ejson['userId']),
          userType: fromEJson(ejson['userType']),
          userProfilePic: fromEJson(ejson['userProfilePic']),
          defaultMap: fromEJson(ejson['defaultMap']),
          customZoom: fromEJson(ejson['customZoom']),
          markerAnimate: fromEJson(ejson['markerAnimate']),
          markerCluster: fromEJson(ejson['markerCluster']),
          markerInfobox: fromEJson(ejson['markerInfobox']),
          markerLabel: fromEJson(ejson['markerLabel']),
          markerLabelWithSpeed: fromEJson(ejson['markerLabelWithSpeed']),
          markerRouteDirection: fromEJson(ejson['markerRouteDirection']),
          poiLabel: fromEJson(ejson['poiLabel']),
          imageMarkers: fromEJson(ejson['imageMarkers']),
          showGeofences: fromEJson(ejson['showGeofences']),
          showGeofenceReport: fromEJson(ejson['showGeofenceReport']),
          autoPanMapGeofenceLoop: fromEJson(ejson['autoPanMapGeofenceLoop']),
          autoPanMapGeofenceTime: fromEJson(ejson['autoPanMapGeofenceTime']),
          autoRptEmail: fromEJson(ejson['autoRptEmail']),
          autoRptEmailList: fromEJson(ejson['autoRptEmailList']),
          maintenanceNotifEnable: fromEJson(ejson['maintenanceNotifEnable']),
          maintenanceNotifReceivers: fromEJson(
            ejson['maintenanceNotifReceivers'],
          ),
          maintenanceReminders: fromEJson(ejson['maintenanceReminders']),
          stockMgmt: fromEJson(ejson['stockMgmt']),
          isThirdParty: fromEJson(ejson['isThirdParty']),
          isWasteMgmtVisible: fromEJson(ejson['isWasteMgmtVisible']),
          isloadUnloadVisible: fromEJson(ejson['isloadUnloadVisible']),
          totalDistAlerts: fromEJson(ejson['totalDistAlerts']),
          totalDistDistanceInterval: fromEJson(
            ejson['totalDistDistanceInterval'],
          ),
          totalDistEmailList: fromEJson(ejson['totalDistEmailList']),
          stopTime: fromEJson(ejson['stopTime']),
          ignitionOffTime: fromEJson(ejson['ignitionOffTime']),
          callsCount: fromEJson(ejson['callsCount']),
          lastTenMins: fromEJson(ejson['lastTenMins']),
          deviceToken: fromEJson(ejson['deviceToken']),
          deviceType: fromEJson(ejson['deviceType']),
          emailConfig: fromEJson(ejson['emailConfig']),
          smsConfig: fromEJson(ejson['smsConfig']),
          sendMailFromEmail: fromEJson(ejson['sendMailFromEmail']),
          lastUpdateSmsMailConfig: fromEJson(ejson['lastUpdateSmsMailConfig']),
          cngNotif: fromEJson(ejson['cngNotif']),
          fitnessNotif: fromEJson(ejson['fitnessNotif']),
          fiveYearPermitNotif: fromEJson(ejson['fiveYearPermitNotif']),
          hbtNotif: fromEJson(ejson['hbtNotif']),
          insuranceNotif: fromEJson(ejson['insuranceNotif']),
          nationalPermitNotif: fromEJson(ejson['nationalPermitNotif']),
          pollutionNotif: fromEJson(ejson['pollutionNotif']),
          serviceNotif: fromEJson(ejson['serviceNotif']),
          tokenTaxNotif: fromEJson(ejson['tokenTaxNotif']),
          customFilterUpdate: fromEJson(ejson['customFilterUpdate']),
          thirdPartyValue: fromEJson(ejson['thirdPartyValue']),
          appName: fromEJson(ejson['appName']),
          alarmAlarm: fromEJson(ejson['alarmAlarm']),
          alarmName: fromEJson(ejson['alarmName']),
          alarmType: fromEJson(ejson['alarmType']),
          deviceDetailsAndroidVersion: fromEJson(
            ejson['deviceDetailsAndroidVersion'],
          ),
          deviceDetailsAppVersion: fromEJson(ejson['deviceDetailsAppVersion']),
          deviceDetailsDeviceType: fromEJson(ejson['deviceDetailsDeviceType']),
          deviceDetailsManufacturer: fromEJson(
            ejson['deviceDetailsManufacturer'],
          ),
          deviceDetailsModel: fromEJson(ejson['deviceDetailsModel']),
          deviceDetailsSdk: fromEJson(ejson['deviceDetailsSdk']),
          listViewColumns: fromEJson(
            ejson['listViewColumns'],
            defaultValue: const [],
          ),
          listViewTimeFormat: fromEJson(ejson['listViewTimeFormat']),
          privacyPolicyDevId: fromEJson(ejson['privacyPolicyDevId']),
          privacyPolicyDevName: fromEJson(ejson['privacyPolicyDevName']),
          privacyPolicyDevTstamp: fromEJson(ejson['privacyPolicyDevTstamp']),
          activationDate: fromEJson(ejson['activationDate']),
          lastLogin: fromEJson(ejson['lastLogin']),
          registerDate: fromEJson(ejson['registerDate']),
          variation: fromEJson(ejson['variation']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GpsUserConfigRealmModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      GpsUserConfigRealmModel,
      'GpsUserConfigRealmModel',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('userId', RealmPropertyType.int, optional: true),
        SchemaProperty('userType', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'userProfilePic',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('defaultMap', RealmPropertyType.string, optional: true),
        SchemaProperty('customZoom', RealmPropertyType.int, optional: true),
        SchemaProperty('markerAnimate', RealmPropertyType.int, optional: true),
        SchemaProperty('markerCluster', RealmPropertyType.int, optional: true),
        SchemaProperty('markerInfobox', RealmPropertyType.int, optional: true),
        SchemaProperty('markerLabel', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'markerLabelWithSpeed',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'markerRouteDirection',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty('poiLabel', RealmPropertyType.int, optional: true),
        SchemaProperty('imageMarkers', RealmPropertyType.int, optional: true),
        SchemaProperty('showGeofences', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'showGeofenceReport',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'autoPanMapGeofenceLoop',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'autoPanMapGeofenceTime',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty('autoRptEmail', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'autoRptEmailList',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'maintenanceNotifEnable',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'maintenanceNotifReceivers',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'maintenanceReminders',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('stockMgmt', RealmPropertyType.int, optional: true),
        SchemaProperty('isThirdParty', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'isWasteMgmtVisible',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'isloadUnloadVisible',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'totalDistAlerts',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'totalDistDistanceInterval',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'totalDistEmailList',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('stopTime', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'ignitionOffTime',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('callsCount', RealmPropertyType.int, optional: true),
        SchemaProperty('lastTenMins', RealmPropertyType.int, optional: true),
        SchemaProperty('deviceToken', RealmPropertyType.string, optional: true),
        SchemaProperty('deviceType', RealmPropertyType.string, optional: true),
        SchemaProperty('emailConfig', RealmPropertyType.string, optional: true),
        SchemaProperty('smsConfig', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'sendMailFromEmail',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'lastUpdateSmsMailConfig',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('cngNotif', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'fitnessNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'fiveYearPermitNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('hbtNotif', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'insuranceNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'nationalPermitNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'pollutionNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'serviceNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'tokenTaxNotif',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'customFilterUpdate',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'thirdPartyValue',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('appName', RealmPropertyType.string, optional: true),
        SchemaProperty('alarmAlarm', RealmPropertyType.string, optional: true),
        SchemaProperty('alarmName', RealmPropertyType.string, optional: true),
        SchemaProperty('alarmType', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'deviceDetailsAndroidVersion',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'deviceDetailsAppVersion',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'deviceDetailsDeviceType',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'deviceDetailsManufacturer',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'deviceDetailsModel',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'deviceDetailsSdk',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'listViewColumns',
          RealmPropertyType.string,
          collectionType: RealmCollectionType.list,
        ),
        SchemaProperty(
          'listViewTimeFormat',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'privacyPolicyDevId',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'privacyPolicyDevName',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'privacyPolicyDevTstamp',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'activationDate',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty(
          'lastLogin',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty(
          'registerDate',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty('variation', RealmPropertyType.double, optional: true),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
