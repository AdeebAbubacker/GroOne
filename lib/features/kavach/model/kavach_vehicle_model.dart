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
  final String customerId;
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
  final int? vehicleStatus;
  final int? status;
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
      id: int.tryParse(json['vehicleId']?.toString() ?? '0') ?? 0,
      customerId: json['customerId']?.toString() ?? '',
      vehicleNumber: json['truckNo']?.toString() ?? '',
      vehicleTypeId: int.tryParse(json['vehicleTypeId']?.toString() ?? '0') ?? 0,
      rcNumber: json['rcNumber']?.toString() ?? '',
      rcDocLink: json['rcDocLink']?.toString() ?? '',
      capacity: json['tonnage']?.toString() ?? '',
      truckMakeAndModel: json['modelNumber']?.toString(),
      truckType: int.tryParse(json['truckTypeId']?.toString() ?? '0'),
      truckLength: int.tryParse(json['truckLength']?.toString() ?? '0'),
      acceptableCommodities: commodities ?? [],
      ownerName: json['ownerName']?.toString(),
      registrationDate: json['registrationDate']?.toString(),
      tonnage: json['tonnage']?.toString(),
      bodyType: json['bodyType']?.toString(),
      loadingSpan: json['loadingSpan']?.toString(),
      modelNumber: json['modelNumber']?.toString(),
      insurancePolicyNumber: json['insurancePolicyNumber']?.toString(),
      insuranceValidityDate: json['insuranceValidityDate']?.toString(),
      fcExpiryDate: json['fcExpiryDate']?.toString(),
      pucExpiryDate: json['pucExpiryDate']?.toString(),
      vehicleStatus: int.tryParse(json['status']?.toString() ?? '0'),
      status: int.tryParse(json['status']?.toString() ?? '0'),
      createdAt: json['createdAt']?.toString() ?? '',
      truckTypeInfo: json['TruckType'] != null
          ? KavachVehicleTruckTypeModel.fromJson(json['TruckType'])
          : null,
    );
  }
}
