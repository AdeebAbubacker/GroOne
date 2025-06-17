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
    this.expectedDeliveryDateTime,
    this.handlingCharges,
    this.laneId,
    this.pickUpLocation,
    this.dropLocation,
  });

  final num? customerId;
  final num? commodityId;
  final num? truckTypeId;
  final String? pickUpAddr;
  final String? pickUpLatlon;
  final String? dropAddr;
  final String? dropLatlon;
  final String? pickUpLocation;
  final String? dropLocation;
  final String? dueDate;
  final num? consignmentWeight;
  final String? note;
  final String? rate;
  final String? expectedDeliveryDateTime;
  final num? handlingCharges;
  final num? laneId;

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
    String? expectedDeliveryDateTime,
    num? handlingCharges,
    num? laneId,
    String? pickUpLocation,
    String? dropLocation,
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
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      laneId: laneId ?? this.laneId,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropLocation: dropLocation ?? this.dropLocation,
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
    "pickUpDateTime": dueDate,
    "consignmentWeight": consignmentWeight,
    "notes": note,
    "rate": rate,
    "expectedDeliveryDateTime": expectedDeliveryDateTime,
    "handlingCharges": handlingCharges,
    "laneId": laneId,
    "pickUpLocation": pickUpLocation,
    "dropLocation": dropLocation,
  };

}
