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
    this.id,
    this.customerId,
    this.name,
    this.mobile,
    this.email,
    this.licenseNumber,
    this.licenseDocLink,
    this.status,
    this.createdAt,
    this.deletedAt,
    this.activeStatus,
    this.licenseExpiryDate,
    this.self,
  });

  final String? id;
  final String? customerId;
  final String? name;
  final String? mobile;
  final String? email;
  final String? licenseNumber;
  final String? licenseDocLink;
  final String? activeStatus;
  final num? status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final DateTime? licenseExpiryDate;
  final int? self;

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      id: json["driverId"]?.toString(),
      customerId: json["customerId"]?.toString(),
      name: json["name"]?.toString(),
      mobile: json["mobile"]?.toString(),
      email: json["email"]?.toString(),
      licenseNumber: json["licenseNumber"]?.toString(),
      licenseDocLink: json["licenseDocLink"]?.toString(),
      activeStatus: json["activeStatus"]?.toString(),
      status: json["driverStatus"] is num ? json["driverStatus"] : num.tryParse(json["driverStatus"]?.toString() ?? ""),
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,
      deletedAt: json["deletedAt"],
      licenseExpiryDate: json["licenseExpiryDate"] != null ? DateTime.tryParse(json["licenseExpiryDate"].toString()) : null,
      self: 0
    );
  }

  Map<String, dynamic> toJson() => {
    "driverId": id,
    "customerId": customerId,
    "name": name,
    "mobile": mobile,
    "email": email,
    "licenseNumber": licenseNumber,
    "licenseDocLink": licenseDocLink,
    "activeStatus": activeStatus,
    "driverStatus": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "licenseExpiryDate": licenseExpiryDate?.toIso8601String(),
    "self": self,
  };
}


