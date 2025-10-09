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
    required this.tdsDocLink,
    required this.tdsDocLinkDetails,

    required this.aadharDocLink,
    required this.aadharDocLinkDetails,
  });

  final String aadhar;
  final bool isAadhar;
  final String pan;
  final String panDocLink;
  final NDocLinkDetails? panDocLinkDetails;
  final bool isPan;
  final String gstin;
  final String gstinDocLink;
  final NDocLinkDetails? gstinDocLinkDetails;
  final bool isGstin;
  final String tan;
  final String tanDocLink;
  final NDocLinkDetails? tanDocLinkDetails;
  final bool isTan;
  final String chequeDocLink;
  final NDocLinkDetails? chequeDocLinkDetails;
  final List tdsDocLink;
  final List<NDocLinkDetails>? tdsDocLinkDetails;

  final String? aadharDocLink;
  final NDocLinkDetails? aadharDocLinkDetails;

  Documents copyWith({
    String? aadhar,
    bool? isAadhar,
    String? pan,
    String? panDocLink,
    NDocLinkDetails? panDocLinkDetails,
    bool? isPan,
    String? gstin,
    String? gstinDocLink,
    NDocLinkDetails? gstinDocLinkDetails,
    bool? isGstin,
    String? tan,
    String? tanDocLink,
    NDocLinkDetails? tanDocLinkDetails,
    bool? isTan,
    String? chequeDocLink,
    NDocLinkDetails? chequeDocLinkDetails,
    List? tdsDocLink,
    List<NDocLinkDetails>? tdsDocLinkDetails,

     String? aadharDocLink,
    NDocLinkDetails? aadharDocLinkDetails
  }) {
    return Documents(
      aadharDocLink: aadharDocLink ?? this.aadharDocLink,
      aadharDocLinkDetails:aadharDocLinkDetails??this.aadharDocLinkDetails ,

      aadhar: aadhar ?? this.aadhar,
      isAadhar: isAadhar ?? this.isAadhar,
      pan: pan ?? this.pan,
      panDocLink: panDocLink ?? this.panDocLink,
      panDocLinkDetails: panDocLinkDetails ?? this.panDocLinkDetails,
      isPan: isPan ?? this.isPan,
      gstin: gstin ?? this.gstin,
      gstinDocLink: gstinDocLink ?? this.gstinDocLink,
      gstinDocLinkDetails: gstinDocLinkDetails ?? this.gstinDocLinkDetails,
      isGstin: isGstin ?? this.isGstin,
      tan: tan ?? this.tan,
      tanDocLink: tanDocLink ?? this.tanDocLink,
      tanDocLinkDetails: tanDocLinkDetails ?? this.tanDocLinkDetails,
      isTan: isTan ?? this.isTan,
      chequeDocLink: chequeDocLink ?? this.chequeDocLink,
      chequeDocLinkDetails: chequeDocLinkDetails ?? this.chequeDocLinkDetails,
      tdsDocLink: tdsDocLink ?? this.tdsDocLink,
      tdsDocLinkDetails: tdsDocLinkDetails ?? this.tdsDocLinkDetails,
    );
  }

  factory Documents.fromJson(Map<String, dynamic> json){

    return Documents(
        aadhar: json["aadhar"] ?? "",
        aadharDocLink: json["aadhar_doc_link"],
        aadharDocLinkDetails:json["aadharDocLinkDetails"] == null ||
            json["aadharDocLinkDetails"] == '' ? null : NDocLinkDetails
            .fromJson(json["aadharDocLinkDetails"]),

        isAadhar: json["isAadhar"] ?? false,
        pan: json["pan"] ?? "",
        panDocLink: json["panDocLink"] ?? "",
        panDocLinkDetails: json["panDocLinkDetails"] == null ||
            json["panDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(
            json["panDocLinkDetails"]),
        isPan: json["isPan"] ?? false,
        gstin: json["gstin"] ?? "",
        gstinDocLink: json["gstinDocLink"] ?? "",
        gstinDocLinkDetails: json["gstinDocLinkDetails"] == null ||
            json["gstinDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(
            json["gstinDocLinkDetails"]),
        isGstin: json["isGstin"] ?? false,
        tan: json["tan"] ?? "",
        tanDocLink: json["tanDocLink"] ?? "",
        tanDocLinkDetails: json["tanDocLinkDetails"] == null ||
            json["tanDocLinkDetails"] == '' ? null : NDocLinkDetails.fromJson(
            json["tanDocLinkDetails"]),
        isTan: json["isTan"] ?? false,
        chequeDocLink: json["chequeDocLink"] ?? "",
        chequeDocLinkDetails: json["chequeDocLinkDetails"] == null ||
            json["chequeDocLinkDetails"] == '' ? null : NDocLinkDetails
            .fromJson(json["chequeDocLinkDetails"]),
        tdsDocLink: json["tdsDocLink"] ?? "",
      tdsDocLinkDetails: (json["tdsDocLinkDetails"] is List)
          ? (json["tdsDocLinkDetails"] as List)
          .whereType<Map<String, dynamic>>() // only keep valid maps
          .map((x) => NDocLinkDetails.fromJson(x))
          .toList()
          : [],


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
