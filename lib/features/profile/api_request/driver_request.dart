class DriverRequest {
  DriverRequest({
    required this.customerId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.licenseNumber,
    required this.licenseDocLink,
    required this.licenseExpiryDate,
    required this.dateOfBirth,

  });

  final String customerId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final String licenseDocLink;
  final String licenseExpiryDate; // ISO string format
  final String dateOfBirth; // ISO string format


  DriverRequest copyWith({
    String? customerId,
    String? name,
    String? mobile,
    String? email,
    String? licenseNumber,
    String? licenseDocLink,
    String? licenseExpiryDate,
    String? dateOfBirth,
    String? experience,
    int? bloodGroup,
    int? licenseCategory,
    int? specialLicense,
    String? communicationPreference,
    int? driverStatus,
  }) {
    return DriverRequest(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseDocLink: licenseDocLink ?? this.licenseDocLink,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
     
    );
  }

  factory DriverRequest.fromJson(Map<String, dynamic> json) {
    return DriverRequest(
      customerId: json["customerId"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      licenseDocLink: json["licenseDocLink"] ?? "",
      licenseExpiryDate: json["licenseExpiryDate"] ?? "",
      dateOfBirth: json["dateOfBirth"] ?? "",
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "name": name,
      "mobile": mobile,
      "email": email,
      "licenseNumber": licenseNumber,
      "licenseDocLink": licenseDocLink,
      "licenseExpiryDate": licenseExpiryDate,
      "dateOfBirth": dateOfBirth,
     
    };
  }
}
