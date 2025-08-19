import 'package:gro_one_app/data/model/serializable.dart';

class KavachInitiatePaymentRequest
    extends Serializable<KavachInitiatePaymentRequest> {
  final String orderId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final String customerMobile;
  final String customerCity;
  final String merchantReferenceNo;
  final String customerId;

  KavachInitiatePaymentRequest({
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.customerMobile,
    required this.customerCity,
    required this.merchantReferenceNo,
    required this.customerId,
  });

  @override
  Map<String, dynamic> toJson() => {
    "amount": amount,
    "customer_name": customerName,
    "customer_email_id": customerEmail,
    "customer_mobile_no": customerMobile,
    "customer_city": customerCity,
    "merchant_reference_no1": customerId,
    "merchant_reference_no2": orderId,
    "merchant_reference_no3": merchantReferenceNo,
  };
}

//{
//   "merchant_reference_no": "fleet",
//   "merchant_reference_no1": "680531ea-2d42-4faa-b59f-67cd51854a15",
//   "merchant_reference_no2": "680531ea-2d42-4faa-b59f-67cd51854a15"
// }
