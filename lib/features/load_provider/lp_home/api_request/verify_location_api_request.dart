class VerifyLocationApiRequest {
  VerifyLocationApiRequest({
    required this.placeId,
    required this.locationdetails,
  });

  final String placeId;
  final LocationDetails? locationdetails;

  VerifyLocationApiRequest copyWith({
    String? placeId,
    LocationDetails? locationdetails,
  }) {
    return VerifyLocationApiRequest(
      placeId: placeId ?? this.placeId,
      locationdetails: locationdetails ?? this.locationdetails,
    );
  }


  Map<String, dynamic> toJson() => {
    "placeId": placeId,
    "locationdetails": locationdetails?.toJson(),
  };

}

class LocationDetails {
  LocationDetails({
    required this.name,
    required this.slug,
  });

  final String name;
  final String slug;

  LocationDetails copyWith({
    String? name,
    String? slug,
  }) {
    return LocationDetails(
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }


  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
  };

}
