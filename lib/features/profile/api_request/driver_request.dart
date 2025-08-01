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
    required this.driverStatus,
  });

  final String customerId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final String licenseDocLink;
  final String licenseExpiryDate; // ISO string format
  final String dateOfBirth; // ISO string format
  final int driverStatus;

  DriverRequest copyWith({
    String? customerId,
    String? name,
    String? mobile,
    String? email,
    String? licenseNumber,
    String? licenseDocLink,
    String? licenseExpiryDate,
    String? dateOfBirth,
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
      driverStatus: driverStatus ?? this.driverStatus,
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
      driverStatus: json["driverStatus"] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (customerId.isNotEmpty) data["customerId"] = customerId;
    if (name.isNotEmpty) data["name"] = name;
    if (mobile.isNotEmpty) data["mobile"] = mobile;
    if (email.isNotEmpty) data["email"] = email;
    if (licenseNumber.isNotEmpty) data["licenseNumber"] = licenseNumber;
    if (licenseDocLink.isNotEmpty) data["licenseDocLink"] = licenseDocLink;
    if (licenseExpiryDate.isNotEmpty) {
      data["licenseExpiryDate"] = licenseExpiryDate;
    }
    if (dateOfBirth.isNotEmpty) data["dateOfBirth"] = dateOfBirth;
    data["driverStatus"] = driverStatus;

    return data;
  }
}
