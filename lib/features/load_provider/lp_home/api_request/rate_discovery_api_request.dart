import 'package:gro_one_app/data/model/serializable.dart';

class RateDiscoveryApiRequest extends Serializable<RateDiscoveryApiRequest>{
  final String? laneId;
  final String? truckTypeId;
  final String? commodityId;
  final String? weightId;
  final String? date;
  RateDiscoveryApiRequest({required this.laneId, required this.truckTypeId, required this.commodityId, required this.weightId, required this.date});

  @override
  Map<String, dynamic> toJson() {
    return {
      "lane_id": laneId ?? "",
      "truck_type_id": truckTypeId ?? "",
      "commodity_id": commodityId ?? "",
      "weight_id": weightId ?? "",
      "date": date ?? "",
    };
  }

}