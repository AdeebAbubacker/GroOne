import 'package:gro_one_app/data/model/serializable.dart';

class VerifyEmailOtpApiRequest extends Serializable<VerifyEmailOtpApiRequest>{
  VerifyEmailOtpApiRequest({
    required this.otp,
    this.customerId,
  });

  final int? otp;
  final dynamic customerId;

  VerifyEmailOtpApiRequest copyWith({
    int? otp,
    num? customerId,
  }) {
    return VerifyEmailOtpApiRequest(
      otp: otp ?? this.otp,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "otp": otp ?? "",
    "customerId": customerId ?? "",
  };

}
