import 'package:gro_one_app/data/model/serializable.dart';

class CreateLoadApiRequest extends Serializable<CreateLoadApiRequest> {
  CreateLoadApiRequest({
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
  });

  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;

  CreateLoadApiRequest copyWith({
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
  }) {
    return CreateLoadApiRequest(
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
    );
  }

  factory CreateLoadApiRequest.fromJson(Map<String, dynamic> json){
    return CreateLoadApiRequest(
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate?.toIso8601String(),
    "consignmentWeight": consignmentWeight,
  };

}
