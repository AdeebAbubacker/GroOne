class DestinationModel {
  DestinationModel({
    required this.address,
    required this.location,
    required this.latLng,
    required this.laneId,
  });

  final String? address;
  final String? location;
  final String? latLng;
  final String? laneId;

  DestinationModel copyWith({
    String? address,
    String? location,
    String? latLng,
    String? laneId,
  }) {
    return DestinationModel(
      address: address ?? this.address,
      location: location ?? this.location,
      latLng: latLng ?? this.latLng,
      laneId: laneId ?? this.laneId,
    );
  }


}
