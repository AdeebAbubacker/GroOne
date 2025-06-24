class KavachVehicleTruckTypeModel {
  final int id;
  final String type;
  final String subType;

  KavachVehicleTruckTypeModel({
    required this.id,
    required this.type,
    required this.subType,
  });

  factory KavachVehicleTruckTypeModel.fromJson(Map<String, dynamic> json) {
    return KavachVehicleTruckTypeModel(
      id: json['id'],
      type: json['type'],
      subType: json['sub_type'],
    );
  }
}

class KavachVehicleModel {
  final int id;
  final int customerId;
  final String vehicleNumber;
  final int vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String capacity;
  final String? truckMakeAndModel;
  final int? truckType;
  final int? truckLength;
  final List<String> acceptableCommodities;
  final String? ownerName;
  final String? registrationDate;
  final String? tonnage;
  final String? bodyType;
  final String? loadingSpan;
  final String? modelNumber;
  final String? insurancePolicyNumber;
  final String? insuranceValidityDate;
  final String? fcExpiryDate;
  final String? pucExpiryDate;
  final int vehicleStatus;
  final int status;
  final String createdAt;
  final KavachVehicleTruckTypeModel? truckTypeInfo;

  KavachVehicleModel({
    required this.id,
    required this.customerId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    this.truckMakeAndModel,
    this.truckType,
    this.truckLength,
    required this.acceptableCommodities,
    this.ownerName,
    this.registrationDate,
    this.tonnage,
    this.bodyType,
    this.loadingSpan,
    this.modelNumber,
    this.insurancePolicyNumber,
    this.insuranceValidityDate,
    this.fcExpiryDate,
    this.pucExpiryDate,
    required this.vehicleStatus,
    required this.status,
    required this.createdAt,
    this.truckTypeInfo,
  });

  factory KavachVehicleModel.fromJson(Map<String, dynamic> json) {
    final commodities = json['acceptableCommodities']
        ?.toString()
        .replaceAll(RegExp(r'[{}"]'), '')
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return KavachVehicleModel(
      id: json['id'],
      customerId: json['customerId'],
      vehicleNumber: json['vehicleNumber'],
      vehicleTypeId: json['vehicleTypeId'],
      rcNumber: json['rcNumber'],
      rcDocLink: json['rcDocLink'],
      capacity: json['capacity'],
      truckMakeAndModel: json['truckMakeAndModel'],
      truckType: json['truckType'],
      truckLength: json['truckLength'],
      acceptableCommodities: commodities ?? [],
      ownerName: json['ownerName'],
      registrationDate: json['registrationDate'],
      tonnage: json['tonnage'],
      bodyType: json['bodyType'],
      loadingSpan: json['loadingSpan'],
      modelNumber: json['modelNumber'],
      insurancePolicyNumber: json['insurancePolicyNumber'],
      insuranceValidityDate: json['insuranceValidityDate'],
      fcExpiryDate: json['fcExpiryDate'],
      pucExpiryDate: json['pucExpiryDate'],
      vehicleStatus: json['vehicleStatus'],
      status: json['status'],
      createdAt: json['createdAt'],
      truckTypeInfo: json['TruckType'] != null
          ? KavachVehicleTruckTypeModel.fromJson(json['TruckType'])
          : null,
    );
  }
}
