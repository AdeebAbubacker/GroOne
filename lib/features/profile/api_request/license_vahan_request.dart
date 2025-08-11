class LicenseVahanRequest {
  LicenseVahanRequest({
    this.licenseNumber,
    this.name,
    this.dob,
  });

  final String? licenseNumber;
  final String? name;
  final String? dob;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (licenseNumber != null) data["license_number"] = licenseNumber;
    if (name != null) data["name"] = name;
    if (dob != null) data["dob"] = dob;
    return data;
  }
}
