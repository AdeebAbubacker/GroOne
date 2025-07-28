class DriverUpdatedResponse {
    DriverUpdatedResponse({
        required this.message,
        required this.data,
    });

    final String message;
    final DriverUpdatedData? data;

    DriverUpdatedResponse copyWith({
        String? message,
        DriverUpdatedData? data,
    }) {
        return DriverUpdatedResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory DriverUpdatedResponse.fromJson(Map<String, dynamic> json){ 
        return DriverUpdatedResponse(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : DriverUpdatedData.fromJson(json["data"]),
        );
    }

}

class DriverUpdatedData {
    DriverUpdatedData({
        required this.driverId,
        required this.name,
        required this.mobile,
        required this.email,
        required this.licenseNumber,
        required this.licenseDocLink,
        required this.licenseExpiryDate,
        required this.customerId,
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
    final int driverStatus;
    final String experience;
    final int bloodGroup;
    final int licenseCategory;
    final int specialLicense;
    final String communicationPreference;
    final CompanyDetails? companyDetails;

    DriverUpdatedData copyWith({
        String? driverId,
        String? name,
        String? mobile,
        String? email,
        String? licenseNumber,
        String? licenseDocLink,
        DateTime? licenseExpiryDate,
        String? customerId,
        int? driverStatus,
        String? experience,
        int? bloodGroup,
        int? licenseCategory,
        int? specialLicense,
        String? communicationPreference,
        CompanyDetails? companyDetails,
    }) {
        return DriverUpdatedData(
            driverId: driverId ?? this.driverId,
            name: name ?? this.name,
            mobile: mobile ?? this.mobile,
            email: email ?? this.email,
            licenseNumber: licenseNumber ?? this.licenseNumber,
            licenseDocLink: licenseDocLink ?? this.licenseDocLink,
            licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
            customerId: customerId ?? this.customerId,
            driverStatus: driverStatus ?? this.driverStatus,
            experience: experience ?? this.experience,
            bloodGroup: bloodGroup ?? this.bloodGroup,
            licenseCategory: licenseCategory ?? this.licenseCategory,
            specialLicense: specialLicense ?? this.specialLicense,
            communicationPreference: communicationPreference ?? this.communicationPreference,
            companyDetails: companyDetails ?? this.companyDetails,
        );
    }

    factory DriverUpdatedData.fromJson(Map<String, dynamic> json){ 
        return DriverUpdatedData(
            driverId: json["driverId"] ?? "",
            name: json["name"] ?? "",
            mobile: json["mobile"] ?? "",
            email: json["email"] ?? "",
            licenseNumber: json["licenseNumber"] ?? "",
            licenseDocLink: json["licenseDocLink"] ?? "",
            licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
            customerId: json["customerId"] ?? "",
            driverStatus: json["driverStatus"] ?? 0,
            experience: json["experience"] ?? "",
            bloodGroup: json["bloodGroup"] ?? 0,
            licenseCategory: json["licenseCategory"] ?? 0,
            specialLicense: json["specialLicense"] ?? 0,
            communicationPreference: json["communicationPreference"] ?? "",
            companyDetails: json["companyDetails"] == null ? null : CompanyDetails.fromJson(json["companyDetails"]),
        );
    }

}

class CompanyDetails {
    CompanyDetails({
        required this.companyTypeId,
        required this.companyName,
        required this.mobile,
    });

    final int companyTypeId;
    final String companyName;
    final String mobile;

    CompanyDetails copyWith({
        int? companyTypeId,
        String? companyName,
        String? mobile,
    }) {
        return CompanyDetails(
            companyTypeId: companyTypeId ?? this.companyTypeId,
            companyName: companyName ?? this.companyName,
            mobile: mobile ?? this.mobile,
        );
    }

    factory CompanyDetails.fromJson(Map<String, dynamic> json){ 
        return CompanyDetails(
            companyTypeId: json["companyTypeId"] ?? 0,
            companyName: json["companyName"] ?? "",
            mobile: json["mobile"] ?? "",
        );
    }

}
