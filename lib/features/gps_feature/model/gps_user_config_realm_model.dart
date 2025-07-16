import 'package:realm/realm.dart';

import 'gps_user_config_model.dart';

part 'gps_user_config_realm_model.realm.dart';

@RealmModel()
class _GpsUserConfigRealmModel {
  @PrimaryKey()
  late ObjectId id;

  int? userId;
  String? userType;
  String? userProfilePic;
  String? defaultMap;
  int? customZoom;
  int? markerAnimate;
  int? markerCluster;
  int? markerInfobox;
  int? markerLabel;
  int? markerLabelWithSpeed;
  int? markerRouteDirection;
  int? poiLabel;
  int? imageMarkers;
  int? showGeofences;
  int? showGeofenceReport;
  int? autoPanMapGeofenceLoop;
  int? autoPanMapGeofenceTime;
  int? autoRptEmail;
  String? autoRptEmailList;
  int? maintenanceNotifEnable;
  String? maintenanceNotifReceivers;
  String? maintenanceReminders;
  int? stockMgmt;
  int? isThirdParty;
  int? isWasteMgmtVisible;
  int? isloadUnloadVisible;
  int? totalDistAlerts;
  String? totalDistDistanceInterval;
  String? totalDistEmailList;
  String? stopTime;
  String? ignitionOffTime;
  int? callsCount;
  int? lastTenMins;
  String? deviceToken;
  String? deviceType;
  String? emailConfig;
  String? smsConfig;
  String? sendMailFromEmail;
  String? lastUpdateSmsMailConfig;
  String? cngNotif;
  String? fitnessNotif;
  String? fiveYearPermitNotif;
  String? hbtNotif;
  String? insuranceNotif;
  String? nationalPermitNotif;
  String? pollutionNotif;
  String? serviceNotif;
  String? tokenTaxNotif;
  String? customFilterUpdate;
  String? thirdPartyValue;
  String? appName;
  String? alarmAlarm;
  String? alarmName;
  String? alarmType;
  String? deviceDetailsAndroidVersion;
  String? deviceDetailsAppVersion;
  String? deviceDetailsDeviceType;
  String? deviceDetailsManufacturer;
  String? deviceDetailsModel;
  int? deviceDetailsSdk;
  List<String> listViewColumns = [];
  String? listViewTimeFormat;
  String? privacyPolicyDevId;
  String? privacyPolicyDevName;
  String? privacyPolicyDevTstamp;
  DateTime? activationDate;
  DateTime? lastLogin;
  DateTime? registerDate;
  double? variation;
  late DateTime createdAt;
}

extension GpsUserConfigRealmModelMapper on GpsUserConfigRealmModel {
  GpsUserConfigData toDomain() => GpsUserConfigData(
    userId: userId,
    userType: userType,
    userProfilePic: userProfilePic,
    defaultMap: defaultMap,
    customZoom: customZoom,
    markerAnimate: markerAnimate,
    markerCluster: markerCluster,
    markerInfobox: markerInfobox,
    markerLabel: markerLabel,
    markerLabelWithSpeed: markerLabelWithSpeed,
    markerRouteDirection: markerRouteDirection,
    poiLabel: poiLabel,
    imageMarkers: imageMarkers,
    showGeofences: showGeofences,
    showGeofenceReport: showGeofenceReport,
    autoPanMapGeofenceLoop: autoPanMapGeofenceLoop,
    autoPanMapGeofenceTime: autoPanMapGeofenceTime,
    autoRptEmail: autoRptEmail,
    autoRptEmailList: autoRptEmailList,
    maintenanceNotifEnable: maintenanceNotifEnable,
    maintenanceNotifReceivers: maintenanceNotifReceivers,
    maintenanceReminders: maintenanceReminders,
    stockMgmt: stockMgmt,
    isThirdParty: isThirdParty,
    isWasteMgmtVisible: isWasteMgmtVisible,
    isloadUnloadVisible: isloadUnloadVisible,
    totalDistAlerts: totalDistAlerts,
    totalDistDistanceInterval: totalDistDistanceInterval,
    totalDistEmailList: totalDistEmailList,
    stopTime: stopTime,
    ignitionOffTime: ignitionOffTime,
    callsCount: callsCount,
    lastTenMins: lastTenMins,
    deviceToken: deviceToken,
    deviceType: deviceType,
    emailConfig: emailConfig,
    smsConfig: smsConfig,
    sendMailFromEmail: sendMailFromEmail,
    lastUpdateSmsMailConfig: lastUpdateSmsMailConfig,
    cngNotif: cngNotif,
    fitnessNotif: fitnessNotif,
    fiveYearPermitNotif: fiveYearPermitNotif,
    hbtNotif: hbtNotif,
    insuranceNotif: insuranceNotif,
    nationalPermitNotif: nationalPermitNotif,
    pollutionNotif: pollutionNotif,
    serviceNotif: serviceNotif,
    tokenTaxNotif: tokenTaxNotif,
    customFilterUpdate: customFilterUpdate,
    thirdPartyValue: thirdPartyValue,
    appName: appName,
    alarmSettings:
        (alarmAlarm != null || alarmName != null || alarmType != null)
            ? GpsAlarmSettings(
              alarm: alarmAlarm,
              name: alarmName,
              type: alarmType,
            )
            : null,
    deviceDetails:
        (deviceDetailsAndroidVersion != null ||
                deviceDetailsAppVersion != null ||
                deviceDetailsDeviceType != null ||
                deviceDetailsManufacturer != null ||
                deviceDetailsModel != null ||
                deviceDetailsSdk != null)
            ? GpsDeviceDetails(
              androidVersion: deviceDetailsAndroidVersion,
              appVersion: deviceDetailsAppVersion,
              deviceType: deviceDetailsDeviceType,
              manufacturer: deviceDetailsManufacturer,
              model: deviceDetailsModel,
              sdk: deviceDetailsSdk,
            )
            : null,
    listViewSettings:
        (listViewColumns != null || listViewTimeFormat != null)
            ? GpsListViewSettings(
              columns: listViewColumns,
              timeFormat: listViewTimeFormat,
            )
            : null,
    privacyPolicyDevId: privacyPolicyDevId,
    privacyPolicyDevName: privacyPolicyDevName,
    privacyPolicyDevTstamp: privacyPolicyDevTstamp,
    activationDate: activationDate,
    lastLogin: lastLogin,
    registerDate: registerDate,
    variation: variation,
  );

  static GpsUserConfigRealmModel fromDomain(GpsUserConfigData data) {
    final obj = GpsUserConfigRealmModel(
      ObjectId(),
      userId: data.userId,
      userType: data.userType,
      userProfilePic: data.userProfilePic,
      defaultMap: data.defaultMap,
      customZoom: data.customZoom,
      markerAnimate: data.markerAnimate,
      markerCluster: data.markerCluster,
      markerInfobox: data.markerInfobox,
      markerLabel: data.markerLabel,
      markerLabelWithSpeed: data.markerLabelWithSpeed,
      markerRouteDirection: data.markerRouteDirection,
      poiLabel: data.poiLabel,
      imageMarkers: data.imageMarkers,
      showGeofences: data.showGeofences,
      showGeofenceReport: data.showGeofenceReport,
      autoPanMapGeofenceLoop: data.autoPanMapGeofenceLoop,
      autoPanMapGeofenceTime: data.autoPanMapGeofenceTime,
      autoRptEmail: data.autoRptEmail,
      autoRptEmailList: data.autoRptEmailList,
      maintenanceNotifEnable: data.maintenanceNotifEnable,
      maintenanceNotifReceivers: data.maintenanceNotifReceivers,
      maintenanceReminders: data.maintenanceReminders,
      stockMgmt: data.stockMgmt,
      isThirdParty: data.isThirdParty,
      isWasteMgmtVisible: data.isWasteMgmtVisible,
      isloadUnloadVisible: data.isloadUnloadVisible,
      totalDistAlerts: data.totalDistAlerts,
      totalDistDistanceInterval: data.totalDistDistanceInterval,
      totalDistEmailList: data.totalDistEmailList,
      stopTime: data.stopTime,
      ignitionOffTime: data.ignitionOffTime,
      callsCount: data.callsCount,
      lastTenMins: data.lastTenMins,
      deviceToken: data.deviceToken,
      deviceType: data.deviceType,
      emailConfig: data.emailConfig,
      smsConfig: data.smsConfig,
      sendMailFromEmail: data.sendMailFromEmail,
      lastUpdateSmsMailConfig: data.lastUpdateSmsMailConfig,
      cngNotif: data.cngNotif,
      fitnessNotif: data.fitnessNotif,
      fiveYearPermitNotif: data.fiveYearPermitNotif,
      hbtNotif: data.hbtNotif,
      insuranceNotif: data.insuranceNotif,
      nationalPermitNotif: data.nationalPermitNotif,
      pollutionNotif: data.pollutionNotif,
      serviceNotif: data.serviceNotif,
      tokenTaxNotif: data.tokenTaxNotif,
      customFilterUpdate: data.customFilterUpdate,
      thirdPartyValue: data.thirdPartyValue,
      appName: data.appName,
      alarmAlarm: data.alarmSettings?.alarm,
      alarmName: data.alarmSettings?.name,
      alarmType: data.alarmSettings?.type,
      deviceDetailsAndroidVersion: data.deviceDetails?.androidVersion,
      deviceDetailsAppVersion: data.deviceDetails?.appVersion,
      deviceDetailsDeviceType: data.deviceDetails?.deviceType,
      deviceDetailsManufacturer: data.deviceDetails?.manufacturer,
      deviceDetailsModel: data.deviceDetails?.model,
      deviceDetailsSdk: data.deviceDetails?.sdk,
      listViewColumns: data.listViewSettings?.columns ?? [],
      listViewTimeFormat: data.listViewSettings?.timeFormat,
      privacyPolicyDevId: data.privacyPolicyDevId,
      privacyPolicyDevName: data.privacyPolicyDevName,
      privacyPolicyDevTstamp: data.privacyPolicyDevTstamp,
      activationDate: data.activationDate,
      lastLogin: data.lastLogin,
      registerDate: data.registerDate,
      variation: data.variation,
      DateTime.now(),
    );
    return obj;
  }
}
