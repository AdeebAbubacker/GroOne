class DestinationModel {
  DestinationModel({
     this.address,
     this.location,
     this.latLng,
     this.laneId,
  });

   final String? address;
   final String? location;
  final String? latLng;
  final num? laneId;

  DestinationModel copyWith({
    String? address,
    String? location,
    String? latLng,
    num? laneId,
  }) {
    return DestinationModel(
      address: address ?? this.address,
      location: location ?? this.location,
      latLng: latLng ?? this.latLng,
      laneId: laneId ?? this.laneId,
    );
  }

  @override
  String toString() {
    return ' DestinationModel { address: $address, location: $location, latLng: $latLng, laneId: $laneId}';
  }


}
