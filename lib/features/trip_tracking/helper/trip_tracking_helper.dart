import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripTrackingHelper{
 static  LatLng getLatLngFromString(String latLng) {

    if (latLng.isEmpty || !latLng.contains(',')) {
      return const LatLng(0, 0);
    }
    final cleaned = latLng.replaceAll('[', '').replaceAll(']', '');
    final parts = cleaned.split(',');
    return LatLng(double.tryParse(parts[0].trim())??0, double.tryParse(parts[1].trim())??88.37060880000001);
  }

}