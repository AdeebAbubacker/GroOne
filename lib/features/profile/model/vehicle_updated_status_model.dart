class VehcileUpdatedStatusModel {
    VehcileUpdatedStatusModel({
        required this.vehicleId,
        required this.customerId,
        required this.truckNo,
        required this.ownerName,
        required this.registrationDate,
        required this.tonnage,
        required this.truckTypeId,
        required this.modelNumber,
        required this.rcNumber,
        required this.rcDocLink,
        required this.insurancePolicyNumber,
        required this.insuranceValidityDate,
        required this.fcExpiryDate,
        required this.pucExpiryDate,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String vehicleId;
    final String customerId;
    final String truckNo;
    final dynamic ownerName;
    final dynamic registrationDate;
    final String tonnage;
    final int truckTypeId;
    final String modelNumber;
    final dynamic rcNumber;
    final dynamic rcDocLink;
    final dynamic insurancePolicyNumber;
    final dynamic insuranceValidityDate;
    final dynamic fcExpiryDate;
    final dynamic pucExpiryDate;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    VehcileUpdatedStatusModel copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        dynamic ownerName,
        dynamic registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        dynamic rcNumber,
        dynamic rcDocLink,
        dynamic insurancePolicyNumber,
        dynamic insuranceValidityDate,
        dynamic fcExpiryDate,
        dynamic pucExpiryDate,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic deletedAt,
    }) {
        return VehcileUpdatedStatusModel(
            vehicleId: vehicleId ?? this.vehicleId,
            customerId: customerId ?? this.customerId,
            truckNo: truckNo ?? this.truckNo,
            ownerName: ownerName ?? this.ownerName,
            registrationDate: registrationDate ?? this.registrationDate,
            tonnage: tonnage ?? this.tonnage,
            truckTypeId: truckTypeId ?? this.truckTypeId,
            modelNumber: modelNumber ?? this.modelNumber,
            rcNumber: rcNumber ?? this.rcNumber,
            rcDocLink: rcDocLink ?? this.rcDocLink,
            insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
            insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
            fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
            pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory VehcileUpdatedStatusModel.fromJson(Map<String, dynamic> json){ 
        return VehcileUpdatedStatusModel(
            vehicleId: json["vehicleId"] ?? "",
            customerId: json["customerId"] ?? "",
            truckNo: json["truckNo"] ?? "",
            ownerName: json["ownerName"],
            registrationDate: json["registrationDate"],
            tonnage: json["tonnage"] ?? "",
            truckTypeId: json["truckTypeId"] ?? 0,
            modelNumber: json["modelNumber"] ?? "",
            rcNumber: json["rcNumber"],
            rcDocLink: json["rcDocLink"],
            insurancePolicyNumber: json["insurancePolicyNumber"],
            insuranceValidityDate: json["insuranceValidityDate"],
            fcExpiryDate: json["fcExpiryDate"],
            pucExpiryDate: json["pucExpiryDate"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}
