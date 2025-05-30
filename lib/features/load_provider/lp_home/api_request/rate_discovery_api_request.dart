import 'package:gro_one_app/data/model/serializable.dart';

class RateDiscoveryApiRequest extends Serializable<RateDiscoveryApiRequest>{
  final String? pickup;
  final String? drop;
  RateDiscoveryApiRequest({required this.pickup,required this.drop});

  @override
  Map<String, dynamic> toJson() {
    return {
      "pickup": pickup ?? "",
      "drop": drop ?? "",
    };
  }

}