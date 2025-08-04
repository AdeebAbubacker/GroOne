class VehicleVerificationSuccess {
    VehicleVerificationSuccess({
        required this.message,
        required this.data,
    });

    final String message;
    final VehicleVerificationData? data;

    VehicleVerificationSuccess copyWith({
        String? message,
        VehicleVerificationData? data,
    }) {
        return VehicleVerificationSuccess(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory VehicleVerificationSuccess.fromJson(Map<String, dynamic> json){ 
        return VehicleVerificationSuccess(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : VehicleVerificationData.fromJson(json["data"]),
        );
    }

}

class VehicleVerificationData {
    VehicleVerificationData({
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
    final String rcNumber;
    final String rcDocLink;
    final dynamic insurancePolicyNumber;
    final dynamic insuranceValidityDate;
    final dynamic fcExpiryDate;
    final dynamic pucExpiryDate;
    final int status;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    VehicleVerificationData copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        dynamic? ownerName,
        dynamic? registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        String? rcNumber,
        String? rcDocLink,
        dynamic? insurancePolicyNumber,
        dynamic? insuranceValidityDate,
        dynamic? fcExpiryDate,
        dynamic? pucExpiryDate,
        int? status,
        DateTime? createdAt,
        dynamic? updatedAt,
        dynamic? deletedAt,
    }) {
        return VehicleVerificationData(
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

    factory VehicleVerificationData.fromJson(Map<String, dynamic> json){ 
        return VehicleVerificationData(
            vehicleId: json["vehicleId"] ?? "",
            customerId: json["customerId"] ?? "",
            truckNo: json["truckNo"] ?? "",
            ownerName: json["ownerName"],
            registrationDate: json["registrationDate"],
            tonnage: json["tonnage"] ?? "",
            truckTypeId: json["truckTypeId"] ?? 0,
            modelNumber: json["modelNumber"] ?? "",
            rcNumber: json["rcNumber"] ?? "",
            rcDocLink: json["rcDocLink"] ?? "",
            insurancePolicyNumber: json["insurancePolicyNumber"],
            insuranceValidityDate: json["insuranceValidityDate"],
            fcExpiryDate: json["fcExpiryDate"],
            pucExpiryDate: json["pucExpiryDate"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: json["updatedAt"],
            deletedAt: json["deletedAt"],
        );
    }

}



class LicenseVerificationSuccess {
    LicenseVerificationSuccess({
        required this.message,
        required this.data,
    });

    final String message;
    final LicenseVerificationData? data;

    LicenseVerificationSuccess copyWith({
        String? message,
        LicenseVerificationData? data,
    }) {
        return LicenseVerificationSuccess(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory LicenseVerificationSuccess.fromJson(Map<String, dynamic> json){ 
        return LicenseVerificationSuccess(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : LicenseVerificationData.fromJson(json["data"]),
        );
    }

}

class LicenseVerificationData {
    LicenseVerificationData({
        required this.driverId,
        required this.name,
        required this.mobile,
        required this.email,
        required this.licenseNumber,
        required this.licenseDocLink,
        required this.licenseExpiryDate,
        required this.customerId,
        required this.dateOfBirth,
        required this.driverStatus,
        required this.experience,
        required this.bloodGroup,
        required this.licenseCategory,
        required this.specialLicense,
        required this.communicationPreference,
        required this.companyDetails,
    });

    final String driverId;
    final String name;
    final String mobile;
    final String email;
    final String licenseNumber;
    final String licenseDocLink;
    final DateTime? licenseExpiryDate;
    final String customerId;
    final DateTime? dateOfBirth;
    final int driverStatus;
    final String experience;
    final int bloodGroup;
    final int licenseCategory;
    final int specialLicense;
    final String communicationPreference;
    final dynamic companyDetails;

    LicenseVerificationData copyWith({
        String? driverId,
        String? name,
        String? mobile,
        String? email,
        String? licenseNumber,
        String? licenseDocLink,
        DateTime? licenseExpiryDate,
        String? customerId,
        DateTime? dateOfBirth,
        int? driverStatus,
        String? experience,
        int? bloodGroup,
        int? licenseCategory,
        int? specialLicense,
        String? communicationPreference,
        dynamic? companyDetails,
    }) {
        return LicenseVerificationData(
            driverId: driverId ?? this.driverId,
            name: name ?? this.name,
            mobile: mobile ?? this.mobile,
            email: email ?? this.email,
            licenseNumber: licenseNumber ?? this.licenseNumber,
            licenseDocLink: licenseDocLink ?? this.licenseDocLink,
            licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
            customerId: customerId ?? this.customerId,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            driverStatus: driverStatus ?? this.driverStatus,
            experience: experience ?? this.experience,
            bloodGroup: bloodGroup ?? this.bloodGroup,
            licenseCategory: licenseCategory ?? this.licenseCategory,
            specialLicense: specialLicense ?? this.specialLicense,
            communicationPreference: communicationPreference ?? this.communicationPreference,
            companyDetails: companyDetails ?? this.companyDetails,
        );
    }

    factory LicenseVerificationData.fromJson(Map<String, dynamic> json){ 
        return LicenseVerificationData(
            driverId: json["driverId"] ?? "",
            name: json["name"] ?? "",
            mobile: json["mobile"] ?? "",
            email: json["email"] ?? "",
            licenseNumber: json["licenseNumber"] ?? "",
            licenseDocLink: json["licenseDocLink"] ?? "",
            licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
            customerId: json["customerId"] ?? "",
            dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
            driverStatus: json["driverStatus"] ?? 0,
            experience: json["experience"] ?? "",
            bloodGroup: json["bloodGroup"] ?? 0,
            licenseCategory: json["licenseCategory"] ?? 0,
            specialLicense: json["specialLicense"] ?? 0,
            communicationPreference: json["communicationPreference"] ?? "",
            companyDetails: json["companyDetails"],
        );
    }

}
