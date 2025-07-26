class PaginatedDriverList {
    PaginatedDriverList({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<Datum> data;
    final int total;
    final PageMeta? pageMeta;

    PaginatedDriverList copyWith({
        List<Datum>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return PaginatedDriverList(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory PaginatedDriverList.fromJson(Map<String, dynamic> json){ 
        return PaginatedDriverList(
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class Datum {
    Datum({
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
    final dynamic licenseDocLink;
    final DateTime? licenseExpiryDate;
    final String customerId;
    final DateTime? dateOfBirth;
    final int driverStatus;
    final String experience;
    final int bloodGroup;
    final int licenseCategory;
    final int specialLicense;
    final String communicationPreference;
    final CompanyDetails? companyDetails;

    Datum copyWith({
        String? driverId,
        String? name,
        String? mobile,
        String? email,
        String? licenseNumber,
        dynamic? licenseDocLink,
        DateTime? licenseExpiryDate,
        String? customerId,
        DateTime? dateOfBirth,
        int? driverStatus,
        String? experience,
        int? bloodGroup,
        int? licenseCategory,
        int? specialLicense,
        String? communicationPreference,
        CompanyDetails? companyDetails,
    }) {
        return Datum(
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

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            driverId: json["driverId"] ?? "",
            name: json["name"] ?? "",
            mobile: json["mobile"] ?? "",
            email: json["email"] ?? "",
            licenseNumber: json["licenseNumber"] ?? "",
            licenseDocLink: json["licenseDocLink"],
            licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
            customerId: json["customerId"] ?? "",
            dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
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
        required this.companyName,
        required this.companyTypeId,
        required this.mobile,
        required this.gstin,
    });

    final String companyName;
    final int companyTypeId;
    final String mobile;
    final String gstin;

    CompanyDetails copyWith({
        String? companyName,
        int? companyTypeId,
        String? mobile,
        String? gstin,
    }) {
        return CompanyDetails(
            companyName: companyName ?? this.companyName,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            mobile: mobile ?? this.mobile,
            gstin: gstin ?? this.gstin,
        );
    }

    factory CompanyDetails.fromJson(Map<String, dynamic> json){ 
        return CompanyDetails(
            companyName: json["companyName"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            mobile: json["mobile"] ?? "",
            gstin: json["gstin"] ?? "",
        );
    }

}

class PageMeta {
    PageMeta({
        required this.page,
        required this.pageCount,
        required this.nextPage,
        required this.pageSize,
        required this.total,
    });

    final int page;
    final int pageCount;
    final dynamic nextPage;
    final int pageSize;
    final int total;

    PageMeta copyWith({
        int? page,
        int? pageCount,
        dynamic? nextPage,
        int? pageSize,
        int? total,
    }) {
        return PageMeta(
            page: page ?? this.page,
            pageCount: pageCount ?? this.pageCount,
            nextPage: nextPage ?? this.nextPage,
            pageSize: pageSize ?? this.pageSize,
            total: total ?? this.total,
        );
    }

    factory PageMeta.fromJson(Map<String, dynamic> json){ 
        return PageMeta(
            page: json["page"] ?? 0,
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"],
            pageSize: json["pageSize"] ?? 0,
            total: json["total"] ?? 0,
        );
    }

}
