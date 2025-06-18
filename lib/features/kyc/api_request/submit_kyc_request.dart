class SubmitKycApiRequest {
  SubmitKycApiRequest({
     this.aadhar,
     this.isAadhar,
     this.pan,
     this.panDocLink,
     this.isPan,
     this.gstin,
     this.gstinDocLink,
     this.isGstin,
     this.tan,
     this.tanDocLink,
     this.isTan,
    this.chequeDocLink,
    this.tdsDocLink,
     this.address1,
     this.address2,
     this.address3,
     this.bankAccount,
     this.bankName,
     this.branchName,
     this.ifscCode,
  });

  final String? aadhar;
  final bool? isAadhar;
  final String? pan;
  final String? panDocLink;
  final bool? isPan;
  final String? gstin;
  final String? gstinDocLink;
  final bool? isGstin;
  final String? tan;
  final String? tanDocLink;
  final bool? isTan;
  final String? chequeDocLink;
  final String? tdsDocLink;
  final String? address1;
  final String? address2;
  final String? address3;
  final String? bankAccount;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  Map<String, dynamic> toJson() => {
    "aadhar": aadhar ?? "",
    "isAadhar": isAadhar ?? false,
    "pan": pan ?? "",
    "panDocLink": panDocLink ?? "",
    "isPan": isPan ?? false,
    "gstin": gstin ?? "",
    "gstinDocLink": gstinDocLink ?? "",
    "isGstin": isGstin ?? false,
    "tan": tan ?? "",
    "tanDocLink": tanDocLink ?? "",
    "isTan": isTan ?? false,
    "chequeDocLink": chequeDocLink ?? "",
    "tdsDocLink": tdsDocLink ?? "",
    "address1": address1 ?? "",
    "address2": address2 ?? "",
    "address3": address3 ?? "",
    "bankAccount": bankAccount ?? "",
    "bankName": bankName ?? "",
    "branchName": branchName ?? "",
    "ifscCode": ifscCode ?? "",
  };

}
