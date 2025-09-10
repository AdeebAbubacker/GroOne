import 'dart:io';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../models/gps_vehicle_models.dart';
import '../models/gps_truck_length_model.dart';
import '../models/gps_commodity_model.dart';

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
    return aadhar.hashCode ^
        customerId.hashCode ^
        pan.hashCode ^
        panImage.hashCode ^
        addressProofFront.hashCode ^
        addressProofBack.hashCode ^
        identityProofFront.hashCode ^
        identityProofBack.hashCode;
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
    return <String, dynamic>{'limit': limit, 'page': page};
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

  const GpsAadhaarSendOtpRequest({required this.aadhaar, this.force = true});

  Map<String, dynamic> toJson() {
    return {'aadhaar': aadhaar, 'force': force};
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
    return {'request_id': requestId, 'otp': otp, 'aadhaar': aadhaar};
  }
}

class GpsPanVerificationRequest {
  final String panNumber;
  final String name;

  const GpsPanVerificationRequest({
    required this.panNumber,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'pan_number': panNumber, 'name': name};
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
      hasDocuments = data.containsKey('document') && data['document'] != null;

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

/// New GPS KYC Upload Request Model (for the new API)
class GpsKycUploadRequest {
  final String aadhar;
  final bool isAadhar;
  final String? aadharDocLink;
  final String? pan;
  final String? panDocLink;
  final bool? isPan;
  final bool fromFleet;

  const GpsKycUploadRequest({
    required this.aadhar,
    required this.isAadhar,
    this.pan,
    this.panDocLink,
    this.isPan,
    this.aadharDocLink,
    this.fromFleet = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'aadhar': aadhar,
      'isAadhar': isAadhar,
      'aadhar_doc_link': aadharDocLink,
      'fromFleet': fromFleet,
    };

    // Only include PAN fields if PAN is provided
    if (pan != null && pan!.isNotEmpty) {
      json['pan'] = pan;
      json['isPan'] = isPan ?? true;
      if (panDocLink != null && panDocLink!.isNotEmpty) {
        json['panDocLink'] = panDocLink;
      }
    }

    return json;
  }

  @override
  String toString() {
    return 'GpsKycUploadRequest{aadhar: $aadhar, isAadhar: $isAadhar, aadharDocLink: $aadharDocLink, pan: $pan, panDocLink: $panDocLink, isPan: $isPan, fromFleet: $fromFleet}';
  }
}

/// New GPS KYC Check Response Model (for the new API)
class GpsKycCheckResponseModel {
  final String customerId;
  final GpsKycDocuments? documents;
  final int isKyc;

  const GpsKycCheckResponseModel({
    required this.customerId,
    this.documents,
    required this.isKyc,
  });

  factory GpsKycCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return GpsKycCheckResponseModel(
      customerId: json['customerId'] ?? '',
      documents:
          json['documents'] != null
              ? GpsKycDocuments.fromJson(json['documents'])
              : null,
      isKyc: json['isKyc'] ?? 0,
    );
  }

  /// Check if KYC documents exist
  bool get hasKycDocuments {
    // Check if documents exist AND Aadhaar has a proper number
    // The isKyc flag might not always be reliable, so we focus on actual document existence
    // return documents != null &&
    //        documents!.aadhar != null &&
    //        documents!.aadhar!.isNotEmpty &&
    //        documents!.isAadhar == true;

    // As per change request
    return documents != null &&
        documents!.panDocLink != null &&
        documents!.panDocLink!.isNotEmpty == true;
  }

  @override
  String toString() {
    return 'GpsKycCheckResponseModel{customerId: $customerId, documents: $documents, isKyc: $isKyc}';
  }
}

/// GPS KYC Documents Model
class GpsKycDocuments {
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

  const GpsKycDocuments({
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
  });

  factory GpsKycDocuments.fromJson(Map<String, dynamic> json) {
    return GpsKycDocuments(
      aadhar: json['aadhar'],
      isAadhar: json['isAadhar'],
      pan: json['pan'],
      panDocLink: json['panDocLink'],
      isPan: json['isPan'],
      gstin: json['gstin'],
      gstinDocLink: json['gstinDocLink'],
      isGstin: json['isGstin'],
      tan: json['tan'],
      tanDocLink: json['tanDocLink'],
      isTan: json['isTan'],
      chequeDocLink: json['chequeDocLink'],
      tdsDocLink: json['tdsDocLink'],
    );
  }

  @override
  String toString() {
    return 'GpsKycDocuments{aadhar: $aadhar, isAadhar: $isAadhar, pan: $pan, panDocLink: $panDocLink, isPan: $isPan, gstin: $gstin, gstinDocLink: $gstinDocLink, isGstin: $isGstin, tan: $tan, tanDocLink: $tanDocLink, isTan: $isTan, chequeDocLink: $chequeDocLink, tdsDocLink: $tdsDocLink}';
  }
}

/// New GPS KYC Upload Response Model
class GpsKycUploadResponseModel {
  final String message;

  const GpsKycUploadResponseModel({required this.message});

  factory GpsKycUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return GpsKycUploadResponseModel(message: json['message'] ?? '');
  }

  @override
  String toString() {
    return 'GpsKycUploadResponseModel{message: $message}';
  }
}

// ==================== GPS Order Creation API Requests ====================

/// GPS Order Vehicle Model
class GpsOrderVehicle {
  final String vehicleNumber;

  GpsOrderVehicle({required this.vehicleNumber});

  Map<String, dynamic> toJson() => {"vehicleNumber": vehicleNumber};
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
  final String mobileNumber;
  final String email;

  GpsCustomerInfo({
    required this.companyName,
    required this.contactNumber,
    required this.blueMembershipId,
    required this.mobileNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    "CompanyName": companyName,
    "contactNumber": contactNumber,
    "BlueMembershipID": blueMembershipId,
    "mobileNumber": mobileNumber,
    "email": email,
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
  String? paymentRequestId;
  final int customerSeriesId;
  final bool isOrderPaid;
  final String customerId;
  final int createdEmpUserId;
  final String? createdEmpId;
  final String orderReferencedBy;
  final double totalPrice;
  final int categoryId;
  final int orderTypeId; // Added missing field
  final int teamId; // Added teamId field
  final String shippingPersonIncharge;
  final String shippingPersonContactNo;
  final GpsCustomerInfo customerInfo;
  final GpsOrderAddress billingAddress;
  final GpsOrderAddress shippingAddress;
  final List<GpsOrderItem> orders;

  GpsOrderRequest({
    required this.orderSource,
    required this.customerSeriesId,
    this.paymentRequestId,
    required this.isOrderPaid,
    required this.customerId,
    required this.createdEmpUserId,
    this.createdEmpId,
    required this.orderReferencedBy,
    required this.totalPrice,
    required this.categoryId,
    required this.orderTypeId, // Added to constructor
    required this.teamId, // Added to constructor
    required this.shippingPersonIncharge,
    required this.shippingPersonContactNo,
    required this.customerInfo,
    required this.billingAddress,
    required this.shippingAddress,
    required this.orders,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "orderSource": orderSource,
      "customerSeriesId": customerSeriesId,
      "isOrderPaid": isOrderPaid,
      "customerId": customerId,
      "createdEmpUserId": createdEmpUserId,
      "orderReferencedBy": orderReferencedBy,
      "totalPrice": totalPrice,
      "categoryId": categoryId,
      "orderTypeId": orderTypeId, // Added to JSON
      "teamId": teamId, // Added to JSON
      "shippingPersonIncharge": shippingPersonIncharge,
      "shippingPersonContactNo": shippingPersonContactNo,
      "customerInfo": customerInfo.toJson(),
      "billingAddress": billingAddress.toJson(),
      "shippingAddress": shippingAddress.toJson(),
      "orders": orders.map((o) => o.toJson()).toList(),
    };

    // Add createdEmpId only if it's not null
    if (createdEmpId != null) {
      json["createdEmpId"] = createdEmpId!;
    }

    if (paymentRequestId != null) {
      json["paymentUid"] = paymentRequestId ?? '';
    }

    return json;
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

  GpsOrderSummaryData({required this.summary, required this.grandTotal});

  factory GpsOrderSummaryData.fromJson(Map<String, dynamic> json) {
    final summaryList =
        (json['summary'] as List<dynamic>?)
            ?.map(
              (item) =>
                  GpsOrderSummaryItem.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [];

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

  GpsOrderSummaryRequest({required this.products});

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

class GpsOrderApiRequest {
  final ApiService _apiService;

  GpsOrderApiRequest(this._apiService);

  /// Get list of vehicles for a customer
  Future<Result<GpsVehicleListResponse>> getVehicles({
    required String customerId,
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final result = await _apiService.get(
        '${ApiUrls.baseUrl}/customer/api/v1/vehicle/$customerId?limit=$limit&page=$page',
      );

      if (result is Success) {
        // Handle direct response format (no success/status wrapper)
        if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // Check if it has the expected fields for vehicle list response
          if (response.containsKey('data') && response.containsKey('total')) {
            final vehicleResponse = GpsVehicleListResponse.fromJson(response);
            return Success(vehicleResponse);
          } else {
            return Error(
              ErrorWithMessage(
                message: 'Invalid response format - missing required fields',
              ),
            );
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Add a new vehicle
  Future<Result<GpsAddVehicleResponse>> addVehicle({
    required GpsAddVehicleRequest request,
  }) async {
    try {
      final result = await _apiService.post(
        '${ApiUrls.baseUrl}/customer/api/v1/vehicle/add',
        body: request.toJson(),
      );

      if (result is Success) {
        // Handle direct response format (vehicle data directly)
        if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // Check if it has vehicle fields
          if (response.containsKey('vehicleId') ||
              response.containsKey('truckNo')) {
            // Create a success response wrapper
            final successResponse = GpsAddVehicleResponse(
              success: true,
              message: 'Vehicle added successfully',
              data: GpsAddVehicleResponseData.fromJson(response),
            );
            return Success(successResponse);
          } else {
            return Error(
              ErrorWithMessage(
                message: 'Invalid response format - missing vehicle data',
              ),
            );
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Upload document (RC book)
  Future<Result<GpsDocumentUploadResponse>> uploadDocument({
    required File file,
    required String userId,
  }) async {
    try {
      final result = await _apiService.multipart(
        'https://gro-devapi.letsgro.co/document/api/v1/upload',
        file,
        fields: {
          'userId': userId,
          'fileType': 'license',
          'documentType': 'rc_book',
        },
        pathName: 'file',
      );

      if (result is Success) {
        // Handle direct response format
        if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // Check if it has the expected fields
          if (response.containsKey('url') && response.containsKey('filePath')) {
            return Success(GpsDocumentUploadResponse.fromJson(response));
          } else {
            return Error(
              ErrorWithMessage(
                message: 'Invalid response format - missing required fields',
              ),
            );
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Fetch truck types
  Future<Result<List<String>>> fetchTruckTypes() async {
    try {
      final result = await _apiService.get(ApiUrls.kavachTruckType);

      if (result is Success) {
        // Handle direct array response
        if (result.value is List) {
          final truckTypes = (result.value as List).cast<String>();
          return Success(truckTypes);
        }
        // Handle JSON object response
        else if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // If it has success field, use getResponseStatus
          if (response.containsKey('success') ||
              response.containsKey('status')) {
            return await _apiService.getResponseStatus(
              result.value,
              (data) => (data['data'] as List).cast<String>(),
            );
          } else {
            // Direct data access if no success/status field
            final data = response['data'] as List?;
            if (data != null) {
              final truckTypes = data.cast<String>();
              return Success(truckTypes);
            } else {
              return Error(
                ErrorWithMessage(message: 'No data found in response'),
              );
            }
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Fetch truck lengths for a specific type
  Future<Result<List<GpsTruckLengthModel>>> fetchTruckLengths(
    String type,
  ) async {
    try {
      final result = await _apiService.get(
        '${ApiUrls.kavachTruckSubType}/$type',
      );

      if (result is Success) {
        // Handle direct array response
        if (result.value is List) {
          final truckLengths =
              (result.value as List)
                  .map((e) => GpsTruckLengthModel.fromJson(e))
                  .toList();
          return Success(truckLengths);
        }
        // Handle JSON object response
        else if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // If it has success field, use getResponseStatus
          if (response.containsKey('success') ||
              response.containsKey('status')) {
            return await _apiService.getResponseStatus(
              result.value,
              (data) =>
                  (data['data'] as List)
                      .map((e) => GpsTruckLengthModel.fromJson(e))
                      .toList(),
            );
          } else {
            // Direct data access if no success/status field
            final data = response['data'] as List?;
            if (data != null) {
              final truckLengths =
                  data.map((e) => GpsTruckLengthModel.fromJson(e)).toList();
              return Success(truckLengths);
            } else {
              return Error(
                ErrorWithMessage(message: 'No data found in response'),
              );
            }
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Fetch commodities
  Future<Result<List<GpsCommodityModel>>> fetchCommodities() async {
    try {
      final result = await _apiService.get(ApiUrls.kavachFetchCommodities);

      if (result is Success) {
        // Handle direct array response
        if (result.value is List) {
          final commodities =
              (result.value as List)
                  .map((e) => GpsCommodityModel.fromJson(e))
                  .toList();
          return Success(commodities);
        }
        // Handle JSON object response
        else if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // If it has success field, use getResponseStatus
          if (response.containsKey('success') ||
              response.containsKey('status')) {
            return await _apiService.getResponseStatus(
              result.value,
              (data) =>
                  (data['data'] as List)
                      .map((e) => GpsCommodityModel.fromJson(e))
                      .toList(),
            );
          } else {
            // Direct data access if no success/status field
            final data = response['data'] as List?;
            if (data != null) {
              final commodities =
                  data.map((e) => GpsCommodityModel.fromJson(e)).toList();
              return Success(commodities);
            } else {
              return Error(
                ErrorWithMessage(message: 'No data found in response'),
              );
            }
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Verify vehicle
  Future<Result<bool>> verifyVehicle(String vehicleNumber) async {
    try {
      // Custom headers for the new vehicle verification API
      final customHeaders = {
        'accept': 'application/json',
        'X-API-Key': '5f522b06263423e4cab5eb45d27f2be4',
        'X-Application-UDID': '52e3dcc8-52ef-4f52-8756-3a06996757cd',
        'Content-Type': 'application/json',
      };

      final result = await _apiService.post(
        'https://groone-uat.letsgro.co/vehicle_number/api/v1/send_vehicle_number',
        body: {'vehicle_number': vehicleNumber},
        customHeaders: customHeaders,
      );

      if (result is Success) {
        // Handle response format with status field
        if (result.value is Map<String, dynamic>) {
          final response = result.value as Map<String, dynamic>;

          // Check if it has success field
          if (response.containsKey('success')) {
            final isVerified = response['success'] == true;
            return Success(isVerified);
          } else {
            return Error(
              ErrorWithMessage(
                message: 'Invalid response format - missing success field',
              ),
            );
          }
        } else {
          return Error(ErrorWithMessage(message: 'Invalid response format'));
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }
}
