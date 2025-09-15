class GpsVehicleModel {
  final String vehicleId;
  final String customerId;
  final String truckNo;
  final String? ownerName;
  final String? registrationDate;
  final String tonnage;
  final int truckTypeId;
  final String modelNumber;
  final String? insurancePolicyNumber;
  final String? insuranceValidityDate;
  final String? fcExpiryDate;
  final String? pucExpiryDate;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GpsVehicleModel({
    required this.vehicleId,
    required this.customerId,
    required this.truckNo,
    this.ownerName,
    this.registrationDate,
    required this.tonnage,
    required this.truckTypeId,
    required this.modelNumber,
    this.insurancePolicyNumber,
    this.insuranceValidityDate,
    this.fcExpiryDate,
    this.pucExpiryDate,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GpsVehicleModel.fromJson(Map<String, dynamic> json) {
    
    final vehicle = GpsVehicleModel(
      vehicleId: json['vehicleId'] ?? '',
      customerId: json['customerId'] ?? '',
      truckNo: json['truckNo'] ?? '',
      ownerName: json['ownerName'],
      registrationDate: json['registrationDate'],
      tonnage: (json['tonnage'] ?? '').toString(), // Convert to string to handle both int and string
      truckTypeId: json['truckTypeId'] ?? 0,
      modelNumber: json['modelNumber'] ?? '',
      insurancePolicyNumber: json['insurancePolicyNumber'],
      insuranceValidityDate: json['insuranceValidityDate'],
      fcExpiryDate: json['fcExpiryDate'],
      pucExpiryDate: json['pucExpiryDate'],
      status: json['status'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
    
    return vehicle;
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'customerId': customerId,
      'truckNo': truckNo,
      'ownerName': ownerName,
      'registrationDate': registrationDate,
      'tonnage': tonnage,
      'truckTypeId': truckTypeId,
      'modelNumber': modelNumber,
      'insurancePolicyNumber': insurancePolicyNumber,
      'insuranceValidityDate': insuranceValidityDate,
      'fcExpiryDate': fcExpiryDate,
      'pucExpiryDate': pucExpiryDate,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  // Convenience getters
  String get vehicleNumber => truckNo;
  String get capacity => tonnage;
  bool get isActive => status == 1;
  String get statusText => status == 1 ? 'Active' : 'Inactive';
  String get truckMakeAndModel => modelNumber; // For backward compatibility
  String get id => vehicleId; // For backward compatibility
  int get vehicleStatus => status; // For backward compatibility
  
  // Additional getters for UI compatibility
  String get rcNumber => modelNumber; // Using modelNumber as RC number for now
  String get truckLength => '20'; // Default truck length, can be updated when API provides this field
}

class GpsVehicleListResponse {
  final List<GpsVehicleModel> data;
  final int total;
  final GpsPageMeta pageMeta;

  GpsVehicleListResponse({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  factory GpsVehicleListResponse.fromJson(Map<String, dynamic> json) {
    
    final dataList = json['data'] as List<dynamic>?;
    
    final vehicles = dataList?.map((item) {
      return GpsVehicleModel.fromJson(item as Map<String, dynamic>);
    }).toList() ?? [];
    
    
    return GpsVehicleListResponse(
      data: vehicles,
      total: json['total'] ?? 0,
      pageMeta: GpsPageMeta.fromJson(json['pageMeta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'total': total,
      'pageMeta': pageMeta.toJson(),
    };
  }
}

class GpsPageMeta {
  final int page;
  final int pageCount;
  final int? nextPage;
  final int pageSize;
  final int total;

  GpsPageMeta({
    required this.page,
    required this.pageCount,
    this.nextPage,
    required this.pageSize,
    required this.total,
  });

  factory GpsPageMeta.fromJson(Map<String, dynamic> json) {
    
    // Handle both string and int values for numeric fields
    final page = json['page'];
    final pageCount = json['pageCount'];
    final nextPage = json['nextPage'];
    final pageSize = json['pageSize'];
    final total = json['total'];
    
    
    return GpsPageMeta(
      page: page is int ? page : int.tryParse(page?.toString() ?? '1') ?? 1,
      pageCount: pageCount is int ? pageCount : int.tryParse(pageCount?.toString() ?? '1') ?? 1,
      nextPage: nextPage is int ? nextPage : (nextPage != null ? int.tryParse(nextPage.toString()) : null),
      pageSize: pageSize is int ? pageSize : int.tryParse(pageSize?.toString() ?? '10') ?? 10,
      total: total is int ? total : int.tryParse(total?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageCount': pageCount,
      'nextPage': nextPage,
      'pageSize': pageSize,
      'total': total,
    };
  }
}

class GpsAddVehicleRequest {
  final String customerId;
  final String truckNo;
  final String rcNumber;
  final String rcDocLink;
  final String tonnage;
  final int truckTypeId;
  final String truckMakeAndModel;
  final List<int> acceptableCommodities;
  final int truckLength;
  final int vehicleStatus;

  GpsAddVehicleRequest({
    required this.customerId,
    required this.truckNo,
    required this.rcNumber,
    required this.rcDocLink,
    required this.tonnage,
    required this.truckTypeId,
    required this.truckMakeAndModel,
    required this.acceptableCommodities,
    required this.truckLength,
    required this.vehicleStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'truckNo': truckNo,
      'rcNumber': rcNumber,
      'rcDocLink': rcDocLink,
      'tonnage': tonnage,
      'truckTypeId': truckTypeId,
      'truckMakeAndModel': truckMakeAndModel,
      'acceptableCommodities': acceptableCommodities,
      'truckLength': truckLength,
      'vehicleStatus': vehicleStatus,
    };
  }
}

class GpsAddVehicleResponse {
  final bool success;
  final String message;
  final GpsAddVehicleResponseData? data;

  GpsAddVehicleResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GpsAddVehicleResponse.fromJson(Map<String, dynamic> json) {
    return GpsAddVehicleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? GpsAddVehicleResponseData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GpsAddVehicleResponseData {
  final String vehicleId;
  final String customerId;
  final String truckNo;
  final String tonnage;
  final int truckTypeId;
  final String modelNumber;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GpsAddVehicleResponseData({
    required this.vehicleId,
    required this.customerId,
    required this.truckNo,
    required this.tonnage,
    required this.truckTypeId,
    required this.modelNumber,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GpsAddVehicleResponseData.fromJson(Map<String, dynamic> json) {
    return GpsAddVehicleResponseData(
      vehicleId: json['vehicleId'] ?? '',
      customerId: json['customerId'] ?? '',
      truckNo: json['truckNo'] ?? '',
      tonnage: json['tonnage'] ?? '',
      truckTypeId: json['truckTypeId'] ?? 0,
      modelNumber: json['modelNumber'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'customerId': customerId,
      'truckNo': truckNo,
      'tonnage': tonnage,
      'truckTypeId': truckTypeId,
      'modelNumber': modelNumber,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

class GpsDocumentUploadResponse {
  final String url;
  final String filePath;
  final String originalName;
  final int size;
  final String mimeType;

  GpsDocumentUploadResponse({
    required this.url,
    required this.filePath,
    required this.originalName,
    required this.size,
    required this.mimeType,
  });

  factory GpsDocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return GpsDocumentUploadResponse(
      url: json['url'] ?? '',
      filePath: json['filePath'] ?? '',
      originalName: json['originalName'] ?? '',
      size: json['size'] ?? 0,
      mimeType: json['mimeType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'filePath': filePath,
      'originalName': originalName,
      'size': size,
      'mimeType': mimeType,
    };
  }
} 