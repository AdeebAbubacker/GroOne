class KycDocumentResponse {
  KycDocumentResponse({
    required this.customerId,
    required this.documents,
    required this.isKyc,
  });

  final String customerId;
  final KycDocuments? documents;
  final int isKyc;

  KycDocumentResponse copyWith({
    String? customerId,
    KycDocuments? documents,
    int? isKyc,
  }) {
    return KycDocumentResponse(
      customerId: customerId ?? this.customerId,
      documents: documents ?? this.documents,
      isKyc: isKyc ?? this.isKyc,
    );
  }

  factory KycDocumentResponse.fromJson(Map<String, dynamic> json){
    return KycDocumentResponse(
      customerId: json["customerId"] ?? "",
      documents: json["documents"] == null ? null : KycDocuments.fromJson(json["documents"]),
      isKyc: json["isKyc"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "documents": documents?.toJson(),
    "isKyc": isKyc,
  };

}

class KycDocuments {
  KycDocuments({
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
    required this.chequeDocLink,
    required this.tdsDocLink,
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
  final String chequeDocLink;
  final String tdsDocLink;

  KycDocuments copyWith({
    String? aadhar,
    bool? isAadhar,
    String? pan,
    String? panDocLink,
    bool? isPan,
    String? gstin,
    String? gstinDocLink,
    bool? isGstin,
    String? tan,
    String? tanDocLink,
    bool? isTan,
    String? chequeDocLink,
    String? tdsDocLink,
  }) {
    return KycDocuments(
      aadhar: aadhar ?? this.aadhar,
      isAadhar: isAadhar ?? this.isAadhar,
      pan: pan ?? this.pan,
      panDocLink: panDocLink ?? this.panDocLink,
      isPan: isPan ?? this.isPan,
      gstin: gstin ?? this.gstin,
      gstinDocLink: gstinDocLink ?? this.gstinDocLink,
      isGstin: isGstin ?? this.isGstin,
      tan: tan ?? this.tan,
      tanDocLink: tanDocLink ?? this.tanDocLink,
      isTan: isTan ?? this.isTan,
      chequeDocLink: chequeDocLink ?? this.chequeDocLink,
      tdsDocLink: tdsDocLink ?? this.tdsDocLink,
    );
  }

  factory KycDocuments.fromJson(Map<String, dynamic> json){
    return KycDocuments(
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
  };

}
