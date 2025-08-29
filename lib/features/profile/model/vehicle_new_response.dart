class VehicleNewModel {
    VehicleNewModel({
        required this.vehicleId,
        required this.customerId,
        required this.truckNo,
        required this.tonnage,
        required this.truckTypeId,
        required this.modelNumber,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String vehicleId;
    final String customerId;
    final String truckNo;
    final String tonnage;
    final int truckTypeId;
    final String modelNumber;
    final int status;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    VehicleNewModel copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        int? status,
        DateTime? createdAt,
        dynamic updatedAt,
        dynamic deletedAt,
    }) {
        return VehicleNewModel(
            vehicleId: vehicleId ?? this.vehicleId,
            customerId: customerId ?? this.customerId,
            truckNo: truckNo ?? this.truckNo,
            tonnage: tonnage ?? this.tonnage,
            truckTypeId: truckTypeId ?? this.truckTypeId,
            modelNumber: modelNumber ?? this.modelNumber,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory VehicleNewModel.fromJson(Map<String, dynamic> json){ 
        return VehicleNewModel(
            vehicleId: json["vehicleId"] ?? "",
            customerId: json["customerId"] ?? "",
            truckNo: json["truckNo"] ?? "",
            tonnage: json["tonnage"] ?? "",
            truckTypeId: json["truckTypeId"] ?? 0,
            modelNumber: json["modelNumber"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: json["updatedAt"],
            deletedAt: json["deletedAt"],
        );
    }

}
