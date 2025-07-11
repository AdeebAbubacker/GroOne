import 'package:gro_one_app/data/model/serializable.dart';

class VerifyEmailOtpApiRequest extends Serializable<VerifyEmailOtpApiRequest>{
  VerifyEmailOtpApiRequest({
    required this.email,
    required this.otp,
    this.customerId,
  });

  final String? email;
  final String? otp;
  final dynamic customerId;

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

  @override
  Map<String, dynamic> toJson() => {
    "email": email ?? "",
    "otp": otp ?? "",
    "customerId": customerId ?? "",
  };

}
