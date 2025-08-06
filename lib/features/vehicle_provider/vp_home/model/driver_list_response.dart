class DriverListResponse {
  DriverListResponse({

    required this.data,
  });


  final List<DriverDetails> data;

  factory DriverListResponse.fromJson(Map<String, dynamic> json) {


    return DriverListResponse(
      data: json["data"] == null
          ? []
          : List<DriverDetails>.from(
          json["data"].map((x) {
            return DriverDetails.fromJson(x);
          })),
    );
  }


}

class DriverDetails {
  DriverDetails({
    required this.id,
    required this.customerId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.licenseNumber,
    required this.licenseDocLink,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.licenseExpiryDate,
  });

  final String? id;
  final String? customerId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final String licenseDocLink;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final DateTime? licenseExpiryDate;

  factory DriverDetails.fromJson(Map<String, dynamic> json){
    return DriverDetails(
      id: json["driverId"] ?? 0,
      customerId: json["customerId"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      licenseDocLink: json["licenseDocLink"] ?? "",
      status: json["driverStatus"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "name": name,
    "mobile": mobile,
    "email": email,
    "licenseNumber": licenseNumber,
    "licenseDocLink": licenseDocLink,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "licenseExpiryDate": licenseExpiryDate?.toIso8601String(),
  };

}
