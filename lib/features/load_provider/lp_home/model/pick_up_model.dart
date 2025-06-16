class PickUpModel {
  PickUpModel({
     this.address,
     this.location,
     this.latLng,
     this.laneId,
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

  @override
  String toString() {
    return 'PickUpModel { address: $address, location: $location, latLng: $latLng, laneId: $laneId}';

  }

}
