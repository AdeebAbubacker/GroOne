import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';

abstract class KavachOrderEvent {}

class KavachSubmitOrder extends KavachOrderEvent {
  final KavachOrderRequest request;

  KavachSubmitOrder(this.request);
}
