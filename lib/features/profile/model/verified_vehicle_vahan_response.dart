class VerifedVehicleVahanData {
    VerifedVehicleVahanData({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final VerifiedVehicleData? data;

    VerifedVehicleVahanData copyWith({
        bool? success,
        String? message,
        VerifiedVehicleData? data,
    }) {
        return VerifedVehicleVahanData(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory VerifedVehicleVahanData.fromJson(Map<String, dynamic> json){ 
        return VerifedVehicleVahanData(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : VerifiedVehicleData.fromJson(json["data"]),
        );
    }

}

class VerifiedVehicleData {
    VerifiedVehicleData({
        required this.userName,
        required this.rcRegistrationDate,
        required this.vehicleGrossWeight,
        required this.vehicleMakeModel,
        required this.insurancePolicyNumber,
        required this.insuranceExpiryDate,
        required this.rcPuccExpiryDate,
        required this.rcExpiryDate,
        required this.isValidVehicleType,
    });

    final String userName;
    final String rcRegistrationDate;
    final String vehicleGrossWeight;
    final String vehicleMakeModel;
    final String insurancePolicyNumber;
    final String insuranceExpiryDate;
    final String rcPuccExpiryDate;
    final String rcExpiryDate;
    final bool isValidVehicleType;

    VerifiedVehicleData copyWith({
        String? userName,
        String? rcRegistrationDate,
        String? vehicleGrossWeight,
        String? vehicleMakeModel,
        String? insurancePolicyNumber,
        String? insuranceExpiryDate,
        String? rcPuccExpiryDate,
        String? rcExpiryDate,
        bool? isValidVehicleType,
    }) {
        return VerifiedVehicleData(
            userName: userName ?? this.userName,
            rcRegistrationDate: rcRegistrationDate ?? this.rcRegistrationDate,
            vehicleGrossWeight: vehicleGrossWeight ?? this.vehicleGrossWeight,
            vehicleMakeModel: vehicleMakeModel ?? this.vehicleMakeModel,
            insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
            insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
            rcPuccExpiryDate: rcPuccExpiryDate ?? this.rcPuccExpiryDate,
            rcExpiryDate: rcExpiryDate ?? this.rcExpiryDate,
            isValidVehicleType: isValidVehicleType ?? this.isValidVehicleType,
        );
    }

    factory VerifiedVehicleData.fromJson(Map<String, dynamic> json){ 
        return VerifiedVehicleData(
            userName: json["user_name"] ?? "",
            rcRegistrationDate: json["rc_registration_date"] ?? "",
            vehicleGrossWeight: json["vehicle_gross_weight"] ?? "",
            vehicleMakeModel: json["vehicle_make_model"] ?? "",
            insurancePolicyNumber: json["insurance_policy_number"] ?? "",
            insuranceExpiryDate: json["insurance_expiry_date"] ?? "",
            rcPuccExpiryDate: json["rc_pucc_expiry_date"] ?? "",
            rcExpiryDate: json["rc_expiry_date"] ?? "",
            isValidVehicleType: json["is_valid_vehicle_type"] ?? false,
        );
    }

}
