import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../helpers/map_helper.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_text_field.dart';
import '../../../utils/extra_utils.dart';
import '../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../cubit/gps_geofence_map_cubit/gps_geofence_map_cubit.dart';
import '../cubit/gps_geofence_map_cubit/gps_geofence_map_state.dart';
import '../models/gps_geofence_model.dart';

class GeofenceMapViewScreen extends StatefulWidget {
  final GpsGeofenceModel? geofence; // Now nullable for new geofences
  final ValueChanged<GpsGeofenceModel>? onSave; // Callback for saving

  const GeofenceMapViewScreen({
    super.key,
    this.geofence, // Can be null for new geofence
    this.onSave,
  });

  @override
  State<GeofenceMapViewScreen> createState() => _GeofenceMapViewScreenState();
}

class _GeofenceMapViewScreenState extends State<GeofenceMapViewScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentCenter;
  double _currentRadius = 500; // Default for new circles
  List<LatLng> _currentPolygonPoints = [];
  List<LatLng> _currentPolylinePoints = [];

  Set<Circle> _circles = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  MapType _mapType = MapType.normal;

  void _toggleMapType() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  final TextEditingController _geofenceNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late GeofenceMode _mode; // Current mode of interaction
  GpsGeofenceModel? _activeGeofence; // The geofence being created/edited

  @override
  void initState() {
    super.initState();

    if (widget.geofence == null) {
      // Scenario 2: Adding a new geofence - default to drawing a circle
      _mode = GeofenceMode.addCircle;
      _activeGeofence = GpsGeofenceModel.newCircle();
      _geofenceNameController.text = _activeGeofence!.name;

      _handleCurrentLocation();
    } else {
      // Scenario 1: Viewing/Editing an existing geofence
      _activeGeofence = widget.geofence!;
      _geofenceNameController.text = _activeGeofence!.name;
      _mode = _getInitialModeForExistingGeofence(
        _activeGeofence!,
      ); // Start in edit mode

      if (_activeGeofence!.shapeType == "circle") {
        _currentCenter =
            _activeGeofence!.center ?? const LatLng(28.6139, 77.2090);
        // _currentRadius = _activeGeofence!.radius ?? 500;
        _currentRadius = (_activeGeofence!.radius ?? 500).clamp(40.0, 20040.0);
        _setCircle(_currentCenter!, _currentRadius);
        _setMarker(
          _currentCenter!,
          isDraggable: _mode == GeofenceMode.editCircle,
        );
      } else if (_activeGeofence!.shapeType == "polygon") {
        _currentPolygonPoints = _activeGeofence!.polygonPoints ?? [];
        if (_currentPolygonPoints.isNotEmpty) {
          _currentCenter = _getPolygonCenter(
            _currentPolygonPoints,
          ); // Calculate center for camera
          _setPolygon(_currentPolygonPoints);
          _setPolygonMarkers(
            _currentPolygonPoints,
            isDraggable: _mode == GeofenceMode.editPolygon,
          );
        }
      } else if (_activeGeofence!.shapeType == "polyline") {
        _currentPolylinePoints = _activeGeofence!.polygonPoints ?? [];
        if (_currentPolylinePoints.isNotEmpty) {
          _currentCenter = _getPolylineCenter(
            _currentPolylinePoints,
          ); // Calculate center for camera
          _setPolyline(_currentPolylinePoints);
          _setPolylineMarkers(
            _currentPolylinePoints,
            isDraggable: _mode == GeofenceMode.editPolyline,
          );
        }
      }
    }
  }

  // Determines the initial mode when an existing geofence is loaded
  GeofenceMode _getInitialModeForExistingGeofence(GpsGeofenceModel geofence) {
    switch (geofence.shapeType) {
      case "circle":
        return GeofenceMode.editCircle;
      case "polygon":
        return GeofenceMode.editPolygon;
      case "polyline":
        return GeofenceMode.editPolyline;
      default:
        return GeofenceMode.view; // Fallback if shapeType is unknown
    }
  }

  Future<void> _handleCurrentLocation() async {
    final pos = await MapHelper.getCurrentLocation();
    if (pos != null) {
      setState(() {
        _currentCenter = pos;
        _setCircle(pos, _currentRadius);
        _setMarker(pos, isDraggable: true);
      });
      if (_mapController != null) {
        await MapHelper.animateTo(_mapController!, pos);
      }
    }
  }

  void _setCircle(LatLng center, double radius) {
    setState(() {
      _circles = {
        Circle(
          circleId: const CircleId("geofence_circle"),
          center: center,
          radius: radius,
          fillColor: Colors.blue.withValues(alpha: 0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      };
      _polygons = {}; // Clear other shapes
      _polylines = {};
    });
  }

  LatLng _getPolygonCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    double lat = 0;
    double lng = 0;
    for (var point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  void _setPolyline(List<LatLng> points) {
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId("geofence_polyline"),
          points: points,
          color: Colors.red,
          width: 3,
        ),
      };
      _circles = {};
      _polygons = {};
    });
    // Adjust camera to fit polyline after it's drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (points.isNotEmpty) {
        _moveCameraToPolyline(points);
      }
    });
  }

  LatLng _getPolylineCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    double lat = 0;
    double lng = 0;
    for (var point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  void _moveCameraToPolyline(List<LatLng> points) {
    final bounds = _getLatLngBounds(points);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _setPolygon(List<LatLng> points) {
    if (points.length >= 3) {
      setState(() {
        _polygons = {
          Polygon(
            polygonId: const PolygonId("geofence_polygon"),
            points: points,
            fillColor: Colors.green.withValues(alpha: 0.2),
            strokeColor: Colors.green,
            strokeWidth: 2,
          ),
        };
        _circles = {};
        _polylines = {};
      });
      // Adjust camera to fit the polygon after it's drawn
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraToPolygon(points);
      });
    } else {
      setState(() {
        _polygons = {}; // Clear if not enough points for a valid polygon
      });
    }
  }

  void _moveCameraToPolygon(List<LatLng> points) {
    final bounds = _getLatLngBounds(points);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    if (points.isEmpty) {
      // Fallback for empty points, perhaps center on the initial map target
      return LatLngBounds(
        southwest: const LatLng(28.5, 77.1),
        northeast: const LatLng(28.7, 77.3),
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

  void _setMarker(LatLng position, {bool isDraggable = false}) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("geofence_marker"),
          position: position,
          draggable: isDraggable,
          onDragEnd: (newPosition) {
            setState(() {
              _currentCenter = newPosition;
              _setCircle(_currentCenter!, _currentRadius);
            });
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      };
    });
  }

  void _setPolygonMarkers(List<LatLng> points, {bool isDraggable = false}) {
    setState(() {
      _markers.clear();
      for (int i = 0; i < points.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId("polygon_point_$i"),
            position: points[i],
            draggable: isDraggable,
            onDragEnd: (newPosition) {
              setState(() {
                _currentPolygonPoints[i] = newPosition;
                _setPolygon(_currentPolygonPoints);
              });
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }
    });
  }

  void _setPolylineMarkers(List<LatLng> points, {bool isDraggable = false}) {
    setState(() {
      _markers.clear();
      for (int i = 0; i < points.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId("polyline_point_$i"),
            position: points[i],
            draggable: isDraggable,
            onDragEnd: (newPosition) {
              setState(() {
                _currentPolylinePoints[i] = newPosition;
                _setPolyline(_currentPolylinePoints);
              });
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Move camera to initial position after map is created
    if (_activeGeofence!.shapeType == "circle" && _currentCenter != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentCenter!, 12),
      );
    } else if ((_activeGeofence!.shapeType == "polygon" ||
            _activeGeofence!.shapeType == "polyline") &&
        (_currentPolygonPoints.isNotEmpty ||
            _currentPolylinePoints.isNotEmpty)) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          _getLatLngBounds(_activeGeofence!.polygonPoints ?? []),
          50,
        ),
      );
    } else {
      // If no geofence or points, animate to a default location (e.g., Delhi)
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(const LatLng(28.6139, 77.2090), 5),
      );
    }
  }

  void _onMapTap(LatLng latLng) {
    if (_mode == GeofenceMode.addCircle) {
      setState(() {
        _currentCenter = latLng;
        _setCircle(_currentCenter!, _currentRadius);
        _setMarker(_currentCenter!, isDraggable: true);
      });
    } else if (_mode == GeofenceMode.addPolygon) {
      setState(() {
        _currentPolygonPoints.add(latLng);
        _setPolygon(_currentPolygonPoints);
        _setPolygonMarkers(_currentPolygonPoints, isDraggable: true);
      });
    } else if (_mode == GeofenceMode.addPolyline) {
      setState(() {
        _currentPolylinePoints.add(latLng);
        _setPolyline(_currentPolylinePoints);
        _setPolylineMarkers(_currentPolylinePoints, isDraggable: true);
      });
    }
  }

  // Resets the map and sets up for drawing a new geofence of the specified type
  void _resetMapForNewGeofence(String shapeType) {
    setState(() {
      _circles.clear();
      _polygons.clear();
      _polylines.clear();
      _markers.clear();
      _currentCenter = null;
      _currentRadius = 500; // Reset to default for new circle
      _currentPolygonPoints.clear();
      _currentPolylinePoints.clear();

      if (shapeType == "circle") {
        _mode = GeofenceMode.addCircle;
        _activeGeofence = GpsGeofenceModel.newCircle();
      } else if (shapeType == "polygon") {
        _mode = GeofenceMode.addPolygon;
        _activeGeofence = GpsGeofenceModel.newPolygon();
      } else if (shapeType == "polyline") {
        _mode = GeofenceMode.addPolyline;
        _activeGeofence = GpsGeofenceModel.newPolyline();
      }

      if (widget.geofence != null) {
        _activeGeofence!.id = widget.geofence!.id; // Preserve ID
        _activeGeofence!.name = widget.geofence!.name; // Preserve name
      }

      _geofenceNameController.text = _activeGeofence!.name; // Update name input
    });
  }

  void _saveGeofence() {
    if (_activeGeofence == null) return; // Should not happen

    _activeGeofence!.name = _geofenceNameController.text;

    if (_activeGeofence!.shapeType == "circle") {
      _activeGeofence!.center = _currentCenter;
      _activeGeofence!.radius = _currentRadius;
    } else if (_activeGeofence!.shapeType == "polygon") {
      _activeGeofence!.polygonPoints = _currentPolygonPoints;
    } else if (_activeGeofence!.shapeType == "polyline") {
      _activeGeofence!.polygonPoints = _currentPolylinePoints;
    }

    // Call the onSave callback to pass data back to the parent
    // widget.onSave?.call(_activeGeofence!);
    context.read<GpsGeofenceCubit>().submitGeofence(_activeGeofence!);
    // Navigator.pop(context); // Go back after saving
  }

  // Function to remove the last point for polygon/polyline drawing
  void _removeLastPoint() {
    setState(() {
      if (_mode == GeofenceMode.addPolygon &&
          _currentPolygonPoints.isNotEmpty) {
        _currentPolygonPoints.removeLast();
        _setPolygon(_currentPolygonPoints);
        _setPolygonMarkers(_currentPolygonPoints, isDraggable: true);
      } else if (_mode == GeofenceMode.addPolyline &&
          _currentPolylinePoints.isNotEmpty) {
        _currentPolylinePoints.removeLast();
        _setPolyline(_currentPolylinePoints);
        _setPolylineMarkers(_currentPolylinePoints, isDraggable: true);
      }
    });
  }

  Widget buildLocationSearchField(BuildContext context) {
    return AppTextField(
      controller: searchController,
      labelText: context.appText.search,
      hintText: context.appText.search,
      decoration: commonInputDecoration(
        suffixIcon: Icon(Icons.clear, size: 20),
        suffixOnTap: () {
          searchController.clear();
          context.read<GpsGeofenceMapCubit>().resetAutoCompleteState();
        },
      ),
      onChanged: (value) {
        if (value.isNotEmpty && value.length > 2) {
          context.read<GpsGeofenceMapCubit>().fetchAutoComplete(value);
        } else {
          context.read<GpsGeofenceMapCubit>().resetAutoCompleteState();
        }
      },
    );
  }

  Widget buildSuggestionListWidget(BuildContext context) {
    return BlocConsumer<GpsGeofenceMapCubit, GpsGeofenceMapState>(
      listenWhen:
          (prev, curr) =>
              prev is! GpsGeofenceMapError && curr is GpsGeofenceMapError,
      listener: (context, state) {
        if (state is GpsGeofenceMapError) {
          ToastMessages.error(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is GpsGeofenceMapAutoCompleteLoaded) {
          final suggestions = state.autoCompleteData.predictions;
          if (suggestions.isEmpty) return Container();
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return ListTile(
                  title: Text(item.description ?? context.appText.unknown),
                  onTap: () {
                    // Call verify location API
                    final request = VerifyLocationApiRequest(
                      placeId: item.placeId ?? "",
                      type: 1,
                    );
                    context.read<GpsGeofenceMapCubit>().verifyLocation(request);
                  },
                );
              },
            ),
          );
        }
        if (state is GpsGeofenceMapLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are in an "add" mode
    bool isAddMode =
        _mode == GeofenceMode.addCircle ||
        _mode == GeofenceMode.addPolygon ||
        _mode == GeofenceMode.addPolyline;

    // Determine if we are in an "edit" mode
    bool isEditMode =
        _mode == GeofenceMode.editCircle ||
        _mode == GeofenceMode.editPolygon ||
        _mode == GeofenceMode.editPolyline;

    // Determine if the current shape is a circle
    bool isCircleShape =
        _activeGeofence?.shapeType == "circle" &&
        (_mode == GeofenceMode.addCircle || _mode == GeofenceMode.editCircle);
    // Determine if the current shape is a polygon
    bool isPolygonShape =
        _activeGeofence?.shapeType == "polygon" &&
        (_mode == GeofenceMode.addPolygon || _mode == GeofenceMode.editPolygon);
    // Determine if the current shape is a polyline
    bool isPolylineShape =
        _activeGeofence?.shapeType == "polyline" &&
        (_mode == GeofenceMode.addPolyline ||
            _mode == GeofenceMode.editPolyline);

    return BlocListener<GpsGeofenceCubit, GpsGeofenceState>(
      listener: (context, state) {
        if (state is GpsGeofenceLoaded) {
          showSuccessDialog(
            context,
            text:
                widget.geofence == null
                    ? context.appText.geofenceAddedSuccess
                    : context.appText.geofenceUpdatedSuccess,
            subheading: '',
          );

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (state is GpsGeofenceError) {
          // Show error dialog if needed
          ToastMessages.error(message: state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentCenter ?? const LatLng(28.6139, 77.2090),
                  zoom: _currentCenter != null ? 12 : 5,
                ),
                mapType: _mapType,
                markers: _markers,
                circles: _circles,
                polygons: _polygons,
                polylines: _polylines,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onTap: _onMapTap, // Handles tap for drawing new shapes
              ),

              // AppBar with back & search (simplified for this example)
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // buildLocationSearchField(context).expand(),
                      AppIconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Implement search functionality
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Floating buttons for drawing/editing modes
              Positioned(
                right: 16,
                top: 150,
                child: Column(
                  children: [
                    // Button to add a new circle geofence
                    _buildFloatingButton(
                      Icons.circle_outlined,
                      () {
                        _resetMapForNewGeofence("circle");
                      },
                      isActive:
                          _mode == GeofenceMode.addCircle ||
                          _mode == GeofenceMode.editCircle,
                    ),
                    10.height,
                    // Button to add a new polygon geofence
                    _buildFloatingButton(
                      Icons.square_outlined,
                      () {
                        _resetMapForNewGeofence("polygon");
                      },
                      isActive:
                          _mode == GeofenceMode.addPolygon ||
                          _mode == GeofenceMode.editPolygon,
                    ),
                    10.height,
                    // Button to add a new polyline geofence
                    _buildFloatingButton(
                      Icons.timeline, // Using a timeline icon for polyline
                      () {
                        _resetMapForNewGeofence("polyline");
                      },
                      isActive:
                          _mode == GeofenceMode.addPolyline ||
                          _mode == GeofenceMode.editPolyline,
                    ),
                    10.height,
                    // Button to remove last point (only for polygon/polyline drawing)
                    if ((_mode == GeofenceMode.addPolygon &&
                            _currentPolygonPoints.isNotEmpty) ||
                        (_mode == GeofenceMode.addPolyline &&
                            _currentPolylinePoints.isNotEmpty))
                      _buildFloatingButton(
                        Icons.backspace,
                        _removeLastPoint,
                        color: Colors.white,
                      ),
                    10.height,
                    // Edit button - only show if an existing geofence is being viewed, to switch to edit mode
                    if (widget.geofence != null && !isEditMode && !isAddMode)
                      _buildFloatingButton(Icons.edit_outlined, () {
                        setState(() {
                          if (widget.geofence!.shapeType == "circle") {
                            _mode = GeofenceMode.editCircle;
                            _setMarker(
                              _currentCenter!,
                              isDraggable: true,
                            ); // Make marker draggable
                          } else if (widget.geofence!.shapeType == "polygon") {
                            _mode = GeofenceMode.editPolygon;
                            _setPolygonMarkers(
                              _currentPolygonPoints,
                              isDraggable: true,
                            );
                          } else if (widget.geofence!.shapeType == "polyline") {
                            _mode = GeofenceMode.editPolyline;
                            _setPolylineMarkers(
                              _currentPolylinePoints,
                              isDraggable: true,
                            );
                          }
                        });
                      }, color: Colors.blue),
                    10.height,
                    _buildFloatingButton(
                      _mapType == MapType.normal ? Icons.satellite : Icons.map,
                      _toggleMapType,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Bottom Sheet for Geofence Details and Actions
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display radius for circles or shape type for polygons/polylines
                      if (isCircleShape && _currentCenter != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('${context.appText.geofenceRadius}:'),
                                const SizedBox(width: 8),
                                Text(
                                  '${_currentRadius.toInt()} ${context.appText.metersShort}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Slider for adjusting circle radius
                            Slider(
                              value: _currentRadius.clamp(
                                40.0,
                                20040.0,
                              ), // Clamp for safety
                              min: 40.0,
                              max: 20040.0,
                              divisions: 100, // Adjust divisions as needed
                              label: '${_currentRadius.toStringAsFixed(1)} m',
                              onChanged: (value) {
                                setState(() {
                                  _currentRadius = value;
                                  if (_currentCenter != null) {
                                    _setCircle(_currentCenter!, _currentRadius);
                                  }
                                });
                              },
                            ),
                          ],
                        )
                      else if (isPolygonShape)
                        Text(
                          '${context.appText.polygonGeofence} (${_currentPolygonPoints.length} ${context.appText.points})',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (isPolylineShape)
                        Text(
                          '${context.appText.polylineGeofence} (${_currentPolylinePoints.length} ${context.appText.points})',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                         Text(
                          context.appText.selectGeofenceTypeHint,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      12.height,
                      // Geofence Name Input
                      AppTextField(
                        labelText: context.appText.geofenceName,
                        controller: _geofenceNameController,
                        onChanged: (text) {
                          if (_activeGeofence != null) {
                            _activeGeofence!.name = text; // Update model's name
                          }
                        },
                      ),
                      16.height,
                      // Confirm Button (Enable only if a valid shape is drawn)
                      ElevatedButton(
                        onPressed:
                            (_currentCenter != null && isCircleShape) ||
                                    (_currentPolygonPoints.length >= 3 &&
                                        isPolygonShape) ||
                                    (_currentPolylinePoints.length >= 2 &&
                                        isPolylineShape)
                                ? _saveGeofence
                                : null, // Disable button if no valid shape
                        style: AppButtonStyle.primary,
                        child: Center(
                          child: Text(
                            widget.geofence == null
                                ? context.appText.confirmLocation
                                : context.appText.updateGeofence,
                            style:
                                _currentCenter == null
                                    ? AppTextStyle.h5.copyWith(
                                      color: Colors.grey,
                                    )
                                    : AppTextStyle.h5WhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton(
    IconData icon,
    VoidCallback onPressed, {
    Color color = Colors.white,
    bool isActive = false, // New parameter to indicate active state
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withValues(alpha: 0.8) : color,
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
}

enum GeofenceMode {
  view, // For initial display of existing geofence, no active editing
  addCircle,
  addPolygon,
  addPolyline,
  editCircle,
  editPolygon,
  editPolyline,
}
