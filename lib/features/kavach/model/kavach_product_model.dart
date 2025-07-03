// class KavachProduct {
//   final String id;
//   final String name;
//   final String part;
//   final double price;
//   final double gstPerc;
//   final String productDesc;
//   final String fileKey;
//   final String? unitMeasurement;
//   final double? purchasePrice;
//
//   KavachProduct({
//     required this.id,
//     required this.name,
//     required this.part,
//     required this.price,
//     required this.gstPerc,
//     required this.productDesc,
//     required this.fileKey,
//     required this.unitMeasurement,
//     required this.purchasePrice,
//   });
//
//   factory KavachProduct.fromJson(Map<String, dynamic> json) {
//     return KavachProduct(
//       id: json['id']?.toString() ?? '',
//       name: json['name'] ?? '',
//       part: json['part'] ?? '',
//       price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
//       gstPerc: double.tryParse(json['gst_perc']?.toString() ?? '') ?? 0.0,
//       productDesc: json['product_desc'] ?? '',
//       fileKey: json['file_key'] ?? '',
//       unitMeasurement: json['unit_measurement']?.toString() ?? '',
//       purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '') ?? 0.0,
//     );
//   }
// }

class KavachProduct {
  final String id;
  final String type;
  final String name;
  final String part;
  final double price;
  final double gstPerc;
  final String productDesc;
  final String fileKey;
  final String? unitMeasurement;
  final double? purchasePrice;

  // New fields added
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleTankType;
  final String? vehicleEngine;
  final String? vehicleDeviceType;

  final String? kAcntCode;
  final String? eAcntCode;
  final String? sAcntCode;
  final String? hsnSacCode;

  KavachProduct({
    required this.id,
    required this.type,
    required this.name,
    required this.part,
    required this.price,
    required this.gstPerc,
    required this.productDesc,
    required this.fileKey,
    required this.unitMeasurement,
    required this.purchasePrice,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleTankType,
    this.vehicleEngine,
    this.vehicleDeviceType,
    this.kAcntCode,
    this.eAcntCode,
    this.sAcntCode,
    this.hsnSacCode,
  });

  factory KavachProduct.fromJson(Map<String, dynamic> json) {
    return KavachProduct(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      part: json['part']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      gstPerc: double.tryParse(json['gst_perc']?.toString() ?? '') ?? 0.0,
      productDesc: json['product_desc']?.toString() ?? '',
      fileKey: json['file_key']?.toString() ?? '',
      unitMeasurement: json['unit_measurement']?.toString(),
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? ''),
      vehicleMake: json['vehicle_make']?.toString(),
      vehicleModel: json['vehicle_model']?.toString(),
      vehicleTankType: json['vehicle_tank_type']?.toString(),
      vehicleEngine: json['vehicle_engine']?.toString(),
      vehicleDeviceType: json['vehicle_device_type']?.toString(),
      kAcntCode: json['k_acnt_code']?.toString(),
      eAcntCode: json['e_acnt_code']?.toString(),
      sAcntCode: json['s_acnt_code']?.toString(),
      hsnSacCode: json['hsn_sac_code']?.toString(),
    );
  }
}
