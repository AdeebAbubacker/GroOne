class DocumentTypeResponseModel {
  String? message;
  List<DocumentTypeLst>? documentTypeList;

  DocumentTypeResponseModel({
    this.message,
    this.documentTypeList,
  });

  factory DocumentTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeResponseModel(
      message: json['message'] as String?,
      documentTypeList: (json['data'] as List<dynamic>?)
          ?.map((e) => DocumentTypeLst.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'documentTypeList': documentTypeList?.map((e) => e.toJson()).toList(),
    };
  }
}


class DocumentTypeLst {
  int? documentTypeId;
  String? name;
  List<String>? mimeTypes;
  String? maxFileSize;
  List<String>? allowedExtensions;
  bool? isActive;
  String? fileType;
  FolderDetails? folderDetails;

  DocumentTypeLst({
    this.documentTypeId,
    this.name,
    this.mimeTypes,
    this.maxFileSize,
    this.allowedExtensions,
    this.isActive,
    this.fileType,
    this.folderDetails,
  });

  factory DocumentTypeLst.fromJson(Map<String, dynamic> json) {
    return DocumentTypeLst(
      documentTypeId: json['documentTypeId'] as int?,
      name: json['name'] as String?,
      mimeTypes:
          (json['mimeTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      maxFileSize: json['maxFileSize'] as String?,
      allowedExtensions:
          (json['allowedExtensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      isActive: json['isActive'] as bool?,
      fileType: json['fileType'] as String?,
      folderDetails:
          json['folderDetails'] != null
              ? FolderDetails.fromJson(json['folderDetails'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentTypeId': documentTypeId,
      'name': name,
      'mimeTypes': mimeTypes,
      'maxFileSize': maxFileSize,
      'allowedExtensions': allowedExtensions,
      'isActive': isActive,
      'fileType': fileType,
      'folderDetails': folderDetails?.toJson(),
    };
  }
}

class FolderDetails {
  String? customer;
  String? vp;
  String? lp;
  String? admin;
  String? bothLpvp;
  String? driver;

  FolderDetails({
    this.customer,
    this.vp,
    this.lp,
    this.admin,
    this.bothLpvp,
    this.driver,
  });

  factory FolderDetails.fromJson(Map<String, dynamic> json) {
    return FolderDetails(
      customer: json['customer'] as String?,
      vp: json['vp'] as String?,
      lp: json['lp'] as String?,
      admin: json['admin'] as String?,
      bothLpvp: json['both_lpvp'] as String?,
      driver: json['driver'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'vp': vp,
      'lp': lp,
      'admin': admin,
      'both_lpvp': bothLpvp,
      'driver': driver,
    };
  }
}
