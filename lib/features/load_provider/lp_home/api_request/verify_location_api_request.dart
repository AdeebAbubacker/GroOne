class VerifyLocationApiRequest {
  VerifyLocationApiRequest({
    required this.placeId,
    required this.type,
    this.locationId,
  });

  final String placeId;
  final int type;
  final int? locationId;

  VerifyLocationApiRequest copyWith({
    String? placeId,
    int? type,
    int? locationId,
  }) {
    return VerifyLocationApiRequest(
      placeId: placeId ?? this.placeId,
      type: type ?? this.type,
      locationId: locationId ?? this.locationId,
    );
  }


  Map<String, dynamic> toJson() => {
    "placeId": placeId,
    "type": type,
    if (locationId != null) "locationId": locationId!,
  };

}
