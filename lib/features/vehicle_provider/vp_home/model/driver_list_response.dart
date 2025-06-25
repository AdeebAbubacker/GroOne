class DriverListResponse {
  DriverListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<DriverDetails> data;

  factory DriverListResponse.fromJson(Map<String, dynamic> json) {


    return DriverListResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"]['data'] == null
          ? []
          : List<DriverDetails>.from(
          json["data"]['data'].map((x) {
            print("x ${x}");
            return DriverDetails.fromJson(x);
          })),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

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

  final int id;
  final num customerId;
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
    print("json is $json");
    return DriverDetails(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      licenseDocLink: json["licenseDocLink"] ?? "",
      status: json["status"] ?? 0,
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
