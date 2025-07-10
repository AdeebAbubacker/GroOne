import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../dependency_injection/locator.dart';
import '../cubit/vehicle_detail_cubit.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../widgets/map_floating_menu.dart';

class VehicleMapDetailScreen extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  const VehicleMapDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<VehicleDetailCubit>(),
      child: _VehicleMapDetailView(vehicle: vehicle),
    );
  }
}

class _VehicleMapDetailView extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  const _VehicleMapDetailView({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Stack(
          children: [
            // Map section
            Positioned.fill(
              child: BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
                builder: (context, state) {
                  return _VehicleMapSection(
                    vehicle: vehicle,
                    mapType: state.mapType,
                    trafficEnabled: state.trafficEnabled,
                  );
                },
              ),
            ),
            // Top info card overlay
            Positioned(
              top: 24,
              left: 16,
              right: 16,
              child: _VehicleInfoOverlayCard(vehicle: vehicle),
            ),
            // Floating map actions overlay
            Positioned(
              right: 16,
              bottom: 180,
              child: Column(
                children: [
                  // Floating menu
                  BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
                    builder: (context, state) {
                      return MapFloatingMenu(
                        onToggleTraffic:
                            () =>
                                context
                                    .read<VehicleDetailCubit>()
                                    .toggleTraffic(),
                        onToggleMapType:
                            () =>
                                context
                                    .read<VehicleDetailCubit>()
                                    .toggleMapType(),
                        onReachability: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reachability feature coming soon!',
                              ),
                            ),
                          );
                        },
                        onNearbyVehicles: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Nearby Vehicles feature coming soon!',
                              ),
                            ),
                          );
                        },
                        onNearbyPlaces: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Nearby Places feature coming soon!',
                              ),
                            ),
                          );
                        },
                        isTrafficEnabled: state.trafficEnabled,
                        isSatellite: state.mapType == MapType.satellite,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Location icon
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        // TODO: Implement location functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Location feature coming soon!'),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Draggable bottom sheet
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return _VehicleBottomCard(
                  vehicle: vehicle,
                  scrollController: scrollController,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedBadge extends StatelessWidget {
  final String speed;
  const _SpeedBadge({required this.speed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            speed.split(' ').first,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          const Text(
            'Km/h',
            style: TextStyle(fontSize: 11, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _VehicleBottomCard extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final ScrollController? scrollController;
  const _VehicleBottomCard({required this.vehicle, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatIconItem(
                  icon: Icons.speed,
                  label: 'Odo',
                  value:
                      vehicle.odoReading?.isNotEmpty == true
                          ? vehicle.odoReading!
                          : '-',
                  sublabel: '',
                  color: Colors.grey[800]!,
                ),
                _StatIconItem(
                  icon: Icons.directions_car,
                  label: 'Moving Time',
                  value:
                      vehicle.todayDistance?.isNotEmpty == true
                          ? vehicle.todayDistance!
                          : '-',
                  sublabel: vehicle.statusDuration ?? '-',
                  color: Colors.green,
                ),
                _StatIconItem(
                  icon: Icons.timelapse,
                  label: 'Idle',
                  value: '-', // If you have idle data, use it here
                  sublabel: '-',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action buttons row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ActionButton(
                    label: 'Play route',
                    icon: Icons.play_arrow,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Capture',
                    icon: Icons.camera_alt,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Share',
                    icon: Icons.share,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Call driver',
                    icon: Icons.phone,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Info rows
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                const Text(
                  'Last Trip Time',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  vehicle.lastUpdate != null
                      ? _formatTime(vehicle.lastUpdate!)
                      : '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.speed, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                const Text(
                  'Max Speed',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  vehicle.lastSpeed?.isNotEmpty == true
                      ? vehicle.lastSpeed!
                      : '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Status chips row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChipWithIcon(
                  icon: Icons.flash_on,
                  label: 'Immobilizer',
                  value: '-',
                  color: Colors.red,
                ),
                _StatusChipWithIcon(
                  icon: Icons.door_front_door,
                  label: 'Door',
                  value: '-',
                  color: Colors.grey,
                ),
                _StatusChipWithIcon(
                  icon: Icons.thermostat,
                  label: 'Temp',
                  value: '-',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
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

class _VehicleInfoOverlayCard extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  const _VehicleInfoOverlayCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
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
                        vehicle.vehicleNumber ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(
                        label: (vehicle.status ?? '-').capitalize(),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      vehicle.status == 'IGNITION_ON'
                          ? 'ON'
                          : (vehicle.status == 'IGNITION_OFF' ? 'OFF' : '-'),
                      style: TextStyle(
                        color:
                            vehicle.status == 'IGNITION_ON'
                                ? Colors.green
                                : (vehicle.status == 'IGNITION_OFF'
                                    ? Colors.red
                                    : Colors.grey),
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
        color: color.withOpacity(0.1),
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

class _VehicleMapSection extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final MapType mapType;
  final bool trafficEnabled;

  const _VehicleMapSection({
    required this.vehicle,
    required this.mapType,
    required this.trafficEnabled,
  });

  @override
  Widget build(BuildContext context) {
    LatLng? latLng;
    if (vehicle.location != null && vehicle.location!.contains(',')) {
      final parts = vehicle.location!.split(',');
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        latLng = LatLng(lat, lng);
      }
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 260,
        child: GoogleMap(
          initialCameraPosition:
              latLng != null
                  ? CameraPosition(target: latLng, zoom: 14)
                  : const CameraPosition(
                    target: LatLng(20.5937, 78.9629),
                    zoom: 4,
                  ),
          markers:
              latLng != null
                  ? {
                    Marker(
                      markerId: MarkerId(vehicle.vehicleNumber ?? 'unknown'),
                      position: latLng,
                      infoWindow: InfoWindow(title: vehicle.vehicleNumber),
                    ),
                  }
                  : {},
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: mapType,
          trafficEnabled: trafficEnabled,
        ),
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
