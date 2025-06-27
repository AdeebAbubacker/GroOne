
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
      'customerId': customerId,
      'aadhar': aadhar,
      'pan': pan,
      'addressProofFront': addressProofFront,
      'addressProofBack': addressProofBack,
      'identityProofFront': identityProofFront,
      'identityProofBack': identityProofBack,
      'panImage': panImage,
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


