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
     // this.dueDate,
     this.pickUpDateTime,
     this.weightId,
     this.note,
     this.rate,
     this.maxRate,
    this.expectedDeliveryDateTime,
    this.handlingCharges,
    this.laneId,
    this.rateId,
    this.pickUpLocation,
    this.dropLocation,
    this.pickUpWholeAddr,
    this.dropWholeAddr
  });

  final String? customerId;
  final num? commodityId;
  final num? truckTypeId;
  final String? pickUpAddr;
  final String? pickUpLatlon;
  final String? dropAddr;
  final String? dropLatlon;
  final String? pickUpLocation;
  final String? dropLocation;
  // final String? dueDate;
  final String? pickUpDateTime;
  final int? weightId;
  final String? note;
  final String? rate;
  final String? maxRate;
  final String? expectedDeliveryDateTime;
  final num? handlingCharges;
  final num? laneId;
  final int? rateId;
  final String? pickUpWholeAddr;
  final String? dropWholeAddr;

  CreateLoadApiRequest copyWith({
    String? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLatlon,
    // String? dueDate,
    String? pickUpDateTime,
    int? weightId,
    String? note,
    String? rate,
    String? maxRate,
    String? expectedDeliveryDateTime,
    num? handlingCharges,
    num? laneId,
    int? rateId,
    String? pickUpLocation,
    String? dropLocation,
    String? pickUpWholeAddr,
    String? dropWholeAddr,
  }) {
    return CreateLoadApiRequest(
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      // dueDate: dueDate ?? this.dueDate,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      weightId: weightId ?? this.weightId,
      note: note ?? this.note,
      rate: rate ?? this.rate,
      maxRate: maxRate ?? this.maxRate,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      pickUpWholeAddr: pickUpWholeAddr ?? this.pickUpWholeAddr,
      dropWholeAddr: dropWholeAddr ?? this.dropWholeAddr,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "customerId": customerId ?? 0,
    "commodityId": commodityId ?? 0,
    "truckTypeId": truckTypeId ?? 0,
    "pickUpAddr": pickUpAddr ?? "",
    "pickUpLatlon": pickUpLatlon ?? "",
    "dropAddr": dropAddr ?? "",
    "dropLatlon": dropLatlon ?? "",
    // "dueDate": dueDate ?? "",
    "pickUpDateTime": pickUpDateTime ?? "",
    "weightId": weightId ?? 0,
    "notes": note  ??"",
    "rate": rate ?? "",
    "maxRate": maxRate ?? "",
    "expectedDeliveryDateTime": expectedDeliveryDateTime ?? "",
    "handlingCharges": handlingCharges ?? "",
    "laneId": laneId ?? 0,
    "rateId": rateId ?? 0,
    "pickUpLocation": pickUpLocation ?? "",
    "dropLocation": dropLocation ?? "",
    "pickUpWholeAddr": pickUpWholeAddr ?? "",
    "dropWholeAddr": dropWholeAddr ?? "",
  };

}
