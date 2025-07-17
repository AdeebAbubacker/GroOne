import 'dart:convert';

GpsMobileConfigModel gpsMobileConfigModelFromJson(String str) =>
    GpsMobileConfigModel.fromJson(json.decode(str));

String gpsMobileConfigModelToJson(GpsMobileConfigModel data) =>
    json.encode(data.toJson());

class GpsMobileConfigModel {
  final GpsMobileConfigData? data;

  GpsMobileConfigModel({this.data});

  factory GpsMobileConfigModel.fromJson(Map<String, dynamic> json) =>
      GpsMobileConfigModel(
        data:
            json["data"] != null
                ? GpsMobileConfigData.fromJson(json["data"])
                : null,
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class GpsMobileConfigData {
  final dynamic admin;
  final GpsAppSettings? appSettings;
  final dynamic bluetoothImmoblize;
  final dynamic dashboard;
  final String? faqUrl;
  final GpsFreshChat? freshChat;
  final dynamic geofenceDashboard;
  final dynamic immobilize;
  final dynamic liveStream;
  final dynamic parkingMode;
  final GpsPoi? poi;
  final dynamic qrScanCall;
  final GpsReport? report;
  final GpsSubscription? subscription;
  final dynamic testNotification;
  final String? whiteLabelUrl;

  GpsMobileConfigData({
    this.admin,
    this.appSettings,
    this.bluetoothImmoblize,
    this.dashboard,
    this.faqUrl,
    this.freshChat,
    this.geofenceDashboard,
    this.immobilize,
    this.liveStream,
    this.parkingMode,
    this.poi,
    this.qrScanCall,
    this.report,
    this.subscription,
    this.testNotification,
    this.whiteLabelUrl,
  });

  factory GpsMobileConfigData.fromJson(Map<String, dynamic> json) =>
      GpsMobileConfigData(
        admin: json["admin"],
        appSettings:
            json["app_settings"] != null
                ? GpsAppSettings.fromJson(json["app_settings"])
                : null,
        bluetoothImmoblize: json["bluetooth_immoblize"],
        dashboard: json["dashboard"],
        faqUrl: json["faq_url"],
        freshChat:
            json["fresh_chat"] != null
                ? GpsFreshChat.fromJson(json["fresh_chat"])
                : null,
        geofenceDashboard: json["geofence_dashboard"],
        immobilize: json["immobilize"],
        liveStream: json["live_stream"],
        parkingMode: json["parking_mode"],
        poi: json["poi"] != null ? GpsPoi.fromJson(json["poi"]) : null,
        qrScanCall: json["qr_scan_call"],
        report:
            json["report"] != null ? GpsReport.fromJson(json["report"]) : null,
        subscription:
            json["subscription"] != null
                ? GpsSubscription.fromJson(json["subscription"])
                : null,
        testNotification: json["test_notification"],
        whiteLabelUrl: json["white_label_url"],
      );

  Map<String, dynamic> toJson() => {
    "admin": admin,
    "app_settings": appSettings?.toJson(),
    "bluetooth_immoblize": bluetoothImmoblize,
    "dashboard": dashboard,
    "faq_url": faqUrl,
    "fresh_chat": freshChat?.toJson(),
    "geofence_dashboard": geofenceDashboard,
    "immobilize": immobilize,
    "live_stream": liveStream,
    "parking_mode": parkingMode,
    "poi": poi?.toJson(),
    "qr_scan_call": qrScanCall,
    "report": report?.toJson(),
    "subscription": subscription?.toJson(),
    "test_notification": testNotification,
    "white_label_url": whiteLabelUrl,
  };
}

class GpsAppSettings {
  final GpsCallCredit? callCredit;
  final bool? showLastVehOnRestartApp;

  GpsAppSettings({this.callCredit, this.showLastVehOnRestartApp});

  factory GpsAppSettings.fromJson(Map<String, dynamic> json) => GpsAppSettings(
    callCredit:
        json["call_credit"] != null
            ? GpsCallCredit.fromJson(json["call_credit"])
            : null,
    showLastVehOnRestartApp: json["show_last_veh_on_restart_app"],
  );

  Map<String, dynamic> toJson() => {
    "call_credit": callCredit?.toJson(),
    "show_last_veh_on_restart_app": showLastVehOnRestartApp,
  };
}

class GpsCallCredit {
  final bool? active;
  final GpsRazorPayDetails? razorPayDetails;

  GpsCallCredit({this.active, this.razorPayDetails});

  factory GpsCallCredit.fromJson(Map<String, dynamic> json) => GpsCallCredit(
    active: json["active"],
    razorPayDetails:
        json["razor_pay_details"] != null
            ? GpsRazorPayDetails.fromJson(json["razor_pay_details"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "razor_pay_details": razorPayDetails?.toJson(),
  };
}

class GpsRazorPayDetails {
  final String? razorPayKey;
  final String? saltId;
  final String? saltPassword;

  GpsRazorPayDetails({this.razorPayKey, this.saltId, this.saltPassword});

  factory GpsRazorPayDetails.fromJson(Map<String, dynamic> json) =>
      GpsRazorPayDetails(
        razorPayKey: json["razor_pay_key"],
        saltId: json["salt_id"],
        saltPassword: json["salt_password"],
      );

  Map<String, dynamic> toJson() => {
    "razor_pay_key": razorPayKey,
    "salt_id": saltId,
    "salt_password": saltPassword,
  };
}

class GpsFreshChat {
  final bool? active;
  final GpsFreshChatDetails? freshChatDetails;
  final GpsSupportDetails? supportDetails;

  GpsFreshChat({this.active, this.freshChatDetails, this.supportDetails});

  factory GpsFreshChat.fromJson(Map<String, dynamic> json) => GpsFreshChat(
    active: json["active"],
    freshChatDetails:
        json["fresh_chat_details"] != null
            ? GpsFreshChatDetails.fromJson(json["fresh_chat_details"])
            : null,
    supportDetails:
        json["support_details"] != null
            ? GpsSupportDetails.fromJson(json["support_details"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "fresh_chat_details": freshChatDetails?.toJson(),
    "support_details": supportDetails?.toJson(),
  };
}

class GpsFreshChatDetails {
  final String? id;
  final String? key;

  GpsFreshChatDetails({this.id, this.key});

  factory GpsFreshChatDetails.fromJson(Map<String, dynamic> json) =>
      GpsFreshChatDetails(id: json["Id"], key: json["key"]);

  Map<String, dynamic> toJson() => {"Id": id, "key": key};
}

class GpsSupportDetails {
  final List<String>? email;
  final String? helpImageUrl;
  final List<String>? mobile;
  final String? websiteUrl;
  final String? whatsapp;

  GpsSupportDetails({
    this.email,
    this.helpImageUrl,
    this.mobile,
    this.websiteUrl,
    this.whatsapp,
  });

  factory GpsSupportDetails.fromJson(Map<String, dynamic> json) =>
      GpsSupportDetails(
        email: json["email"] != null ? List<String>.from(json["email"]) : null,
        helpImageUrl: json["help_image_url"],
        mobile:
            json["mobile"] != null ? List<String>.from(json["mobile"]) : null,
        websiteUrl: json["website_url"],
        whatsapp: json["whatsapp"],
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "help_image_url": helpImageUrl,
    "mobile": mobile,
    "website_url": websiteUrl,
    "whatsapp": whatsapp,
  };
}

class GpsPoi {
  final bool? create;
  final bool? delete;
  final bool? show;
  final bool? update;

  GpsPoi({this.create, this.delete, this.show, this.update});

  factory GpsPoi.fromJson(Map<String, dynamic> json) => GpsPoi(
    create: json["create"],
    delete: json["delete"],
    show: json["show"],
    update: json["update"],
  );

  Map<String, dynamic> toJson() => {
    "create": create,
    "delete": delete,
    "show": show,
    "update": update,
  };
}

class GpsReport {
  final bool? active;
  final dynamic otherReports;

  GpsReport({this.active, this.otherReports});

  factory GpsReport.fromJson(Map<String, dynamic> json) =>
      GpsReport(active: json["active"], otherReports: json["other_reports"]);

  Map<String, dynamic> toJson() => {
    "active": active,
    "other_reports": otherReports,
  };
}

class GpsSubscription {
  final bool? active;
  final GpsRazorPayDetails? razorPayDetails;

  GpsSubscription({this.active, this.razorPayDetails});

  factory GpsSubscription.fromJson(Map<String, dynamic> json) =>
      GpsSubscription(
        active: json["active"],
        razorPayDetails:
            json["razor_pay_details"] != null
                ? GpsRazorPayDetails.fromJson(json["razor_pay_details"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "active": active,
    "razor_pay_details": razorPayDetails?.toJson(),
  };
}
