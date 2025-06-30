import '../../../load_provider/lp_loads/model/lp_load_get_by_id_response.dart';

class LoadDetailsResponseModel {
  LoadDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final LoadDetails? data;

  LoadDetailsResponseModel copyWith({
    bool? success,
    String? message,
    LoadDetails? data,
  }) {
    return LoadDetailsResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoadDetailsResponseModel.fromJson(Map<String, dynamic> json){
    return LoadDetailsResponseModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : LoadDetails.fromJson(json["data"]),
    );
  }

}

class LoadDetails {
  LoadDetails({
    required this.id,
    required this.loadId,
    required this.laneId,
    required this.rateId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLocation,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLocation,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.notes,
    required this.rate,
    required this.status,
    required this.loadStatus,
    required this.vehicleLength,
    required this.pickUpDateTime,
    required this.expectedDeliveryDateTime,
    required this.handlingCharges,
    required this.acceptedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.commodity,
    required this.truckType,
    required this.customer,
    required this.timeline,
  });

  final int? id;
  final String? loadId;
  final dynamic laneId;
  final int? rateId;
  final int? customerId;
  final int? commodityId;
  final int? truckTypeId;
  final String? pickUpAddr;
  final String? pickUpLocation;
  final int? assignStatus;
  final String? pickUpLatlon;
  final String? dropAddr;
  final String? dropLocation;
  final String? dropLatlon;
  final DateTime? dueDate;
  final int? consignmentWeight;
  final String? notes;
  final String? rate;
  final int? status;
  final int? loadStatus;
  final String? vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final int? handlingCharges;
  final int? acceptedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final DataCommodity? commodity;
  final TruckType? truckType;
  final Customer? customer;
  final List<Timeline> timeline;

  LoadDetails copyWith({
    int? id,
    String? loadId,
    dynamic? laneId,
    int? rateId,
    int? customerId,
    int? commodityId,
    int? truckTypeId,
    String? pickUpAddr,
    String? pickUpLocation,
    int? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    int? consignmentWeight,
    String? notes,
    String? rate,
    int? status,
    int? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    int? handlingCharges,
    int? acceptedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    DataCommodity? commodity,
    TruckType? truckType,
    Customer? customer,
    List<Timeline>? timeline,
  }) {
    return LoadDetails(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      notes: notes ?? this.notes,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      vehicleLength: vehicleLength ?? this.vehicleLength,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      timeline: timeline ?? this.timeline,
    );
  }

  factory LoadDetails.fromJson(Map<String, dynamic> json){
    return LoadDetails(
      id: json["id"],
      loadId: json["loadId"],
      laneId: json["laneId"],
      rateId: json["rateId"],
      customerId: json["customerId"],
      commodityId: json["commodityId"],
      truckTypeId: json["truckTypeId"],
      pickUpAddr: json["pickUpAddr"],
      pickUpLocation: json["pickUpLocation"],
      assignStatus: json["assignStatus"],
      pickUpLatlon: json["pickUpLatlon"],
      dropAddr: json["dropAddr"],
      dropLocation: json["dropLocation"],
      dropLatlon: json["dropLatlon"],
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"],
      notes: json["notes"],
      rate: json["rate"],
      status: json["status"],
      loadStatus: json["loadStatus"],
      vehicleLength: json["vehicleLength"],
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"],
      acceptedBy: json["acceptedBy"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
    );
  }



}

class DataCommodity {
  DataCommodity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
  });

  final int? id;
  final String? name;
  final dynamic description;
  final dynamic iconUrl;

  DataCommodity copyWith({
    int? id,
    String? name,
    dynamic? description,
    dynamic? iconUrl,
  }) {
    return DataCommodity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory DataCommodity.fromJson(Map<String, dynamic> json){
    return DataCommodity(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      iconUrl: json["iconUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "iconUrl": iconUrl,
  };

}

class Customer {
  Customer({
    required this.id,
    required this.customerDetails,
  });

  final int? id;
  final CustomerDetails? customerDetails;

  Customer copyWith({
    int? id,
    CustomerDetails? customerDetails,
  }) {
    return Customer(
      id: id ?? this.id,
      customerDetails: customerDetails ?? this.customerDetails,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"],
      customerDetails: json["customerDetails"] == null ? null : CustomerDetails.fromJson(json["customerDetails"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerDetails": customerDetails?.toJson(),
  };

}

class CustomerDetails {
  CustomerDetails({
    required this.companyName,
  });

  final String? companyName;

  CustomerDetails copyWith({
    String? companyName,
  }) {
    return CustomerDetails(
      companyName: companyName ?? this.companyName,
    );
  }

  factory CustomerDetails.fromJson(Map<String, dynamic> json){
    return CustomerDetails(
      companyName: json["companyName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
  };

}



class TruckTypeClass {
  TruckTypeClass({
    required this.id,
  });

  final int? id;

  TruckTypeClass copyWith({
    int? id,
  }) {
    return TruckTypeClass(
      id: id ?? this.id,
    );
  }

  factory TruckTypeClass.fromJson(Map<String, dynamic> json){
    return TruckTypeClass(
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
  };

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
  });

  final int? id;
  final String? type;
  final String? subType;
  final dynamic iconUrl;

  TruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"],
      type: json["type"],
      subType: json["subType"],
      iconUrl: json["iconUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "subType": subType,
    "iconUrl": iconUrl,
  };

}
