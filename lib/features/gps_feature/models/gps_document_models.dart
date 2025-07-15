import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';

import '../../kavach/model/kavach_address_model.dart';

/// GPS Document Upload Response
class GpsDocumentUploadResponse {
  final bool success;
  final String message;
  final dynamic data;

  const GpsDocumentUploadResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GpsDocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return GpsDocumentUploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
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
    return 'GpsDocumentUploadResponse{success: $success, message: $message, data: $data}';
  }
}

/// GPS Product List Response
class GpsProductListResponse {
  final bool success;
  final String message;
  final GpsProductListData? data;
  final int? statusCode;

  const GpsProductListResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory GpsProductListResponse.fromJson(Map<String, dynamic> json) {
    return GpsProductListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? GpsProductListData.fromJson(json['data']) : null,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'GpsProductListResponse{success: $success, message: $message, data: $data, statusCode: $statusCode}';
  }
}

/// GPS Product List Data
class GpsProductListData {
  final List<GpsProduct> rows;
  final GpsProductListMeta meta;

  const GpsProductListData({
    required this.rows,
    required this.meta,
  });

  factory GpsProductListData.fromJson(Map<String, dynamic> json) {
    return GpsProductListData(
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => GpsProduct.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: GpsProductListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'rows': rows.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'GpsProductListData{rows: $rows, meta: $meta}';
  }
}

/// GPS Product List Meta
class GpsProductListMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const GpsProductListMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory GpsProductListMeta.fromJson(Map<String, dynamic> json) {
    return GpsProductListMeta(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }

  @override
  String toString() {
    return 'GpsProductListMeta{total: $total, page: $page, limit: $limit, totalPages: $totalPages}';
  }
}

/// GPS Product Model
class GpsProduct {
  final String id;
  final String fleetProductId;
  final String? userFriendlyId;
  final String? type;
  final String name;
  final String? part;
  final String? serviceType;
  final String price;
  final String gstPerc;
  final String? productDesc;
  final String? fileKey;
  final String? unitMeasurement;
  final String? purchasePrice;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleTankType;
  final String? vehicleEngine;
  final String? vehicleDeviceType;
  final String? kAcntCode;
  final String? eAcntCode;
  final String? sAcntCode;
  final String? hsnSacCode;
  final int? vendorId;

  const GpsProduct({
    required this.id,
    required this.fleetProductId,
    this.userFriendlyId,
    this.type,
    required this.name,
    this.part,
    this.serviceType,
    required this.price,
    required this.gstPerc,
    this.productDesc,
    this.fileKey,
    this.unitMeasurement,
    this.purchasePrice,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleTankType,
    this.vehicleEngine,
    this.vehicleDeviceType,
    this.kAcntCode,
    this.eAcntCode,
    this.sAcntCode,
    this.hsnSacCode,
    this.vendorId,
  });

  factory GpsProduct.fromJson(Map<String, dynamic> json) {
    return GpsProduct(
      id: json['id'] as String? ?? '',
      fleetProductId: json['fleetProductId'] as String? ?? '',
      userFriendlyId: json['userFriendlyId'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String? ?? '',
      part: json['part'] as String?,
      serviceType: json['service_type'] as String?,
      price: json['price'] as String? ?? '0',
      gstPerc: json['gst_perc'] as String? ?? '0',
      productDesc: json['product_desc'] as String?,
      fileKey: json['file_key'] as String?,
      unitMeasurement: json['unit_measurement'] as String?,
      purchasePrice: json['purchase_price'] as String?,
      vehicleMake: json['vehicle_make'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehicleTankType: json['vehicle_tank_type'] as String?,
      vehicleEngine: json['vehicle_engine'] as String?,
      vehicleDeviceType: json['vehicle_device_type'] as String?,
      kAcntCode: json['k_acnt_code'] as String?,
      eAcntCode: json['e_acnt_code'] as String?,
      sAcntCode: json['s_acnt_code'] as String?,
      hsnSacCode: json['hsn_sac_code'] as String?,
      vendorId: json['vendorId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fleetProductId': fleetProductId,
      'userFriendlyId': userFriendlyId,
      'type': type,
      'name': name,
      'part': part,
      'service_type': serviceType,
      'price': price,
      'gst_perc': gstPerc,
      'product_desc': productDesc,
      'file_key': fileKey,
      'unit_measurement': unitMeasurement,
      'purchase_price': purchasePrice,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_tank_type': vehicleTankType,
      'vehicle_engine': vehicleEngine,
      'vehicle_device_type': vehicleDeviceType,
      'k_acnt_code': kAcntCode,
      'e_acnt_code': eAcntCode,
      's_acnt_code': sAcntCode,
      'hsn_sac_code': hsnSacCode,
      'vendorId': vendorId,
    };
  }

  /// Convert to KavachProduct for compatibility with existing UI
  KavachProduct toKavachProduct() {
    return KavachProduct(
      id: id,
      name: name,
      part: part ?? '',
      price: double.tryParse(price) ?? 0.0,
      gstPerc: double.tryParse(gstPerc) ?? 0.0,
      productDesc: productDesc ?? '',
      fileKey: fileKey ?? '',
      unitMeasurement: unitMeasurement ?? '',
      purchasePrice: double.tryParse(purchasePrice ?? '0') ?? 0.0,
      type: type ?? '',
    );
  }

  @override
  String toString() {
    return 'GpsProduct{id: $id, name: $name, price: $price, gstPerc: $gstPerc}';
  }
}

/// GPS Aadhaar Send OTP Response
class GpsAadhaarSendOtpResponse {
  final bool success;
  final String message;
  final String? requestId;

  const GpsAadhaarSendOtpResponse({
    required this.success,
    required this.message,
    this.requestId,
  });

  factory GpsAadhaarSendOtpResponse.fromJson(Map<String, dynamic> json) {
    return GpsAadhaarSendOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      requestId: json['request_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'request_id': requestId,
    };
  }

  @override
  String toString() {
    return 'GpsAadhaarSendOtpResponse{success: $success, message: $message, requestId: $requestId}';
  }
}

/// GPS Aadhaar Verify OTP Response
class GpsAadhaarVerifyOtpResponse {
  final bool success;
  final String message;
  final bool isVerified;

  const GpsAadhaarVerifyOtpResponse({
    required this.success,
    required this.message,
    required this.isVerified,
  });

  factory GpsAadhaarVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response structure
    final status = json['status'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    
    // Check if verification was successful based on status and data
    bool isVerified = false;
    if (status) {
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        final dataMessage = data['message'] as String? ?? '';
        isVerified = dataMessage.toLowerCase().contains('verified successfully');
      }
    }
    
    return GpsAadhaarVerifyOtpResponse(
      success: status,
      message: message,
      isVerified: isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'is_verified': isVerified,
    };
  }

  @override
  String toString() {
    return 'GpsAadhaarVerifyOtpResponse{success: $success, message: $message, isVerified: $isVerified}';
  }
}

/// GPS PAN Verification Response
class GpsPanVerificationResponse {
  final bool success;
  final String message;
  final bool isVerified;

  const GpsPanVerificationResponse({
    required this.success,
    required this.message,
    required this.isVerified,
  });

  factory GpsPanVerificationResponse.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response structure
    final status = json['status'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    
    // Check if verification was successful based on status and data
    bool isVerified = false;
    if (status) {
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        final dataMessage = data['message'] as String? ?? '';
        isVerified = dataMessage.toLowerCase().contains('verified successfully');
      }
    }
    
    return GpsPanVerificationResponse(
      success: status,
      message: message,
      isVerified: isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'is_verified': isVerified,
    };
  }

  @override
  String toString() {
    return 'GpsPanVerificationResponse{success: $success, message: $message, isVerified: $isVerified}';
  }
}

/// GPS Address List Response
class GpsAddressListResponse {
  final bool success;
  final String message;
  final GpsAddressListData? data;
  final int? statusCode;

  const GpsAddressListResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory GpsAddressListResponse.fromJson(Map<String, dynamic> json) {
    return GpsAddressListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? GpsAddressListData.fromJson(json['data']) : null,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'GpsAddressListResponse{success: $success, message: $message, data: $data, statusCode: $statusCode}';
  }
}

/// GPS Address List Data
class GpsAddressListData {
  final List<GpsAddress> rows;
  final GpsAddressListMeta meta;

  const GpsAddressListData({
    required this.rows,
    required this.meta,
  });

  factory GpsAddressListData.fromJson(Map<String, dynamic> json) {
    return GpsAddressListData(
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => GpsAddress.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: GpsAddressListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'rows': rows.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'GpsAddressListData{rows: $rows, meta: $meta}';
  }
}

/// GPS Address List Meta
class GpsAddressListMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const GpsAddressListMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory GpsAddressListMeta.fromJson(Map<String, dynamic> json) {
    return GpsAddressListMeta(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }

  @override
  String toString() {
    return 'GpsAddressListMeta{total: $total, page: $page, limit: $limit, totalPages: $totalPages}';
  }
}

/// GPS Address Model
class GpsAddress {
  final String id;
  final String addressName;
  final String fullAddress;
  final String? gstin;
  final String? addressType;
  final bool isDefault;

  const GpsAddress({
    required this.id,
    required this.addressName,
    required this.fullAddress,
    this.gstin,
    this.addressType,
    this.isDefault = false,
  });

  factory GpsAddress.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response format
    final id = json['preferedAddressId']?.toString() ?? json['id']?.toString() ?? '';
    final addressName = json['addrName'] ?? json['addressName'] ?? '';
    final addr = json['addr'] ?? json['addr1'] ?? '';
    final city = json['city'] ?? '';
    final state = json['state'] ?? '';
    final pincode = json['pincode'] ?? '';
    final gstin = json['gstIn'] ?? json['gstin'] as String?;
    final addrType = json['addrType']?.toString() ?? '';
    final isDefault = json['isDefault'] ?? false;
    
    // Construct full address from components
    final fullAddress = '$addr, $city, $state, India - $pincode';
    
    return GpsAddress(
      id: id,
      addressName: addressName,
      fullAddress: fullAddress,
      gstin: gstin,
      addressType: addrType,
      isDefault: isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'addressName': addressName,
      'fullAddress': fullAddress,
      'gstin': gstin,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }

  /// Convert to KavachAddressModel for compatibility with existing UI
  KavachAddressModel toKavachAddressModel() {
    return KavachAddressModel(
      id: int.tryParse(id) ?? 0,
      customerName: addressName,
      mobileNumber: '',
      customerId: 851,
      addressName: addressName,
      addr1: fullAddress,
      addr2: '',
      city: '',
      state: '',
      country: 'India',
      gstin: gstin,
      pincode: '',
      addrType: 1,
      status: 1,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'GpsAddress{id: $id, addressName: $addressName, fullAddress: $fullAddress}';
  }
}

/// GPS Add Address Response
class GpsAddAddressResponse {
  final bool success;
  final String message;
  final GpsAddress? data;
  final int? statusCode;

  const GpsAddAddressResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory GpsAddAddressResponse.fromJson(Map<String, dynamic> json) {
    // Handle case where API returns address data directly
    if (json.containsKey('preferedAddressId') || json.containsKey('customerId')) {
      // This is the address data returned directly from API
      return GpsAddAddressResponse(
        success: true,
        message: 'Address added successfully',
        data: GpsAddress.fromJson(json),
        statusCode: 200,
      );
    }
    
    // Handle case where API returns wrapped response
    if (json.containsKey('success')) {
      return GpsAddAddressResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? GpsAddress.fromJson(json['data']) : null,
        statusCode: json['statusCode'] as int?,
      );
    }
    
    // Fallback for unknown response format
    return GpsAddAddressResponse(
      success: true,
      message: 'Address added successfully',
      data: GpsAddress.fromJson(json),
      statusCode: 200,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'GpsAddAddressResponse{success: $success, message: $message, data: $data, statusCode: $statusCode}';
  }
} 