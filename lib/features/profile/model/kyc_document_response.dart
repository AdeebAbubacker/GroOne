class KycDocumentResponse {
  KycDocumentResponse({
    required this.customerId,
    required this.documents,
    required this.isKyc,
  });

  final String? customerId;
  final Documents? documents;
  final int? isKyc;

  factory KycDocumentResponse.fromJson(Map<String, dynamic> json) {
    return KycDocumentResponse(
      customerId: json["customerId"],
      documents:
          json["documents"] == null
              ? null
              : Documents.fromJson(json["documents"]),
      isKyc: json["isKyc"],
    );
  }
}

class Documents {
  Documents({
    required this.aadhar,
    required this.isAadhar,
    required this.aadharDocLink,
    required this.aadharDocLinkDetails,
    required this.pan,
    required this.panDocLink,
    required this.panDocLinkDetails,
    required this.isPan,
    required this.gstin,
    required this.gstinDocLink,
    required this.gstinDocLinkDetails,
    required this.isGstin,
    required this.tan,
    required this.tanDocLink,
    required this.tanDocLinkDetails,
    required this.isTan,
    required this.chequeDocLink,
    required this.chequeDocLinkDetails,
    required this.isTds,
    required this.tdsDocLink,
    required this.tdsDocLinkDetails,
  });

  final String? aadhar;
  final bool? isAadhar;
  final String? aadharDocLink;
  final String? aadharDocLinkDetails;
  final String? pan;
  final String? panDocLink;
  final PanDocLinkDetails? panDocLinkDetails;
  final bool? isPan;
  final dynamic gstin;
  final dynamic gstinDocLink;
  final dynamic gstinDocLinkDetails;
  final bool? isGstin;
  final dynamic tan;
  final dynamic tanDocLink;
  final dynamic tanDocLinkDetails;
  final bool? isTan;
  final dynamic chequeDocLink;
  final dynamic chequeDocLinkDetails;
  final bool? isTds;
  final List<dynamic> tdsDocLink;
  final List<dynamic> tdsDocLinkDetails;

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      aadhar: json["aadhar"],
      isAadhar: json["isAadhar"],
      aadharDocLink: json["aadhar_doc_link"],
      aadharDocLinkDetails: json["aadharDocLinkDetails"],
      pan: json["pan"],
      panDocLink: json["panDocLink"],
      panDocLinkDetails:
          json["panDocLinkDetails"] == null
              ? null
              : PanDocLinkDetails.fromJson(json["panDocLinkDetails"]),
      isPan: json["isPan"],
      gstin: json["gstin"],
      gstinDocLink: json["gstinDocLink"],
      gstinDocLinkDetails: json["gstinDocLinkDetails"],
      isGstin: json["isGstin"],
      tan: json["tan"],
      tanDocLink: json["tanDocLink"],
      tanDocLinkDetails: json["tanDocLinkDetails"],
      isTan: json["isTan"],
      chequeDocLink: json["chequeDocLink"],
      chequeDocLinkDetails: json["chequeDocLinkDetails"],
      isTds: json["isTds"],
      tdsDocLink:
          json["tdsDocLink"] == null
              ? []
              : List<dynamic>.from(json["tdsDocLink"]!.map((x) => x)),
      tdsDocLinkDetails:
          json["tdsDocLinkDetails"] == null
              ? []
              : List<dynamic>.from(json["tdsDocLinkDetails"]!.map((x) => x)),
      aadharDocDetails:    json["aadharDocLinkDetails"] == null  || json["aadharDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(json["aadharDocLinkDetails"]),
      aadhar: json["aadhar"] ?? "",
      isAadhar: json["isAadhar"] ?? false,
      pan: json["pan"] ?? "",
      panDocLink: json["panDocLink"] ?? "",
      panDocLinkDetails: json["panDocLinkDetails"] == null  || json["panDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(json["panDocLinkDetails"]),
      isPan: json["isPan"] ?? false,
      gstin: json["gstin"] ?? "",
      gstinDocLink: json["gstinDocLink"] ?? "",
      gstinDocLinkDetails: json["gstinDocLinkDetails"] == null  || json["gstinDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(json["gstinDocLinkDetails"]),
      isGstin: json["isGstin"] ?? false,
      tan: json["tan"] ?? "",
      tanDocLink: json["tanDocLink"] ?? "",
      tanDocLinkDetails: json["tanDocLinkDetails"] == null  || json["tanDocLinkDetails"] == '' ?  null : NDocLinkDetails.fromJson(json["tanDocLinkDetails"]),
      isTan: json["isTan"] ?? false,
      chequeDocLink: json["chequeDocLink"] ?? "",
      chequeDocLinkDetails: json["chequeDocLinkDetails"] == null || json["chequeDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(json["chequeDocLinkDetails"]),
      tdsDocLink: json["tdsDocLink"] ?? "",
      tdsDocLinkDetails: json["tdsDocLinkDetails"] == null  ? [] : List<NDocLinkDetails>.from(json['tdsDocLinkDetails'].map((x)=>NDocLinkDetails.fromJson(x))).toList()

    );
  }
}

class PanDocLinkDetails {
  PanDocLinkDetails({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.fileSize,
    required this.createdAt,
    required this.fileExtension,
    required this.filePath,
  });

  final String? documentId;
  final String? title;
  final String? documentType;
  final String? fileSize;
  final DateTime? createdAt;
  final String? fileExtension;
  final String? filePath;

  factory PanDocLinkDetails.fromJson(Map<String, dynamic> json) {
    return PanDocLinkDetails(
      documentId: json["documentId"],
      title: json["title"],
      documentType: json["documentType"],
      fileSize: json["fileSize"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      fileExtension: json["fileExtension"],
      filePath: json["filePath"],
    );
  }
}

class NDocLinkDetails {
  NDocLinkDetails({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.fileSize,
    required this.createdAt,
    required this.fileExtension,
  });

  final String documentId;
  final String title;
  final String documentType;
  final String fileSize;
  final DateTime? createdAt;
  final String? fileExtension;

  NDocLinkDetails copyWith({
    String? documentId,
    String? title,
    String? documentType,
    String? fileSize,
    DateTime? createdAt,
    String? fileExtension,
  }) {
    return NDocLinkDetails(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      documentType: documentType ?? this.documentType,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      fileExtension: fileExtension ?? this.fileExtension,
    );
  }

  factory NDocLinkDetails.fromJson(Map<String, dynamic> json) {
    return NDocLinkDetails(
      documentId: json["documentId"] ?? "",
      title: json["title"] ?? "",
      documentType: json["documentType"] ?? "",
      fileSize: json["fileSize"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      fileExtension: json["fileExtension"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "documentId": documentId,
    "title": title,
    "documentType": documentType,
    "fileSize": fileSize,
    "createdAt": createdAt?.toIso8601String(),
    "fileExtension": fileExtension,
  };
}
