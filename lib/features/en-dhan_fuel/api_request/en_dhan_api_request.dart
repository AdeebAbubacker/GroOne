import 'dart:io';

class EnDhanKycApiRequest {
  final String? aadhar;
  final String? pan;
  final bool isAadhar;
  final String? aadharDocLink;
  final String? panDocLink;
  final bool? isPan;
  final bool fromFleet;

  const EnDhanKycApiRequest({
    required this.aadhar,
    required this.isAadhar,
    this.pan,
    this.panDocLink,
    this.isPan,
    this.aadharDocLink,
    this.fromFleet = true,
  });

  Map<String, dynamic> toJson({bool includeFromFleet = true}) {
    final Map<String, dynamic> json = {
      'aadhar': aadhar,
      'isAadhar': isAadhar,
      'aadhar_doc_link': aadharDocLink,
    };

    if (includeFromFleet) {
      json['fromFleet'] = fromFleet;
    }

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
    return 'EnDhanKycApiRequest{aadhar: $aadhar, isAadhar: $isAadhar, aadharDocLink: $aadharDocLink, pan: $pan, panDocLink: $panDocLink, isPan: $isPan, fromFleet: $fromFleet}';
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
    final Map<String, dynamic> json = <String, dynamic>{
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
      'ObjCardDetailsAl': objCardDetailsAl.map((e) => e.toJson()).toList(),
    };

    // Only include referralCode if it's not null and not empty
    if (referralCode != null && referralCode!.isNotEmpty) {
      json['referralCode'] = referralCode;
    }

    return json;
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
      // 'RcNumber': rcNumber,
      // 'MobileNo': mobileNo, // Always include MobileNo, even if null
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
  final File? addressProofFront;
  final File? addressProofBack;
  final File? identityProofFront;
  final File? identityProofBack;

  const EnDhanKycMultipartApiRequest({
    this.addressProofFront,
    this.addressProofBack,
    this.identityProofFront,
    this.identityProofBack,
  });

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
    // PAN image is now handled as string URL, not as file

    return files;
  }

  @override
  String toString() {
    return 'EnDhanKycMultipartApiRequest{addressProofFront: ${addressProofFront?.path}, addressProofBack: ${addressProofBack?.path}, identityProofFront: ${identityProofFront?.path}, identityProofBack: ${identityProofBack?.path}}';
  }
}

// ==================== Aadhaar Verification API Requests ====================

class AadhaarSendOtpRequest {
  final String aadhaar;
  final bool force;

  const AadhaarSendOtpRequest({required this.aadhaar, this.force = true});

  Map<String, dynamic> toJson() {
    return {'aadhaar': aadhaar, 'force': force};
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
    return {'request_id': requestId, 'otp': otp, 'aadhaar': aadhaar};
  }
}

class PanVerificationRequest {
  final String panNumber;
  final String name;

  const PanVerificationRequest({required this.panNumber, required this.name});

  Map<String, dynamic> toJson() {
    return {'pan_number': panNumber, 'name': name};
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
      'vehicle_number': vehicleNumber, // Use snake_case
      'force': force,
    };
  }
}
