import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';

abstract class KavachOrderState {}

class KavachOrderInitial extends KavachOrderState {}

class KavachOrderSubmitting extends KavachOrderState {}

class KavachOrderSuccess extends KavachOrderState {
  final String? orderId;
  
  KavachOrderSuccess({this.orderId});
}

class KavachOrderFailure extends KavachOrderState {
  final String message;

  KavachOrderFailure(this.message);
}

class KavachPaymentInitial extends KavachOrderState {}

class KavachPaymentInitiating extends KavachOrderState {}

class KavachPaymentSuccess extends KavachOrderState {
  final OrderAddedSuccess paymentResponse;
  
  KavachPaymentSuccess(this.paymentResponse);
}

class KavachPaymentFailure extends KavachOrderState {
  final String message;

  KavachPaymentFailure(this.message);
}

class KavachPaymentStatusChecking extends KavachOrderState {}
class KavachPaymentStatusSuccess extends KavachOrderState {}
class KavachPaymentStatusFailure extends KavachOrderState {
  final String message;
  KavachPaymentStatusFailure(this.message);
}