import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GpsGeofenceModel {
//   final int id;
//   final String name;
//   final String area;
//   final String? shapeType; // circle or polygon
//   final double? radius; // for circle
//   final LatLng? center; // for circle
//   final List<LatLng>? polygonPoints; // for polygon
//
//   GpsGeofenceModel({
//     required this.id,
//     required this.name,
//     required this.area,
//     this.shapeType,
//     this.radius,
//     this.center,
//     this.polygonPoints,
//   });
//
//   factory GpsGeofenceModel.fromJson(Map<String, dynamic> json) {
//     String? type = json['attributes']?['type'] ?? json['attributes']?['shape'];
//     double? radius;
//     LatLng? center;
//     List<LatLng>? polygonPoints;
//
//     // Try to get radius
//     if (json['attributes']?['geojson']?['radius'] != null) {
//       radius = (json['attributes']['geojson']['radius'] as num).toDouble();
//     } else if (json['attributes']?['radius'] != null) {
//       radius = (json['attributes']['radius'] as num).toDouble();
//     }
//
//     // Circle Center
//     if (type == "circle") {
//       try {
//         final coords = json['attributes']['geojson']['features'][0]['geometry']['coordinates'];
//         if (coords != null && coords.length == 2) {
//           final lng = double.tryParse(coords[0].toString());
//           final lat = double.tryParse(coords[1].toString());
//           if (lat != null && lng != null) {
//             center = LatLng(lat, lng);
//           }
//         }
//       } catch (e) {
//         center = null;
//       }
//     }
//
//     // Polygon Points
//     if (type == "polygon") {
//       try {
//         final coordinates = json['attributes']['geojson']['features'][0]['geometry']['coordinates'];
//         if (coordinates != null && coordinates.isNotEmpty) {
//           // Notice the extra [0] because of GeoJSON nesting
//           polygonPoints = (coordinates[0] as List).map<LatLng>((coordPair) {
//             final lng = double.tryParse(coordPair[0].toString());
//             final lat = double.tryParse(coordPair[1].toString());
//             return LatLng(lat ?? 0, lng ?? 0);
//           }).toList();
//         }
//       } catch (e) {
//         polygonPoints = [];
//       }
//     }
//
//
//     return GpsGeofenceModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       area: json['area'] ?? '',
//       shapeType: type,
//       radius: radius,
//       center: center,
//       polygonPoints: polygonPoints,
//     );
//   }
// }


class GpsGeofenceModel {
  final String id;
  String name;
  final String area;
  final String shapeType; // "circle", "polygon", "polyline"
  final String? coveredArea;
  LatLng? center; // For circle
  double? radius; // For circle
  List<LatLng>? polygonPoints; // For polygon and polyline

  GpsGeofenceModel({
    required this.id,
    required this.name,
    required this.area,
    required this.shapeType,
    this.coveredArea,
    this.center,
    this.radius,
    this.polygonPoints,
  });

  /// Factory constructor for new circle geofence
  factory GpsGeofenceModel.newCircle() {
    return GpsGeofenceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Circle Geofence',
      area: '',
      shapeType: 'circle',
      center: null,
      radius: 500, // Default radius
    );
  }

  /// Factory constructor for new polygon geofence
  factory GpsGeofenceModel.newPolygon() {
    return GpsGeofenceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Polygon Geofence',
      area: '',
      shapeType: 'polygon',
      polygonPoints: [],
    );
  }

  /// Factory constructor for new polyline geofence
  factory GpsGeofenceModel.newPolyline() {
    return GpsGeofenceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Polyline Geofence',
      area: '',
      shapeType: 'polyline',
      polygonPoints: [],
    );
  }

  /// From JSON for existing data
  factory GpsGeofenceModel.fromJson(Map<String, dynamic> json) {
    String? type = json['attributes']?['type'] ?? json['attributes']?['shape'];
    String? coveredArea = json['attributes']?['covered_area'];
    double? radius;
    LatLng? center;
    List<LatLng>? points;

    if (type == "circle") {
      try {
        final coords = json['attributes']['geojson']['features'][0]['geometry']['coordinates'];
        if (coords != null && coords.length == 2) {
          final lng = double.tryParse(coords[0].toString());
          final lat = double.tryParse(coords[1].toString());
          if (lat != null && lng != null) {
            center = LatLng(lat, lng);
          }
        }
        // radius = (json['radius'] as num?)?.toDouble();
        radius = (json['attributes']['radius'] as num?)?.toDouble()
            ?? (json['attributes']['geojson']['radius'] as num?)?.toDouble();
      } catch (_) {}
    } else if (type == "polygon" || type == "polyline") {
      try {
        final coordinates = type == "polygon"
            ? json['attributes']['geojson']['features'][0]['geometry']['coordinates'][0]
            : json['attributes']['geojson']['features'][0]['geometry']['coordinates'];
        if (coordinates != null) {
          points = coordinates.map<LatLng>((coordPair) {
            final lng = double.tryParse(coordPair[0].toString());
            final lat = double.tryParse(coordPair[1].toString());
            return LatLng(lat ?? 0, lng ?? 0);
          }).toList();
        }
      } catch (_) {}
    }

    return GpsGeofenceModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      area: json['area'] ?? '',
      shapeType: type ?? 'circle',
      center: center,
      coveredArea: coveredArea,
      radius: radius,
      polygonPoints: points,
    );
  }
}
