class LocationAddressResponse {
  LocationAddressResponse({
    required this.fetchedResults,
    required this.status,
  });

  final List<FetchedResults> fetchedResults;
  final String status;

  LocationAddressResponse copyWith({
    List<FetchedResults>? results,
    String? status,
  }) {
    return LocationAddressResponse(
      fetchedResults: fetchedResults,
      status: status ?? this.status,
    );
  }

  factory LocationAddressResponse.fromJson(Map<String, dynamic> json){
    return LocationAddressResponse(
      fetchedResults: json["results"] == null ? [] : List<FetchedResults>.from(json["results"]!.map((x) => FetchedResults.fromJson(x))),
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "results": fetchedResults.map((x) => x.toJson()).toList(),
    "status": status,
  };

}

class FetchedResults {
  FetchedResults({
    required this.formattedAddress,
    required this.placeId,
  });

  final String formattedAddress;
  final String placeId;

  FetchedResults copyWith({
    String? formattedAddress,
    String? placeId,
  }) {
    return FetchedResults(
      formattedAddress: formattedAddress ?? this.formattedAddress,
      placeId: placeId ?? this.placeId,
    );
  }

  factory FetchedResults.fromJson(Map<String, dynamic> json){
    return FetchedResults(
      formattedAddress: json["formatted_address"] ?? "",
      placeId: json["place_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "formatted_address": formattedAddress,
    "place_id": placeId,
  };
}