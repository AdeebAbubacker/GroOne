
class VehicleRequest {
  VehicleRequest({
    this.customerId,
    this.truckNo,
    this.ownerName,
    this.registrationDate,
    this.tonnage,
    this.truckTypeId,
    this.modelNumber,
    this.insurancePolicyNumber,
    this.insuranceValidityDate,
    this.fcExpiryDate,
    this.pucExpiryDate,
    this.acceptableCommodities,
    this.truckLength,
    this.vehicleStatus,
  });

  final String? customerId;
  final String? truckNo;
  final String? ownerName;
  final String? registrationDate;
  final String? tonnage;
  final int? truckTypeId;
  final String? modelNumber;
  final String? insurancePolicyNumber;
  final String? insuranceValidityDate;
  final String? fcExpiryDate;
  final String? pucExpiryDate;
  final List<int>? acceptableCommodities;
  final int? truckLength;
  final int? vehicleStatus;

  VehicleRequest copyWith({
    String? customerId,
    String? truckNo,
    String? ownerName,
    String? registrationDate,
    String? rcNumber,
    String? rcDocLink,
    String? tonnage,
    int? truckTypeId,
    String? modelNumber,
    String? insurancePolicyNumber,
    String? insuranceValidityDate,
    String? fcExpiryDate,
    String? pucExpiryDate,
    List<int>? acceptableCommodities,
    int? truckLength,
    int? vehicleStatus,
  }) {
    return VehicleRequest(
      customerId: customerId ?? this.customerId,
      truckNo: truckNo ?? this.truckNo,
      ownerName: ownerName ?? this.ownerName,
      registrationDate: registrationDate ?? this.registrationDate,
      tonnage: tonnage ?? this.tonnage,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      modelNumber: modelNumber ?? this.modelNumber,
      insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
      fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
      pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
      acceptableCommodities: acceptableCommodities ?? this.acceptableCommodities,
      truckLength: truckLength ?? this.truckLength,
      vehicleStatus: vehicleStatus ?? this.vehicleStatus,
    );
  }

  factory VehicleRequest.fromJson(Map<String, dynamic> json) {
    return VehicleRequest(
      customerId: json["customerId"],
      truckNo: json["truckNo"],
      ownerName: json["ownerName"],
      registrationDate: json["registrationDate"],
      tonnage: json["tonnage"],
      truckTypeId: json["truckTypeId"],
      modelNumber: json["modelNumber"] ?? json["modelNumber"],
      insurancePolicyNumber: json["insurancePolicyNumber"],
      insuranceValidityDate: json["insuranceValidityDate"],
      fcExpiryDate: json["fcExpiryDate"],
      pucExpiryDate: json["pucExpiryDate"],
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
      if (ownerName != null) "ownerName": ownerName,
      if (registrationDate != null) "registrationDate": registrationDate,
      if (tonnage != null) "tonnage": tonnage,
      if (truckTypeId != null) "truckTypeId": truckTypeId,
      if (modelNumber != null) "modelNumber": modelNumber,
      if (insurancePolicyNumber != null) "insurancePolicyNumber": insurancePolicyNumber,
      if (insuranceValidityDate != null) "insuranceValidityDate": insuranceValidityDate,
      if (fcExpiryDate != null) "fcExpiryDate": fcExpiryDate,
      if (pucExpiryDate != null) "pucExpiryDate": pucExpiryDate,
      if (acceptableCommodities != null) "acceptableCommodities": acceptableCommodities,
      if (truckLength != null) "truckLength": truckLength,
      if (vehicleStatus != null) "vehicleStatus": vehicleStatus,
    };
  }
}

