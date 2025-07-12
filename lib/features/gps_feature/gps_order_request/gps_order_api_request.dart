import 'dart:io';

/// GPS Document Upload Request
class GpsDocumentUploadApiRequest {
  final String aadhar;
  final String? pan;
  final String? panImage;
  final String? addressProofFront;
  final String? addressProofBack;
  final String? identityProofFront;
  final String? identityProofBack;
  final String customerId;

  const GpsDocumentUploadApiRequest({
    required this.aadhar,
    this.pan,
    this.panImage,
    this.addressProofFront,
    this.addressProofBack,
    this.identityProofFront,
    this.identityProofBack,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aadhar': aadhar,
      'customerId': customerId,
      if (pan != null) 'pan': pan,
      if (panImage != null) 'panImage': panImage,
      if (addressProofFront != null) 'addressProofFront': addressProofFront,
      if (addressProofBack != null) 'addressProofBack': addressProofBack,
      if (identityProofFront != null) 'identityProofFront': identityProofFront,
      if (identityProofBack != null) 'identityProofBack': identityProofBack,
    };
  }

  @override
  String toString() {
    return 'GpsDocumentUploadApiRequest{aadhar: $aadhar, customerId: $customerId, pan: $pan, panImage: $panImage, addressProofFront: $addressProofFront, addressProofBack: $addressProofBack, identityProofFront: $identityProofFront, identityProofBack: $identityProofBack}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GpsDocumentUploadApiRequest &&
        other.aadhar == aadhar &&
        other.customerId == customerId &&
        other.pan == pan &&
        other.panImage == panImage &&
        other.addressProofFront == addressProofFront &&
        other.addressProofBack == addressProofBack &&
        other.identityProofFront == identityProofFront &&
        other.identityProofBack == identityProofBack;
  }

  @override
  int get hashCode {
    return aadhar.hashCode ^ customerId.hashCode ^ pan.hashCode ^ panImage.hashCode ^ addressProofFront.hashCode ^ addressProofBack.hashCode ^ identityProofFront.hashCode ^ identityProofBack.hashCode;
  }
}

/// GPS Document Upload Multipart Request
class GpsDocumentUploadMultipartApiRequest {
  final String aadhar;
  final String? pan;
  final File? panImage;
  final File? addressProofFront;
  final File? addressProofBack;
  final File? identityProofFront;
  final File? identityProofBack;
  final String customerId;

  const GpsDocumentUploadMultipartApiRequest({
    required this.aadhar,
    this.pan,
    this.panImage,
    this.addressProofFront,
    this.addressProofBack,
    this.identityProofFront,
    this.identityProofBack,
    required this.customerId,
  });

  /// Get form fields (string data)
  Map<String, String> getFormFields() {
    final Map<String, String> fields = {
      'aadhar': aadhar,
      'customerId': customerId,
    };
    
    if (pan != null && pan!.isNotEmpty) {
      fields['pan'] = pan!;
    }
    
    return fields;
  }

  /// Get files for multipart upload
  Map<String, File> getFiles() {
    final Map<String, File> files = {};
    
    if (panImage != null) {
      files['panImage'] = panImage!;
    }
    if (addressProofFront != null) {
      files['addressProofFront'] = addressProofFront!;
    }
    if (addressProofBack != null) {
      files['addressProofBack'] = addressProofBack!;
    }
    if (identityProofFront != null) {
      files['identityProofFront'] = identityProofFront!;
    }
    if (identityProofBack != null) {
      files['identityProofBack'] = identityProofBack!;
    }
    
    return files;
  }

  @override
  String toString() {
    return 'GpsDocumentUploadMultipartApiRequest{aadhar: $aadhar, pan: $pan, panImage: ${panImage?.path}, addressProofFront: ${addressProofFront?.path}, addressProofBack: ${addressProofBack?.path}, identityProofFront: ${identityProofFront?.path}, identityProofBack: ${identityProofBack?.path}}';
  }
}

/// GPS Product List Request
class GpsProductListRequest {
  final int fleetProductId;
  final int page;
  final int limit;

  const GpsProductListRequest({
    this.fleetProductId = 1,
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fleetProductId': fleetProductId,
      'page': page,
      'limit': limit,
    };
  }

  @override
  String toString() {
    return 'GpsProductListRequest{fleetProductId: $fleetProductId, page: $page, limit: $limit}';
  }
}

/// GPS Address List Request
class GpsAddressListRequest {
  final String customerId; // Changed from int to String for UUID
  final int limit;
  final int page;

  const GpsAddressListRequest({
    required this.customerId,
    this.limit = 10,
    this.page = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'limit': limit,
      'page': page,
    };
  }

  @override
  String toString() {
    return 'GpsAddressListRequest{customerId: $customerId, limit: $limit, page: $page}';
  }
}

// ==================== Aadhaar Verification API Requests ====================

class GpsAadhaarSendOtpRequest {
  final String aadhaar;
  final bool force;

  const GpsAadhaarSendOtpRequest({
    required this.aadhaar,
    this.force = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'aadhaar': aadhaar,
      'force': force,
    };
  }
}

class GpsAadhaarVerifyOtpRequest {
  final String requestId;
  final String otp;
  final String aadhaar;

  const GpsAadhaarVerifyOtpRequest({
    required this.requestId,
    required this.otp,
    required this.aadhaar,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'otp': otp,
      'aadhaar': aadhaar,
    };
  }
}

class GpsPanVerificationRequest {
  final String pan;
  final bool force;

  const GpsPanVerificationRequest({
    required this.pan,
    this.force = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'pan': pan,
      'force': force,
    };
  }
}

/// GPS Add Address Request
class GpsAddAddressRequest {
  final String customerId;
  final String addrName;
  final String addr;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final String addrType; // "1" for shipping, "2" for billing
  final String country;
  final String? gstIn;

  const GpsAddAddressRequest({
    required this.customerId,
    required this.addrName,
    required this.addr,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
    required this.addrType,
    required this.country,
    this.gstIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'addrName': addrName,
      'addr': addr,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isDefault': isDefault,
      'addrType': addrType,
      'country': country,
      if (gstIn != null && gstIn!.isNotEmpty) 'gstIn': gstIn,
    };
  }

  @override
  String toString() {
    return 'GpsAddAddressRequest{customerId: $customerId, addrName: $addrName, addr: $addr, city: $city, state: $state, pincode: $pincode, isDefault: $isDefault, addrType: $addrType, country: $country, gstIn: $gstIn}';
  }
}

/// GPS KYC Check Request
class GpsKycCheckRequest {
  const GpsKycCheckRequest();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }

  @override
  String toString() {
    return 'GpsKycCheckRequest{}';
  }
}

/// GPS KYC Check Response Model
class GpsKycCheckModel {
  final bool success;
  final String message;
  final dynamic data;
  final bool hasKycDocuments;
  final Map<String, dynamic>? kycData;

  const GpsKycCheckModel({
    required this.success,
    required this.message,
    required this.data,
    required this.hasKycDocuments,
    this.kycData,
  });

  factory GpsKycCheckModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    bool hasDocuments = false;
    Map<String, dynamic>? kycData;

    if (data != null && data is Map<String, dynamic>) {
      // Check if document exists in the response (singular 'document', not 'documents')
      hasDocuments = data.containsKey('document') && 
                    data['document'] != null;
      
      print('🔍 GpsKycCheckModel.fromJson:');
      print('  - data keys: ${data.keys}');
      print('  - has document key: ${data.containsKey('document')}');
      print('  - document value: ${data['document']}');
      print('  - hasDocuments: $hasDocuments');
      
      kycData = data;
    }

    return GpsKycCheckModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: data,
      hasKycDocuments: hasDocuments,
      kycData: kycData,
    );
  }

  @override
  String toString() {
    return 'GpsKycCheckModel{success: $success, message: $message, data: $data, hasKycDocuments: $hasKycDocuments, kycData: $kycData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GpsKycCheckModel &&
        other.success == success &&
        other.message == message &&
        other.data == data &&
        other.hasKycDocuments == hasKycDocuments &&
        other.kycData == kycData;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        message.hashCode ^
        data.hashCode ^
        hasKycDocuments.hashCode ^
        kycData.hashCode;
  }
}

// ==================== GPS Order Creation API Requests ====================

/// GPS Order Vehicle Model
class GpsOrderVehicle {
  final String vehicleNumber;

  GpsOrderVehicle({required this.vehicleNumber});

  Map<String, dynamic> toJson() => {
    "vehicleNumber": vehicleNumber,
    "deviceUniqueNumber": "DEV123456789"
  };
}

/// GPS Order Item Model
class GpsOrderItem {
  final int productServiceId;
  final int noOfProducts;
  final double unitPrice;
  final double totalPrice;
  final int stockAvailable;
  final List<GpsOrderVehicle> vehicleNumbers;

  GpsOrderItem({
    required this.productServiceId,
    required this.noOfProducts,
    required this.unitPrice,
    required this.totalPrice,
    required this.stockAvailable,
    required this.vehicleNumbers,
  });

  Map<String, dynamic> toJson() => {
    "productServiceId": productServiceId,
    "noOfProducts": noOfProducts,
    "unitPrice": unitPrice,
    "totalPrice": totalPrice,
    "stockAvailable": stockAvailable,
    "vehicle_number": vehicleNumbers.map((v) => v.toJson()).toList(),
  };
}

/// GPS Customer Info Model
class GpsCustomerInfo {
  final String companyName;
  final String contactNumber;
  final String blueMembershipId;

  GpsCustomerInfo({
    required this.companyName,
    required this.contactNumber,
    required this.blueMembershipId,
  });

  Map<String, dynamic> toJson() => {
    "CompanyName": companyName,
    "contactNumber": contactNumber,
    "BlueMembershipID": blueMembershipId,
  };
}

/// GPS Address Model for Order Creation
class GpsOrderAddress {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String gstId;

  GpsOrderAddress({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.gstId,
  });

  Map<String, dynamic> toJson() => {
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "state": state,
    "postalCode": postalCode,
    "country": country,
    "gstId": gstId,
  };
}

/// GPS Order Creation Request Model
class GpsOrderRequest {
  final String orderSource;
  final bool isOrderPaid;
  final String customerId;
  final int createdEmpUserId;
  final String orderReferencedBy;
  final double totalPrice;
  final int categoryId;
  final String shippingPersonIncharge;
  final String shippingPersonContactNo;
  final GpsCustomerInfo customerInfo;
  final GpsOrderAddress billingAddress;
  final GpsOrderAddress shippingAddress;
  final List<GpsOrderItem> orders;

  GpsOrderRequest({
    required this.orderSource,
    required this.isOrderPaid,
    required this.customerId,
    required this.createdEmpUserId,
    required this.orderReferencedBy,
    required this.totalPrice,
    required this.categoryId,
    required this.shippingPersonIncharge,
    required this.shippingPersonContactNo,
    required this.customerInfo,
    required this.billingAddress,
    required this.shippingAddress,
    required this.orders,
  });

  Map<String, dynamic> toJson() => {
    "orderSource": orderSource,
    "isOrderPaid": isOrderPaid,
    "customerId": customerId,
    "createdEmpUserId": createdEmpUserId,
    "orderReferencedBy": orderReferencedBy,
    "totalPrice": totalPrice,
    "categoryId": categoryId,
    "shippingPersonIncharge": shippingPersonIncharge,
    "shippingPersonContactNo": shippingPersonContactNo,
    "customerInfo": customerInfo.toJson(),
    "billingAddress": billingAddress.toJson(),
    "shippingAddress": shippingAddress.toJson(),
    "orders": orders.map((o) => o.toJson()).toList(),
  };

  @override
  String toString() {
    return 'GpsOrderRequest{orderSource: $orderSource, isOrderPaid: $isOrderPaid, customerId: $customerId, createdEmpUserId: $createdEmpUserId, orderReferencedBy: $orderReferencedBy, totalPrice: $totalPrice, categoryId: $categoryId, shippingPersonIncharge: $shippingPersonIncharge, shippingPersonContactNo: $shippingPersonContactNo, customerInfo: $customerInfo, billingAddress: $billingAddress, shippingAddress: $shippingAddress, orders: $orders}';
  }
}

// ==================== GPS Order Summary API ====================

/// GPS Order Summary Item Model
class GpsOrderSummaryItem {
  final String productName;
  final String partName;
  final String userFriendlyId;
  final String hsnCode;
  final String gstPercentage;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalGst;
  final double totalAmount;

  GpsOrderSummaryItem({
    required this.productName,
    required this.partName,
    required this.userFriendlyId,
    required this.hsnCode,
    required this.gstPercentage,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalGst,
    required this.totalAmount,
  });

  factory GpsOrderSummaryItem.fromJson(Map<String, dynamic> json) {
    return GpsOrderSummaryItem(
      productName: json['productName'] ?? '',
      partName: json['partName'] ?? '',
      userFriendlyId: json['userFriendlyId'] ?? '',
      hsnCode: json['hsnCode'] ?? '',
      gstPercentage: json['gstPercentage'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      cgst: (json['cgst'] ?? 0.0).toDouble(),
      sgst: (json['sgst'] ?? 0.0).toDouble(),
      igst: (json['igst'] ?? 0.0).toDouble(),
      totalGst: (json['totalGst'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'partName': partName,
    'userFriendlyId': userFriendlyId,
    'hsnCode': hsnCode,
    'gstPercentage': gstPercentage,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'discount': discount,
    'cgst': cgst,
    'sgst': sgst,
    'igst': igst,
    'totalGst': totalGst,
    'totalAmount': totalAmount,
  };
}

/// GPS Order Summary Data Model
class GpsOrderSummaryData {
  final List<GpsOrderSummaryItem> summary;
  final double grandTotal;

  GpsOrderSummaryData({
    required this.summary,
    required this.grandTotal,
  });

  factory GpsOrderSummaryData.fromJson(Map<String, dynamic> json) {
    final summaryList = (json['summary'] as List<dynamic>?)
        ?.map((item) => GpsOrderSummaryItem.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];
    
    return GpsOrderSummaryData(
      summary: summaryList,
      grandTotal: (json['grandTotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary.map((item) => item.toJson()).toList(),
    'grandTotal': grandTotal,
  };
}

/// GPS Order Summary Response Model
class GpsOrderSummaryResponse {
  final bool success;
  final String message;
  final GpsOrderSummaryData data;
  final int statusCode;

  GpsOrderSummaryResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory GpsOrderSummaryResponse.fromJson(Map<String, dynamic> json) {
    return GpsOrderSummaryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: GpsOrderSummaryData.fromJson(json['data'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
    'statusCode': statusCode,
  };
}

/// GPS Order Summary Request Model
class GpsOrderSummaryRequest {
  final List<GpsOrderSummaryRequestItem> products;

  GpsOrderSummaryRequest({
    required this.products,
  });

  Map<String, dynamic> toJson() => {
    'products': products.map((item) => item.toJson()).toList(),
  };
}

/// GPS Order Summary Request Item Model
class GpsOrderSummaryRequestItem {
  final int productId;
  final int quantity;
  final double discount;
  final String state;
  final String gstId;

  GpsOrderSummaryRequestItem({
    required this.productId,
    required this.quantity,
    required this.discount,
    required this.state,
    required this.gstId,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'discount': discount,
    'state': state,
    'gstId': gstId,
  };
}
