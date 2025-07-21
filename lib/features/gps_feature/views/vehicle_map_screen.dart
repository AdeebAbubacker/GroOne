import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/mixins/gps_refresh_mixin.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/widgets/map_floating_menu.dart';
import 'package:gro_one_app/features/gps_feature/views/path_replay_screen.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/app_share_helper.dart';

// Cubit for selected vehicle state
class SelectedVehicleCubit extends Cubit<GpsCombinedVehicleData?> {
  bool _isClosed = false;
  
  SelectedVehicleCubit() : super(null);
  
  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(null);
  }
  
  void select(GpsCombinedVehicleData? vehicle) {
    if (!_isClosed) {
      emit(vehicle);
    }
  }
}

class VehicleMapScreen extends StatefulWidget {
  final List<GpsCombinedVehicleData> vehicles;
  final GpsCombinedVehicleData? initialSelectedVehicle;
  const VehicleMapScreen({
    super.key,
    required this.vehicles,
    this.initialSelectedVehicle,
  });

  @override
  State<VehicleMapScreen> createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen>
    with GpsRefreshMixin {
  @override
  GpsScreenType get screenType => GpsScreenType.map;

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController = Completer();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<VehicleListCubit>()),
        BlocProvider<SelectedVehicleCubit>(
          create:
              (_) =>
                  SelectedVehicleCubit()..select(widget.initialSelectedVehicle),
        ),
      ],
      child: BlocBuilder<SelectedVehicleCubit, GpsCombinedVehicleData?>(
        builder: (context, selectedVehicle) {
          final isSingleVehicle = widget.vehicles.length == 1;
          final markers = <Marker>{};
          for (final vehicle in widget.vehicles) {
            final loc = vehicle.location;
            if (loc != null && loc.contains(',')) {
              final parts = loc.split(',');
              final lat = double.tryParse(parts[0].trim());
              final lng = double.tryParse(parts[1].trim());
              if (lat != null && lng != null) {
                markers.add(
                  Marker(
                    markerId: MarkerId(vehicle.vehicleNumber ?? 'unknown'),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(
                      title: vehicle.address ?? vehicle.vehicleNumber,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow,
                    ),
                    onTap:
                        isSingleVehicle
                            ? null
                            : () {
                              context.read<SelectedVehicleCubit>().select(
                                vehicle,
                              );
                            },
                  ),
                );
              }
            }
          }
          final initialCameraPosition = () {
            if (isSingleVehicle && markers.isNotEmpty) {
              return CameraPosition(target: markers.first.position, zoom: 14);
            } else if (markers.isNotEmpty) {
              return CameraPosition(target: markers.first.position, zoom: 12);
            } else {
              return const CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 4,
              );
            }
          }();
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: context.watch<VehicleListCubit>().state.mapType,
                  trafficEnabled:
                      context.watch<VehicleListCubit>().state.trafficEnabled,
                  onMapCreated: (controller) {
                    if (!mapController.isCompleted) {
                      mapController.complete(controller);
                    }
                  },
                ),
                if (!isSingleVehicle && selectedVehicle == null) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                        top: 36,
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => context.pop(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'SB Matric School',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.list, color: Colors.blue),
                      label: const Text(
                        'List View',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
                if (selectedVehicle != null) ...[
                  Positioned(
                    top: 24,
                    left: 16,
                    right: 16,
                    child: _VehicleInfoOverlayCard(vehicle: selectedVehicle),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.35,
                    minChildSize: 0.2,
                    maxChildSize: 0.85,
                    builder: (context, scrollController) {
                      return _VehicleBottomCard(
                        vehicle: selectedVehicle,
                        scrollController: scrollController,
                      );
                    },
                  ),
                ],
                // Current Location Button
                Positioned(
                  right: 16,
                  bottom: 180,
                  child: FloatingActionButton(
                    heroTag: "currentLocation",
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    elevation: 4,
                    onPressed: () async {
                      try {
                        final locationService = LocationService();
                        final result =
                            await locationService.getCurrentLatLong();
                        if (result is Success<geo.Position>) {
                          final position = result.value;
                          final controller = await mapController.future;
                          await controller.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(position.latitude, position.longitude),
                              15,
                            ),
                          );
                        } else if (result is Error<geo.Position>) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.type.getText(context)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error getting current location'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 260,
                  child: MapFloatingMenu(
                    onToggleTraffic:
                        () => context.read<VehicleListCubit>().toggleTraffic(),
                    onToggleMapType:
                        () => context.read<VehicleListCubit>().toggleMapType(),
                    onReachability: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reachability feature coming soon!'),
                        ),
                      );
                    },
                    onNearbyVehicles: () async {
                      final locationService = LocationService();
                      final result = await locationService.getCurrentLatLong();
                      if (result is Success<geo.Position>) {
                        final userPos = result.value;
                        double minDistance = double.infinity;
                        GpsCombinedVehicleData? nearestVehicle;
                        double? nearestDistance;

                        for (final vehicle in widget.vehicles) {
                          if (vehicle.location != null &&
                              vehicle.location!.contains(',')) {
                            final parts = vehicle.location!.split(',');
                            final lat = double.tryParse(parts[0].trim());
                            final lng = double.tryParse(parts[1].trim());
                            if (lat != null && lng != null) {
                              final distance =
                                  geo.Geolocator.distanceBetween(
                                    userPos.latitude,
                                    userPos.longitude,
                                    lat,
                                    lng,
                                  ) /
                                  1000; // in km
                              if (distance < minDistance) {
                                minDistance = distance;
                                nearestVehicle = vehicle;
                                nearestDistance = distance;
                              }
                            }
                          }
                        }

                        if (nearestVehicle != null && nearestDistance != null) {
                          showDialog(
                            context: context,
                            builder:
                                (_) => NearestVehicleDialog(
                                  vehicle: nearestVehicle!,
                                  distance: nearestDistance!,
                                ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No vehicles found')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not get current location'),
                          ),
                        );
                      }
                    },
                    onNearbyPlaces: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nearby Places feature coming soon!'),
                        ),
                      );
                    },
                    isTrafficEnabled:
                        context.watch<VehicleListCubit>().state.trafficEnabled,
                    isSatellite:
                        context.watch<VehicleListCubit>().state.mapType ==
                        MapType.satellite,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Real implementations from vehicle_map_detail_screen.dart ---

class _VehicleInfoOverlayCard extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  const _VehicleInfoOverlayCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    String? lat;
    String? lng;
    if (vehicle.location != null && vehicle.location!.contains(',')) {
      final parts = vehicle.location!.split(',');
      lat = parts[0].trim();
      lng = parts[1].trim();
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        (vehicle.vehicleNumber ?? '-').formatVehicleNumberForDisplay,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(
                        label: (vehicle.status ?? '-').capitalize(),
                        color: _getStatusColor(vehicle.status),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getIgnitionStatus(vehicle.ignition, vehicle.status),
                      style: TextStyle(
                        color: _getIgnitionColor(
                          vehicle.ignition,
                          vehicle.status,
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Ignition',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Show address below vehicle number/status
            if (vehicle.address != null && vehicle.address!.isNotEmpty)
              Text(
                vehicle.address!,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              )
            else if (lat != null && lng != null)
              FutureBuilder<String>(
                future: MapHelper.getAddressFromLatLngDoubles(
                  double.tryParse(lat) ?? 0,
                  double.tryParse(lng) ?? 0,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Fetching address...',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    );
                  } else {
                    return const Text(
                      'No address found',
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    );
                  }
                },
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Icon(Icons.battery_full, color: Colors.blue, size: 18),
                const SizedBox(width: 2),
                Text(
                  vehicle.networkSignal != null
                      ? '${vehicle.networkSignal}%'
                      : '-',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    vehicle.statusDuration ?? '-',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Icon(Icons.refresh, size: 20, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'IGNITION_ON':
      case 'ACTIVE':
        return Colors.green;
      case 'IGNITION_OFF':
      case 'OFF':
        return Colors.red;
      case 'IDLE':
        return Colors.orange;
      case 'INACTIVE':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getIgnitionStatus(String? ignition, String? status) {
    if (ignition != null) {
      final ignitionLower = ignition.toLowerCase();
      if (ignitionLower == 'on' ||
          ignitionLower == '1' ||
          ignitionLower == 'true') {
        return 'ON';
      } else if (ignitionLower == 'off' ||
          ignitionLower == '0' ||
          ignitionLower == 'false') {
        return 'OFF';
      }
    }

    // Fallback to status field
    switch (status?.toUpperCase()) {
      case 'IGNITION_ON':
      case 'ACTIVE':
        return 'ON';
      case 'IGNITION_OFF':
      case 'OFF':
      case 'INACTIVE':
        return 'OFF';
      case 'IDLE':
        return 'IDLE';
      default:
        return '-';
    }
  }

  Color _getIgnitionColor(String? ignition, String? status) {
    final ignitionStatus = _getIgnitionStatus(ignition, status);
    switch (ignitionStatus) {
      case 'ON':
        return Colors.green;
      case 'OFF':
        return Colors.red;
      case 'IDLE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

extension _CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Replace the _VehicleBottomCard stateless widget with a stateful one
class _VehicleBottomCard extends StatefulWidget {
  final GpsCombinedVehicleData vehicle;
  final ScrollController? scrollController;
  const _VehicleBottomCard({required this.vehicle, this.scrollController});

  @override
  State<_VehicleBottomCard> createState() => _VehicleBottomCardState();
}

class _VehicleBottomCardState extends State<_VehicleBottomCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FA),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top summary row
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Odo
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.speed,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Odo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatOdoReading(widget.vehicle.odoReading),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Kms',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      // Moving Time
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              const Text(
                                'Moving Time',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDistance(widget.vehicle.todayDistance),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.vehicle.statusDuration ?? '-',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Idle
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Idle',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatIdleCount(widget.vehicle.idleTime),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatIdleTime(widget.vehicle.idleTime),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ActionButton(
                      label: 'Play route',
                      icon: Icons.play_arrow,
                      onTap: () {
                        _showPlayRouteBottomSheet(context, widget.vehicle);
                      },
                    ),
                    // const SizedBox(width: 12),
                    // _ActionButton(
                    //   label: 'Capture',
                    //   icon: Icons.camera_alt,
                    //   onTap: () {},
                    // ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      label: 'Share',
                      icon: Icons.share,
                      onTap: () {
                        AppShareHelper.showVehicleShareWidget(
                          context: context,
                          vehicleNumber: widget.vehicle.vehicleNumber ?? '',
                          location: widget.vehicle.location,
                          lastUpdate: widget.vehicle.lastUpdate,
                          deviceId: widget.vehicle.deviceId,
                          token: AppConstants.token,
                          onLiveLocationShare: (token, deviceId, vehicleNumber, isLiveLocation, hours) async {
                            try {
                              final repository = locator<GpsVehicleExtraInfoRepository>();
                              final result = await repository.shareVehicleLocation(
                                token: token,
                                deviceId: deviceId,
                                vehicleNumber: vehicleNumber,
                                isLiveLocation: isLiveLocation,
                                hours: hours,
                                location: widget.vehicle.location ?? '',
                                lastUpdate: widget.vehicle.lastUpdate,
                              );
                              if (context.mounted) {
                                if (result is Success<String>) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result.value), backgroundColor: Colors.green),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Multiple sharing failed'), backgroundColor: Colors.red),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Multiple sharing failed'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                          onCurrentLocationShare: (vehicleNumber, location, lastUpdate) async {
                            try {
                              final repository = locator<GpsVehicleExtraInfoRepository>();
                              final result = await repository.shareVehicleLocation(
                                token: AppConstants.token ?? '',
                                deviceId: widget.vehicle.deviceId!,
                                vehicleNumber: vehicleNumber,
                                isLiveLocation: false,
                                hours: 0,
                                location: location,
                                lastUpdate: lastUpdate,
                              );
                              if (context.mounted) {
                                if (result is Success<String>) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result.value), backgroundColor: Colors.green),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No location data available for sharing'),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No location data available for sharing'),
                                    backgroundColor: Colors.orange,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      label: 'Call driver',
                      icon: Icons.phone,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            // Info card
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.vpn_key,
                      label: 'Ignition On Since',
                      value: _formatIgnitionOnTime(
                        widget.vehicle.lastIgnitionOnFixTime,
                      ),
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: Icons.speed,
                      label: 'Last Trip Distance',
                      value: _formatDistance(widget.vehicle.totalDistance),
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Last Trip Time',
                      value: _formatLastTripTime(widget.vehicle.lastUpdate),
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: Icons.speed,
                      label: 'Max Speed',
                      value: _formatSpeed(widget.vehicle.lastSpeed),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Immobilizer row (now expandable)
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
                bottom: 16,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _StatusIconText(
                            icon: Icons.flash_on,
                            iconColor: Colors.blue,
                            label: 'Immobilizer',
                            value: _getImmobilizerStatus(widget.vehicle.alarm),
                            valueColor: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: _StatusIconText(
                            icon: Icons.door_front_door,
                            iconColor: Colors.red,
                            label: 'Door',
                            value: _getDoorStatus(widget.vehicle.deviceStatus),
                            valueColor: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: _StatusIconText(
                            icon: Icons.thermostat,
                            iconColor: Colors.orange,
                            label: 'Temp',
                            value: _formatTemperature(widget.vehicle.tmp),
                            valueColor: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2),
                              ],
                            ),
                            child: Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_expanded) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.public,
                              iconColor: Colors.green,
                              label: 'Geofence',
                              value: _getGeofenceStatus(
                                widget.vehicle.geofenceIds,
                              ),
                              valueColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.local_parking,
                              iconColor: Colors.blue,
                              label: 'Parking',
                              value: _getParkingStatus(widget.vehicle.valid),
                              valueColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.agriculture,
                              iconColor: Colors.green,
                              label: 'Vehicle Btt',
                              value: _formatBatteryPercent(
                                widget.vehicle.batteryPercent,
                              ),
                              valueColor: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 32), // for arrow alignment
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.ac_unit,
                              iconColor: Colors.teal,
                              label: 'A/C',
                              value: _getACStatus(widget.vehicle.deviceStatus),
                              valueColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.electric_car,
                              iconColor: Colors.green,
                              label: 'GPS Btt',
                              value: _formatGPSBattery(widget.vehicle.extBatt),
                              valueColor: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 32),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatOdoReading(String? odoReading) {
    if (odoReading == null || odoReading.isEmpty) return '-';
    try {
      final odo = double.tryParse(odoReading);
      if (odo != null) {
        return '${odo.toStringAsFixed(0)} km';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return odoReading;
  }

  String _formatDistance(String? distance) {
    if (distance == null || distance.isEmpty) return '-';
    try {
      final dist = double.tryParse(distance);
      if (dist != null) {
        return '${dist.toStringAsFixed(1)} km';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return distance;
  }

  String _formatIdleCount(String? idleTime) {
    if (idleTime == null || idleTime.isEmpty) return '-';
    // Try to extract count from idle time if it contains count information
    // For now, return a default value since we don't have idle count in the API
    return '0';
  }

  String _formatIdleTime(String? idleTime) {
    if (idleTime == null || idleTime.isEmpty) return '-';
    return formatDuration(idleTime);
  }

  String _formatIgnitionOnTime(String? lastIgnitionOnFixTime) {
    if (lastIgnitionOnFixTime == null || lastIgnitionOnFixTime.isEmpty) {
      return 'N/A';
    }
    try {
      final dateTime = DateTime.parse(lastIgnitionOnFixTime);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString().substring(2)}, ${_formatTime(dateTime)}';
    } catch (e) {
      return lastIgnitionOnFixTime;
    }
  }

  String _formatLastTripTime(DateTime? lastUpdate) {
    if (lastUpdate == null) return 'N/A';
    return _formatTime(lastUpdate);
  }

  String _formatSpeed(String? speed) {
    if (speed == null || speed.isEmpty) return 'N/A';
    return '$speed Km/h';
  }

  String _getImmobilizerStatus(String? alarm) {
    if (alarm == null || alarm.isEmpty) return 'N/A';
    return alarm.toUpperCase();
  }

  String _getDoorStatus(String? deviceStatus) {
    if (deviceStatus == null || deviceStatus.isEmpty) return 'N/A';
    return deviceStatus.toUpperCase();
  }

  String _formatTemperature(String? tmp) {
    if (tmp == null || tmp.isEmpty) return 'N/A';
    try {
      final temp = double.tryParse(tmp);
      if (temp != null) {
        return '${temp.toStringAsFixed(1)}°C';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return '$tmp°C';
  }

  String _getGeofenceStatus(String? geofenceIds) {
    if (geofenceIds == null || geofenceIds.isEmpty) return 'N/A';
    // If geofenceIds is present, it means the vehicle is outside a geofence
    // This is a simplified logic - in a real app, you'd check against specific geofence definitions
    return 'Outside';
  }

  String _getParkingStatus(String? valid) {
    if (valid == null || valid.isEmpty) return 'N/A';
    return valid == '1' ? 'Parked' : 'Moving';
  }

  String _formatBatteryPercent(String? batteryPercent) {
    if (batteryPercent == null || batteryPercent.isEmpty) return 'N/A';
    try {
      final battery = double.tryParse(batteryPercent);
      if (battery != null && battery >= 0 && battery <= 100) {
        return battery.toInt().toString();
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return batteryPercent;
  }

  String _getACStatus(String? deviceStatus) {
    if (deviceStatus == null || deviceStatus.isEmpty) return 'N/A';
    return 'OFF';
  }

  String _formatGPSBattery(double? battery) {
    if (battery == null) return 'N/A';
    return battery.toStringAsFixed(2) + 'V';
  }

  void _showPlayRouteBottomSheet(BuildContext context, GpsCombinedVehicleData vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlayRouteBottomSheet(vehicle: vehicle),
    );
  }
}

// Info row widget for the info card
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sublabel;
  final Color color;
  const _StatIconItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
          if (sublabel.isNotEmpty)
            Text(
              sublabel,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _StatusChipWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatusChipWithIcon({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: 1,
      ),
    );
  }
}

String _formatTime(DateTime dateTime) {
  // Format as hh:mm AM/PM
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $ampm';
}

// New widget for the new style row
class _StatusIconText extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  const _StatusIconText({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

String formatDuration(dynamic rawIdleTime) {
  int totalSeconds = 0;

  if (rawIdleTime == null) return '-';

  // Try to parse if it's a string number
  if (rawIdleTime is String) {
    totalSeconds = int.tryParse(rawIdleTime) ?? 0;
  } else if (rawIdleTime is int) {
    totalSeconds = rawIdleTime;
  }

  // If the value is in minutes (and not seconds), convert to seconds
  // This is a crude check; adjust as needed for your data
  if (totalSeconds < 100000 && totalSeconds > 0) {
    totalSeconds *= 60;
  }

  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return '${hours}hrs ${minutes} mins';
  } else if (hours > 0) {
    return '${hours}hrs';
  } else if (minutes > 0) {
    return '${minutes} mins';
  } else {
    return '0 min';
  }
}

String _formatVoltage(double? v) {
  if (v == null) return '-';
  return v.toStringAsFixed(2) + 'V';
}

String _formatOdoMeters(int? meters) {
  if (meters == null) return '-';
  return (meters / 1000).toStringAsFixed(0) + ' km';
}

String _formatTripDistance(double? km) {
  if (km == null) return '-';
  return km.toStringAsFixed(2) + ' km';
}

String _formatSignal(int? rssi) {
  if (rssi == null) return '-';
  return '$rssi/5';
}

String _formatSat(int? sat) {
  if (sat == null) return '-';
  return sat.toString();
}

  String _formatMotion(bool? motion) {
    if (motion == null) return '-';
    return motion ? 'Moving' : 'Stopped';
  }

class PlayRouteBottomSheet extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  
  const PlayRouteBottomSheet({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Play Route',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                // Status indicator (green dot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Route options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _RouteOption(
                  icon: Icons.vpn_key,
                  label: 'Ignition Path',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToPathReplay(context, vehicle, 'ignition');
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                _RouteOption(
                  icon: Icons.location_on,
                  label: 'Daily Path',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToPathReplay(context, vehicle, 'daily');
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                _RouteOption(
                  icon: Icons.replay,
                  label: 'Path Replay',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToPathReplay(context, vehicle, 'replay');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _navigateToPathReplay(BuildContext context, GpsCombinedVehicleData vehicle, String routeType) {
    // Get current date for query parameters
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 1));
    final endDate = now;

    final Map<String, dynamic> queryParams = {
      "start": startDate.toIso8601String(),
      "end": endDate.toIso8601String(),
      "timezone_offset": "0",
      "inputs": {},
      "device_ids": vehicle.deviceId,
      "fwd_variable": 0.0,
    };

    // Navigate to path replay screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PathReplayScreen(
          token: AppConstants.token ?? '',
          queryParams: queryParams,
          vehicleNumber: vehicle.vehicleNumber,
        ),
      ),
    );
  }
}

class _RouteOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RouteOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class NearestVehicleDialog extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final double distance;

  const NearestVehicleDialog({
    super.key,
    required this.vehicle,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replace icon with asset image
            SizedBox(
              height: 160,
              width: 160,
              child: Image.asset(
                'assets/icons/png/nearest_vehicle_illustration.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nearest Vehicle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              vehicle.vehicleNumber ?? '-',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'You are ',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(
                    text: '${distance.toStringAsFixed(1)} Kms',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' away from the nearest vehicle'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
