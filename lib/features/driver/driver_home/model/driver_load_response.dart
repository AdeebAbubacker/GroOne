class LoadDetails {
  final String loadSeriesID;
  final String loadId;
  final String laneId;
  final int rateId;
  final String customerId;
  final int commodityId;
  final int truckTypeId;
  final String pickUpAddr;
  final String pickUpLocation;
  final int assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLocation;
  final String dropLatlon;
  final DateTime dueDate;
  final int consignmentWeight;
  final String notes;
  final String rate;
  final String vpRate;
  final String vpMaxRate;
  final int status;
  final int loadStatus;
  final String vehicleLength;
  final String pickUpDateTime;
  final DateTime expectedDeliveryDateTime;
  final int handlingCharges;
  final String acceptedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final dynamic commodity; // You can replace with proper model if available
  final dynamic truckType; // You can replace with proper model if available
  final dynamic customer; // You can replace with proper model if available
  final List<dynamic> timeline; // Replace dynamic with appropriate class if available
  final dynamic trip; // Replace with Trip model if available

  LoadDetails({
    required this.loadSeriesID,
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
    this.updatedAt,
    this.deletedAt,
    this.commodity,
    this.truckType,
    this.customer,
    required this.timeline,
    this.trip,
  });

  factory LoadDetails.fromJson(Map<String, dynamic> json) {
    return LoadDetails(
      loadSeriesID: json['loadSeriesID'],
      loadId: json['loadId'],
      laneId: json['laneId'],
      rateId: json['rateId'],
      customerId: json['customerId'],
      commodityId: json['commodityId'],
      truckTypeId: json['truckTypeId'],
      pickUpAddr: json['pickUpAddr'],
      pickUpLocation: json['pickUpLocation'],
      assignStatus: json['assignStatus'],
      pickUpLatlon: json['pickUpLatlon'],
      dropAddr: json['dropAddr'],
      dropLocation: json['dropLocation'],
      dropLatlon: json['dropLatlon'],
      dueDate: DateTime.parse(json['dueDate']),
      consignmentWeight: json['consignmentWeight'],
      notes: json['notes'],
      rate: json['rate'],
      vpRate: json['vpRate'],
      vpMaxRate: json['vpMaxRate'],
      status: json['status'],
      loadStatus: json['loadStatus'],
      vehicleLength: json['vehicleLength'],
      pickUpDateTime: json['pickUpDateTime'],
      expectedDeliveryDateTime: DateTime.parse(json['expectedDeliveryDateTime']),
      handlingCharges: json['handlingCharges'],
      acceptedBy: json['acceptedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      commodity: json['commodity'],
      truckType: json['truckType'],
      customer: json['customer'],
      timeline: json['timeline'] ?? [],
      trip: json['trip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loadSeriesID': loadSeriesID,
      'loadId': loadId,
      'laneId': laneId,
      'rateId': rateId,
      'customerId': customerId,
      'commodityId': commodityId,
      'truckTypeId': truckTypeId,
      'pickUpAddr': pickUpAddr,
      'pickUpLocation': pickUpLocation,
      'assignStatus': assignStatus,
      'pickUpLatlon': pickUpLatlon,
      'dropAddr': dropAddr,
      'dropLocation': dropLocation,
      'dropLatlon': dropLatlon,
      'dueDate': dueDate.toIso8601String(),
      'consignmentWeight': consignmentWeight,
      'notes': notes,
      'rate': rate,
      'vpRate': vpRate,
      'vpMaxRate': vpMaxRate,
      'status': status,
      'loadStatus': loadStatus,
      'vehicleLength': vehicleLength,
      'pickUpDateTime': pickUpDateTime,
      'expectedDeliveryDateTime': expectedDeliveryDateTime.toIso8601String(),
      'handlingCharges': handlingCharges,
      'acceptedBy': acceptedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'commodity': commodity,
      'truckType': truckType,
      'customer': customer,
      'timeline': timeline,
      'trip': trip,
    };
  }
}
