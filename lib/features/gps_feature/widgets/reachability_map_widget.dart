import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/app_colors.dart';

class ReachabilityMapWidget extends StatefulWidget {
  final LatLng center;
  final double? radius;
  final Function(LatLng)? onLocationSelected;
  final bool showRadius;

  const ReachabilityMapWidget({
    super.key,
    required this.center,
    this.radius,
    this.onLocationSelected,
    this.showRadius = true,
  });

  @override
  State<ReachabilityMapWidget> createState() => _ReachabilityMapWidgetState();
}

class _ReachabilityMapWidgetState extends State<ReachabilityMapWidget> {
  GoogleMapController? _mapController;
  LatLng _currentCenter = const LatLng(12.9716, 77.5946);
  double _currentRadius = 500.0;
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.center;
    _currentRadius = widget.radius ?? 500.0;
    _updateMapElements();
  }

  @override
  void didUpdateWidget(ReachabilityMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.center != oldWidget.center ||
        widget.radius != oldWidget.radius) {
      _currentCenter = widget.center;
      _currentRadius = widget.radius ?? 500.0;
      _updateMapElements();
    }
  }

  void _updateMapElements() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('center_marker'),
          position: _currentCenter,
          infoWindow: const InfoWindow(
            title: 'Selected Location',
            snippet: 'Tap to change location',
          ),
        ),
      };

      if (widget.showRadius) {
        _circles = {
          Circle(
            circleId: const CircleId('reachability_circle'),
            center: _currentCenter,
            radius: _currentRadius,
            fillColor: AppColors.primaryColor.withOpacity(0.2),
            strokeColor: AppColors.primaryColor,
            strokeWidth: 2,
          ),
        };
      }
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentCenter = position;
      _updateMapElements();
    });

    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(position);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _currentCenter, zoom: 12),
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      markers: _markers,
      circles: _circles,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      mapType: MapType.normal,
      onCameraMove: (CameraPosition position) {
        // Update center when camera moves
        if (position.target != _currentCenter) {
          setState(() {
            _currentCenter = position.target;
            _updateMapElements();
          });
        }
      },
    );
  }
}
