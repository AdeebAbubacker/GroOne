class DirectionResponse {
  final List<Route> routes;
  final String status;

  DirectionResponse({required this.routes, required this.status});

  factory DirectionResponse.fromJson(Map<String, dynamic> json) {
    return DirectionResponse(
      routes: (json['routes'] as List).map((e) => Route.fromJson(e)).toList(),
      status: json['status'],
    );
  }
}

class Route {
  final List<Leg> legs;
  final OverviewPolyline overviewPolyline;

  Route({required this.legs, required this.overviewPolyline});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      legs: (json['legs'] as List).map((e) => Leg.fromJson(e)).toList(),
      overviewPolyline: OverviewPolyline.fromJson(json['overview_polyline']),
    );
  }
}

class Leg {
  final TextValue distance;
  final TextValue duration;
  final Location startLocation;
  final Location endLocation;

  Leg({
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      distance: TextValue.fromJson(json['distance']),
      duration: TextValue.fromJson(json['duration']),
      startLocation: Location.fromJson(json['start_location']),
      endLocation: Location.fromJson(json['end_location']),
    );
  }
}

class TextValue {
  final String text;
  final int value;

  TextValue({required this.text, required this.value});

  factory TextValue.fromJson(Map<String, dynamic> json) {
    return TextValue(
      text: json['text'],
      value: json['value'],
    );
  }
}
class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
class OverviewPolyline {
  final String points;

  OverviewPolyline({required this.points});

  factory OverviewPolyline.fromJson(Map<String, dynamic> json) {
    return OverviewPolyline(
      points: json['points'],
    );
  }
}







