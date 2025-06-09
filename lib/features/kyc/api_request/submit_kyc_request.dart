class SubmitKycApiRequest {
  SubmitKycApiRequest({
    required this.aadhar,
    required this.isAadhar,
    required this.pan,
    required this.panDocLink,
    required this.isPan,
    required this.gstin,
    required this.gstinDocLink,
    required this.isGstin,
    required this.tan,
    required this.tanDocLink,
    required this.isTan,
      this.chequeDocLink,
      this.tdsDocLink,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.bankAccount,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
  });

  final String aadhar;
  final bool isAadhar;
  final String pan;
  final String panDocLink;
  final bool isPan;
  final String gstin;
  final String gstinDocLink;
  final bool isGstin;
  final String tan;
  final String tanDocLink;
  final bool isTan;
  final String? chequeDocLink;
    String? tdsDocLink;
  final String address1;
  final String address2;
  final String address3;
  final String bankAccount;
  final String bankName;
  final String branchName;
  final String ifscCode;

  factory SubmitKycApiRequest.fromJson(Map<String, dynamic> json){
    return SubmitKycApiRequest(
      aadhar: json["aadhar"] ?? "",
      isAadhar: json["isAadhar"] ?? false,
      pan: json["pan"] ?? "",
      panDocLink: json["panDocLink"] ?? "",
      isPan: json["isPan"] ?? false,
      gstin: json["gstin"] ?? "",
      gstinDocLink: json["gstinDocLink"] ?? "",
      isGstin: json["isGstin"] ?? false,
      tan: json["tan"] ?? "",
      tanDocLink: json["tanDocLink"] ?? "",
      isTan: json["isTan"] ?? false,
      chequeDocLink: json["chequeDocLink"] ?? "",
      tdsDocLink: json["tdsDocLink"] ?? "",
      address1: json["address1"] ?? "",
      address2: json["address2"] ?? "",
      address3: json["address3"] ?? "",
      bankAccount: json["bankAccount"] ?? "",
      bankName: json["bankName"] ?? "",
      branchName: json["branchName"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "aadhar": aadhar,
    "isAadhar": isAadhar,
    "pan": pan,
    "panDocLink": panDocLink,
    "isPan": isPan,
    "gstin": gstin,
    "gstinDocLink": gstinDocLink,
    "isGstin": isGstin,
    "tan": tan,
    "tanDocLink": tanDocLink,
    "isTan": isTan,
    "chequeDocLink": chequeDocLink,
    "tdsDocLink": tdsDocLink,
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "bankAccount": bankAccount,
    "bankName": bankName,
    "branchName": branchName,
    "ifscCode": ifscCode,
  };

}
