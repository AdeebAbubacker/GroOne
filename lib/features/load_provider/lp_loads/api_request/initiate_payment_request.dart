import 'package:gro_one_app/data/model/serializable.dart';

class InitiatePaymentRequest extends Serializable<InitiatePaymentRequest> {
  final String orderId;
  final int amount;
  final String customerName;
  final String customerEmail;
  final String customerMobile;
  final String customerCity;

  InitiatePaymentRequest({
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.customerMobile,
    required this.customerCity,
  });

  @override
  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "amount": amount,
        "customer_name": customerName,
        "customer_email_id": customerEmail,
        "customer_mobile_no": customerMobile,
        "customer_city": customerCity,
      };
}
