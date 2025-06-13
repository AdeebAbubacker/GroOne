class PickUpModel {
  PickUpModel({
    required this.address,
    required this.location,
    required this.latLng,
    required this.laneId,
  });

  final String? address;
  final String? location;
  final String? latLng;
  final String? laneId;

  PickUpModel copyWith({
    String? address,
    String? location,
    String? latLng,
    String? laneId,
  }) {
    return PickUpModel(
      address: address ?? this.address,
      location: location ?? this.location,
      latLng: latLng ?? this.latLng,
      laneId: laneId ?? this.laneId,
    );
  }

  factory PickUpModel.fromJson(Map<String, dynamic> json){
    return PickUpModel(
      address: json["address"],
      location: json["location"],
      latLng: json["latLng"],
      laneId: json["laneId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "location": location,
    "latLng": latLng,
    "laneId": laneId,
  };

}
