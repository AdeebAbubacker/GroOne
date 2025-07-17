import 'dart:convert';

GpsDeviceFuelModel gpsDeviceFuelModelFromJson(String str) =>
    GpsDeviceFuelModel.fromJson(json.decode(str));

String gpsDeviceFuelModelToJson(GpsDeviceFuelModel data) =>
    json.encode(data.toJson());

class GpsDeviceFuelModel {
  final List<GpsDeviceFuelData>? data;
  final bool? success;
  final int? total;

  GpsDeviceFuelModel({this.data, this.success, this.total});

  factory GpsDeviceFuelModel.fromJson(Map<String, dynamic> json) =>
      GpsDeviceFuelModel(
        data:
            json["data"] != null
                ? List<GpsDeviceFuelData>.from(
                  json["data"].map((x) => GpsDeviceFuelData.fromJson(x)),
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

class GpsDeviceFuelData {
  final String? amount;
  final int? deviceId;
  final String? fuelFilled;
  final String? fuelType;
  final int? id;
  final String? imageName;
  final String? mileage;
  final String? paymentType;
  final String? pricePerLitre;
  final DateTime? timestamp;
  final String? totalDistance;
  final String? totalEngineSeconds;
  final String? transactionId;
  final DateTime? updateTime;
  final int? userId;

  GpsDeviceFuelData({
    this.amount,
    this.deviceId,
    this.fuelFilled,
    this.fuelType,
    this.id,
    this.imageName,
    this.mileage,
    this.paymentType,
    this.pricePerLitre,
    this.timestamp,
    this.totalDistance,
    this.totalEngineSeconds,
    this.transactionId,
    this.updateTime,
    this.userId,
  });

  factory GpsDeviceFuelData.fromJson(Map<String, dynamic> json) =>
      GpsDeviceFuelData(
        amount: json["amount"],
        deviceId: json["device_id"],
        fuelFilled: json["fuel_filled"],
        fuelType: json["fuel_type"],
        id: json["id"],
        imageName: json["image_name"],
        mileage: json["mileage"],
        paymentType: json["payment_type"],
        pricePerLitre: json["price_per_litre"],
        timestamp:
            json["timestamp"] != null
                ? DateTime.tryParse(json["timestamp"])
                : null,
        totalDistance: json["total_distance"],
        totalEngineSeconds: json["total_engine_seconds"],
        transactionId: json["transaction_id"],
        updateTime:
            json["update_time"] != null
                ? DateTime.tryParse(json["update_time"])
                : null,
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "device_id": deviceId,
    "fuel_filled": fuelFilled,
    "fuel_type": fuelType,
    "id": id,
    "image_name": imageName,
    "mileage": mileage,
    "payment_type": paymentType,
    "price_per_litre": pricePerLitre,
    "timestamp": timestamp?.toIso8601String(),
    "total_distance": totalDistance,
    "total_engine_seconds": totalEngineSeconds,
    "transaction_id": transactionId,
    "update_time": updateTime?.toIso8601String(),
    "user_id": userId,
  };
}
