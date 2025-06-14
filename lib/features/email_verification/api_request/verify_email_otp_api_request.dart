class VerifyEmailOtpApiRequest {
  VerifyEmailOtpApiRequest({
    required this.email,
    required this.otp,
    this.customerId,
  });

  final String? email;
  final String? otp;
  final num? customerId;

  VerifyEmailOtpApiRequest copyWith({
    String? email,
    String? otp,
    num? customerId,
  }) {
    return VerifyEmailOtpApiRequest(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      customerId: customerId ?? this.customerId,
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email ?? "",
    "otp": otp ?? "",
    "customerId": customerId ?? "",
  };

}
