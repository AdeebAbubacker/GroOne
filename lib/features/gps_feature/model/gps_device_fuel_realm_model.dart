import 'package:realm/realm.dart';

import 'gps_device_fuel_model.dart';

part 'gps_device_fuel_realm_model.realm.dart';

@RealmModel()
class _GpsDeviceFuelRealmModel {
  @PrimaryKey()
  late ObjectId id;

  int? fuelId;
  String? amount;
  int? deviceId;
  String? fuelFilled;
  String? fuelType;
  String? imageName;
  String? mileage;
  String? paymentType;
  String? pricePerLitre;
  DateTime? timestamp;
  String? totalDistance;
  String? totalEngineSeconds;
  String? transactionId;
  DateTime? updateTime;
  int? userId;
  late DateTime createdAt;
}

extension GpsDeviceFuelRealmModelMapper on GpsDeviceFuelRealmModel {
  GpsDeviceFuelData toDomain() => GpsDeviceFuelData(
    id: fuelId,
    amount: amount,
    deviceId: deviceId,
    fuelFilled: fuelFilled,
    fuelType: fuelType,
    imageName: imageName,
    mileage: mileage,
    paymentType: paymentType,
    pricePerLitre: pricePerLitre,
    timestamp: timestamp,
    totalDistance: totalDistance,
    totalEngineSeconds: totalEngineSeconds,
    transactionId: transactionId,
    updateTime: updateTime,
    userId: userId,
  );

  static GpsDeviceFuelRealmModel fromDomain(GpsDeviceFuelData data) {
    final obj = GpsDeviceFuelRealmModel(
      ObjectId(),
      fuelId: data.id,
      amount: data.amount,
      deviceId: data.deviceId,
      fuelFilled: data.fuelFilled,
      fuelType: data.fuelType,
      imageName: data.imageName,
      mileage: data.mileage,
      paymentType: data.paymentType,
      pricePerLitre: data.pricePerLitre,
      timestamp: data.timestamp,
      totalDistance: data.totalDistance,
      totalEngineSeconds: data.totalEngineSeconds,
      transactionId: data.transactionId,
      updateTime: data.updateTime,
      userId: data.userId,
      DateTime.now(),
    );
    return obj;
  }
}
