import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/network/api_service.dart';
import '../../../dependency_injection/locator.dart';
import '../cubit/path_replay_cubit.dart';
import '../cubit/path_replay_state.dart';
import '../repository/path_replay_repository.dart';
import '../service/path_replay_service.dart';

class PathReplayScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> queryParams;
  final String? vehicleNumber;
  final String? routeType;

  const PathReplayScreen({
    super.key,
    required this.token,
    required this.queryParams,
    this.vehicleNumber,
    this.routeType,
  });

  @override
  Widget build(BuildContext context) {
    final routeType =
        this.routeType ?? queryParams['route_type']?.toString() ?? 'replay';

    return BlocProvider(
      create: (_) {
        final cubit = PathReplayCubit(
          PathReplayRepository(PathReplayService(locator<ApiService>())),
        );

        // Initialize data based on route type
        if (routeType == 'ignition') {
          // For ignition path, use the new trip path API
          final deviceId = queryParams['device_ids'];
          if (deviceId != null) {
            cubit.fetchTripPath(token, deviceId);
          }
        } else if (routeType == 'daily') {
          // For daily path, use regular path replay API with today's date range
          final deviceId = queryParams['device_ids'];
          if (deviceId != null) {
            // Create today's date range (00:00:00 to current time)
            final now = DateTime.now();
            final startOfDay = DateTime(now.year, now.month, now.day);

            final dailyQueryParams = {
              "start": startOfDay.toUtc().toIso8601String(),
              "end": now.toUtc().toIso8601String(),
              "timezone_offset": "0",
              "inputs": {},
              "device_ids": deviceId,
              "fwd_variable": 0.0,
            };

            cubit.fetchPathReplay(token, dailyQueryParams);
          }
        } else {
          // For regular path replay
          cubit.fetchPathReplay(token, queryParams);
        }

        return cubit;
      },
      child: PathReplayView(
        vehicleNumber:
            vehicleNumber ?? queryParams['vehicleNumber']?.toString() ?? '',
        routeType: routeType,
      ),
    );
  }
}

class PathReplayView extends StatelessWidget {
  final String vehicleNumber;
  final String routeType;

  const PathReplayView({
    super.key,
    required this.vehicleNumber,
    required this.routeType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PathReplayCubit, PathReplayState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PathReplayState state,
  ) {
    String routeTypeTitle;
    switch (routeType) {
      case 'ignition':
        routeTypeTitle = 'Ignition Path';
        break;
      case 'daily':
        routeTypeTitle = 'Daily Path';
        break;
      case 'replay':
      default:
        routeTypeTitle = 'Path Replay';
        break;
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                routeTypeTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (state.isLoading) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                vehicleNumber.isNotEmpty ? vehicleNumber : 'Vehicle',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              if (state.stopsCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2A5B),
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
                ),
            ],
          ),
        ],
      ),
      toolbarHeight: 60,
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Widget _buildBody(BuildContext context, PathReplayState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading path data...'),
          ],
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error Loading Path Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<PathReplayCubit>().retry();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final hasData =
        state.pathType == 'ignition'
            ? state.tripPathPositions.isNotEmpty
            : state.pathPositions.isNotEmpty;

    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No Path Data Available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'No location data found for the selected time period.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<PathReplayCubit>().retry();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        PathReplayMapWidget(state: state),
        _buildAddressOverlay(context, state),
        _buildBottomStatsPanel(context, state),
      ],
    );
  }

  Widget _buildAddressOverlay(BuildContext context, PathReplayState state) {
    final hasData =
        state.pathType == 'ignition'
            ? state.tripPathPositions.isNotEmpty
            : state.pathPositions.isNotEmpty;

    if (!hasData) return const SizedBox.shrink();

    // Don't show address overlay for ignition and daily paths since we're not tracking current position
    if (state.pathType == 'ignition' || state.pathType == 'daily')
      return const SizedBox.shrink();

    final currentIndex = state.currentIndex.clamp(
      0,
      state.pathType == 'ignition'
          ? state.tripPathPositions.length - 1
          : state.pathPositions.length - 1,
    );

    final currentPosition = LatLng(
      state.pathPositions[currentIndex].latitude!,
      state.pathPositions[currentIndex].longitude!,
    );

    return Positioned(
      top: 120,
      left: 30,
      right: 30,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            state.currentAddress,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomStatsPanel(BuildContext context, PathReplayState state) {
    final hasData =
        state.pathType == 'ignition'
            ? state.tripPathPositions.isNotEmpty
            : state.pathPositions.isNotEmpty;

    if (!hasData) return const SizedBox.shrink();

    final currentIndex = state.currentIndex.clamp(
      0,
      state.pathType == 'ignition'
          ? state.tripPathPositions.length - 1
          : state.pathPositions.length - 1,
    );

    final currentSpeed =
        state.pathType == 'ignition'
            ? state.tripPathPositions[currentIndex].speed ?? 0
            : state.pathPositions[currentIndex].speed ?? 0;

    final currentDistance =
        state.pathType == 'ignition'
            ? state.tripPathPositions[currentIndex].totalDistance ?? 0
            : state.pathPositions[currentIndex].totalDistance ?? 0;

    final totalDistance =
        state.pathType == 'ignition'
            ? state.tripPathPositions.isNotEmpty
                ? state.tripPathPositions.last.totalDistance ?? 0
                : 0
            : state.pathPositions.isNotEmpty
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
              // Only show playback controls for non-ignition and non-daily paths
              if (routeType != 'ignition' && routeType != 'daily') ...[
                const SizedBox(height: 18),
                // Slider Row
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          final cubit = context.read<PathReplayCubit>();
                          if (state.isPlaying) {
                            cubit.pause();
                          } else {
                            cubit.play();
                          }
                        },
                        child: Icon(
                          state.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: const Color(0xFF0062FF),
                          size: 38,
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          hasData
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
                                      (state.pathType == 'ignition'
                                              ? state.tripPathPositions.length -
                                                  1
                                              : state.pathPositions.length - 1)
                                          .toDouble(),
                                  divisions:
                                      state.pathType == 'ignition'
                                          ? (state.tripPathPositions.length > 1
                                              ? state.tripPathPositions.length -
                                                  1
                                              : 1)
                                          : (state.pathPositions.length > 1
                                              ? state.pathPositions.length - 1
                                              : 1),
                                  onChanged: (value) {
                                    context.read<PathReplayCubit>().seek(
                                      value.toInt(),
                                    );
                                  },
                                ),
                              )
                              : Container(
                                height: 24,
                                color: Colors.transparent,
                              ),
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
                                selected
                                    ? const Color(0xFF0062FF)
                                    : Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}

class PathReplayMapWidget extends StatefulWidget {
  final PathReplayState state;

  const PathReplayMapWidget({super.key, required this.state});

  @override
  State<PathReplayMapWidget> createState() => _PathReplayMapWidgetState();
}

class _PathReplayMapWidgetState extends State<PathReplayMapWidget> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PathReplayCubit, PathReplayState>(
      listener: (context, state) {
        _handleStateChange(state);
      },
      child: _buildMap(),
    );
  }

  Widget _buildMap() {
    final pathPoints =
        widget.state.pathType == 'ignition'
            ? widget.state.tripPathPositions
                .map((pos) => LatLng(pos.latitude!, pos.longitude!))
                .toList()
            : widget.state.pathPositions
                .map((pos) => LatLng(pos.latitude!, pos.longitude!))
                .toList();

    final currentIndex = widget.state.currentIndex.clamp(
      0,
      pathPoints.length - 1,
    );
    final currentPosition =
        pathPoints.isNotEmpty ? pathPoints[currentIndex] : null;

    final markers = <Marker>{};

    if (currentPosition != null) {
      if (widget.state.pathType == 'ignition' ||
          widget.state.pathType == 'daily') {
        // For ignition and daily paths, show static vehicle icon (same as regular path but without rotation)
        if (widget.state.truckIcon != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('vehicle'),
              position: currentPosition,
              icon: widget.state.truckIcon!,
              flat: true,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Vehicle Position',
                snippet:
                    widget.state.pathType == 'ignition'
                        ? "Speed: ${widget.state.tripPathPositions[currentIndex].speed?.toStringAsFixed(1) ?? 0} Km/h"
                        : "Speed: ${widget.state.pathPositions[currentIndex].speed?.toStringAsFixed(1) ?? 0} Km/h",
              ),
            ),
          );
        }
      } else if (widget.state.truckIcon != null) {
        // For regular paths, show animated truck marker
        final cubit = context.read<PathReplayCubit>();
        markers.add(
          Marker(
            markerId: const MarkerId('truck'),
            position: widget.state.animatedMarkerPosition ?? currentPosition,
            icon: widget.state.truckIcon!,
            rotation: cubit.getCurrentRotation(),
            flat: true,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(
              title: widget.state.currentAddress,
              snippet:
                  "Speed: ${widget.state.pathPositions[currentIndex].speed?.toStringAsFixed(1) ?? 0} Km/h",
            ),
          ),
        );
      }
    }

    final polyline = Polyline(
      polylineId: const PolylineId('pathReplay'),
      color: Colors.blueAccent,
      width: 5,
      points: pathPoints,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition ?? const LatLng(20.5937, 78.9629),
        zoom: 14.0,
      ),
      polylines: {polyline},
      markers: markers,
      onMapCreated: (controller) {
        _mapController.complete(controller);
        _handleMapCreated(controller);
      },
    );
  }

  void _handleMapCreated(GoogleMapController controller) {
    final cubit = context.read<PathReplayCubit>();

    // Fit map to path if not already done
    if (!widget.state.hasFitToPath &&
        (widget.state.pathType == 'ignition'
            ? widget.state.tripPathPositions.length > 1
            : widget.state.pathPositions.length > 1)) {
      cubit.setHasFitToPath(true);
      final bounds = cubit.getPathBounds();
      if (bounds != null) {
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
      }
    }
  }

  void _handleStateChange(PathReplayState state) async {
    if (!_mapController.isCompleted) return;

    final controller = await _mapController.future;

    // Follow truck during playback (only for regular paths, not ignition or daily)
    if (state.hasFitToPath &&
        state.animatedMarkerPosition != null &&
        state.isPlaying &&
        state.pathType != 'ignition' &&
        state.pathType != 'daily') {
      controller.animateCamera(
        CameraUpdate.newLatLng(state.animatedMarkerPosition!),
      );
    }
  }
}
