import 'dart:convert';

GpsUserConfigModel gpsUserConfigModelFromJson(String str) =>
    GpsUserConfigModel.fromJson(json.decode(str));

String gpsUserConfigModelToJson(GpsUserConfigModel data) =>
    json.encode(data.toJson());

class GpsUserConfigModel {
  final List<GpsUserConfigData>? data;

  GpsUserConfigModel({this.data});

  factory GpsUserConfigModel.fromJson(Map<String, dynamic> json) =>
      GpsUserConfigModel(
        data:
            json["data"] != null
                ? List<GpsUserConfigData>.from(
                  json["data"].map((x) => GpsUserConfigData.fromJson(x)),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    "data":
        data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
  };
}

class GpsUserConfigData {
  final int? activationCodes;
  final DateTime? activationDate;
  final int? afterLoginPage;
  final GpsAlarmSettings? alarmSettings;
  final String? appName;
  final int? autoPanMapGeofenceLoop;
  final int? autoPanMapGeofenceTime;
  final int? autoRptEmail;
  final String? autoRptEmailList;
  final int? callsCount;
  final String? cngNotif;
  final String? customFilterUpdate;
  final int? customZoom;
  final String? defaultMap;
  final GpsDeviceDetails? deviceDetails;
  final String? deviceToken;
  final String? deviceType;
  final String? emailConfig;
  final String? fitnessNotif;
  final String? fiveYearPermitNotif;
  final String? hbtNotif;
  final int? id;
  final String? ignitionOffTime;
  final int? imageMarkers;
  final String? insuranceNotif;
  final int? isThirdParty;
  final int? isWasteMgmtVisible;
  final int? isloadUnloadVisible;
  final DateTime? lastLogin;
  final int? lastTenMins;
  final String? lastUpdateSmsMailConfig;
  final GpsListViewSettings? listViewSettings;
  final int? maintenanceNotifEnable;
  final String? maintenanceNotifReceivers;
  final String? maintenanceReminders;
  final int? markerAnimate;
  final int? markerCluster;
  final int? markerInfobox;
  final int? markerLabel;
  final int? markerLabelWithSpeed;
  final int? markerRouteDirection;
  final String? nationalPermitNotif;
  final int? poiLabel;
  final String? pollutionNotif;
  final String? privacyPolicyDevId;
  final String? privacyPolicyDevName;
  final String? privacyPolicyDevTstamp;
  final DateTime? registerDate;
  final String? sendMailFromEmail;
  final String? serviceNotif;
  final int? showGeofenceReport;
  final int? showGeofences;
  final String? smsConfig;
  final int? stockMgmt;
  final String? stopTime;
  final String? thirdPartyValue;
  final String? tokenTaxNotif;
  final int? totalDistAlerts;
  final String? totalDistDistanceInterval;
  final String? totalDistEmailList;
  final int? userId;
  final String? userProfilePic;
  final String? userType;
  final double? variation;

  GpsUserConfigData({
    this.activationCodes,
    this.activationDate,
    this.afterLoginPage,
    this.alarmSettings,
    this.appName,
    this.autoPanMapGeofenceLoop,
    this.autoPanMapGeofenceTime,
    this.autoRptEmail,
    this.autoRptEmailList,
    this.callsCount,
    this.cngNotif,
    this.customFilterUpdate,
    this.customZoom,
    this.defaultMap,
    this.deviceDetails,
    this.deviceToken,
    this.deviceType,
    this.emailConfig,
    this.fitnessNotif,
    this.fiveYearPermitNotif,
    this.hbtNotif,
    this.id,
    this.ignitionOffTime,
    this.imageMarkers,
    this.insuranceNotif,
    this.isThirdParty,
    this.isWasteMgmtVisible,
    this.isloadUnloadVisible,
    this.lastLogin,
    this.lastTenMins,
    this.lastUpdateSmsMailConfig,
    this.listViewSettings,
    this.maintenanceNotifEnable,
    this.maintenanceNotifReceivers,
    this.maintenanceReminders,
    this.markerAnimate,
    this.markerCluster,
    this.markerInfobox,
    this.markerLabel,
    this.markerLabelWithSpeed,
    this.markerRouteDirection,
    this.nationalPermitNotif,
    this.poiLabel,
    this.pollutionNotif,
    this.privacyPolicyDevId,
    this.privacyPolicyDevName,
    this.privacyPolicyDevTstamp,
    this.registerDate,
    this.sendMailFromEmail,
    this.serviceNotif,
    this.showGeofenceReport,
    this.showGeofences,
    this.smsConfig,
    this.stockMgmt,
    this.stopTime,
    this.thirdPartyValue,
    this.tokenTaxNotif,
    this.totalDistAlerts,
    this.totalDistDistanceInterval,
    this.totalDistEmailList,
    this.userId,
    this.userProfilePic,
    this.userType,
    this.variation,
  });

  factory GpsUserConfigData.fromJson(Map<String, dynamic> json) =>
      GpsUserConfigData(
        activationCodes: json["activation_codes"],
        activationDate:
            json["activation_date"] != null
                ? DateTime.tryParse(json["activation_date"])
                : null,
        afterLoginPage: json["after_login_page"],
        alarmSettings:
            json["alarm_settings"] != null
                ? GpsAlarmSettings.fromJson(json["alarm_settings"])
                : null,
        appName: json["app_name"],
        autoPanMapGeofenceLoop: json["auto_pan_map_geofence_loop"],
        autoPanMapGeofenceTime: json["auto_pan_map_geofence_time"],
        autoRptEmail: json["auto_rpt_email"],
        autoRptEmailList: json["auto_rpt_email_list"],
        callsCount: json["calls_count"],
        cngNotif: json["cng_notif"],
        customFilterUpdate: json["custom_filter_update"],
        customZoom: json["custom_zoom"],
        defaultMap: json["default_map"],
        deviceDetails:
            json["device_details"] != null
                ? GpsDeviceDetails.fromJson(json["device_details"])
                : null,
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        emailConfig: json["email_config"],
        fitnessNotif: json["fitness_notif"],
        fiveYearPermitNotif: json["five_year_permit_notif"],
        hbtNotif: json["hbt_notif"],
        id: json["id"],
        ignitionOffTime: json["ignition_off_time"],
        imageMarkers: json["image_markers"],
        insuranceNotif: json["insurance_notif"],
        isThirdParty: json["is_third_party"],
        isWasteMgmtVisible: json["is_waste_mgmt_visible"],
        isloadUnloadVisible: json["isload_unload_visible"],
        lastLogin:
            json["last_login"] != null
                ? DateTime.tryParse(json["last_login"])
                : null,
        lastTenMins: json["last_ten_mins"],
        lastUpdateSmsMailConfig: json["last_update_sms_mail_config"],
        listViewSettings:
            json["list_view_settings"] != null
                ? GpsListViewSettings.fromJson(json["list_view_settings"])
                : null,
        maintenanceNotifEnable: json["maintenance_notif_enable"],
        maintenanceNotifReceivers: json["maintenance_notif_receivers"],
        maintenanceReminders: json["maintenance_reminders"],
        markerAnimate: json["marker_animate"],
        markerCluster: json["marker_cluster"],
        markerInfobox: json["marker_infobox"],
        markerLabel: json["marker_label"],
        markerLabelWithSpeed: json["marker_label_with_speed"],
        markerRouteDirection: json["marker_route_direction"],
        nationalPermitNotif: json["national_permit_notif"],
        poiLabel: json["poi_label"],
        pollutionNotif: json["pollution_notif"],
        privacyPolicyDevId: json["privacy_policy_dev_id"],
        privacyPolicyDevName: json["privacy_policy_dev_name"],
        privacyPolicyDevTstamp: json["privacy_policy_dev_tstamp"],
        registerDate:
            json["register_date"] != null
                ? DateTime.tryParse(json["register_date"])
                : null,
        sendMailFromEmail: json["send_mail_from_email"],
        serviceNotif: json["service_notif"],
        showGeofenceReport: json["show_geofence_report"],
        showGeofences: json["show_geofences"],
        smsConfig: json["sms_config"],
        stockMgmt: json["stock_mgmt"],
        stopTime: json["stop_time"],
        thirdPartyValue: json["third_party_value"],
        tokenTaxNotif: json["token_tax_notif"],
        totalDistAlerts: json["total_dist_alerts"],
        totalDistDistanceInterval: json["total_dist_distance_interval"],
        totalDistEmailList: json["total_dist_email_list"],
        userId: json["user_id"],
        userProfilePic: json["user_profile_pic"],
        userType: json["user_type"],
        variation: json["variation"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "activation_codes": activationCodes,
    "activation_date": activationDate?.toIso8601String(),
    "after_login_page": afterLoginPage,
    "alarm_settings": alarmSettings?.toJson(),
    "app_name": appName,
    "auto_pan_map_geofence_loop": autoPanMapGeofenceLoop,
    "auto_pan_map_geofence_time": autoPanMapGeofenceTime,
    "auto_rpt_email": autoRptEmail,
    "auto_rpt_email_list": autoRptEmailList,
    "calls_count": callsCount,
    "cng_notif": cngNotif,
    "custom_filter_update": customFilterUpdate,
    "custom_zoom": customZoom,
    "default_map": defaultMap,
    "device_details": deviceDetails?.toJson(),
    "device_token": deviceToken,
    "device_type": deviceType,
    "email_config": emailConfig,
    "fitness_notif": fitnessNotif,
    "five_year_permit_notif": fiveYearPermitNotif,
    "hbt_notif": hbtNotif,
    "id": id,
    "ignition_off_time": ignitionOffTime,
    "image_markers": imageMarkers,
    "insurance_notif": insuranceNotif,
    "is_third_party": isThirdParty,
    "is_waste_mgmt_visible": isWasteMgmtVisible,
    "isload_unload_visible": isloadUnloadVisible,
    "last_login": lastLogin?.toIso8601String(),
    "last_ten_mins": lastTenMins,
    "last_update_sms_mail_config": lastUpdateSmsMailConfig,
    "list_view_settings": listViewSettings?.toJson(),
    "maintenance_notif_enable": maintenanceNotifEnable,
    "maintenance_notif_receivers": maintenanceNotifReceivers,
    "maintenance_reminders": maintenanceReminders,
    "marker_animate": markerAnimate,
    "marker_cluster": markerCluster,
    "marker_infobox": markerInfobox,
    "marker_label": markerLabel,
    "marker_label_with_speed": markerLabelWithSpeed,
    "marker_route_direction": markerRouteDirection,
    "national_permit_notif": nationalPermitNotif,
    "poi_label": poiLabel,
    "pollution_notif": pollutionNotif,
    "privacy_policy_dev_id": privacyPolicyDevId,
    "privacy_policy_dev_name": privacyPolicyDevName,
    "privacy_policy_dev_tstamp": privacyPolicyDevTstamp,
    "register_date": registerDate?.toIso8601String(),
    "send_mail_from_email": sendMailFromEmail,
    "service_notif": serviceNotif,
    "show_geofence_report": showGeofenceReport,
    "show_geofences": showGeofences,
    "sms_config": smsConfig,
    "stock_mgmt": stockMgmt,
    "stop_time": stopTime,
    "third_party_value": thirdPartyValue,
    "token_tax_notif": tokenTaxNotif,
    "total_dist_alerts": totalDistAlerts,
    "total_dist_distance_interval": totalDistDistanceInterval,
    "total_dist_email_list": totalDistEmailList,
    "user_id": userId,
    "user_profile_pic": userProfilePic,
    "user_type": userType,
    "variation": variation,
  };
}

class GpsAlarmSettings {
  final String? alarm;
  final String? name;
  final String? type;

  GpsAlarmSettings({this.alarm, this.name, this.type});

  factory GpsAlarmSettings.fromJson(Map<String, dynamic> json) =>
      GpsAlarmSettings(
        alarm: json["alarm"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {"alarm": alarm, "name": name, "type": type};
}

class GpsDeviceDetails {
  final String? androidVersion;
  final String? appVersion;
  final String? deviceType;
  final String? manufacturer;
  final String? model;
  final int? sdk;

  GpsDeviceDetails({
    this.androidVersion,
    this.appVersion,
    this.deviceType,
    this.manufacturer,
    this.model,
    this.sdk,
  });

  factory GpsDeviceDetails.fromJson(Map<String, dynamic> json) =>
      GpsDeviceDetails(
        androidVersion: json["androidVersion"],
        appVersion: json["app_version"],
        deviceType: json["deviceType"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        sdk: json["sdk"],
      );

  Map<String, dynamic> toJson() => {
    "androidVersion": androidVersion,
    "app_version": appVersion,
    "deviceType": deviceType,
    "manufacturer": manufacturer,
    "model": model,
    "sdk": sdk,
  };
}

class GpsListViewSettings {
  final List<String>? columns;
  final String? timeFormat;

  GpsListViewSettings({this.columns, this.timeFormat});

  factory GpsListViewSettings.fromJson(Map<String, dynamic> json) =>
      GpsListViewSettings(
        columns:
            json["columns"] != null ? List<String>.from(json["columns"]) : null,
        timeFormat: json["timeFormat"],
      );

  Map<String, dynamic> toJson() => {
    "columns": columns != null ? List<dynamic>.from(columns!) : null,
    "timeFormat": timeFormat,
  };
}
