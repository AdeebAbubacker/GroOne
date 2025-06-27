class EnDhanKycModel {
  final bool success;
  final String message;
  final EnDhanKycData? data;

  const EnDhanKycModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory EnDhanKycModel.fromJson(Map<String, dynamic> json) {
    return EnDhanKycModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? EnDhanKycData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'EnDhanKycModel{success: $success, message: $message, data: $data}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnDhanKycModel &&
        other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}

class EnDhanKycData {
  final EnDhanDocument? document;

  const EnDhanKycData({
    this.document,
  });

  factory EnDhanKycData.fromJson(Map<String, dynamic> json) {
    return EnDhanKycData(
      document: json['document'] != null 
          ? EnDhanDocument.fromJson(json['document'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'document': document?.toJson(),
    };
  }

  @override
  String toString() {
    return 'EnDhanKycData{document: $document}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnDhanKycData && other.document == document;
  }

  @override
  int get hashCode => document.hashCode;
}

class EnDhanDocument {
  final String? identityProofNo;
  final String? addressProofNo;
  final String? createdAt;
  final int? id;
  final int? customerId;
  final String? aadhar;
  final String? pan;
  final String? addressProofFront;
  final String? addressProofFrontLocal;
  final String? addressProofBack;
  final String? addressProofBackLocal;
  final String? identityProofFront;
  final String? identityProofFrontLocal;
  final String? identityProofBack;
  final String? identityProofBackLocal;
  final String? panImage;
  final String? endhanCustomerId;
  final String? identityProofType;
  final String? addressProofType;
  final String? deletedAt;

  const EnDhanDocument({
    this.identityProofNo,
    this.addressProofNo,
    this.createdAt,
    this.id,
    this.customerId,
    this.aadhar,
    this.pan,
    this.addressProofFront,
    this.addressProofFrontLocal,
    this.addressProofBack,
    this.addressProofBackLocal,
    this.identityProofFront,
    this.identityProofFrontLocal,
    this.identityProofBack,
    this.identityProofBackLocal,
    this.panImage,
    this.endhanCustomerId,
    this.identityProofType,
    this.addressProofType,
    this.deletedAt,
  });

  factory EnDhanDocument.fromJson(Map<String, dynamic> json) {
    return EnDhanDocument(
      identityProofNo: json['identityProofNo'] as String?,
      addressProofNo: json['addressProofNo'] as String?,
      createdAt: json['createdAt'] as String?,
      id: json['id'] as int?,
      customerId: json['customerId'] as int?,
      aadhar: json['aadhar'] as String?,
      pan: json['pan'] as String?,
      addressProofFront: json['addressProofFront'] as String?,
      addressProofFrontLocal: json['addressProofFrontLocal'] as String?,
      addressProofBack: json['addressProofBack'] as String?,
      addressProofBackLocal: json['addressProofBackLocal'] as String?,
      identityProofFront: json['identityProofFront'] as String?,
      identityProofFrontLocal: json['identityProofFrontLocal'] as String?,
      identityProofBack: json['identityProofBack'] as String?,
      identityProofBackLocal: json['identityProofBackLocal'] as String?,
      panImage: json['panImage'] as String?,
      endhanCustomerId: json['endhanCustomerId'] as String?,
      identityProofType: json['identityProofType'] as String?,
      addressProofType: json['addressProofType'] as String?,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'identityProofNo': identityProofNo,
      'addressProofNo': addressProofNo,
      'createdAt': createdAt,
      'id': id,
      'customerId': customerId,
      'aadhar': aadhar,
      'pan': pan,
      'addressProofFront': addressProofFront,
      'addressProofFrontLocal': addressProofFrontLocal,
      'addressProofBack': addressProofBack,
      'addressProofBackLocal': addressProofBackLocal,
      'identityProofFront': identityProofFront,
      'identityProofFrontLocal': identityProofFrontLocal,
      'identityProofBack': identityProofBack,
      'identityProofBackLocal': identityProofBackLocal,
      'panImage': panImage,
      'endhanCustomerId': endhanCustomerId,
      'identityProofType': identityProofType,
      'addressProofType': addressProofType,
      'deletedAt': deletedAt,
    };
  }

  @override
  String toString() {
    return 'EnDhanDocument{identityProofNo: $identityProofNo, addressProofNo: $addressProofNo, createdAt: $createdAt, id: $id, customerId: $customerId, aadhar: $aadhar, pan: $pan, addressProofFront: $addressProofFront, addressProofFrontLocal: $addressProofFrontLocal, addressProofBack: $addressProofBack, addressProofBackLocal: $addressProofBackLocal, identityProofFront: $identityProofFront, identityProofFrontLocal: $identityProofFrontLocal, identityProofBack: $identityProofBack, identityProofBackLocal: $identityProofBackLocal, panImage: $panImage, endhanCustomerId: $endhanCustomerId, identityProofType: $identityProofType, addressProofType: $addressProofType, deletedAt: $deletedAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnDhanDocument &&
        other.identityProofNo == identityProofNo &&
        other.addressProofNo == addressProofNo &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.customerId == customerId &&
        other.aadhar == aadhar &&
        other.pan == pan &&
        other.addressProofFront == addressProofFront &&
        other.addressProofFrontLocal == addressProofFrontLocal &&
        other.addressProofBack == addressProofBack &&
        other.addressProofBackLocal == addressProofBackLocal &&
        other.identityProofFront == identityProofFront &&
        other.identityProofFrontLocal == identityProofFrontLocal &&
        other.identityProofBack == identityProofBack &&
        other.identityProofBackLocal == identityProofBackLocal &&
        other.panImage == panImage &&
        other.endhanCustomerId == endhanCustomerId &&
        other.identityProofType == identityProofType &&
        other.addressProofType == addressProofType &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return identityProofNo.hashCode ^
        addressProofNo.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        customerId.hashCode ^
        aadhar.hashCode ^
        pan.hashCode ^
        addressProofFront.hashCode ^
        addressProofFrontLocal.hashCode ^
        addressProofBack.hashCode ^
        addressProofBackLocal.hashCode ^
        identityProofFront.hashCode ^
        identityProofFrontLocal.hashCode ^
        identityProofBack.hashCode ^
        identityProofBackLocal.hashCode ^
        panImage.hashCode ^
        endhanCustomerId.hashCode ^
        identityProofType.hashCode ^
        addressProofType.hashCode ^
        deletedAt.hashCode;
  }
}

/// Response model for KYC check API
class EnDhanKycCheckModel {
  final bool success;
  final String message;
  final dynamic data; // Can be EnDhanKycData or String

  const EnDhanKycCheckModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory EnDhanKycCheckModel.fromJson(Map<String, dynamic> json) {
    return EnDhanKycCheckModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }

  /// Check if KYC documents exist
  bool get hasKycDocuments {
    if (data is String) {
      return data != "Document not found";
    }
    return data is Map<String, dynamic> && data['document'] != null;
  }

  /// Get KYC data if exists
  EnDhanKycData? get kycData {
    if (data is Map<String, dynamic> && data['document'] != null) {
      return EnDhanKycData.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'EnDhanKycCheckModel{success: $success, message: $message, data: $data}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnDhanKycCheckModel &&
        other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
} 