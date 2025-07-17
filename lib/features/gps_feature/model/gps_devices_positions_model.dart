import 'dart:convert';

GpsDevicesPositionsModel gpsDevicesPositionsModelFromJson(String str) =>
    GpsDevicesPositionsModel.fromJson(json.decode(str));

String gpsDevicesPositionsModelToJson(GpsDevicesPositionsModel data) =>
    json.encode(data.toJson());

class GpsDevicesPositionsModel {
  final bool success;
  final String message;
  final Map<String, GpsDevicePositionData>? data;
  final GpsPositionCounts? counts;
  final int? dbTotal;
  final String? deviceNameSos;
  final int? sosCount;

  GpsDevicesPositionsModel({
    required this.success,
    required this.message,
    this.data,
    this.counts,
    this.dbTotal,
    this.deviceNameSos,
    this.sosCount,
  });

  factory GpsDevicesPositionsModel.fromJson(Map<String, dynamic> json) =>
      GpsDevicesPositionsModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data:
            json["data"] != null
                ? Map.from(json["data"]).map(
                  (k, v) => MapEntry(
                    k.toString(),
                    GpsDevicePositionData.fromJson(v as Map<String, dynamic>),
                  ),
                )
                : null,
        counts:
            json["counts"] != null
                ? GpsPositionCounts.fromJson(json["counts"])
                : null,
        dbTotal: json["db_total"],
        deviceNameSos: json["device_name_sos"]?.toString(),
        sosCount: json["sos_count"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.map((k, v) => MapEntry(k, v.toJson())),
    "counts": counts?.toJson(),
    "db_total": dbTotal,
    "device_name_sos": deviceNameSos,
    "sos_count": sosCount,
  };
}

class GpsDevicePositionData {
  final int? id;
  final String? name;
  final String? category;
  final String? course;
  final String? distance;
  final bool? expired;
  final String? externalId;
  final int? filterStatus;
  final bool? gpsStatus;
  final String? idleFixTimeKey;
  final String? ignition;
  final String? lastRenewalDate;
  final String? posAttr;
  final String? prevOdometer;
  final String? protocol;
  final String? speed;
  final int? status;
  final String? subscriptionExpiryDate;
  final String? totalDistance;
  final String? tripName;
  final String? uniqueId;
  final String? valid;
  final String? alarm;
  final String? deviceStatus;
  final String? fixTime;
  final String? geofenceIds;
  final String? harshAccelerations;
  final String? harshBrakings;
  final String? harshCornerings;
  final String? idleFixTime;
  final String? lastIgnitionOffFixTime;
  final String? lastIgnitionOnFixTime;
  final String? lastUpdate;
  final String? latitude;
  final String? longitude;
  final String? network;
  final String? overSpeeds;
  final String? pushedtoServer;
  final String? serverTime;
  final String? tmp;

  GpsDevicePositionData({
    this.id,
    this.name,
    this.category,
    this.course,
    this.distance,
    this.expired,
    this.externalId,
    this.filterStatus,
    this.gpsStatus,
    this.idleFixTimeKey,
    this.ignition,
    this.lastRenewalDate,
    this.posAttr,
    this.prevOdometer,
    this.protocol,
    this.speed,
    this.status,
    this.subscriptionExpiryDate,
    this.totalDistance,
    this.tripName,
    this.uniqueId,
    this.valid,
    this.alarm,
    this.deviceStatus,
    this.fixTime,
    this.geofenceIds,
    this.harshAccelerations,
    this.harshBrakings,
    this.harshCornerings,
    this.idleFixTime,
    this.lastIgnitionOffFixTime,
    this.lastIgnitionOnFixTime,
    this.lastUpdate,
    this.latitude,
    this.longitude,
    this.network,
    this.overSpeeds,
    this.pushedtoServer,
    this.serverTime,
    this.tmp,
  });

  factory GpsDevicePositionData.fromJson(Map<String, dynamic> json) =>
      GpsDevicePositionData(
        id: json["id"],
        name: json["name"]?.toString(),
        category: json["category"]?.toString(),
        course: json["course"]?.toString(),
        distance: json["distance"]?.toString(),
        expired: json["expired"],
        externalId: json["external_id"]?.toString(),
        filterStatus: json["filterStatus"],
        gpsStatus: json["gps_status"],
        idleFixTimeKey: json["idleFixTimeKey"]?.toString(),
        ignition: json["ignition"]?.toString(),
        lastRenewalDate: json["last_renewal_date"]?.toString(),
        posAttr: json["posAttr"]?.toString(),
        prevOdometer: json["prevOdometer"]?.toString(),
        protocol: json["protocol"]?.toString(),
        speed: json["speed"]?.toString(),
        status: json["status"],
        subscriptionExpiryDate: json["subscription_expiry_date"]?.toString(),
        totalDistance: json["totalDistance"]?.toString(),
        tripName: json["trip_name"]?.toString(),
        uniqueId: json["uniqueId"]?.toString(),
        valid: json["valid"]?.toString(),
        alarm: json["alarm"]?.toString(),
        deviceStatus: json["deviceStatus"]?.toString(),
        fixTime: json["fixTime"]?.toString(),
        geofenceIds: json["geofenceIds"]?.toString(),
        harshAccelerations: json["harshAccelerations"]?.toString(),
        harshBrakings: json["harshBrakings"]?.toString(),
        harshCornerings: json["harshCornerings"]?.toString(),
        idleFixTime: json["idleFixTime"]?.toString(),
        lastIgnitionOffFixTime: json["lastIgnitionOffFixTime"]?.toString(),
        lastIgnitionOnFixTime: json["lastIgnitionOnFixTime"]?.toString(),
        lastUpdate: json["lastUpdate"]?.toString(),
        latitude: json["latitude"]?.toString(),
        longitude: json["longitude"]?.toString(),
        network: json["network"]?.toString(),
        overSpeeds: json["overSpeeds"]?.toString(),
        pushedtoServer: json["pushedtoServer"]?.toString(),
        serverTime: json["serverTime"]?.toString(),
        tmp: json["tmp"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "course": course,
    "distance": distance,
    "expired": expired,
    "external_id": externalId,
    "filterStatus": filterStatus,
    "gps_status": gpsStatus,
    "idleFixTimeKey": idleFixTimeKey,
    "ignition": ignition,
    "last_renewal_date": lastRenewalDate,
    "posAttr": posAttr,
    "prevOdometer": prevOdometer,
    "protocol": protocol,
    "speed": speed,
    "status": status,
    "subscription_expiry_date": subscriptionExpiryDate,
    "totalDistance": totalDistance,
    "trip_name": tripName,
    "uniqueId": uniqueId,
    "valid": valid,
    "alarm": alarm,
    "deviceStatus": deviceStatus,
    "fixTime": fixTime,
    "geofenceIds": geofenceIds,
    "harshAccelerations": harshAccelerations,
    "harshBrakings": harshBrakings,
    "harshCornerings": harshCornerings,
    "idleFixTime": idleFixTime,
    "lastIgnitionOffFixTime": lastIgnitionOffFixTime,
    "lastIgnitionOnFixTime": lastIgnitionOnFixTime,
    "lastUpdate": lastUpdate,
    "latitude": latitude,
    "longitude": longitude,
    "network": network,
    "overSpeeds": overSpeeds,
    "pushedtoServer": pushedtoServer,
    "serverTime": serverTime,
    "tmp": tmp,
  };
}

class GpsPositionCounts {
  final int? idle;
  final int? ignitionOff;
  final int? ignitionOn;
  final int? inactive;
  final int? total;

  GpsPositionCounts({
    this.idle,
    this.ignitionOff,
    this.ignitionOn,
    this.inactive,
    this.total,
  });

  factory GpsPositionCounts.fromJson(Map<String, dynamic> json) =>
      GpsPositionCounts(
        idle: json["IDLE"],
        ignitionOff: json["IGNITION_OFF"],
        ignitionOn: json["IGNITION_ON"],
        inactive: json["INACTIVE"],
        total: json["TOTAL"],
      );

  Map<String, dynamic> toJson() => {
    "IDLE": idle,
    "IGNITION_OFF": ignitionOff,
    "IGNITION_ON": ignitionOn,
    "INACTIVE": inactive,
    "TOTAL": total,
  };
}
