import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_info_window_details_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/helper/gps_map_helper.dart';
import 'package:gro_one_app/features/gps_feature/helper/vehicle_marker_helper.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/views/path_replay_screen.dart';
import 'package:gro_one_app/features/gps_feature/widgets/gps_screen_lifecycle_wrapper.dart';
import 'package:gro_one_app/features/gps_feature/widgets/map_floating_menu.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/app_share_helper.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../helper/gps_session_manager.dart';
import '../widgets/nearby_places_bottom_sheet.dart';

// Cubit for selected vehicle state
class SelectedVehicleCubit extends Cubit<GpsCombinedVehicleData?> {
  bool _isClosed = false;

  SelectedVehicleCubit() : super(null);

  bool get isClosed => _isClosed;

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
    try {
      if (!_isClosed) {
        emit(vehicle);
      }
    } catch (e) {
      // Handle any errors that might occur during emit
    }
  }
}

class VehicleMapScreen extends StatelessWidget {
  final List<GpsCombinedVehicleData> vehicles;
  final GpsCombinedVehicleData? initialSelectedVehicle;

  const VehicleMapScreen({
    super.key,
    required this.vehicles,
    this.initialSelectedVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return GpsScreenLifecycleWrapper(
      screenType: GpsScreenType.map,
      child: _VehicleMapContent(
        vehicles: vehicles,
        initialSelectedVehicle: initialSelectedVehicle,
      ),
    );
  }
}

class _VehicleMapContent extends StatelessWidget {
  final List<GpsCombinedVehicleData> vehicles;
  final GpsCombinedVehicleData? initialSelectedVehicle;

  const _VehicleMapContent({
    required this.vehicles,
    this.initialSelectedVehicle,
  });

  Future<Map<String, bool>> _loadGeofenceToggles() async {
    return await GpsSessionManager.getGeofenceToggleMap();
  }

  /// Safely select a vehicle using the cubit with proper error handling
  void _safeSelectVehicle(
    BuildContext context,
    GpsCombinedVehicleData? vehicle,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (context.mounted) {
          final cubit = context.read<SelectedVehicleCubit>();
          if (cubit != null && !cubit.isClosed) {
            cubit.select(vehicle);
          }
        }
      } catch (e) {
        // Error selecting vehicle
      }
    });
  }

  /// Creates vehicle markers with custom vehicle icons based on vehicle type and status
  Future<Set<Marker>> _createVehicleMarkers(
    List<GpsCombinedVehicleData> vehicles,
    BuildContext context,
  ) async {
    final markers = <Marker>{};
    for (final vehicle in vehicles) {
      final loc = vehicle.location;
      if (loc != null && loc.contains(',')) {
        final parts = loc.split(',');
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          // Use custom vehicle marker with larger emoji icons
          final marker =
              await VehicleMarkerHelper.createCustomVehicleMarkerWithEmoji(
                vehicleId: vehicle.vehicleNumber ?? 'unknown',
                position: LatLng(lat, lng),
                title: vehicle.vehicleNumber ?? 'Unknown Vehicle',
                onTap: () {
                  _safeSelectVehicle(context, vehicle);
                },
                vehicleCategory: vehicle.category,
                status: vehicle.status,
                lastUpdate: vehicle.lastUpdate,
                isExpired:
                    false, // You can add logic to determine if vehicle is expired
              );
          markers.add(marker);
        }
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController =
        GpsMapHelper.createMapController();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<VehicleListCubit>()),
        BlocProvider<SelectedVehicleCubit>(
          create: (_) => SelectedVehicleCubit(),
        ),
        BlocProvider.value(value: locator<GpsGeofenceCubit>()),
      ],
      child: BlocBuilder<SelectedVehicleCubit, GpsCombinedVehicleData?>(
        builder: (context, selectedVehicle) {
          final isSingleVehicle = vehicles.length == 1;
          return FutureBuilder<Set<Marker>>(
            future: _createVehicleMarkers(vehicles, context),
            builder: (context, markerSnapshot) {
              final markers = markerSnapshot.data ?? <Marker>{};
              final initialCameraPosition = () {
                // If there's an initial selected vehicle, focus on it
                if (initialSelectedVehicle != null) {
                  final initialVehicle = vehicles.firstWhere(
                    (v) =>
                        v.vehicleNumber ==
                        initialSelectedVehicle!.vehicleNumber,
                    orElse: () => vehicles.first,
                  );
                  final loc = initialVehicle.location;
                  if (loc != null && loc.contains(',')) {
                    final parts = loc.split(',');
                    final lat = double.tryParse(parts[0].trim());
                    final lng = double.tryParse(parts[1].trim());
                    if (lat != null && lng != null) {
                      return GpsMapHelper.createCameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 14,
                      );
                    }
                  }
                }

                if (isSingleVehicle && markers.isNotEmpty) {
                  return GpsMapHelper.createCameraPosition(
                    target: markers.first.position,
                    zoom: 14,
                  );
                } else if (markers.isNotEmpty) {
                  return GpsMapHelper.createCameraPosition(
                    target: markers.first.position,
                    zoom: 12,
                  );
                } else {
                  return GpsMapHelper.getDefaultCameraPosition();
                }
              }();
              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () => _performRefresh(context),
                  child: Stack(
                    children: [
                      BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
                        builder: (context, geofenceState) {
                          // Load geofences if not already loaded
                          if (geofenceState is GpsGeofenceInitial) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<GpsGeofenceCubit>().loadGeofences();
                            });
                          }

                          // Check if geofence display is enabled
                          final showGeofenceOnMap =
                              GpsSessionManager.isShowGeofenceOnMapEnabled();

                          if (showGeofenceOnMap &&
                              geofenceState is GpsGeofenceLoaded) {
                            return FutureBuilder<Map<String, bool>>(
                              future: _loadGeofenceToggles(),
                              builder: (context, toggleSnapshot) {
                                Set<Circle> circles = {};
                                Set<Polygon> polygons = {};
                                Set<Polyline> polylines = {};

                                if (toggleSnapshot.hasData) {
                                  final toggleMap = toggleSnapshot.data!;

                                  for (final geofence
                                      in geofenceState.geofences) {
                                    final shouldShow =
                                        toggleMap[geofence.id] ?? false;

                                    if (shouldShow) {
                                      if (geofence.shapeType == 'circle' &&
                                          geofence.center != null &&
                                          geofence.radius != null) {
                                        circles.add(
                                          Circle(
                                            circleId: CircleId(
                                              "geofence_circle_${geofence.id}",
                                            ),
                                            center: geofence.center!,
                                            radius: geofence.radius!,
                                            fillColor: const Color(
                                              0x330000FF,
                                            ), // Blue with 20% opacity
                                            strokeColor: Colors.blue,
                                            strokeWidth: 2,
                                          ),
                                        );
                                      } else if (geofence.shapeType ==
                                              'polygon' &&
                                          geofence.polygonPoints != null &&
                                          geofence.polygonPoints!.isNotEmpty) {
                                        polygons.add(
                                          Polygon(
                                            polygonId: PolygonId(
                                              "geofence_polygon_${geofence.id}",
                                            ),
                                            points: geofence.polygonPoints!,
                                            fillColor: const Color(
                                              0x3300FF00,
                                            ), // Green with 20% opacity
                                            strokeColor: Colors.green,
                                            strokeWidth: 2,
                                          ),
                                        );
                                      } else if (geofence.shapeType ==
                                              'polyline' &&
                                          geofence.polygonPoints != null &&
                                          geofence.polygonPoints!.isNotEmpty) {
                                        polylines.add(
                                          Polyline(
                                            polylineId: PolylineId(
                                              "geofence_polyline_${geofence.id}",
                                            ),
                                            points: geofence.polygonPoints!,
                                            color: Colors.red,
                                            width: 3,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }

                                return GpsMapHelper.createGpsMap(
                                  initialCameraPosition: initialCameraPosition,
                                  markers: markers,
                                  circles: circles,
                                  polygons: polygons,
                                  polylines: polylines,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: true,
                                  mapType:
                                      context
                                          .watch<VehicleListCubit>()
                                          .state
                                          .mapType,
                                  trafficEnabled:
                                      context
                                          .watch<VehicleListCubit>()
                                          .state
                                          .trafficEnabled,
                                  onMapCreated: (controller) {
                                    GpsMapHelper.handleMapCreated(
                                      controller,
                                      mapController,
                                      null,
                                    );
                                  },
                                  onTap: (LatLng position) {
                                    // Hide bottom sheet and top card when tapping on map (not on vehicle)
                                    _safeSelectVehicle(context, null);
                                  },
                                );
                              },
                            );
                          } else {
                            return GpsMapHelper.createGpsMap(
                              initialCameraPosition: initialCameraPosition,
                              markers: markers,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: true,
                              mapType:
                                  context
                                      .watch<VehicleListCubit>()
                                      .state
                                      .mapType,
                              trafficEnabled:
                                  context
                                      .watch<VehicleListCubit>()
                                      .state
                                      .trafficEnabled,
                              onMapCreated: (controller) {
                                GpsMapHelper.handleMapCreated(
                                  controller,
                                  mapController,
                                  null,
                                );
                              },
                              onTap: (LatLng position) {
                                // Hide bottom sheet and top card when tapping on map (not on vehicle)
                                _safeSelectVehicle(context, null);
                              },
                            );
                          }
                        },
                      ),
                      if (selectedVehicle == null) ...[
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
                          child: _VehicleInfoOverlayCard(
                            vehicle: selectedVehicle,
                          ),
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
                        child: GpsMapHelper.createMapFloatingButton(
                          icon: Icons.my_location,
                          heroTag: "currentLocation",
                          onPressed: () async {
                            try {
                              final locationService = LocationService();
                              final result =
                                  await locationService.getCurrentLatLong();
                              if (result is Success<geo.Position>) {
                                final position = result.value;
                                final controller = await mapController.future;
                                await GpsMapHelper.animateToLocation(
                                  controller,
                                  LatLng(position.latitude, position.longitude),
                                  zoom: 15,
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
                                  content: Text(
                                    'Error getting current location',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 260,
                        child: MapFloatingMenu(
                          onToggleTraffic:
                              () =>
                                  context
                                      .read<VehicleListCubit>()
                                      .toggleTraffic(),
                          onToggleMapType:
                              () =>
                                  context
                                      .read<VehicleListCubit>()
                                      .toggleMapType(),
                          onReachability: () {
                            // Navigate to GPS reports screen with reachability pre-selected
                            context.push(
                              AppRouteName.gpsReports,
                              extra: {
                                'preSelectedReportType': 'reachability',
                                'preSelectedVehicle': selectedVehicle,
                              },
                            );
                          },
                          onNearbyVehicles: () async {
                            final locationService = LocationService();
                            final result =
                                await locationService.getCurrentLatLong();
                            if (result is Success<geo.Position>) {
                              final userPos = result.value;
                              double minDistance = double.infinity;
                              GpsCombinedVehicleData? nearestVehicle;
                              double? nearestDistance;

                              for (final vehicle in vehicles) {
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

                              if (nearestVehicle != null &&
                                  nearestDistance != null) {
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
                                  const SnackBar(
                                    content: Text('No vehicles found'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not get current location',
                                  ),
                                ),
                              );
                            }
                          },
                          onNearbyPlaces: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder:
                                  (context) => const NearbyPlacesBottomSheet(),
                            );
                          },
                          isTrafficEnabled:
                              context
                                  .watch<VehicleListCubit>()
                                  .state
                                  .trafficEnabled,
                          isSatellite:
                              context.watch<VehicleListCubit>().state.mapType ==
                              MapType.satellite,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                        (vehicle.vehicleNumber ?? '-')
                            .formatVehicleNumberForDisplay,
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
                Expanded(
                  child: Text(
                    _formatStatusDuration(vehicle.statusDuration),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                BlocBuilder<VehicleListCubit, VehicleListState>(
                  builder: (context, vehicleState) {
                    final isRefreshing =
                        vehicleState.vehicleDataState?.status == Status.LOADING;

                    return GestureDetector(
                      onTap:
                          isRefreshing ? null : () => _performRefresh(context),
                      child: AnimatedRotation(
                        turns: isRefreshing ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          Icons.refresh,
                          size: 20,
                          color: isRefreshing ? Colors.blue : Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    final statusUpper = status.toUpperCase();
    switch (statusUpper) {
      case 'IGNITION_ON':
      case 'ACTIVE':
      case 'RUNNING':
      case 'ON':
        return Colors.green;
      case 'IGNITION_OFF':
      case 'OFF':
      case 'INACTIVE':
      case 'STOPPED':
        return Colors.red;
      case 'IDLE':
      case 'PARKED':
        return Colors.orange;
      case 'MAINTENANCE':
      case 'SERVICE':
        return Colors.purple;
      case 'ERROR':
      case 'FAULT':
        return Colors.red;
      default:
        // Try to determine color from status string
        final statusLower = status.toLowerCase();
        if (statusLower.contains('on') ||
            statusLower.contains('active') ||
            statusLower.contains('running')) {
          return Colors.green;
        } else if (statusLower.contains('off') ||
            statusLower.contains('inactive') ||
            statusLower.contains('stopped')) {
          return Colors.red;
        } else if (statusLower.contains('idle') ||
            statusLower.contains('parked')) {
          return Colors.orange;
        }
        return Colors.grey;
    }
  }

  String _getIgnitionStatus(String? ignition, String? status) {
    if (ignition != null) {
      final ignitionLower = ignition.toLowerCase().trim();
      if (ignitionLower == 'on' ||
          ignitionLower == '1' ||
          ignitionLower == 'true' ||
          ignitionLower == 'yes' ||
          ignitionLower == 'running') {
        return 'ON';
      } else if (ignitionLower == 'off' ||
          ignitionLower == '0' ||
          ignitionLower == 'false' ||
          ignitionLower == 'no' ||
          ignitionLower == 'stopped') {
        return 'OFF';
      }
    }

    // Fallback to status field
    if (status != null) {
      final statusUpper = status.toUpperCase();
      switch (statusUpper) {
        case 'IGNITION_ON':
        case 'ACTIVE':
        case 'RUNNING':
        case 'ON':
          return 'ON';
        case 'IGNITION_OFF':
        case 'OFF':
        case 'INACTIVE':
        case 'STOPPED':
          return 'OFF';
        case 'IDLE':
        case 'PARKED':
          return 'IDLE';
        default:
          // Try to extract ignition info from status string
          final statusLower = status.toLowerCase();
          if (statusLower.contains('on') || statusLower.contains('active')) {
            return 'ON';
          } else if (statusLower.contains('off') ||
              statusLower.contains('inactive')) {
            return 'OFF';
          } else if (statusLower.contains('idle')) {
            return 'IDLE';
          }
      }
    }

    return '-';
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

  String _formatStatusDuration(String? statusDuration) {
    if (statusDuration == null || statusDuration.isEmpty) return '-';

    // If it's already in a readable format, return as is
    if (statusDuration.contains('ago') ||
        statusDuration.contains('h') ||
        statusDuration.contains('m') ||
        statusDuration.contains('d')) {
      return statusDuration;
    }

    // Try to parse as timestamp and convert to relative time
    try {
      final timestamp = int.tryParse(statusDuration);
      if (timestamp != null) {
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(lastUpdate);

        if (difference.inMinutes < 60) {
          return '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          return '${difference.inHours}h ago';
        } else {
          return '${difference.inDays}d ago';
        }
      }
    } catch (e) {
      // If parsing fails, return the original value
    }

    return statusDuration;
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
        color: color.withValues(alpha: 0.25),
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

// Stateless widget with BlocProvider
class _VehicleBottomCard extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final ScrollController? scrollController;
  const _VehicleBottomCard({required this.vehicle, this.scrollController});

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '0h 0m';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '0m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = locator<GpsInfoWindowDetailsCubit>();
        return cubit;
      },
      child: _VehicleBottomCardContent(
        vehicle: vehicle,
        scrollController: scrollController,
        formatDuration: _formatDuration,
      ),
    );
  }
}

class _VehicleBottomCardContent extends StatefulWidget {
  final GpsCombinedVehicleData vehicle;
  final ScrollController? scrollController;
  final String Function(int?) formatDuration;

  const _VehicleBottomCardContent({
    required this.vehicle,
    this.scrollController,
    required this.formatDuration,
  });

  @override
  State<_VehicleBottomCardContent> createState() =>
      _VehicleBottomCardContentState();
}

class _VehicleBottomCardContentState extends State<_VehicleBottomCardContent> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    // Call API when widget is first created
    _loadInfoWindowDetails();
  }

  @override
  void didUpdateWidget(_VehicleBottomCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Call API when vehicle changes
    if (oldWidget.vehicle.deviceId != widget.vehicle.deviceId) {
      _loadInfoWindowDetails();
    }
  }

  void _loadInfoWindowDetails() {
    if (widget.vehicle.deviceId != null) {
      context.read<GpsInfoWindowDetailsCubit>().getInfoWindowDetails(
        widget.vehicle.deviceId.toString(),
      );
    }
  }

  @override
  void dispose() {
    // Reset cubit state when widget is disposed
    context.read<GpsInfoWindowDetailsCubit>().resetState();
    super.dispose();
  }

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
                      // Daily Total Distance
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              const Text(
                                'Daily Total Distance',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          BlocBuilder<
                            GpsInfoWindowDetailsCubit,
                            GpsInfoWindowDetailsState
                          >(
                            builder: (context, infoState) {
                              if (infoState.infoWindowDetailsState?.status ==
                                      Status.SUCCESS &&
                                  infoState.infoWindowDetailsState?.data !=
                                      null) {
                                final infoDetails =
                                    infoState.infoWindowDetailsState!.data!;
                                return Text(
                                  _formatDistanceFromCache(
                                    infoDetails.cacheDistance,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              } else {
                                return Text(
                                  _formatDistance(widget.vehicle.todayDistance),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatStatusDuration(
                              widget.vehicle.statusDuration,
                            ),
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
                            _calculateIdleCountFromTimestamps(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _calculateIdleTimeFromTimestamps(),
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
                      iconColor: Colors.blue,
                      onTap: () {
                        _showPlayRouteBottomSheet(context, widget.vehicle);
                      },
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      label: 'Share',
                      icon: Icons.share,
                      iconColor: Colors.teal,
                      onTap: () {
                        AppShareHelper.showVehicleShareWidget(
                          context: context,
                          vehicleNumber: widget.vehicle.vehicleNumber ?? '',
                          location: widget.vehicle.location,
                          lastUpdate: widget.vehicle.lastUpdate,
                          deviceId: widget.vehicle.deviceId,
                          token: AppConstants.token,
                          onLiveLocationShare: (
                            token,
                            deviceId,
                            vehicleNumber,
                            isLiveLocation,
                            hours,
                          ) async {
                            try {
                              final repository =
                                  locator<GpsVehicleExtraInfoRepository>();
                              final result = await repository
                                  .shareVehicleLocation(
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
                                    SnackBar(
                                      content: Text(result.value),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Multiple sharing failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Multiple sharing failed'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          onCurrentLocationShare: (
                            vehicleNumber,
                            location,
                            lastUpdate,
                          ) async {
                            try {
                              final repository =
                                  locator<GpsVehicleExtraInfoRepository>();
                              final result = await repository
                                  .shareVehicleLocation(
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
                                    SnackBar(
                                      content: Text(result.value),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No location data available for sharing',
                                      ),
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
                                    content: Text(
                                      'No location data available for sharing',
                                    ),
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
                      iconColor: Colors.lightBlue,
                      onTap: () {
                        _callDriver(context, widget.vehicle);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Info Window Details Card (Trip Details)
            BlocBuilder<GpsInfoWindowDetailsCubit, GpsInfoWindowDetailsState>(
              builder: (context, state) {
                if (state.infoWindowDetailsState?.status == Status.LOADING) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (state.infoWindowDetailsState?.status == Status.SUCCESS &&
                    state.infoWindowDetailsState?.data != null) {
                  final infoDetails = state.infoWindowDetailsState!.data!;
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.vpn_key,
                            label:
                                _getIgnitionStatus(
                                          widget.vehicle.ignition,
                                          widget.vehicle.status,
                                        ) ==
                                        'ON'
                                    ? 'Ignition On Since'
                                    : 'Ignition OFF Since',
                            value: _formatIgnitionTime(
                              widget.vehicle.lastIgnitionOnFixTime,
                              widget.vehicle.lastIgnitionOffFixTime,
                              widget.vehicle.ignition,
                              widget.vehicle.status,
                            ),
                          ),
                          const Divider(height: 1),
                          _InfoRow(
                            icon: Icons.access_time,
                            label: 'Last Trip Time',
                            value: _formatLastTripTime(
                              widget.vehicle.lastUpdate,
                            ),
                          ),
                          const Divider(height: 1),
                          _InfoWindowDetailRow(
                            icon: Icons.speed,
                            label: 'Max Speed',
                            value:
                                '${infoDetails.maxSpeedKph?.toStringAsFixed(1) ?? '0.0'} km/h',
                          ),
                          const Divider(height: 1),
                          _InfoWindowDetailRow(
                            icon: Icons.route,
                            label: 'Last Trip Distance',
                            value:
                                '${infoDetails.lastTripDistance?.toStringAsFixed(1) ?? '0.0'} km',
                          ),
                          const Divider(height: 1),
                          _InfoWindowDetailRow(
                            icon: Icons.stop_circle,
                            label: 'Stops Count',
                            value: '${infoDetails.stopsCount ?? 0}',
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
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
                            icon: Icons.thermostat,
                            iconColor: Colors.orange,
                            label: 'Temp',
                            value: _formatTemperature(widget.vehicle.tmp),
                            valueColor: Colors.black,
                          ),
                        ),
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
                              value: _getVehicleBatteryDisplay(),
                              valueColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: _StatusIconText(
                              icon: Icons.battery_charging_full,
                              iconColor: Colors.green,
                              label: 'Vehicle Btt',
                              value: _getGPSBatteryDisplay(),
                              valueColor: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 32), // for arrow alignment
                        ],
                      ),
                      const SizedBox(height: 12),
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
      // Remove any non-numeric characters except decimal point
      final cleanOdo = odoReading.replaceAll(RegExp(r'[^\d.]'), '');
      final odo = double.tryParse(cleanOdo);
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
      // Remove any non-numeric characters except decimal point
      final cleanDistance = distance.replaceAll(RegExp(r'[^\d.]'), '');
      final dist = double.tryParse(cleanDistance);
      if (dist != null) {
        return '${dist.toStringAsFixed(1)} km';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return distance;
  }

  String _formatDistanceFromCache(double? cacheDistance) {
    if (cacheDistance == null) return '-';
    return '${cacheDistance.toStringAsFixed(1)} km';
  }

  String _formatIdleCount(String? idleTime) {
    if (idleTime == null || idleTime.isEmpty) return '-';
    // Since we don't have idle count in the API, we'll calculate it from idle time
    try {
      final idleSeconds = int.tryParse(idleTime);
      if (idleSeconds != null && idleSeconds > 0) {
        // If idle time is more than 5 minutes, consider it as an idle event
        if (idleSeconds > 300) {
          // 5 minutes = 300 seconds
          return '1';
        }
      }
    } catch (e) {
      // If parsing fails, return default
    }
    return '0';
  }

  String _calculateIdleCountFromTimestamps() {
    final idleFixTime = widget.vehicle.idleFixTime;
    final idleFixTimeKey = widget.vehicle.idleFixTimeKey;

    if (idleFixTime == null ||
        idleFixTime.isEmpty ||
        idleFixTimeKey == null ||
        idleFixTimeKey.isEmpty) {
      return '-';
    }

    try {
      // Parse UTC timestamps
      final DateTime idleFixTimeUtc = DateTime.parse(idleFixTime);
      final DateTime idleFixTimeKeyUtc = DateTime.parse(idleFixTimeKey);

      // Convert to local time
      final DateTime idleFixTimeLocal = idleFixTimeUtc.toLocal();
      final DateTime idleFixTimeKeyLocal = idleFixTimeKeyUtc.toLocal();

      // Calculate the difference - always subtract the earlier time from the later time
      Duration difference;
      if (idleFixTimeLocal.isAfter(idleFixTimeKeyLocal)) {
        difference = idleFixTimeLocal.difference(idleFixTimeKeyLocal);
      } else {
        difference = idleFixTimeKeyLocal.difference(idleFixTimeLocal);
      }

      // Calculate idle count based on duration
      final int totalSeconds = difference.inSeconds;
      if (totalSeconds < 0) {
        return '0'; // Invalid time difference
      }

      // If idle time is more than 5 minutes, consider it as an idle event
      if (totalSeconds > 300) {
        return '1';
      }

      return '0';
    } catch (e) {
      // If parsing fails, fall back to the original idleTime calculation
      return _formatIdleCount(widget.vehicle.idleTime);
    }
  }

  String _formatIdleTime(String? idleTime) {
    if (idleTime == null || idleTime.isEmpty) return '-';
    return formatDuration(idleTime);
  }

  String _calculateIdleTimeFromTimestamps() {
    final idleFixTime = widget.vehicle.idleFixTime;
    final idleFixTimeKey = widget.vehicle.idleFixTimeKey;

    if (idleFixTime == null ||
        idleFixTime.isEmpty ||
        idleFixTimeKey == null ||
        idleFixTimeKey.isEmpty) {
      return '-';
    }

    try {
      // Parse UTC timestamps
      final DateTime idleFixTimeUtc = DateTime.parse(idleFixTime);
      final DateTime idleFixTimeKeyUtc = DateTime.parse(idleFixTimeKey);

      // Convert to local time
      final DateTime idleFixTimeLocal = idleFixTimeUtc.toLocal();
      final DateTime idleFixTimeKeyLocal = idleFixTimeKeyUtc.toLocal();

      // Calculate the difference - always subtract the earlier time from the later time
      Duration difference;
      if (idleFixTimeLocal.isAfter(idleFixTimeKeyLocal)) {
        difference = idleFixTimeLocal.difference(idleFixTimeKeyLocal);
      } else {
        difference = idleFixTimeKeyLocal.difference(idleFixTimeLocal);
      }

      // Format the duration
      final int totalSeconds = difference.inSeconds;

      if (totalSeconds < 0) {
        return '-'; // Invalid time difference
      }

      final int hours = totalSeconds ~/ 3600;
      final int minutes = (totalSeconds % 3600) ~/ 60;

      String result;
      if (hours > 0 && minutes > 0) {
        result = '${hours}h ${minutes}m';
      } else if (hours > 0) {
        result = '${hours}h';
      } else if (minutes > 0) {
        result = '${minutes}m';
      } else {
        result = '0m';
      }

      return result;
    } catch (e) {
      // If parsing fails, fall back to the original idleTime
      return _formatIdleTime(widget.vehicle.idleTime);
    }
  }

  String _getIgnitionStatus(String? ignition, String? status) {
    if (ignition != null) {
      final ignitionLower = ignition.toLowerCase().trim();
      if (ignitionLower == 'on' ||
          ignitionLower == '1' ||
          ignitionLower == 'true' ||
          ignitionLower == 'yes' ||
          ignitionLower == 'running') {
        return 'ON';
      } else if (ignitionLower == 'off' ||
          ignitionLower == '0' ||
          ignitionLower == 'false' ||
          ignitionLower == 'no' ||
          ignitionLower == 'stopped') {
        return 'OFF';
      }
    }

    // Fallback to status field
    if (status != null) {
      final statusUpper = status.toUpperCase();
      switch (statusUpper) {
        case 'IGNITION_ON':
        case 'ACTIVE':
        case 'RUNNING':
        case 'ON':
          return 'ON';
        case 'IGNITION_OFF':
        case 'OFF':
        case 'INACTIVE':
        case 'STOPPED':
          return 'OFF';
        case 'IDLE':
        case 'PARKED':
          return 'IDLE';
        default:
          // Try to extract ignition info from status string
          final statusLower = status.toLowerCase();
          if (statusLower.contains('on') || statusLower.contains('active')) {
            return 'ON';
          } else if (statusLower.contains('off') ||
              statusLower.contains('inactive')) {
            return 'OFF';
          } else if (statusLower.contains('idle')) {
            return 'IDLE';
          }
      }
    }

    return '-';
  }

  String _formatIgnitionTime(
    String? lastIgnitionOnFixTime,
    String? lastIgnitionOffFixTime,
    String? ignition,
    String? status,
  ) {
    final ignitionStatus = _getIgnitionStatus(ignition, status);

    if (ignitionStatus == 'ON') {
      // Show ignition on time
      if (lastIgnitionOnFixTime == null || lastIgnitionOnFixTime.isEmpty) {
        return 'N/A';
      }
      try {
        final dateTime = DateTime.parse(lastIgnitionOnFixTime);
        final localDateTime = dateTime.toLocal();
        return '${localDateTime.day.toString().padLeft(2, '0')}-${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.year.toString().substring(2)}, ${_formatTime(localDateTime)}';
      } catch (e) {
        return lastIgnitionOnFixTime;
      }
    } else {
      // Show ignition off time
      if (lastIgnitionOffFixTime == null || lastIgnitionOffFixTime.isEmpty) {
        return 'N/A';
      }
      try {
        final dateTime = DateTime.parse(lastIgnitionOffFixTime);
        final localDateTime = dateTime.toLocal();
        return '${localDateTime.day.toString().padLeft(2, '0')}-${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.year.toString().substring(2)}, ${_formatTime(localDateTime)}';
      } catch (e) {
        return lastIgnitionOffFixTime;
      }
    }
  }

  String _formatLastTripTime(DateTime? lastUpdate) {
    if (lastUpdate == null) return 'N/A';
    return _formatTime(lastUpdate);
  }

  String _formatTemperature(String? tmp) {
    if (tmp == null || tmp.isEmpty) return '-';

    // Check if it's a timestamp (ISO format)
    if (tmp.contains('T') && tmp.contains('+')) {
      try {
        final dateTime = DateTime.parse(tmp);
        // Extract temperature from posAttr if available
        if (widget.vehicle.posAttr != null &&
            widget.vehicle.posAttr!.isNotEmpty) {
          try {
            final posAttrMap =
                jsonDecode(widget.vehicle.posAttr!) as Map<String, dynamic>;
            if (posAttrMap.containsKey('tmp')) {
              final tempValue = posAttrMap['tmp'];
              if (tempValue != null) {
                final temp = double.tryParse(tempValue.toString());
                if (temp != null) {
                  return '${temp.toStringAsFixed(1)}°C';
                }
              }
            }
            // Also try other common temperature field names
            if (posAttrMap.containsKey('temperature')) {
              final tempValue = posAttrMap['temperature'];
              if (tempValue != null) {
                final temp = double.tryParse(tempValue.toString());
                if (temp != null) {
                  return '${temp.toStringAsFixed(1)}°C';
                }
              }
            }
            if (posAttrMap.containsKey('temp')) {
              final tempValue = posAttrMap['temp'];
              if (tempValue != null) {
                final temp = double.tryParse(tempValue.toString());
                if (temp != null) {
                  return '${temp.toStringAsFixed(1)}°C';
                }
              }
            }
          } catch (e) {
            // JSON parsing failed
          }
        }
        // If no temperature found in posAttr, return N/A instead of timestamp
        return 'N/A';
      } catch (e) {
        // Timestamp parsing failed
      }
    }

    // Try to parse as temperature
    try {
      // Remove any non-numeric characters except decimal point and minus
      final cleanTemp = tmp.replaceAll(RegExp(r'[^\d.-]'), '');
      final temp = double.tryParse(cleanTemp);
      if (temp != null) {
        return '${temp.toStringAsFixed(1)}°C';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }

    // If the original value doesn't contain temperature units, add them
    if (tmp.contains('°') || tmp.contains('C') || tmp.contains('F')) {
      return tmp;
    }

    // If all else fails, show the raw value (truncated if too long)
    return tmp.length > 10 ? '${tmp.substring(0, 10)}...' : tmp;
  }

  String _getGeofenceStatus(String? geofenceIds) {
    if (geofenceIds == null || geofenceIds.isEmpty) return '-';
    final cleanGeofence = geofenceIds.trim();

    // Handle empty array
    if (cleanGeofence == '[]' || cleanGeofence == 'null') {
      return 'Outside';
    }

    // If geofenceIds is "0", null, or empty, it means outside
    if (cleanGeofence == '0' ||
        cleanGeofence.isEmpty ||
        cleanGeofence.toLowerCase() == 'none') {
      return 'Outside';
    } else {
      return 'Inside';
    }
  }

  String _getParkingStatus(String? valid) {
    if (valid == null || valid.isEmpty) return '-';
    final validLower = valid.toLowerCase().trim();

    if (validLower == '1' ||
        validLower == 'true' ||
        validLower == 'parked' ||
        validLower == 'yes' ||
        validLower == 'stop') {
      return 'Parked';
    } else if (validLower == '0' ||
        validLower == 'false' ||
        validLower == 'moving' ||
        validLower == 'no' ||
        validLower == 'run') {
      return 'Moving';
    }
    // If it's a number, treat as boolean
    final numValue = int.tryParse(validLower);
    if (numValue != null) {
      return numValue > 0 ? 'Parked' : 'Moving';
    }
    // If it contains keywords, try to determine status
    if (validLower.contains('park') || validLower.contains('stop')) {
      return 'Parked';
    } else if (validLower.contains('move') || validLower.contains('run')) {
      return 'Moving';
    }
    // If all else fails, show the raw value (truncated if too long)
    return valid.length > 10 ? '${valid.substring(0, 10)}...' : valid;
  }

  String _formatBatteryPercent(String? batteryPercent) {
    if (batteryPercent == null || batteryPercent.isEmpty) return '-';
    try {
      // Remove any non-numeric characters except decimal point
      final cleanBattery = batteryPercent.replaceAll(RegExp(r'[^\d.]'), '');
      final battery = double.tryParse(cleanBattery);
      if (battery != null && battery >= 0 && battery <= 100) {
        return '${battery.toInt()}%';
      } else if (battery != null && battery > 100) {
        // If battery value is greater than 100, it might be in volts
        return '${battery.toStringAsFixed(1)}V';
      }
    } catch (e) {
      // If parsing fails, return the original value
    }
    return batteryPercent;
  }

  String _getACStatus(String? deviceStatus) {
    // Try to extract AC status from posAttr if direct field doesn't contain AC info
    if (deviceStatus != null &&
        deviceStatus.isNotEmpty &&
        !deviceStatus.toLowerCase().contains('ac') &&
        widget.vehicle.posAttr != null &&
        widget.vehicle.posAttr!.isNotEmpty) {
      try {
        final posAttrMap =
            jsonDecode(widget.vehicle.posAttr!) as Map<String, dynamic>;
        // Look for AC-related fields in the JSON
        if (posAttrMap.containsKey('ac')) {
          final acValue = posAttrMap['ac'];
          if (acValue != null) {
            final acNum = int.tryParse(acValue.toString());
            if (acNum != null) {
              return acNum > 0 ? 'ON' : 'OFF';
            }
          }
        }
        // Check ignition status as AC might be related
        if (posAttrMap.containsKey('ignition')) {
          final ignitionValue = posAttrMap['ignition'];
          if (ignitionValue != null) {
            if (ignitionValue.toString().toLowerCase() == 'true') {
              return 'ON'; // AC might be on when ignition is on
            }
          }
        }
      } catch (e) {
        // JSON parsing failed
      }
    }

    if (deviceStatus == null || deviceStatus.isEmpty) return '-';

    final statusLower = deviceStatus.toLowerCase().trim();

    if (statusLower.contains('ac') || statusLower.contains('air')) {
      if (statusLower.contains('on') ||
          statusLower.contains('1') ||
          statusLower.contains('yes')) {
        return 'ON';
      } else if (statusLower.contains('off') ||
          statusLower.contains('0') ||
          statusLower.contains('no')) {
        return 'OFF';
      }
    }
    // If it's a number, treat as boolean
    final numValue = int.tryParse(statusLower);
    if (numValue != null) {
      return numValue > 0 ? 'ON' : 'OFF';
    }
    // If it contains keywords, try to determine status
    if (statusLower.contains('on') || statusLower.contains('1')) {
      return 'ON';
    } else if (statusLower.contains('off') || statusLower.contains('0')) {
      return 'OFF';
    }
    // If all else fails, show the raw value (truncated if too long)
    return deviceStatus.length > 10
        ? '${deviceStatus.substring(0, 10)}...'
        : deviceStatus;
  }

  String _formatGPSBattery(double? battery) {
    if (battery == null) return '-';
    // GPS battery is typically in volts (3.3V - 4.2V for Li-ion)
    if (battery >= 0 && battery <= 10) {
      return '${battery.toStringAsFixed(2)}V';
    } else if (battery > 10 && battery <= 100) {
      // If it's a percentage
      return '${battery.toInt()}%';
    } else if (battery > 100 && battery <= 5000) {
      // High value, might be in millivolts
      return '${(battery / 1000).toStringAsFixed(2)}V';
    }
    return '${battery.toStringAsFixed(2)}V';
  }

  String _getGPSBatteryDisplay() {
    // Try direct field first
    if (widget.vehicle.extBatt != null) {
      return _formatGPSBattery(widget.vehicle.extBatt);
    }

    // Try to extract from posAttr if available
    if (widget.vehicle.posAttr != null && widget.vehicle.posAttr!.isNotEmpty) {
      try {
        final posAttrMap =
            jsonDecode(widget.vehicle.posAttr!) as Map<String, dynamic>;
        if (posAttrMap.containsKey('extBatt')) {
          final extBattValue = posAttrMap['extBatt'];
          if (extBattValue != null) {
            final extBatt = double.tryParse(extBattValue.toString());
            if (extBatt != null) {
              return _formatGPSBattery(extBatt);
            }
          }
        }
      } catch (e) {
        // JSON parsing failed
      }
    }

    return '-';
  }

  String _formatVehicleBattery(double? battery) {
    if (battery == null) return '-';

    // Vehicle battery is typically in volts (12V for car battery, 24V for truck battery)
    if (battery >= 0 && battery <= 30) {
      // Likely voltage (12V or 24V system)
      return '${battery.toStringAsFixed(1)}V';
    } else if (battery > 30 && battery <= 100) {
      // Likely percentage
      return '${battery.toInt()}%';
    } else if (battery > 100 && battery <= 15000) {
      // Very high value, might be in millivolts (typical range for vehicle batteries)
      return '${(battery / 1000).toStringAsFixed(1)}V';
    } else if (battery > 15000) {
      // Extremely high value, might be in microvolts or wrong unit
      return '${(battery / 1000000).toStringAsFixed(2)}V';
    }

    return '${battery.toStringAsFixed(1)}V';
  }

  String _getVehicleBatteryDisplay() {
    // Try multiple data sources for vehicle battery
    if (widget.vehicle.battery != null) {
      return _formatVehicleBattery(widget.vehicle.battery);
    }

    // Try to extract from batteryPercent (which is actually JSON)
    if (widget.vehicle.batteryPercent != null &&
        widget.vehicle.batteryPercent!.isNotEmpty) {
      try {
        final batteryPercentMap =
            jsonDecode(widget.vehicle.batteryPercent!) as Map<String, dynamic>;
        if (batteryPercentMap.containsKey('battery')) {
          final batteryValue = batteryPercentMap['battery'];
          if (batteryValue != null) {
            final battery = double.tryParse(batteryValue.toString());
            if (battery != null) {
              return _formatVehicleBattery(battery);
            }
          }
        }
      } catch (e) {
        // Fallback to string parsing
        return _formatBatteryPercent(widget.vehicle.batteryPercent);
      }
    }

    // Try to extract from posAttr if available
    if (widget.vehicle.posAttr != null && widget.vehicle.posAttr!.isNotEmpty) {
      try {
        final posAttrMap =
            jsonDecode(widget.vehicle.posAttr!) as Map<String, dynamic>;
        if (posAttrMap.containsKey('battery')) {
          final batteryValue = posAttrMap['battery'];
          if (batteryValue != null) {
            final battery = double.tryParse(batteryValue.toString());
            if (battery != null) {
              return _formatVehicleBattery(battery);
            }
          }
        }
      } catch (e) {
        // Try alternative parsing methods
        return _parseBatteryFromString(widget.vehicle.posAttr!);
      }
    }

    return '-';
  }

  String _parseBatteryFromString(String posAttr) {
    // Try to find battery patterns in the string
    final patterns = [
      RegExp(r'battery[:\s]*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'batt[:\s]*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'(\d+\.?\d*)[vV]', caseSensitive: false), // voltage pattern
      RegExp(r'(\d+\.?\d*)%', caseSensitive: false), // percentage pattern
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(posAttr);
      if (match != null) {
        final value = double.tryParse(match.group(1)!);
        if (value != null) {
          return _formatVehicleBattery(value);
        }
      }
    }

    // If no patterns match, try to extract any number that could be battery
    final numbers = RegExp(r'(\d+\.?\d*)').allMatches(posAttr);
    for (final match in numbers) {
      final value = double.tryParse(match.group(1)!);
      if (value != null && value > 0 && value < 50) {
        // Likely voltage range
        return _formatVehicleBattery(value);
      }
    }

    return '-';
  }

  String _formatStatusDuration(String? statusDuration) {
    if (statusDuration == null || statusDuration.isEmpty) return '-';

    // If it's already in a readable format, return as is
    if (statusDuration.contains('ago') ||
        statusDuration.contains('h') ||
        statusDuration.contains('m') ||
        statusDuration.contains('d')) {
      return statusDuration;
    }

    // Try to parse as timestamp and convert to relative time
    try {
      final timestamp = int.tryParse(statusDuration);
      if (timestamp != null) {
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(lastUpdate);

        if (difference.inMinutes < 60) {
          return '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          return '${difference.inHours}h ago';
        } else {
          return '${difference.inDays}d ago';
        }
      }
    } catch (e) {
      // If parsing fails, return the original value
    }

    return statusDuration;
  }

  void _showPlayRouteBottomSheet(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlayRouteBottomSheet(vehicle: vehicle),
    );
  }

  void _callDriver(BuildContext context, GpsCombinedVehicleData vehicle) async {
    final phoneNumber = widget.vehicle.phone;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Driver phone number not available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Clean the phone number (remove spaces, dashes, etc.)
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Add country code if not present (assuming India +91)
    final phoneWithCountryCode =
        cleanPhoneNumber.startsWith('+')
            ? cleanPhoneNumber
            : cleanPhoneNumber.startsWith('91')
            ? '+$cleanPhoneNumber'
            : '+91$cleanPhoneNumber';

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneWithCountryCode);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not launch dialer for $phoneWithCountryCode',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching dialer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

// Info window detail row widget for trip details
class _InfoWindowDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoWindowDetailRow({
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
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
    // Handle different time formats
    final cleanTime = rawIdleTime.trim();

    // Check if it's already in a readable format (e.g., "2h 30m")
    if (cleanTime.contains('h') ||
        cleanTime.contains('hr') ||
        cleanTime.contains('hour')) {
      return cleanTime;
    }

    // Check if it's in HH:MM:SS format
    if (cleanTime.contains(':')) {
      final parts = cleanTime.split(':');
      if (parts.length == 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final seconds = int.tryParse(parts[2]) ?? 0;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
      } else if (parts.length == 2) {
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        totalSeconds = minutes * 60 + seconds;
      }
    } else {
      // Try to parse as a simple number
      totalSeconds = int.tryParse(cleanTime) ?? 0;
    }
  } else if (rawIdleTime is int) {
    totalSeconds = rawIdleTime;
  } else if (rawIdleTime is double) {
    totalSeconds = rawIdleTime.toInt();
  }

  // If the value is very small (less than 1000), it might be in minutes
  // If it's between 1000-100000, it might be in seconds
  // If it's very large, it might already be in seconds
  if (totalSeconds > 0 && totalSeconds < 1000) {
    totalSeconds *= 60; // Convert minutes to seconds
  }

  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return '${hours}h ${minutes}m';
  } else if (hours > 0) {
    return '${hours}h';
  } else if (minutes > 0) {
    return '${minutes}m';
  } else {
    return '0m';
  }
}

class PlayRouteBottomSheet extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;

  const PlayRouteBottomSheet({super.key, required this.vehicle});

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

  void _navigateToPathReplay(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
    String routeType,
  ) {
    // Show date range picker for custom date selection
    _showDateRangePicker(context, vehicle, routeType);
  }

  void _showDateRangePicker(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
    String routeType,
  ) {
    DateTime? startDate;
    DateTime? endDate;

    // Set default date ranges based on route type
    final now = DateTime.now();
    switch (routeType) {
      case 'ignition':
        if (vehicle.lastIgnitionOnFixTime != null &&
            vehicle.lastIgnitionOnFixTime!.isNotEmpty) {
          try {
            startDate = DateTime.parse(vehicle.lastIgnitionOnFixTime!);
            endDate = now;
          } catch (e) {
            startDate = now.subtract(const Duration(days: 1));
            endDate = now;
          }
        } else {
          startDate = now.subtract(const Duration(days: 1));
          endDate = now;
        }
        break;
      case 'daily':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = now;
        break;
      case 'replay':
      default:
        startDate = now.subtract(const Duration(days: 7));
        endDate = now;
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => DateRangePickerBottomSheet(
            vehicle: vehicle,
            routeType: routeType,
            initialStartDate: startDate!,
            initialEndDate: endDate!,
            onDateRangeSelected: (selectedStartDate, selectedEndDate) {
              _navigateToPathReplayWithDates(
                context,
                vehicle,
                routeType,
                selectedStartDate,
                selectedEndDate,
              );
            },
          ),
    );
  }

  void _navigateToPathReplayWithDates(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
    String routeType,
    DateTime startDate,
    DateTime endDate,
  ) {
    final Map<String, dynamic> queryParams = {
      "start": startDate.toUtc().toIso8601String(),
      "end": endDate.toUtc().toIso8601String(),
      "timezone_offset": "0",
      "inputs": {},
      "device_ids": vehicle.deviceId,
      "fwd_variable": 0.0,
    };

    // Determine if bottom sheet should be shown based on route type
    final showBottomSheet = routeType == 'replay';

    // Navigate to path replay screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PathReplayScreen(
              token: AppConstants.token ?? '',
              queryParams: queryParams,
              vehicleNumber: vehicle.vehicleNumber,
              routeType: routeType,
              showBottomSheet: showBottomSheet,
            ),
      ),
    );
  }
}

/// A bottom sheet widget that allows users to select a custom date range for path replay.
///
/// This widget provides:
/// - Date picker for start and end dates
/// - Quick selection buttons for common date ranges (Today, Last 7 Days, Last 30 Days)
/// - Date range validation and warnings for large ranges
/// - Automatic navigation to path replay screen with selected dates
class DateRangePickerBottomSheet extends StatefulWidget {
  final GpsCombinedVehicleData vehicle;
  final String routeType;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  const DateRangePickerBottomSheet({
    super.key,
    required this.vehicle,
    required this.routeType,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<DateRangePickerBottomSheet> createState() =>
      _DateRangePickerBottomSheetState();
}

class _DateRangePickerBottomSheetState
    extends State<DateRangePickerBottomSheet> {
  late DateTime startDate;
  late DateTime endDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;

    // Ensure initial date range doesn't exceed 7 days
    final daysDifference = endDate.difference(startDate).inDays;
    if (daysDifference > 6) {
      // If range is too large, adjust end date to be 7 days from start
      endDate = startDate.add(const Duration(days: 6));
    }

    // Ensure dates are not in the future
    final now = DateTime.now();
    if (endDate.isAfter(now)) {
      endDate = now;
      // Recalculate start date to maintain 7-day limit, but allow shorter ranges
      if (startDate.isAfter(endDate)) {
        startDate = endDate;
      }
    }

    _updateControllers();
  }

  void _updateControllers() {
    startDateController.text = _formatDate(startDate);
    endDateController.text = _formatDate(endDate);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    // Calculate valid date ranges to ensure maximum 7 days
    DateTime? firstDate;
    DateTime? lastDate;

    if (isStartDate) {
      // For start date: can be any date up to 6 days before end date
      firstDate = DateTime(2020);
      lastDate = endDate.subtract(
        const Duration(days: 0),
      ); // Allow selecting same day as end date
      // Ensure lastDate is not in the future
      if (lastDate.isAfter(DateTime.now())) {
        lastDate = DateTime.now();
      }
      // Ensure lastDate is not before firstDate
      if (lastDate.isBefore(firstDate)) {
        lastDate = firstDate;
      }
    } else {
      // For end date: can be any date from start date up to 6 days after
      firstDate = startDate.add(
        const Duration(days: 0),
      ); // Allow selecting same day as start date
      lastDate = DateTime.now();
      // Ensure firstDate is not after lastDate
      if (firstDate.isAfter(lastDate)) {
        firstDate = lastDate;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // Ensure end date is not before start date
          if (endDate.isBefore(startDate)) {
            endDate = startDate;
          }
          // Ensure date range doesn't exceed 7 days, but allow shorter ranges
          if (endDate.difference(startDate).inDays > 6) {
            endDate = startDate.add(const Duration(days: 6));
          }
        } else {
          endDate = picked;
          // Ensure start date is not after end date
          if (startDate.isAfter(endDate)) {
            startDate = endDate;
          }
          // Ensure date range doesn't exceed 7 days, but allow shorter ranges
          if (endDate.difference(startDate).inDays > 6) {
            startDate = endDate.subtract(const Duration(days: 6));
          }
        }
        _updateControllers();
      });
    }
  }

  String _getRouteTypeTitle() {
    switch (widget.routeType) {
      case 'ignition':
        return 'Ignition Path';
      case 'daily':
        return 'Daily Path';
      case 'replay':
        return 'Path Replay';
      default:
        return 'Route';
    }
  }

  String _getRouteTypeDescription() {
    switch (widget.routeType) {
      case 'ignition':
        return 'View the vehicle path from ignition start time';
      case 'daily':
        return 'View today\'s complete vehicle path';
      case 'replay':
        return 'View vehicle path for selected date range';
      default:
        return 'View vehicle path';
    }
  }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getRouteTypeTitle(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getRouteTypeDescription(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
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
          // Date range selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Start Date
                _buildDateField(
                  label: 'Start Date',
                  controller: startDateController,
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),
                // End Date
                _buildDateField(
                  label: 'End Date',
                  controller: endDateController,
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 20),
                // Quick date range buttons
                Row(
                  children: [
                    Expanded(
                      child: _QuickDateButton(
                        label: 'Today',
                        onTap: () {
                          final now = DateTime.now();
                          setState(() {
                            startDate = DateTime(now.year, now.month, now.day);
                            endDate = now;
                            _updateControllers();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickDateButton(
                        label: 'Last 3 Days',
                        onTap: () {
                          final now = DateTime.now();
                          setState(() {
                            startDate = now.subtract(const Duration(days: 2));
                            endDate = now;
                            _updateControllers();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _QuickDateButton(
                        label: 'Last 7 Days',
                        onTap: () {
                          final now = DateTime.now();
                          setState(() {
                            startDate = now.subtract(const Duration(days: 6));
                            endDate = now;
                            _updateControllers();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickDateButton(
                        label: 'Last 2 Days',
                        onTap: () {
                          final now = DateTime.now();
                          setState(() {
                            startDate = now.subtract(const Duration(days: 1));
                            endDate = now;
                            _updateControllers();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Helper text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Select a date range to view the vehicle path (minimum 1 day, maximum 7 days). You can select any date range within these limits.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate date range
                          final daysDifference =
                              endDate.difference(startDate).inDays;
                          if (daysDifference < 0) {
                            // Show warning for invalid date range
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Invalid Date Range'),
                                    content: const Text(
                                      'Start date cannot be after end date. Please select a valid date range.',
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          } else if (daysDifference > 6) {
                            // Show warning for date ranges exceeding 7 days
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text(
                                      'Date Range Limit Exceeded',
                                    ),
                                    content: Text(
                                      'You have selected a date range of ${daysDifference + 1} days. The maximum allowed range is 7 days. Please select a smaller date range.',
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          } else {
                            Navigator.pop(context);
                            widget.onDateRangeSelected(startDate, endDate);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'View Path',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blue[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickDateButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.blue[700],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
            Icon(icon, color: Colors.blue, size: 24),
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
            const Icon(Icons.chevron_right, color: Colors.black54, size: 20),
          ],
        ),
      ),
    );
  }
}

// Helper function for refresh functionality
Future<void> _performRefresh(BuildContext context) async {
  try {
    // Show loading state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Refreshing GPS data...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );

    // Trigger GPS data refresh using the lifecycle extension
    await context.gpsManualRefresh();

    // Also refresh vehicle list data
    await context.read<VehicleListCubit>().refreshData();

    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 16),
              SizedBox(width: 12),
              Text('GPS data refreshed successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    // Show error message
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 16),
              SizedBox(width: 12),
              Text('Failed to refresh GPS data'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
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
