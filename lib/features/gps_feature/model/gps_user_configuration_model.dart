import 'dart:convert';

GpsUserConfigurationModel gpsUserConfigurationModelFromJson(String str) =>
    GpsUserConfigurationModel.fromJson(json.decode(str));

String gpsUserConfigurationModelToJson(GpsUserConfigurationModel data) =>
    json.encode(data.toJson());

class GpsUserConfigurationModel {
  final List<GpsUserConfigurationData>? data;
  final bool? success;
  final int? total;

  GpsUserConfigurationModel({this.data, this.success, this.total});

  factory GpsUserConfigurationModel.fromJson(Map<String, dynamic> json) =>
      GpsUserConfigurationModel(
        data:
            json["data"] != null
                ? List<GpsUserConfigurationData>.from(
                  json["data"].map((x) => GpsUserConfigurationData.fromJson(x)),
                )
                : null,
        success: json["success"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "data":
        data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
    "success": success,
    "total": total,
  };
}

class GpsUserConfigurationData {
  final int? activationCodes;
  final bool? addDevicePermission;
  final String? address;
  final String? alternateContact;
  final String? alternateEmail;
  final int? companyId;
  final DateTime? createdOn;
  final String? defaultMap;
  final bool? deleteDevicePermission;
  final int? deviceCountOfChildren;
  final int? deviceInactiveHours;
  final int? deviceLimitAvailable;
  final int? deviceLimitTotal;
  final int? deviceLimitTransferred;
  final int? deviceLimitUsed;
  final bool? editDevicePermission;
  final String? googleAiDeviceId;
  final String? googleAiEmail;
  final int? id;
  final String? idProofNumber;
  final String? idProofUpload;
  final bool? liveStream;
  final dynamic mapOptions;
  final GpsUserConfigurationMore? more;
  final String? name;
  final int? pastReportDays;
  final int? serverId;
  final int? showAllPoiInAddress;
  final int? simAddPermission;
  final int? simViewPermission;
  final int? stockAddPermission;
  final int? stockViewPermission;
  final DateTime? updatedOn;
  final int? usePoiAsAddress;
  final int? userLimitTotal;
  final int? userLimitTransferred;
  final int? userLimitUsed;
  final GpsWebMenu? webMenu;

  GpsUserConfigurationData({
    this.activationCodes,
    this.addDevicePermission,
    this.address,
    this.alternateContact,
    this.alternateEmail,
    this.companyId,
    this.createdOn,
    this.defaultMap,
    this.deleteDevicePermission,
    this.deviceCountOfChildren,
    this.deviceInactiveHours,
    this.deviceLimitAvailable,
    this.deviceLimitTotal,
    this.deviceLimitTransferred,
    this.deviceLimitUsed,
    this.editDevicePermission,
    this.googleAiDeviceId,
    this.googleAiEmail,
    this.id,
    this.idProofNumber,
    this.idProofUpload,
    this.liveStream,
    this.mapOptions,
    this.more,
    this.name,
    this.pastReportDays,
    this.serverId,
    this.showAllPoiInAddress,
    this.simAddPermission,
    this.simViewPermission,
    this.stockAddPermission,
    this.stockViewPermission,
    this.updatedOn,
    this.usePoiAsAddress,
    this.userLimitTotal,
    this.userLimitTransferred,
    this.userLimitUsed,
    this.webMenu,
  });

  factory GpsUserConfigurationData.fromJson(Map<String, dynamic> json) =>
      GpsUserConfigurationData(
        activationCodes: json["activation_codes"],
        addDevicePermission: json["add_device_permission"],
        address: json["address"],
        alternateContact: json["alternate_contact"],
        alternateEmail: json["alternate_email"],
        companyId: json["company_id"],
        createdOn:
            json["created_on"] != null
                ? DateTime.tryParse(json["created_on"])
                : null,
        defaultMap: json["default_map"],
        deleteDevicePermission: json["delete_device_permission"],
        deviceCountOfChildren: json["device_count_of_children"],
        deviceInactiveHours: json["device_inactive_hours"],
        deviceLimitAvailable: json["device_limit_available"],
        deviceLimitTotal: json["device_limit_total"],
        deviceLimitTransferred: json["device_limit_transferred"],
        deviceLimitUsed: json["device_limit_used"],
        editDevicePermission: json["edit_device_permission"],
        googleAiDeviceId: json["google_ai_device_id"],
        googleAiEmail: json["google_ai_email"],
        id: json["id"],
        idProofNumber: json["id_proof_number"],
        idProofUpload: json["id_proof_upload"],
        liveStream: json["live_stream"],
        mapOptions: json["map_options"],
        more:
            json["more"] != null
                ? GpsUserConfigurationMore.fromJson(json["more"])
                : null,
        name: json["name"],
        pastReportDays: json["past_report_days"],
        serverId: json["server_id"],
        showAllPoiInAddress: json["show_all_poi_in_address"],
        simAddPermission: json["sim_add_permission"],
        simViewPermission: json["sim_view_permission"],
        stockAddPermission: json["stock_add_permission"],
        stockViewPermission: json["stock_view_permission"],
        updatedOn:
            json["updated_on"] != null
                ? DateTime.tryParse(json["updated_on"])
                : null,
        usePoiAsAddress: json["use_poi_as_address"],
        userLimitTotal: json["user_limit_total"],
        userLimitTransferred: json["user_limit_transferred"],
        userLimitUsed: json["user_limit_used"],
        webMenu:
            json["web_menu"] != null
                ? GpsWebMenu.fromJson(json["web_menu"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "activation_codes": activationCodes,
    "add_device_permission": addDevicePermission,
    "address": address,
    "alternate_contact": alternateContact,
    "alternate_email": alternateEmail,
    "company_id": companyId,
    "created_on": createdOn?.toIso8601String(),
    "default_map": defaultMap,
    "delete_device_permission": deleteDevicePermission,
    "device_count_of_children": deviceCountOfChildren,
    "device_inactive_hours": deviceInactiveHours,
    "device_limit_available": deviceLimitAvailable,
    "device_limit_total": deviceLimitTotal,
    "device_limit_transferred": deviceLimitTransferred,
    "device_limit_used": deviceLimitUsed,
    "edit_device_permission": editDevicePermission,
    "google_ai_device_id": googleAiDeviceId,
    "google_ai_email": googleAiEmail,
    "id": id,
    "id_proof_number": idProofNumber,
    "id_proof_upload": idProofUpload,
    "live_stream": liveStream,
    "map_options": mapOptions,
    "more": more?.toJson(),
    "name": name,
    "past_report_days": pastReportDays,
    "server_id": serverId,
    "show_all_poi_in_address": showAllPoiInAddress,
    "sim_add_permission": simAddPermission,
    "sim_view_permission": simViewPermission,
    "stock_add_permission": stockAddPermission,
    "stock_view_permission": stockViewPermission,
    "updated_on": updatedOn?.toIso8601String(),
    "use_poi_as_address": usePoiAsAddress,
    "user_limit_total": userLimitTotal,
    "user_limit_transferred": userLimitTransferred,
    "user_limit_used": userLimitUsed,
    "web_menu": webMenu?.toJson(),
  };
}

class GpsUserConfigurationMore {
  final List<String>? bookmarkDevices;
  final String? expiryAlertsBeforeDays;
  final bool? geofenceLabel;
  final int? listViewIdleSeconds;
  final bool? poiShowDefault;
  final int? poiShowOnZoom;
  final Map<String, dynamic>? reports;

  GpsUserConfigurationMore({
    this.bookmarkDevices,
    this.expiryAlertsBeforeDays,
    this.geofenceLabel,
    this.listViewIdleSeconds,
    this.poiShowDefault,
    this.poiShowOnZoom,
    this.reports,
  });

  factory GpsUserConfigurationMore.fromJson(Map<String, dynamic> json) =>
      GpsUserConfigurationMore(
        bookmarkDevices:
            json["bookmark_devices"] != null
                ? List<String>.from(json["bookmark_devices"])
                : null,
        expiryAlertsBeforeDays: json["expiry_alerts_before_days"],
        geofenceLabel: json["geofenceLabel"],
        listViewIdleSeconds: json["list_view_idle_seconds"],
        poiShowDefault: json["poiShowDefault"],
        poiShowOnZoom: json["poiShowOnZoom"],
        reports:
            json["reports"] != null
                ? Map<String, dynamic>.from(json["reports"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "bookmark_devices": bookmarkDevices,
    "expiry_alerts_before_days": expiryAlertsBeforeDays,
    "geofenceLabel": geofenceLabel,
    "list_view_idle_seconds": listViewIdleSeconds,
    "poiShowDefault": poiShowDefault,
    "poiShowOnZoom": poiShowOnZoom,
    "reports": reports,
  };
}

class GpsWebMenu {
  final GpsWebMenuItem? dashboard;
  final GpsWebMenuItem? etaDashboard;
  final GpsWebMenuItem? expense;
  final GpsWebMenuItem? geofence;
  final GpsWebMenuItem? home;
  final GpsWebMenuItem? manage;
  final GpsWebMenuItem? reports;
  final GpsWebMenuItem? settings;
  final GpsWebMenuItem? smsTracking;

  GpsWebMenu({
    this.dashboard,
    this.etaDashboard,
    this.expense,
    this.geofence,
    this.home,
    this.manage,
    this.reports,
    this.settings,
    this.smsTracking,
  });

  factory GpsWebMenu.fromJson(Map<String, dynamic> json) => GpsWebMenu(
    dashboard:
        json["dashboard"] != null
            ? GpsWebMenuItem.fromJson(json["dashboard"])
            : null,
    etaDashboard:
        json["eta_dashboard"] != null
            ? GpsWebMenuItem.fromJson(json["eta_dashboard"])
            : null,
    expense:
        json["expense"] != null
            ? GpsWebMenuItem.fromJson(json["expense"])
            : null,
    geofence:
        json["geofence"] != null
            ? GpsWebMenuItem.fromJson(json["geofence"])
            : null,
    home: json["home"] != null ? GpsWebMenuItem.fromJson(json["home"]) : null,
    manage:
        json["manage"] != null ? GpsWebMenuItem.fromJson(json["manage"]) : null,
    reports:
        json["reports"] != null
            ? GpsWebMenuItem.fromJson(json["reports"])
            : null,
    settings:
        json["settings"] != null
            ? GpsWebMenuItem.fromJson(json["settings"])
            : null,
    smsTracking:
        json["sms_tracking"] != null
            ? GpsWebMenuItem.fromJson(json["sms_tracking"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "dashboard": dashboard?.toJson(),
    "eta_dashboard": etaDashboard?.toJson(),
    "expense": expense?.toJson(),
    "geofence": geofence?.toJson(),
    "home": home?.toJson(),
    "manage": manage?.toJson(),
    "reports": reports?.toJson(),
    "settings": settings?.toJson(),
    "sms_tracking": smsTracking?.toJson(),
  };
}

class GpsWebMenuItem {
  final String? disableMessage;
  final bool? enable;
  final bool? showDisabledMenu;
  final String? url;

  GpsWebMenuItem({
    this.disableMessage,
    this.enable,
    this.showDisabledMenu,
    this.url,
  });

  factory GpsWebMenuItem.fromJson(Map<String, dynamic> json) => GpsWebMenuItem(
    disableMessage: json["disable_message"],
    enable: json["enable"],
    showDisabledMenu: json["show_disabled_menu"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "disable_message": disableMessage,
    "enable": enable,
    "show_disabled_menu": showDisabledMenu,
    "url": url,
  };
}
