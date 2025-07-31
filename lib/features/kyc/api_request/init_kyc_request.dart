class KycInitRequest {
  final String? aadharNumber;
  final List<String>? docs;
  final String? purpose;
  final String? responseUrl;
  final String? redirectUrl;
  final String? nameToMatch;
  final int? expiryInMinutes;
  final bool? pinless;
  final String? redirectMethod;

  KycInitRequest({
    this.aadharNumber,
    this.docs,
    this.purpose,
    this.responseUrl,
    this.redirectUrl,
    this.nameToMatch,
    this.expiryInMinutes,
    this.pinless,
    this.redirectMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'aadhar_number': aadharNumber,
      "docs": ["ADHAR"],
      'purpose': "KYC",
      'response_url': "https://groone-uat.letsgro.co/aadhar/api/v1/digilocker/webhook",
      'redirect_url': "https://gro-devadmin.letsgro.co/",
      'name_to_match': "",
      'expiry_in_minutes': 32,
      'pinless': true,
      'redirect_method': "GET",
    };
  }
}
