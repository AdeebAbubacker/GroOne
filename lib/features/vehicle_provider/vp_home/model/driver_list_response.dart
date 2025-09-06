// class DriverListResponse {
//   DriverListResponse({

//     required this.data,
//   });


//   final List<DriverDetails> data;

//   factory DriverListResponse.fromJson(Map<String, dynamic> json) {


//     return DriverListResponse(
//       data: json["data"] == null
//           ? []
//           : List<DriverDetails>.from(
//           json["data"].map((x) {
//             return DriverDetails.fromJson(x);
//           })),
//     );
//   }


// }

// class DriverDetails {
//   DriverDetails({
//     required this.id,
//     required this.customerId,
//     required this.name,
//     required this.mobile,
//     required this.email,
//     required this.licenseNumber,
//     required this.licenseDocLink,
//     required this.status,
//     required this.createdAt,
//     required this.deletedAt,
//     required this.activeStatus,
//     required this.licenseExpiryDate,
//   });

//   final String? id;
//   final String? customerId;
//   final String name;
//   final String mobile;
//   final String email;
//   final String licenseNumber;
//   final String licenseDocLink;
//   final String activeStatus;
//   final num status;
//   final DateTime? createdAt;
//   final dynamic deletedAt;
//   final DateTime? licenseExpiryDate;

//   factory DriverDetails.fromJson(Map<String, dynamic> json){
//     return DriverDetails(
//       id: json["driverId"] ?? 0,
//       customerId: json["customerId"] ?? "",
//       name: json["name"] ?? "",
//       mobile: json["mobile"] ?? "",
//       email: json["email"] ?? "",
//       licenseNumber: json["licenseNumber"] ?? "",
//       licenseDocLink: json["licenseDocLink"] ?? "",
//       activeStatus: json["activeStatus"] ?? "",
//       status: json["driverStatus"] ?? 0,
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       deletedAt: json["deletedAt"],
//       licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "customerId": customerId,
//     "name": name,
//     "mobile": mobile,
//     "email": email,
//     "licenseNumber": licenseNumber,
//     "licenseDocLink": licenseDocLink,
//     "activeStatus": activeStatus,
//     "status": status,
//     "createdAt": createdAt?.toIso8601String(),
//     "deletedAt": deletedAt,
//     "licenseExpiryDate": licenseExpiryDate?.toIso8601String(),
//   };

// }
class DriverListResponse {
  List<DriverDetails> data;
  int total;
  PageMeta pageMeta;

  DriverListResponse({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  factory DriverListResponse.fromJson(Map<String, dynamic> json) {
    return DriverListResponse(
      data: (json['data'] as List)
          .map((e) => DriverDetails.fromJson(e))
          .toList(),
      total: json['total'],
      pageMeta: PageMeta.fromJson(json['pageMeta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'total': total,
      'pageMeta': pageMeta.toJson(),
    };
  }
}

class DriverDetails {
  String driverId;
  String name;
  String mobile;
  String email;
  String licenseNumber;
  String licenseDocLink;
  DateTime licenseExpiryDate;
  String customerId;
  DateTime dateOfBirth;
  int driverStatus;
  String experience;
  int bloodGroup;
  int licenseCategory;
  int specialLicense;
  String communicationPreference;
  CompanyDetails companyDetails;
  String activeStatus;

  DriverDetails({
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
    required this.activeStatus,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      driverId: json['driverId'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      licenseNumber: json['licenseNumber'],
      licenseDocLink: json['licenseDocLink'],
      licenseExpiryDate: DateTime.parse(json['licenseExpiryDate']),
      customerId: json['customerId'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      driverStatus: json['driverStatus'],
      experience: json['experience'],
      bloodGroup: json['bloodGroup'],
      licenseCategory: json['licenseCategory'],
      specialLicense: json['specialLicense'],
      communicationPreference: json['communicationPreference'],
      companyDetails: CompanyDetails.fromJson(json['companyDetails']),
      activeStatus: json['activeStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'name': name,
      'mobile': mobile,
      'email': email,
      'licenseNumber': licenseNumber,
      'licenseDocLink': licenseDocLink,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'customerId': customerId,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'driverStatus': driverStatus,
      'experience': experience,
      'bloodGroup': bloodGroup,
      'licenseCategory': licenseCategory,
      'specialLicense': specialLicense,
      'communicationPreference': communicationPreference,
      'companyDetails': companyDetails.toJson(),
      'activeStatus': activeStatus,
    };
  }
}

class CompanyDetails {
  String companyName;
  int companyTypeId;
  String mobile;
  String gstin;

  CompanyDetails({
    required this.companyName,
    required this.companyTypeId,
    required this.mobile,
    required this.gstin,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      companyName: json['companyName'],
      companyTypeId: json['companyTypeId'],
      mobile: json['mobile'],
      gstin: json['gstin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companyTypeId': companyTypeId,
      'mobile': mobile,
      'gstin': gstin,
    };
  }
}

class PageMeta {
  int page;
  int pageCount;
  int? nextPage;
  int pageSize;
  int total;

  PageMeta({
    required this.page,
    required this.pageCount,
    this.nextPage,
    required this.pageSize,
    required this.total,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: json['page'],
      pageCount: json['pageCount'],
      nextPage: json['nextPage'],
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageCount': pageCount,
      'nextPage': nextPage,
      'pageSize': pageSize,
      'total': total,
    };
  }
}
