class FleetPincodeVerifyModel {
  FleetPincodeVerifyModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<FleetPincodeVerifyModelData> data;

  FleetPincodeVerifyModel copyWith({
    bool? success,
    String? message,
    List<FleetPincodeVerifyModelData>? data,
  }) {
    return FleetPincodeVerifyModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory FleetPincodeVerifyModel.fromJson(Map<String, dynamic> json){
    return FleetPincodeVerifyModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<FleetPincodeVerifyModelData>.from(json["data"]!.map((x) => FleetPincodeVerifyModelData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class FleetPincodeVerifyModelData {
  FleetPincodeVerifyModelData({
    required this.name,
    required this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  final String name;
  final dynamic description;
  final String branchType;
  final String deliveryStatus;
  final String circle;
  final String district;
  final String division;
  final String region;
  final String block;
  final String state;
  final String country;
  final String pincode;

  FleetPincodeVerifyModelData copyWith({
    String? name,
    dynamic? description,
    String? branchType,
    String? deliveryStatus,
    String? circle,
    String? district,
    String? division,
    String? region,
    String? block,
    String? state,
    String? country,
    String? pincode,
  }) {
    return FleetPincodeVerifyModelData(
      name: name ?? this.name,
      description: description ?? this.description,
      branchType: branchType ?? this.branchType,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      circle: circle ?? this.circle,
      district: district ?? this.district,
      division: division ?? this.division,
      region: region ?? this.region,
      block: block ?? this.block,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
    );
  }

  factory FleetPincodeVerifyModelData.fromJson(Map<String, dynamic> json){
    return FleetPincodeVerifyModelData(
      name: json["Name"] ?? "",
      description: json["Description"],
      branchType: json["BranchType"] ?? "",
      deliveryStatus: json["DeliveryStatus"] ?? "",
      circle: json["Circle"] ?? "",
      district: json["District"] ?? "",
      division: json["Division"] ?? "",
      region: json["Region"] ?? "",
      block: json["Block"] ?? "",
      state: json["State"] ?? "",
      country: json["Country"] ?? "",
      pincode: json["Pincode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Description": description,
    "BranchType": branchType,
    "DeliveryStatus": deliveryStatus,
    "Circle": circle,
    "District": district,
    "Division": division,
    "Region": region,
    "Block": block,
    "State": state,
    "Country": country,
    "Pincode": pincode,
  };

}
