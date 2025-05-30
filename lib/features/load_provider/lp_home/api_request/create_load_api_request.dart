import 'package:gro_one_app/data/model/serializable.dart';

class CreateLoadApiRequest extends Serializable<CreateLoadApiRequest> {
  CreateLoadApiRequest({
     this.customerId,
     this.commodityId,
     this.truckTypeId,
     this.pickUpAddr,
     this.pickUpLatlon,
     this.dropAddr,
     this.dropLatlon,
     this.dueDate,
     this.consignmentWeight,
     this.note,
     this.rate,
  });

  final num? customerId;
  final num? commodityId;
  final num? truckTypeId;
  final String? pickUpAddr;
  final String? pickUpLatlon;
  final String? dropAddr;
  final String? dropLatlon;
  final String? dueDate;
  final num? consignmentWeight;
  final String? note;
  final String? rate;

  CreateLoadApiRequest copyWith({
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLatlon,
    String? dueDate,
    num? consignmentWeight,
    String? note,
    String? rate,
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
      note: note ?? this.note,
      rate: rate ?? this.rate,
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
      dueDate: json["dueDate"],
      consignmentWeight: json["consignmentWeight"] ?? 0,
      note: json["note"] ?? "",
      rate: json["rate"] ?? "",
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
    "dueDate": dueDate,
    "consignmentWeight": consignmentWeight,
    "note": note,
    "rate": rate,

  };

}
