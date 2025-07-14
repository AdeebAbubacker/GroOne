import 'package:gro_one_app/data/model/serializable.dart';


class CreateOrderIdRequest extends Serializable<CreateOrderIdRequest> {
  final int amount;
  final String type;
  final String action;

  CreateOrderIdRequest({
    required this.amount,
    required this.type,
    required this.action,
  });

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': type,
        'action': action,
      };
}
