class ProfileUpdateRequest {
  ProfileUpdateRequest({
    required this.customerName,
    required this.mobileNumber,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.companyName,
    required this.gstin,
  });

  final String customerName;
  final String mobileNumber;
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String ifscCode;
  final String companyName;
  final String gstin;

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json){
    return ProfileUpdateRequest(
      customerName: json["customer_name"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      bankName: json["bankName"] ?? "",
      branchName: json["branchName"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      companyName: json["companyName"] ?? "",
      gstin: json["gstin"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "mobileNumber": mobileNumber,
    "accountNumber": accountNumber,
    "bankName": bankName,
    "branchName": branchName,
    "ifscCode": ifscCode,
    "companyName": companyName,
    "gstin": gstin,
  };

}
