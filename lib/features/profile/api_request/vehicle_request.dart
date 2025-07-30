class VehicleRequest {
  VehicleRequest({
    this.customerId,
    this.truckNo,
    this.rcNumber,
    this.rcDocLink,
    this.tonnage,
    this.truckTypeId,
    this.truckMakeAndModel,
    this.acceptableCommodities,
    this.truckLength,
    this.vehicleStatus,
  });

  final String? customerId;
  final String? truckNo;
  final String? rcNumber;
  final String? rcDocLink;
  final String? tonnage;
  final int? truckTypeId;
  final String? truckMakeAndModel;
  final List<int>? acceptableCommodities;
  final int? truckLength;
  final int? vehicleStatus;

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
      customerId: json["customerId"],
      truckNo: json["truckNo"],
      rcNumber: json["rcNumber"],
      rcDocLink: json["rcDocLink"],
      tonnage: json["tonnage"],
      truckTypeId: json["truckTypeId"],
      truckMakeAndModel: json["truckMakeAndModel"],
      acceptableCommodities: json["acceptableCommodities"] != null
          ? List<int>.from(json["acceptableCommodities"])
          : null,
      truckLength: json["truckLength"],
      vehicleStatus: json["vehicleStatus"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (customerId != null) "customerId": customerId,
      if (truckNo != null) "truckNo": truckNo,
      if (rcNumber != null) "rcNumber": rcNumber,
      if (rcDocLink != null) "rcDocLink": rcDocLink,
      if (tonnage != null) "tonnage": tonnage,
      if (truckTypeId != null) "truckTypeId": truckTypeId,
      if (truckMakeAndModel != null) "truckMakeAndModel": truckMakeAndModel,
      if (acceptableCommodities != null) "acceptableCommodities": acceptableCommodities,
      if (truckLength != null) "truckLength": truckLength,
      if (vehicleStatus != null) "vehicleStatus": vehicleStatus,
    };
  }
}
