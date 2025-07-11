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
    required this.loadId,
    required this.loadSeriesID,
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
    required this.vpRate,
    required this.vpMaxRate,
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
    required this.trip,
  });

  final String? loadId;
  final String? loadSeriesID;
  final dynamic laneId;
  final int? rateId;
  final String? customerId;
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
  final String? vpRate;
  final String? vpMaxRate;
  final int? status;
  final int? loadStatus;
  final String? vehicleLength;
  final String? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final int? handlingCharges;
  final String? acceptedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final DataCommodity? commodity;
  final TruckType? truckType;
  final CustomerDetails? customer;
  final List<Timeline> timeline;
  final Trip? trip;

  LoadDetails copyWith({
    String? id,
    String? loadId,
    dynamic? laneId,
    int? rateId,
    String? customerId,
    int? commodityId,
    int? truckTypeId,
    String? pickUpAddr,
    String? pickUpLocation,
    int? assignStatus,
    Trip? trip,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    int? consignmentWeight,
    String? notes,
    String? rate,
    String? vpRate,
    String? vpMaxRate,
    int? status,
    int? loadStatus,
    String? vehicleLength,
    String? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    int? handlingCharges,
    String? acceptedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    DataCommodity? commodity,
    TruckType? truckType,
    CustomerDetails? customer,
    List<Timeline>? timeline,
  }) {
    return LoadDetails(
     trip: trip ?? this.trip,
      loadId: id ?? this.loadId,
      loadSeriesID: loadId ?? this.loadSeriesID,
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
      vpRate: vpRate ?? this.vpRate,
      vpMaxRate: vpMaxRate ?? this.vpMaxRate,
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
      trip:json['scheduleTripDetails']!=null ? Trip.fromJson(json['scheduleTripDetails']):null,
      loadId: json["loadId"],
      loadSeriesID: json["loadSeriesId"],
      laneId: json["laneId"],
      rateId: json["rateId"],
      customerId: json["customerId"],
      commodityId: json["commodityId"],
      truckTypeId: json["truckTypeId"],
      pickUpAddr:  json['loadRoute']!=null ?  json['loadRoute']["pickUpAddr"]:"",
      pickUpLocation: json['loadRoute']!=null ?  json['loadRoute']["pickUpLocation"]:"",
      assignStatus: json["assignStatus"],
      pickUpLatlon: json['loadRoute']!=null ?  json['loadRoute']["pickUpLatlon"]:"",
      dropAddr: json['loadRoute']!=null ?  json['loadRoute']["dropAddr"]:"",
      dropLocation: json['loadRoute']!=null ?  json['loadRoute']["dropLocation"]:"",
      dropLatlon: json['loadRoute']!=null ?  json['loadRoute']["dropLatlon"]:"",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json['weight']!=null ?json['weight']['value'] :0,
      notes: json["notes"],
      rate: json['loadPrice']!=null ?  json['loadPrice']["rate"]?.toString():"",
      vpMaxRate:  json['loadPrice']!=null ?  json['loadPrice']['vpMaxRate']?.toString()??"" :"",
      vpRate:  json['loadPrice']!=null ?  json['loadPrice']['vpRate']?.toString()??"":"" ,

      status: json["status"],
      loadStatus: json["loadStatusId"],
      vehicleLength: json["vehicleLength"],
      pickUpDateTime:json["pickUpDateTime"] ?? "",
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"],
      acceptedBy: json["acceptedBy"]??"",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : CustomerDetails.fromJson(json["customer"]),
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

class Trip {

  final Driver? driver;
  final Vehicle? vehicle;

  Trip({
    required this.driver,
    required this.vehicle,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {

    print("json is ${json['driver']}");
    return Trip(
      driver: Driver.fromJson(json['driver']),
      vehicle: Vehicle.fromJson(json['vehicle']),
    );
  }
}

class Driver {
  final int? id;
  final String? name;
  final String? mobile;

  Driver({
    required this.id,
    required this.name,
    required this.mobile,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}

class Vehicle {
  final int? id;
  final String? vehicleNumber;
  final TruckType? truckType;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.truckType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicleNumber: json['truckNo'],
      truckType: TruckType.fromJson(json),
    );
  }
}




