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
    this.licenseCategory,
    this.bloodGroup,
    required this.driverStatus,
  });

  final String customerId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final String licenseDocLink;
  final String licenseExpiryDate; 
  final String dateOfBirth; 
  final int? licenseCategory; 
  final int? bloodGroup; 
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
    int? licenseCategory,
    int? bloodGroup,
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
      licenseCategory: licenseCategory ?? this.licenseCategory,
      bloodGroup: bloodGroup ?? this.bloodGroup,
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
      bloodGroup: json["bloodGroup"], 
      licenseCategory: json["licenseCategory"],
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
    if (licenseCategory != null) data["licenseCategory"] = licenseCategory;
    if (bloodGroup != null) data["bloodGroup"] = bloodGroup;

    data["driverStatus"] = driverStatus;

    return data;
  }
}
