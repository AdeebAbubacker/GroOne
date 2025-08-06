import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helper/vehicle_marker_helper.dart';
import '../model/gps_combined_vehicle_model.dart';

/// Custom overlay widget to display vehicle icons on the map
class VehicleIconOverlay extends StatelessWidget {
  final List<GpsCombinedVehicleData> vehicles;
  final GoogleMapController? mapController;
  final Function(GpsCombinedVehicleData) onVehicleTap;

  const VehicleIconOverlay({
    super.key,
    required this.vehicles,
    this.mapController,
    required this.onVehicleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
          vehicles.map((vehicle) {
            return _buildVehicleIcon(vehicle, context);
          }).toList(),
    );
  }

  Widget _buildVehicleIcon(
    GpsCombinedVehicleData vehicle,
    BuildContext context,
  ) {
    // Parse location
    final loc = vehicle.location;
    if (loc == null || !loc.contains(',')) {
      return const SizedBox.shrink();
    }

    final parts = loc.split(',');
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      top: 0,
      child: GestureDetector(
        onTap: () => onVehicleTap(vehicle),
        child: Container(
          width: 48,
          height: 48,
          child: VehicleMarkerHelper.createVehicleIconWidget(
            vehicleCategory: vehicle.category,
            status: vehicle.status,
            lastUpdate: vehicle.lastUpdate,
            isExpired: false,
            size: 48.0,
          ),
        ),
      ),
    );
  }
}

/// Alternative approach using custom markers with vehicle icons
class VehicleIconMarker extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final VoidCallback onTap;

  const VehicleIconMarker({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: VehicleMarkerHelper.createVehicleIconWidget(
          vehicleCategory: vehicle.category,
          status: vehicle.status,
          lastUpdate: vehicle.lastUpdate,
          isExpired: false,
          size: 48.0,
        ),
      ),
    );
  }
}
