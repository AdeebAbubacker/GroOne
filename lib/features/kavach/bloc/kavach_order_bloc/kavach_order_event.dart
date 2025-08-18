import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';

abstract class KavachOrderEvent {}

class KavachSubmitOrder extends KavachOrderEvent {
  final KavachOrderRequest request;

  KavachSubmitOrder(this.request);
}

class KavachInitiatePayment extends KavachOrderEvent {
  final KavachInitiatePaymentRequest request;

  KavachInitiatePayment(this.request);
}

class CheckFleetPaymentStatus extends KavachOrderEvent {
  final String paymentRequestId;
  CheckFleetPaymentStatus(this.paymentRequestId);
}
