import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/utils/location_permission_helper.dart';

/// GPS Map Helper - Provides common map functionality for GPS feature screens
class GpsMapHelper {
  GpsMapHelper._();

  // Default map configurations
  static const LatLng _defaultLocation = LatLng(
    20.5937,
    78.9629,
  ); // India center
  static const LatLng _delhiLocation = LatLng(28.6139, 77.2090);
  static const double _defaultZoom = 14.0;
  static const double _defaultZoomWide = 4.0;
  static const double _defaultZoomClose = 12.0;

  // Cache for bitmap descriptors to avoid recreating them
  static final Map<String, BitmapDescriptor> _bitmapCache = {};

  /// Creates a GoogleMap widget with common configurations
  static Widget createGpsMap({
    required CameraPosition initialCameraPosition,
    Set<Marker> markers = const {},
    Set<Circle> circles = const {},
    Set<Polygon> polygons = const {},
    Set<Polyline> polylines = const {},
    MapType mapType = MapType.normal,
    bool myLocationEnabled = true,
    bool myLocationButtonEnabled = false,
    bool zoomControlsEnabled = true,
    bool trafficEnabled = false,
    bool compassEnabled = true,
    bool mapToolbarEnabled = false,
    MapCreatedCallback? onMapCreated,
    Function(LatLng)? onTap,
    Function(LatLng)? onLongPress,
  }) {
    return FutureBuilder<bool>(
      future: LocationPermissionHelper.shouldEnableMyLocation(),
      builder: (context, snapshot) {
        final canEnableMyLocation = snapshot.data ?? false;

        return GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          circles: circles,
          polygons: polygons,
          polylines: polylines,
          mapType: mapType,
          myLocationEnabled: myLocationEnabled && canEnableMyLocation,
          myLocationButtonEnabled:
              myLocationButtonEnabled && canEnableMyLocation,
          zoomControlsEnabled: zoomControlsEnabled,
          trafficEnabled: trafficEnabled,
          compassEnabled: compassEnabled,
          mapToolbarEnabled: mapToolbarEnabled,
          onMapCreated: onMapCreated,
          onTap: onTap,
          onLongPress: onLongPress,
        );
      },
    );
  }

  /// Creates a camera position for a single location
  static CameraPosition createCameraPosition({
    required LatLng target,
    double zoom = _defaultZoom,
  }) {
    return CameraPosition(target: target, zoom: zoom);
  }

  /// Creates a default camera position (India center)
  static CameraPosition getDefaultCameraPosition() {
    return createCameraPosition(
      target: _defaultLocation,
      zoom: _defaultZoomWide,
    );
  }

  /// Creates a camera position for Delhi
  static CameraPosition getDelhiCameraPosition() {
    return createCameraPosition(
      target: _delhiLocation,
      zoom: _defaultZoomClose,
    );
  }

  /// Creates a camera position for current location
  static Future<CameraPosition> getCurrentLocationCameraPosition({
    double zoom = _defaultZoom,
  }) async {
    final currentLocation = await MapHelper.getCurrentLocation();
    return createCameraPosition(
      target: currentLocation ?? _defaultLocation,
      zoom: zoom,
    );
  }

  /// Creates a camera position that fits multiple markers
  static CameraPosition createBoundsCameraPosition({
    required List<LatLng> points,
    double padding = 50.0,
  }) {
    if (points.isEmpty) {
      return getDefaultCameraPosition();
    }

    final bounds = _getLatLngBounds(points);
    return CameraPosition(
      target: _getCenterFromBounds(bounds),
      zoom: _calculateZoomForBounds(bounds, padding),
    );
  }

  /// Creates a marker with common configurations
  static Marker createMarker({
    required String markerId,
    required LatLng position,
    String? title,
    String? snippet,
    BitmapDescriptor? icon,
    bool draggable = false,
    bool flat = false,
    double rotation = 0.0,
    Offset anchor = const Offset(0.5, 0.5),
    VoidCallback? onTap,
    Function(LatLng)? onDragEnd,
  }) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      draggable: draggable,
      flat: flat,
      rotation: rotation,
      anchor: anchor,
      onTap: onTap,
      onDragEnd: onDragEnd,
    );
  }

  /// Creates a vehicle marker with yellow color
  static Marker createVehicleMarker({
    required String vehicleId,
    required LatLng position,
    String? title,
    String? snippet,
    VoidCallback? onTap,
  }) {
    return createMarker(
      markerId: vehicleId,
      position: position,
      title: title,
      snippet: snippet,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      onTap: onTap,
    );
  }

  /// Creates a vehicle marker with custom vehicle icon
  static Future<Marker> createCustomVehicleMarker({
    required String vehicleId,
    required LatLng position,
    String? title,
    String? snippet,
    VoidCallback? onTap,
    double rotation = 0.0,
  }) async {
    BitmapDescriptor vehicleIcon;

    try {
      // Try to load the custom vehicle icon with appropriate size for map
      vehicleIcon = await _getResizedBitmapDescriptor(
        'assets/images/png/red_car.png',
        targetWidth: 32,
      );
    } catch (e) {
      // Fallback to default yellow marker if custom icon fails to load
      vehicleIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      );
    }

    return createMarker(
      markerId: vehicleId,
      position: position,
      title: title,
      snippet: snippet,
      icon: vehicleIcon,
      onTap: onTap,
      rotation: rotation,
      flat: true,
      anchor: const Offset(0.5, 0.5),
    );
  }

  /// Helper method to resize bitmap descriptor
  static Future<BitmapDescriptor> _getResizedBitmapDescriptor(
    String assetPath, {
    int targetWidth = 32,
  }) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    final ByteData? resizedImage = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(resizedImage!.buffer.asUint8List());
  }

  /// Creates a geofence circle marker
  static Marker createGeofenceCircleMarker({
    required LatLng position,
    bool draggable = false,
    Function(LatLng)? onDragEnd,
  }) {
    return createMarker(
      markerId: "geofence_marker",
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      draggable: draggable,
      onDragEnd: onDragEnd,
    );
  }

  /// Creates a polygon point marker
  static Marker createPolygonPointMarker({
    required int index,
    required LatLng position,
    bool draggable = false,
    Function(LatLng)? onDragEnd,
  }) {
    return createMarker(
      markerId: "polygon_point_$index",
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      draggable: draggable,
      onDragEnd: onDragEnd,
    );
  }

  /// Creates a polyline point marker
  static Marker createPolylinePointMarker({
    required int index,
    required LatLng position,
    bool draggable = false,
    Function(LatLng)? onDragEnd,
  }) {
    return createMarker(
      markerId: "polyline_point_$index",
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      draggable: draggable,
      onDragEnd: onDragEnd,
    );
  }

  /// Creates a circle for geofence
  static Circle createGeofenceCircle({
    required LatLng center,
    required double radius,
    Color fillColor = const Color(0x330000FF), // Blue with 20% opacity
    Color strokeColor = Colors.blue,
    int strokeWidth = 2,
  }) {
    return Circle(
      circleId: const CircleId("geofence_circle"),
      center: center,
      radius: radius,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
    );
  }

  /// Creates a polygon for geofence
  static Polygon createGeofencePolygon({
    required List<LatLng> points,
    Color fillColor = const Color(0x3300FF00), // Green with 20% opacity
    Color strokeColor = Colors.green,
    int strokeWidth = 2,
  }) {
    return Polygon(
      polygonId: const PolygonId("geofence_polygon"),
      points: points,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
    );
  }

  /// Creates a polyline for geofence
  static Polyline createGeofencePolyline({
    required List<LatLng> points,
    Color color = Colors.red,
    int width = 3,
  }) {
    return Polyline(
      polylineId: const PolylineId("geofence_polyline"),
      points: points,
      color: color,
      width: width,
    );
  }

  /// Creates a path polyline
  static Polyline createPathPolyline({
    required List<LatLng> points,
    Color color = Colors.blueAccent,
    int width = 5,
  }) {
    return Polyline(
      polylineId: const PolylineId("pathReplay"),
      points: points,
      color: color,
      width: width,
    );
  }

  /// Animates camera to a specific location
  static Future<void> animateToLocation(
    GoogleMapController controller,
    LatLng location, {
    double zoom = _defaultZoom,
  }) async {
    await MapHelper.animateTo(controller, location, zoom: zoom);
  }

  /// Animates camera to fit bounds
  static Future<void> animateToBounds(
    GoogleMapController controller,
    List<LatLng> points, {
    double padding = 50.0,
  }) async {
    if (points.isEmpty) return;

    final bounds = _getLatLngBounds(points);
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  /// Animates camera to follow a moving object
  static Future<void> animateToFollow(
    GoogleMapController controller,
    LatLng position,
  ) async {
    await controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  /// Gets current location and animates to it
  static Future<void> animateToCurrentLocation(
    GoogleMapController controller, {
    double zoom = _defaultZoom,
  }) async {
    final currentLocation = await MapHelper.getCurrentLocation();
    if (currentLocation != null) {
      await animateToLocation(controller, currentLocation, zoom: zoom);
    }
  }

  /// Calculates bounds for a list of points
  static LatLngBounds _getLatLngBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        southwest: _defaultLocation,
        northeast: _defaultLocation,
      );
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Gets center point from bounds
  static LatLng _getCenterFromBounds(LatLngBounds bounds) {
    return LatLng(
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
    );
  }

  /// Calculates zoom level for bounds
  static double _calculateZoomForBounds(LatLngBounds bounds, double padding) {
    // Simple zoom calculation - can be improved with more sophisticated logic
    final latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
    final lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    if (maxDiff > 10) return _defaultZoomWide;
    if (maxDiff > 1) return _defaultZoomClose;
    return _defaultZoom;
  }

  /// Gets center of polygon points
  static LatLng getPolygonCenter(List<LatLng> points) {
    if (points.isEmpty) return _defaultLocation;

    double lat = 0;
    double lng = 0;
    for (var point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  /// Gets center of polyline points
  static LatLng getPolylineCenter(List<LatLng> points) {
    if (points.isEmpty) return _defaultLocation;

    double lat = 0;
    double lng = 0;
    for (var point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  /// Creates a floating action button for map controls
  static Widget createMapFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    String? heroTag,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.blue,
      elevation: 4,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  /// Creates a custom floating button for map controls
  static Widget createCustomFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            isActive
                ? Colors.blue.withValues(alpha: 0.8)
                : (color ?? Colors.white),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: isActive ? Colors.white : Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  /// Creates a map controller completer
  static Completer<GoogleMapController> createMapController() {
    return Completer<GoogleMapController>();
  }

  /// Handles map creation with common logic
  static void handleMapCreated(
    GoogleMapController controller,
    Completer<GoogleMapController> completer,
    VoidCallback? onMapCreated,
  ) {
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
    onMapCreated?.call();
  }

  /// Creates direction arrows along a polyline using small arrow icons
  static Future<Set<Marker>> createDirectionArrows({
    required List<LatLng> points,
    required String polylineId,
    Color arrowColor = Colors.blue,
    double arrowSize = 24.0, // Larger size for better visibility
    int arrowSpacing = 3, // Show arrow every N points
  }) async {
    final Set<Marker> arrows = {};

    if (points.length < 2) return arrows;

    // Create small arrow icon
    final arrowIcon = await createSmallArrowIcon(
      arrowColor: arrowColor,
      size: arrowSize,
    );

    // Calculate arrow positions along the polyline
    for (int i = 0; i < points.length - 1; i += arrowSpacing) {
      final start = points[i];
      final end = points[i + 1];

      // Calculate midpoint for arrow position
      final midLat = (start.latitude + end.latitude) / 2;
      final midLng = (start.longitude + end.longitude) / 2;
      final arrowPosition = LatLng(midLat, midLng);

      // Calculate bearing for arrow rotation
      final bearing = _calculateBearing(start, end);

      // Create small arrow marker with correct rotation
      arrows.add(
        Marker(
          markerId: MarkerId('${polylineId}_arrow_$i'),
          position: arrowPosition,
          icon: arrowIcon,
          rotation: bearing,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Direction',
            snippet: 'Bearing: ${bearing.toStringAsFixed(1)}°',
          ),
        ),
      );
    }

    return arrows;
  }

  /// Creates a small arrow icon for direction indicators
  static Future<BitmapDescriptor> createSmallArrowIcon({
    Color arrowColor = Colors.blue,
    double size = 16.0,
  }) async {
    try {
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final paint =
          Paint()
            ..color = arrowColor
            ..style = PaintingStyle.fill;

      final path = Path();

      // Arrow head pointing up (will be rotated based on bearing)
      path.moveTo(size / 2, 0);
      path.lineTo(size * 0.2, size * 0.6);
      path.lineTo(size * 0.4, size * 0.6);
      path.lineTo(size * 0.4, size);
      path.lineTo(size * 0.6, size);
      path.lineTo(size * 0.6, size * 0.6);
      path.lineTo(size * 0.8, size * 0.6);
      path.close();

      canvas.drawPath(path, paint);

      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      return BitmapDescriptor.bytes(bytes);
    } catch (e) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  /// Creates stop markers for positions with stop time using different icons based on stop type
  static Set<Marker> createStopMarkers({required List<dynamic> pathPositions}) {
    final Set<Marker> stopMarkers = {};

    for (int i = 0; i < pathPositions.length; i++) {
      final position = pathPositions[i];

      final hasStopTime =
          position.stopTime != null &&
          position.stopTime!.isNotEmpty &&
          position.stopTime != 'null';

      if (hasStopTime &&
          position.latitude != null &&
          position.longitude != null) {
        // Determine stop type based on available data
        final stopType = _determineStopType(position);
        final stopIcon = _getStopTypeIcon(stopType);
        final stopTitle = _getStopTypeTitle(stopType);
        final stopSnippet = _getStopTypeSnippet(stopType, position);

        stopMarkers.add(
          Marker(
            markerId: MarkerId('stop_$i'),
            position: LatLng(position.latitude!, position.longitude!),
            icon: stopIcon,
            flat: true,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(title: stopTitle, snippet: stopSnippet),
          ),
        );
      }
    }
    return stopMarkers;
  }

  /// Determines the type of stop based on position data
  static String _determineStopType(dynamic position) {
    // Check if ignition is off during stop
    final isIgnitionOff =
        position.ignition == 'off' || position.ignition == 'false';

    // Check if vehicle is stationary
    final isStationary = position.motion == 'false' || position.motion == '0';

    // Check speed (if available)
    final speed = position.speed ?? 0.0;
    final isLowSpeed = speed < 5.0; // Consider stops below 5 km/h

    // Determine stop type
    if (isIgnitionOff) {
      return 'ignition_off';
    } else if (isStationary && isLowSpeed) {
      return 'traffic_stop';
    } else if (isLowSpeed) {
      return 'slow_movement';
    } else {
      return 'general_stop';
    }
  }

  /// Gets the appropriate icon for the stop type
  static BitmapDescriptor _getStopTypeIcon(String stopType) {
    switch (stopType) {
      case 'ignition_off':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'traffic_stop':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
      case 'slow_movement':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      case 'general_stop':
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  /// Gets the title for the stop type
  static String _getStopTypeTitle(String stopType) {
    switch (stopType) {
      case 'ignition_off':
        return 'Engine Off Stop';
      case 'traffic_stop':
        return 'Traffic Stop';
      case 'slow_movement':
        return 'Slow Movement';
      case 'general_stop':
      default:
        return 'Stop Point';
    }
  }

  /// Gets the snippet (description) for the stop type
  static String _getStopTypeSnippet(String stopType, dynamic position) {
    final stopTime = position.stopTime ?? 'Unknown';

    switch (stopType) {
      case 'ignition_off':
        return 'Engine stopped • Stop Time: $stopTime';
      case 'traffic_stop':
        return 'Traffic signal/light • Stop Time: $stopTime';
      case 'slow_movement':
        return 'Slow speed movement • Stop Time: $stopTime';
      case 'general_stop':
      default:
        return 'Vehicle stopped • Stop Time: $stopTime';
    }
  }

  /// Calculates bearing between two points
  static double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * 3.14159 / 180.0;
    final lon1 = start.longitude * 3.14159 / 180.0;
    final lat2 = end.latitude * 3.14159 / 180.0;
    final lon2 = end.longitude * 3.14159 / 180.0;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180.0 / 3.14159 + 360.0) % 360.0;
  }
}
