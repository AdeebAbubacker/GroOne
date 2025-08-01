class LicenseVahanRequest {
  LicenseVahanRequest({
    required this.licenseNumber,
    required this.name,
    required this.dob,
  });

  final String licenseNumber;
  final String name;
  final String dob;

  Map<String, dynamic> toJson() => {
        "license_number": licenseNumber,
        "name": name,
        "dob": dob,
      };
}
