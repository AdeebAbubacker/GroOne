import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPlacesBottomSheet extends StatelessWidget {
  const NearbyPlacesBottomSheet({super.key});

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
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                const Text(
                  'Nearby Places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Place options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _PlaceOption(
                  iconPath: 'assets/icons/png/gas_station_icon.png',
                  label: 'Gas Station',
                  onTap: () => _openGoogleMaps(context, 'gas station'),
                ),
                _PlaceOption(
                  iconPath: 'assets/icons/png/restroom_icon.png',
                  label: 'Restroom',
                  onTap: () => _openGoogleMaps(context, 'restroom'),
                ),
                _PlaceOption(
                  iconPath: 'assets/icons/png/restaurant_icon.png',
                  label: 'Restaurant',
                  onTap: () => _openGoogleMaps(context, 'restaurant'),
                ),
                _PlaceOption(
                  iconPath: 'assets/icons/png/police_station_icon.png',
                  label: 'Police Station',
                  onTap: () => _openGoogleMaps(context, 'police station'),
                ),
                _PlaceOption(
                  iconPath: 'assets/icons/png/medical_facility_icon.png',
                  label: 'Medical Facility',
                  onTap: () => _openGoogleMaps(context, 'hospital'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _openGoogleMaps(BuildContext context, String placeType) async {
    try {
      // Get current location
      final locationService = LocationService();
      final result = await locationService.getCurrentLatLong();

      if (result is Success<geo.Position>) {
        final position = result.value;
        final lat = position.latitude;
        final lng = position.longitude;

        // Create Google Maps URL with search query
        final url =
            'https://www.google.com/maps/search/$placeType/@$lat,$lng,14z';

        final Uri uri = Uri.parse(url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (context.mounted) {
            Navigator.pop(context); // Close bottom sheet
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not open Google Maps'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not get current location'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Google Maps: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _PlaceOption extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _PlaceOption({
    required this.iconPath,
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
            Image.asset(iconPath, width: 24, height: 24, fit: BoxFit.contain),
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
