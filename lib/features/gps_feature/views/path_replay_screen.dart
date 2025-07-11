import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../cubit/path_replay_cubit.dart';
import '../cubit/path_replay_state.dart';
import '../model/path_positions_pojo.dart';

class PathReplayScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> queryParams;
  final String? vehicleNumber;

  const PathReplayScreen({
    super.key,
    required this.token,
    required this.queryParams,
    this.vehicleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              context.read<PathReplayCubit>()
                ..fetchPathReplay(token, queryParams),
      child: PathReplayView(
        vehicleNumber:
            vehicleNumber ?? queryParams['vehicleNumber']?.toString() ?? '',
      ),
    );
  }
}

class PathReplayView extends StatefulWidget {
  final String vehicleNumber;
  const PathReplayView({super.key, required this.vehicleNumber});

  @override
  State<PathReplayView> createState() => _PathReplayViewState();
}

class _PathReplayViewState extends State<PathReplayView> {
  final Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor? truckIcon;
  String currentAddress = "Loading address...";
  bool _hasFitToPath = false; // For initial fit
  LatLng? _animatedMarkerPosition;
  Timer? _markerAnimationTimer;
  int? _lastAnimatedIndex;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/png/vp.png',
    );
    setState(() {
      truckIcon = icon;
    });
  }

  Future<String> getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = placemarks.first;
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Unknown location";
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * math.pi / 180.0;
    final lon1 = start.longitude * math.pi / 180.0;
    final lat2 = end.latitude * math.pi / 180.0;
    final lon2 = end.longitude * math.pi / 180.0;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180.0 / math.pi + 360.0) % 360.0;
  }

  Future<void> _fitMapToPolyline(List<LatLng> points) async {
    if (points.isEmpty) return;
    final GoogleMapController controller = await _mapController.future;
    final bounds = _createLatLngBounds(points);
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  LatLngBounds _createLatLngBounds(List<LatLng> points) {
    double x0 = points.first.latitude, x1 = points.first.latitude;
    double y0 = points.first.longitude, y1 = points.first.longitude;
    for (LatLng latLng in points) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  void _animateMarker(LatLng from, LatLng to, {int durationMs = 400}) {
    _markerAnimationTimer?.cancel();
    const int steps = 20;
    int currentStep = 0;
    _animatedMarkerPosition = from;

    _markerAnimationTimer = Timer.periodic(
      Duration(milliseconds: durationMs ~/ steps),
      (timer) {
        currentStep++;
        final double t = currentStep / steps;
        final double lat = from.latitude + (to.latitude - from.latitude) * t;
        final double lng = from.longitude + (to.longitude - from.longitude) * t;
        setState(() {
          _animatedMarkerPosition = LatLng(lat, lng);
        });
        if (currentStep >= steps) {
          timer.cancel();
          setState(() {
            _animatedMarkerPosition = to;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PathReplayCubit, PathReplayState>(
      builder: (context, state) {
        final pathPoints =
            state.pathPositions
                .map((pos) => LatLng(pos.latitude!, pos.longitude!))
                .toList();

        final currentIndex =
            state.pathPositions.isNotEmpty
                ? state.currentIndex.clamp(0, state.pathPositions.length - 1)
                : 0;

        final currentPosition =
            pathPoints.isNotEmpty ? pathPoints[currentIndex] : null;
        final previousPosition =
            (pathPoints.isNotEmpty && currentIndex > 0)
                ? pathPoints[currentIndex - 1]
                : currentPosition;

        // Animate marker smoothly when currentIndex changes
        if (_lastAnimatedIndex != currentIndex &&
            previousPosition != null &&
            currentPosition != null) {
          _lastAnimatedIndex = currentIndex;
          // Animation duration scales with playback speed (faster speed = shorter duration)
          final int durationMs =
              (400 / state.playbackSpeed).clamp(80, 400).toInt();
          _animateMarker(
            _animatedMarkerPosition ?? previousPosition,
            currentPosition,
            durationMs: durationMs,
          );
        }

        // Show address
        if (currentPosition != null) {
          getAddress(currentPosition).then((address) {
            if (mounted) {
              setState(() {
                currentAddress = address;
              });
            }
          });
        }

        // --- Initial fit to path ---
        if (!_hasFitToPath && pathPoints.length > 1) {
          _hasFitToPath = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitMapToPolyline(pathPoints);
          });
        }

        // --- Follow truck during playback (use animated marker position) ---
        if (_hasFitToPath &&
            _animatedMarkerPosition != null &&
            state.isPlaying) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final controller = await _mapController.future;
            controller.animateCamera(
              CameraUpdate.newLatLng(_animatedMarkerPosition!),
            );
          });
        }

        double rotation = 0;
        if (currentIndex > 0 && currentIndex < pathPoints.length) {
          rotation = _calculateBearing(
            pathPoints[currentIndex - 1],
            currentPosition!,
          );
        }

        final markers = <Marker>{};
        if (currentPosition != null && truckIcon != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('truck'),
              position: _animatedMarkerPosition ?? currentPosition,
              icon: truckIcon!,
              rotation: rotation,
              flat: true,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: currentAddress,
                snippet:
                    "Speed:  {state.pathPositions[currentIndex].speed?.toStringAsFixed(1) ?? 0} Km/h",
              ),
            ),
          );
        }

        final polyline = Polyline(
          polylineId: const PolylineId('pathReplay'),
          color: Colors.blueAccent,
          width: 5,
          points: pathPoints,
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Path Replay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      widget.vehicleNumber.isNotEmpty
                          ? widget.vehicleNumber
                          : 'Vehicle',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<PathReplayCubit, PathReplayState>(
                      builder: (context, state) {
                        return state.stopsCount > 0
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF1B2A5B),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${state.stopsCount} Stops',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
            toolbarHeight: 60,
            backgroundColor: Colors.white,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition ?? const LatLng(20.5937, 78.9629),
                  zoom: 14.0,
                ),
                polylines: {polyline},
                markers: markers,
                onMapCreated: (controller) {
                  _mapController.complete(controller);
                },
              ),
              if (currentPosition != null)
                Positioned(
                  top: 120,
                  left: 30,
                  right: 30,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        currentAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
              _buildBottomStatsPanel(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomStatsPanel(BuildContext context, PathReplayState state) {
    final currentSpeed =
        state.pathPositions.isNotEmpty
            ? state.pathPositions[state.currentIndex].speed ?? 0
            : 0;
    final currentDistance =
        state.pathPositions.isNotEmpty
            ? state.pathPositions[state.currentIndex].totalDistance ?? 0
            : 0;
    final totalDistance =
        state.pathPositions.isNotEmpty
            ? state.pathPositions.last.totalDistance ?? 0
            : 0;
    final stops = state.stopsCount;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stats Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Speed
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2A5B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${currentSpeed.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Km/h',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // Current Distance
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentDistance.toStringAsFixed(0)} Kms',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0062FF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Current Distance',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFB0B0B0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Total & Stops
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0062FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${totalDistance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A3B1E),
                              ),
                            ),
                            const Text(
                              ' Kms',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A3B1E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2A5B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$stops Stops',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Slider Row
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (state.isPlaying) {
                          context.read<PathReplayCubit>().pause();
                        } else {
                          context.read<PathReplayCubit>().play();
                        }
                      },
                      child: Icon(
                        state.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Color(0xFF0062FF),
                        size: 38,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        state.pathPositions.isNotEmpty
                            ? SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF0062FF),
                                inactiveTrackColor: const Color(0xFFD1D1D1),
                                trackHeight: 6.0,
                                thumbColor: const Color(0xFF0062FF),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 11,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: state.currentIndex.toDouble(),
                                min: 0,
                                max:
                                    (state.pathPositions.length - 1).toDouble(),
                                divisions:
                                    state.pathPositions.length > 1
                                        ? state.pathPositions.length - 1
                                        : 1,
                                onChanged: (value) {
                                  context.read<PathReplayCubit>().seek(
                                    value.toInt(),
                                  );
                                },
                              ),
                            )
                            : Container(height: 24, color: Colors.transparent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Speed label and buttons
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      'Speed',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...[1.0, 2.0, 4.0, 8.0, 16.0].map((speed) {
                    final bool selected = state.playbackSpeed == speed;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<PathReplayCubit>().changeSpeed(speed);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              selected ? const Color(0xFF0062FF) : Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFB0B0B0),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(48, 38),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "${speed.toInt()}X",
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
