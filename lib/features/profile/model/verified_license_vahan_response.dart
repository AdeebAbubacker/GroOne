class VerifedLicenseVahanData {
    VerifedLicenseVahanData({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final Data? data;

    VerifedLicenseVahanData copyWith({
        bool? success,
        String? message,
        Data? data,
    }) {
        return VerifedLicenseVahanData(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory VerifedLicenseVahanData.fromJson(Map<String, dynamic> json){ 
        return VerifedLicenseVahanData(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.userFullName,
        required this.userDob,
        required this.expiryDate,
        required this.userBloodGroup,
        required this.vehicleCategory,
    });

    final String userFullName;
    final String userDob;
    final String expiryDate;
    final String userBloodGroup;
    final String vehicleCategory;

    Data copyWith({
        String? userFullName,
        String? userDob,
        String? expiryDate,
        String? userBloodGroup,
        String? vehicleCategory,
    }) {
        return Data(
            userFullName: userFullName ?? this.userFullName,
            userDob: userDob ?? this.userDob,
            expiryDate: expiryDate ?? this.expiryDate,
            userBloodGroup: userBloodGroup ?? this.userBloodGroup,
            vehicleCategory: vehicleCategory ?? this.vehicleCategory,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            userFullName: json["user_full_name"] ?? "",
            userDob: json["user_dob"] ?? "",
            expiryDate: json["expiry_date"] ?? "",
            userBloodGroup: json["user_blood_group"] ?? "",
            vehicleCategory: json["vehicle_category"] ?? "",
        );
    }

}
