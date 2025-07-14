import 'dart:io';

class EnDhanKycApiRequest {
  final int? customerId;
  final String? aadhar;
  final String? pan;
  final String? addressProofFront;
  final String? addressProofBack;
  final String? identityProofFront;
  final String? identityProofBack;
  final String? panImage;

  const EnDhanKycApiRequest({
    this.customerId,
    this.aadhar,
    this.pan,
    this.addressProofFront,
    this.addressProofBack,
    this.identityProofFront,
    this.identityProofBack,
    this.panImage,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aadhar': aadhar,
      'pan': pan,
      'addressProofFront': addressProofFront,
      'addressProofBack': addressProofBack,
      'identityProofFront': identityProofFront,
      'identityProofBack': identityProofBack,
      'panImage': panImage
    };
  }

  @override
  String toString() {
    return 'EnDhanKycApiRequest{customerId: $customerId, aadhar: $aadhar, pan: $pan, addressProofFront: $addressProofFront, addressProofBack: $addressProofBack, identityProofFront: $identityProofFront, identityProofBack: $identityProofBack, panImage: $panImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnDhanKycApiRequest &&
        other.customerId == customerId &&
        other.aadhar == aadhar &&
        other.pan == pan &&
        other.addressProofFront == addressProofFront &&
        other.addressProofBack == addressProofBack &&
        other.identityProofFront == identityProofFront &&
        other.identityProofBack == identityProofBack &&
        other.panImage == panImage;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
        aadhar.hashCode ^
        pan.hashCode ^
        addressProofFront.hashCode ^
        addressProofBack.hashCode ^
        identityProofFront.hashCode ^
        identityProofBack.hashCode ^
        panImage.hashCode;
  }
}

/// Card Creation Request
class EnDhanCardCreationApiRequest {
  final int? customerId;
  final String? cardType;
  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? billingAddress;
  final String? pin;

  const EnDhanCardCreationApiRequest({
    this.customerId,
    this.cardType,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.billingAddress,
    this.pin,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customerId': customerId,
      'cardType': cardType,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'billingAddress': billingAddress,
      'pin': pin,
    };
  }

  @override
  String toString() {
    return 'EnDhanCardCreationApiRequest{customerId: $customerId, cardType: $cardType, cardHolderName: $cardHolderName, cardNumber: $cardNumber, expiryDate: $expiryDate, cvv: $cvv, billingAddress: $billingAddress, pin: $pin}';
  }
}

/// Customer Creation Request
class EnDhanCustomerCreationApiRequest {
  final String customerId; // Added customerId parameter
  final String customerName;
  final String title;
  final int zonalOffice;
  final int regionalOffice;
  final String communicationAddress1;
  final String communicationAddress2;
  final String communicationCityName;
  final String communicationPincode;
  final int communicationStateId;
  final int communicationDistrictId;
  final String communicationMobileNo;
  final String communicationEmailid;
  final String incomeTaxPan;
  final String? referralCode; // Added referral code parameter
  final List<EnDhanCardDetailRequest> objCardDetailsAl;

  const EnDhanCustomerCreationApiRequest({
    required this.customerId, // Added customerId parameter
    required this.customerName,
    required this.title,
    required this.zonalOffice,
    required this.regionalOffice,
    required this.communicationAddress1,
    required this.communicationAddress2,
    required this.communicationCityName,
    required this.communicationPincode,
    required this.communicationStateId,
    required this.communicationDistrictId,
    required this.communicationMobileNo,
    required this.communicationEmailid,
    required this.incomeTaxPan,
    this.referralCode, // Added referral code parameter
    required this.objCardDetailsAl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customerId': customerId, // Added customerId to JSON
      'CustomerName': customerName,
      'title': title,
      'ZonalOffice': zonalOffice,
      'RegionalOffice': regionalOffice,
      'CommunicationAddress1': communicationAddress1,
      'CommunicationAddress2': communicationAddress2,
      'CommunicationCityName': communicationCityName,
      'CommunicationPincode': communicationPincode,
      'CommunicationStateId': communicationStateId,
      'CommunicationDistrictId': communicationDistrictId,
      'CommunicationMobileNo': communicationMobileNo,
      'CommunicationEmailid': communicationEmailid,
      'IncomeTaxPan': incomeTaxPan,
      'referralCode': referralCode, // Added referral code to JSON
      'ObjCardDetailsAl': objCardDetailsAl.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'EnDhanCustomerCreationApiRequest{customerName: $customerName, zonalOffice: $zonalOffice, regionalOffice: $regionalOffice, communicationAddress1: $communicationAddress1, communicationAddress2: $communicationAddress2, communicationCityName: $communicationCityName, communicationPincode: $communicationPincode, communicationStateId: $communicationStateId, communicationDistrictId: $communicationDistrictId, communicationMobileNo: $communicationMobileNo, communicationEmailid: $communicationEmailid, incomeTaxPan: $incomeTaxPan, objCardDetailsAl: $objCardDetailsAl}';
  }
}

/// Card Detail Request
class EnDhanCardDetailRequest {
  final String vechileNo;
  final String? mobileNo;
  final String vehicleType;
  final String vinNumber;
  final String rcDocument;
  final String rcNumber;

  const EnDhanCardDetailRequest({
    required this.vechileNo,
    this.mobileNo,
    required this.vehicleType,
    required this.vinNumber,
    required this.rcDocument,
    required this.rcNumber,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'VechileNo': vechileNo,
      'VehicleType': vehicleType,
      'VinNumber': vinNumber,
      'RcDocument': rcDocument,
      'RcNumber': rcNumber,
      'MobileNo': mobileNo, // Always include MobileNo, even if null
    };
    
    return data;
  }

  @override
  String toString() {
    return 'EnDhanCardDetailRequest{vechileNo: $vechileNo, mobileNo: $mobileNo, vehicleType: $vehicleType, vinNumber: $vinNumber, rcDocument: $rcDocument}';
  }
}

/// KYC Multipart Upload Request
class EnDhanKycMultipartApiRequest {
  final String aadhar;
  final String pan;
  final File? addressProofFront;
  final File? addressProofBack;
  final File? identityProofFront;
  final File? identityProofBack;
  final File? panImage;

  const EnDhanKycMultipartApiRequest({
    required this.aadhar,
    required this.pan,
    this.addressProofFront,
    this.addressProofBack,
    this.identityProofFront,
    this.identityProofBack,
    this.panImage,
  });

  /// Get form fields (string data)
  Map<String, String> getFormFields() {
    return {
      'aadhar': aadhar,
      'pan': pan,
    };
  }

  /// Get files for multipart upload
  Map<String, File> getFiles() {
    final Map<String, File> files = {};
    
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
    if (panImage != null) {
      files['panImage'] = panImage!;
    }
    
    return files;
  }

  @override
  String toString() {
    return 'EnDhanKycMultipartApiRequest{aadhar: $aadhar, pan: $pan, addressProofFront: ${addressProofFront?.path}, addressProofBack: ${addressProofBack?.path}, identityProofFront: ${identityProofFront?.path}, identityProofBack: ${identityProofBack?.path}, panImage: ${panImage?.path}}';
  }
}

// ==================== Aadhaar Verification API Requests ====================

class AadhaarSendOtpRequest {
  final String aadhaar;
  final bool force;

  const AadhaarSendOtpRequest({
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

class AadhaarVerifyOtpRequest {
  final String requestId;
  final String otp;
  final String aadhaar;

  const AadhaarVerifyOtpRequest({
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

class PanVerificationRequest {
  final String pan;
  final bool force;

  const PanVerificationRequest({
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

// ==================== Vehicle Verification API Requests ====================

class VehicleVerificationRequest {
  final String vehicleNumber;
  final bool force;

  const VehicleVerificationRequest({
    required this.vehicleNumber,
    this.force = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicle_number': vehicleNumber,  // Use snake_case
      'force': force,
    };
  }
}


