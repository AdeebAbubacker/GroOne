import 'dart:convert';

GpsDevicesExpiryModel gpsDevicesExpiryModelFromJson(String str) =>
    GpsDevicesExpiryModel.fromJson(json.decode(str));

String gpsDevicesExpiryModelToJson(GpsDevicesExpiryModel data) =>
    json.encode(data.toJson());

class GpsDevicesExpiryModel {
  final bool success;
  final String message;
  final List<GpsDeviceExpiryData>? data;

  GpsDevicesExpiryModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory GpsDevicesExpiryModel.fromJson(Map<String, dynamic> json) =>
      GpsDevicesExpiryModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data:
            json["data"] != null
                ? List<GpsDeviceExpiryData>.from(
                  (json["data"] as List).map(
                    (x) =>
                        GpsDeviceExpiryData.fromJson(x as Map<String, dynamic>),
                  ),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class GpsDeviceExpiryData {
  final int? id;
  final String? name;
  final String? category;
  final String? contact;
  final String? dateAdded;
  final int? disabled;
  final bool? expired;
  final int? groupId;
  final String? lastRenewalDate;
  final int? lastUpdate;
  final String? lastUpdateRfc3339;
  final String? model;
  final String? phone;
  final int? positionId;
  final int? status;
  final String? subscriptionExpiryDate;
  final String? uniqueId;
  final GpsDeviceAttributes? attributes;

  GpsDeviceExpiryData({
    this.id,
    this.name,
    this.category,
    this.contact,
    this.dateAdded,
    this.disabled,
    this.expired,
    this.groupId,
    this.lastRenewalDate,
    this.lastUpdate,
    this.lastUpdateRfc3339,
    this.model,
    this.phone,
    this.positionId,
    this.status,
    this.subscriptionExpiryDate,
    this.uniqueId,
    this.attributes,
  });

  factory GpsDeviceExpiryData.fromJson(Map<String, dynamic> json) {
    // Handle phone field which can be either number or string
    dynamic phone = json["phone"];
    String? phoneString;
    if (phone != null) {
      if (phone is int) {
        phoneString = phone.toString();
      } else if (phone is double) {
        phoneString = phone.toInt().toString();
      } else if (phone is String) {
        phoneString = phone;
      }
    }

    return GpsDeviceExpiryData(
      id: json["id"],
      name: json["name"]?.toString(),
      category: json["category"]?.toString(),
      contact: json["contact"]?.toString(),
      dateAdded: json["date_added"]?.toString(),
      disabled: json["disabled"],
      expired: json["expired"],
      groupId: json["groupid"],
      lastRenewalDate: json["last_renewal_date"]?.toString(),
      lastUpdate: json["lastupdate"],
      lastUpdateRfc3339: json["lastupdate_rfc3339"]?.toString(),
      model: json["model"]?.toString(),
      phone: phoneString,
      positionId: json["positionid"],
      status: json["status"],
      subscriptionExpiryDate: json["subscription_expiry_date"]?.toString(),
      uniqueId: json["uniqueid"]?.toString(),
      attributes:
          json["attributes"] != null
              ? GpsDeviceAttributes.fromJson(json["attributes"])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "contact": contact,
    "date_added": dateAdded,
    "disabled": disabled,
    "expired": expired,
    "groupid": groupId,
    "last_renewal_date": lastRenewalDate,
    "lastupdate": lastUpdate,
    "lastupdate_rfc3339": lastUpdateRfc3339,
    "model": model,
    "phone": phone,
    "positionid": positionId,
    "status": status,
    "subscription_expiry_date": subscriptionExpiryDate,
    "uniqueid": uniqueId,
    "attributes": attributes?.toJson(),
  };
}

class GpsDeviceAttributes {
  final int? prevHours;
  final double? prevOdometer;
  final String? resetDate;
  final String? speedLimit;
  final Map<String, dynamic>? additionalInfo;

  GpsDeviceAttributes({
    this.prevHours,
    this.prevOdometer,
    this.resetDate,
    this.speedLimit,
    this.additionalInfo,
  });

  factory GpsDeviceAttributes.fromJson(Map<String, dynamic> json) {
    // Handle speedLimit which can be either double or string
    dynamic speedLimit = json["speedLimit"];
    String? speedLimitString;
    if (speedLimit != null) {
      if (speedLimit is double) {
        speedLimitString = speedLimit.toString();
      } else if (speedLimit is int) {
        speedLimitString = speedLimit.toString();
      } else if (speedLimit is String) {
        speedLimitString = speedLimit;
      }
    }

    return GpsDeviceAttributes(
      prevHours: json["prevHours"],
      prevOdometer: json["prevOdometer"]?.toDouble(),
      resetDate: json["resetDate"]?.toString(),
      speedLimit: speedLimitString,
      additionalInfo: json["additional_info"],
    );
  }

  Map<String, dynamic> toJson() => {
    "prevHours": prevHours,
    "prevOdometer": prevOdometer,
    "resetDate": resetDate,
    "speedLimit": speedLimit,
    "additional_info": additionalInfo,
  };
}
