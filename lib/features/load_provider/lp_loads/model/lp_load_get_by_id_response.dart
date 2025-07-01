class LpLoadGetByIdResponse {
  LpLoadGetByIdResponse({
    required this.success,
    required this.message,
    required this.loadData,
  });

  final bool success;
  final String message;
  final LoadData? loadData;

  LpLoadGetByIdResponse copyWith({
    bool? success,
    String? message,
    LoadData? loadData,
  }) {
    return LpLoadGetByIdResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      loadData: loadData ?? this.loadData,
    );
  }

  factory LpLoadGetByIdResponse.fromJson(Map<String, dynamic> json){
    return LpLoadGetByIdResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      loadData: json["data"] == null ? null : LoadData.fromJson(json["data"]),
    );
  }

}

class LoadData {
  LoadData({
    required this.id,
    required this.loadId,
    required this.laneId,
    required this.rateId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpWholeAddr,
    required this.pickUpLocation,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropWholeAddr,
    required this.dropLocation,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.isAgreed,
    required this.notes,
    required this.rate,
    required this.maxRate,
    required this.vpRate,
    required this.vpMaxRate,
    required this.status,
    required this.loadStatus,
    required this.vehicleLength,
    required this.pickUpDateTime,
    required this.expectedDeliveryDateTime,
    required this.handlingCharges,
    required this.acceptedBy,
    required this.matchingStartDate,
    required this.agreedPrice,
    required this.acceptedVehicleId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.possibleDeliveryDate,
    required this.commodity,
    required this.truckType,
    required this.customer,
    required this.loadStatusDetails,
    required this.weightage,
    required this.trip,
    required this.timeline,
  });

  final int id;
  final String loadId;
  final num laneId;
  final num rateId;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpWholeAddr;
  final String pickUpLocation;
  final num assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropWholeAddr;
  final String dropLocation;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final int isAgreed;
  final String notes;
  final String rate;
  final String? maxRate;
  final String vpRate;
  final String vpMaxRate;
  final num status;
  final num loadStatus;
  final String vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final num handlingCharges;
  final num acceptedBy;
  final DateTime? matchingStartDate;
  final dynamic agreedPrice;
  final num acceptedVehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic possibleDeliveryDate;
  final DataCommodity? commodity;
  final DataTruckType? truckType;
  final Customer? customer;
  final LoadStatusDetails? loadStatusDetails;
  final Weightage? weightage;
  final Trip? trip;
  final List<Timeline> timeline;

  LoadData copyWith({
    int? id,
    String? loadId,
    num? laneId,
    num? rateId,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpWholeAddr,
    String? pickUpLocation,
    num? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropWholeAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    int? isAgreed,
    String? notes,
    String? rate,
    String? maxRate,
    String? vpRate,
    String? vpMaxRate,
    num? status,
    num? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    num? handlingCharges,
    num? acceptedBy,
    DateTime? matchingStartDate,
    dynamic? agreedPrice,
    num? acceptedVehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    dynamic? possibleDeliveryDate,
    DataCommodity? commodity,
    DataTruckType? truckType,
    Customer? customer,
    LoadStatusDetails? loadStatusDetails,
    Weightage? weightage,
    Trip? trip,
    List<Timeline>? timeline,
  }) {
    return LoadData(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpWholeAddr: pickUpWholeAddr ?? this.pickUpWholeAddr,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropWholeAddr: dropWholeAddr ?? this.dropWholeAddr,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      isAgreed: isAgreed ?? this.isAgreed,
      notes: notes ?? this.notes,
      rate: rate ?? this.rate,
      maxRate: maxRate ?? this.maxRate,
      vpRate: vpRate ?? this.vpRate,
      vpMaxRate: vpMaxRate ?? this.vpMaxRate,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      vehicleLength: vehicleLength ?? this.vehicleLength,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      matchingStartDate: matchingStartDate ?? this.matchingStartDate,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      acceptedVehicleId: acceptedVehicleId ?? this.acceptedVehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      weightage: weightage ?? this.weightage,
      trip: trip ?? this.trip,
      timeline: timeline ?? this.timeline,
    );
  }

  factory LoadData.fromJson(Map<String, dynamic> json){
    return LoadData(
      id: json["id"] ?? 0,
      loadId: json["loadId"] ?? "",
      laneId: json["laneId"] ?? 0,
      rateId: json["rateId"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpWholeAddr: json["pickUpWholeAddr"] == null ? "" : json["pickUpWholeAddr"] ?? "",
      pickUpLocation: json["pickUpLocation"] ?? "",
      assignStatus: json["assignStatus"] ?? 0,
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropWholeAddr: json["dropWholeAddr"] == null ? "" :  json["dropWholeAddr"] ?? "",
      dropLocation: json["dropLocation"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      isAgreed: json["isAgreed"] ?? 0,
      notes: json["notes"] ?? "",
      rate: json["rate"] ?? "",
      maxRate: json["maxRate"] ?? "",
      vpRate: json["vpRate"] ?? "",
      vpMaxRate: json["vpMaxRate"] ?? "",
      status: json["status"] ?? 0,
      loadStatus: json["loadStatus"] ?? 0,
      vehicleLength: json["vehicleLength"] ?? "",
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      agreedPrice: json["agreedPrice"],
      acceptedVehicleId: json["acceptedVehicleId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      possibleDeliveryDate: json["possibleDeliveryDate"],
      commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : DataTruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      weightage: json["weightage"] == null ? null : Weightage.fromJson(json["weightage"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      trip: json["trip"] == null ? null : Trip.fromJson(json["trip"]),
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

  final int id;
  final String name;
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
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
      iconUrl: json["iconUrl"],
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.kycPendingDate,
    required this.customerDetails,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;
  final DateTime? kycPendingDate;
  final CustomerDetails? customerDetails;

  Customer copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
    DateTime? kycPendingDate,
    CustomerDetails? customerDetails,
  }) {
    return Customer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      kycPendingDate: kycPendingDate ?? this.kycPendingDate,
      customerDetails: customerDetails ?? this.customerDetails,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
      customerDetails: json["customerDetails"] == null ? null : CustomerDetails.fromJson(json["customerDetails"]),
    );
  }

}

class CustomerDetails {
  CustomerDetails({
    required this.companyName,
  });

  final String companyName;

  CustomerDetails copyWith({
    String? companyName,
  }) {
    return CustomerDetails(
      companyName: companyName ?? this.companyName,
    );
  }

  factory CustomerDetails.fromJson(Map<String, dynamic> json){
    return CustomerDetails(
      companyName: json["companyName"] ?? "",
    );
  }

}

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String loadType;
  final num status;
  final dynamic createdAt;
  final dynamic deletedAt;

  LoadStatusDetails copyWith({
    int? id,
    String? loadType,
    num? status,
    dynamic? createdAt,
    dynamic? deletedAt,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadType: loadType ?? this.loadType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusDetails.fromJson(Map<String, dynamic> json){
    return LoadStatusDetails(
      id: json["id"] ?? 0,
      loadType: json["loadType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: json["createdAt"],
      deletedAt: json["deletedAt"],
    );
  }

}

class Weightage {
  Weightage({
    required this.id,
    required this.measurementUnitId,
    required this.value,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final num measurementUnitId;
  final num value;
  final dynamic description;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Weightage copyWith({
    int? id,
    num? measurementUnitId,
    num? value,
    dynamic? description,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Weightage(
      id: id ?? this.id,
      measurementUnitId: measurementUnitId ?? this.measurementUnitId,
      value: value ?? this.value,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Weightage.fromJson(Map<String, dynamic> json){
    return Weightage(
      id: json["id"] ?? 0,
      measurementUnitId: json["measurementUnitId"] ?? 0,
      value: json["value"] ?? 0,
      description: json["description"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class Timeline {
  Timeline({
    required this.id,
    required this.label,
    required this.status,
    required this.timestamp,
    required this.commodity,
    required this.truckType,
    required this.loadProvider,
  });

  final int id;
  final String label;
  final String status;
  final DateTime? timestamp;
  final TruckTypeClass? commodity;
  final TruckTypeClass? truckType;
  final CustomerDetails? loadProvider;

  Timeline copyWith({
    int? id,
    String? label,
    String? status,
    DateTime? timestamp,
    TruckTypeClass? commodity,
    TruckTypeClass? truckType,
    CustomerDetails? loadProvider,
  }) {
    return Timeline(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadProvider: loadProvider ?? this.loadProvider,
    );
  }

  factory Timeline.fromJson(Map<String, dynamic> json){
    return Timeline(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      status: json["status"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      commodity: json["commodity"] == null ? null : TruckTypeClass.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckTypeClass.fromJson(json["truckType"]),
      loadProvider: json["loadProvider"] == null ? null : CustomerDetails.fromJson(json["loadProvider"]),
    );
  }

}

class TruckTypeClass {
  TruckTypeClass({
    required this.id,
  });

  final int id;

  TruckTypeClass copyWith({
    int? id,
  }) {
    return TruckTypeClass(
      id: id ?? this.id,
    );
  }

  factory TruckTypeClass.fromJson(Map<String, dynamic> json){
    return TruckTypeClass(
      id: json["id"] ?? 0,
    );
  }

}

class Trip {
  Trip({
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.loadId,
    required this.driver,
    required this.vehicle,
  });

  final int id;
  final num vehicleId;
  final num driverId;
  final num acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final num loadId;
  final Driver? driver;
  final Vehicle? vehicle;

  Trip copyWith({
    int? id,
    num? vehicleId,
    num? driverId,
    num? acceptedBy,
    DateTime? etaForPickUp,
    DateTime? expectedDeliveryDate,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
    num? loadId,
    Driver? driver,
    Vehicle? vehicle,
  }) {
    return Trip(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      etaForPickUp: etaForPickUp ?? this.etaForPickUp,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadId: loadId ?? this.loadId,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json){
    return Trip(
      id: json["id"] ?? 0,
      vehicleId: json["vehicleId"] ?? 0,
      driverId: json["driverId"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadId: json["loadId"] ?? 0,
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
      vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    );
  }

}

class Driver {
  Driver({
    required this.id,
    required this.name,
    required this.mobile,
  });

  final int id;
  final String name;
  final String mobile;

  Driver copyWith({
    int? id,
    String? name,
    String? mobile,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }

}

class Vehicle {
  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.truckType,
  });

  final int id;
  final String vehicleNumber;
  final VehicleTruckType? truckType;

  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    VehicleTruckType? truckType,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      truckType: truckType ?? this.truckType,
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(
      id: json["id"] ?? 0,
      vehicleNumber: json["vehicleNumber"] ?? "",
      truckType: json["truckType"] == null ? null : VehicleTruckType.fromJson(json["truckType"]),
    );
  }

}

class VehicleTruckType {
  VehicleTruckType({
    required this.type,
    required this.subType,
  });

  final String type;
  final String subType;

  VehicleTruckType copyWith({
    String? type,
    String? subType,
  }) {
    return VehicleTruckType(
      type: type ?? this.type,
      subType: subType ?? this.subType,
    );
  }

  factory VehicleTruckType.fromJson(Map<String, dynamic> json){
    return VehicleTruckType(
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
    );
  }

}

class DataTruckType {
  DataTruckType({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
  });

  final int id;
  final String type;
  final String subType;
  final dynamic iconUrl;

  DataTruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
  }) {
    return DataTruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory DataTruckType.fromJson(Map<String, dynamic> json){
    return DataTruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
    );
  }

}
