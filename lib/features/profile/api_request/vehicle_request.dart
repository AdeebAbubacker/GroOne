class VehicleRequest {
  VehicleRequest({
    required this.customerId,
    required this.truckNo,
    required this.rcNumber,
    required this.rcDocLink,
    required this.tonnage,
    required this.truckTypeId,
    required this.truckMakeAndModel,
    required this.acceptableCommodities,
    required this.truckLength,
    required this.vehicleStatus,
  });

  final String customerId;
  final String truckNo;
  final String rcNumber;
  final String rcDocLink;
  final String tonnage;
  final int truckTypeId;
  final String truckMakeAndModel;
  final List<int> acceptableCommodities;
  final int truckLength;
  final int vehicleStatus;

  VehicleRequest copyWith({
    String? customerId,
    String? truckNo,
    String? rcNumber,
    String? rcDocLink,
    String? tonnage,
    int? truckTypeId,
    String? truckMakeAndModel,
    List<int>? acceptableCommodities,
    int? truckLength,
    int? vehicleStatus,
  }) {
    return VehicleRequest(
      customerId: customerId ?? this.customerId,
      truckNo: truckNo ?? this.truckNo,
      rcNumber: rcNumber ?? this.rcNumber,
      rcDocLink: rcDocLink ?? this.rcDocLink,
      tonnage: tonnage ?? this.tonnage,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      truckMakeAndModel: truckMakeAndModel ?? this.truckMakeAndModel,
      acceptableCommodities: acceptableCommodities ?? this.acceptableCommodities,
      truckLength: truckLength ?? this.truckLength,
      vehicleStatus: vehicleStatus ?? this.vehicleStatus,
    );
  }

  factory VehicleRequest.fromJson(Map<String, dynamic> json) {
    return VehicleRequest(
      customerId: json["customerId"] ?? "",
      truckNo: json["truckNo"] ?? "",
      rcNumber: json["rcNumber"] ?? "",
      rcDocLink: json["rcDocLink"] ?? "",
      tonnage: json["tonnage"] ?? "",
      truckTypeId: json["truckTypeId"] ?? 0,
      truckMakeAndModel: json["truckMakeAndModel"] ?? "",
      acceptableCommodities: List<int>.from(json["acceptableCommodities"] ?? []),
      truckLength: json["truckLength"] ?? 0,
      vehicleStatus: json["vehicleStatus"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "truckNo": truckNo,
      "rcNumber": rcNumber,
      "rcDocLink": rcDocLink,
      "tonnage": tonnage,
      "truckTypeId": truckTypeId,
      "truckMakeAndModel": truckMakeAndModel,
      "acceptableCommodities": acceptableCommodities,
      "truckLength": truckLength,
      "vehicleStatus": vehicleStatus,
    };
  }
}
