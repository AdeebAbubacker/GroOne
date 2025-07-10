import 'dart:io';

/// GPS Document Upload Request
class GpsDocumentUploadApiRequest {
  final String aadhar;
  final String? pan;
  final String? panImage;

  const GpsDocumentUploadApiRequest({
    required this.aadhar,
    this.pan,
    this.panImage,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aadhar': aadhar,
      if (pan != null) 'pan': pan,
      if (panImage != null) 'panImage': panImage,
    };
  }

  @override
  String toString() {
    return 'GpsDocumentUploadApiRequest{aadhar: $aadhar, pan: $pan, panImage: $panImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GpsDocumentUploadApiRequest &&
        other.aadhar == aadhar &&
        other.pan == pan &&
        other.panImage == panImage;
  }

  @override
  int get hashCode {
    return aadhar.hashCode ^ pan.hashCode ^ panImage.hashCode;
  }
}

/// GPS Document Upload Multipart Request
class GpsDocumentUploadMultipartApiRequest {
  final String aadhar;
  final String? pan;
  final File? panImage;

  const GpsDocumentUploadMultipartApiRequest({
    required this.aadhar,
    this.pan,
    this.panImage,
  });

  /// Get form fields (string data)
  Map<String, String> getFormFields() {
    final Map<String, String> fields = {
      'aadhar': aadhar,
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
    
    return files;
  }

  @override
  String toString() {
    return 'GpsDocumentUploadMultipartApiRequest{aadhar: $aadhar, pan: $pan, panImage: ${panImage?.path}}';
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
