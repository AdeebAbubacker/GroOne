import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/utils/app_json.dart';

class GoogleMapWidget extends StatefulWidget {
  final String? pickupLocation;
  final String? dropLocation;

  // Pickup co-ordinate
  final String? pickUpLatLong;
  final String? dropLatLong;

  // Drop co-ordinate


  const GoogleMapWidget({super.key,this.pickupLocation,this.dropLocation,this.pickUpLatLong,this.dropLatLong});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  final Set<Marker> _markers = {};
  String kilometers = '';
  GoogleMapController? googleMapController;

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

  LatLng _getLatLngFromString(String latLng) {
    if (latLng.isEmpty || !latLng.contains(',')) {
      return const LatLng(0, 0);
    }
    final parts = latLng.split(', ');
    return LatLng(double.parse(parts[0].trim()), double.tryParse(parts[1].trim())??88.37060880000001);
  }

  void setMapMarkers() async {
    final pickupLatLng = _getLatLngFromString(widget.pickUpLatLong??"0,0");
    final dropLatLng = _getLatLngFromString(widget.dropLatLong??"0,0");

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Pickup: ${widget.pickupLocation}'),
        ),
      );


      _markers.add(
        Marker(
          markerId: MarkerId('drop'),
            position: dropLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop: ${widget.dropLocation}'),
        ),
      );
    });

    print("_markers is ${_markers}");


    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );


    kilometers = '${(distanceInMeters / 1000).toStringAsFixed(2)} KM';


    // Move camera to show both markers
    LatLngBounds bounds;

    if (pickupLatLng.latitude > dropLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: dropLatLng,
        northeast: pickupLatLng,
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: dropLatLng,
      );
    }


    await Future.delayed(const Duration(milliseconds: 300));
    // googleMapController?.animateCamera(
    //   CameraUpdate.newLatLngBounds(bounds, 120),
    // );
  }


  @override
  Widget build(BuildContext context) {
    return buildGoogleMapWidget();
  }

  Widget buildGoogleMapWidget(){
    return Builder(
      builder: (context) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(12.993959463114383,80.17066519707441),
            zoom: 10,
          ),
          markers: _markers,

          onMapCreated: (controller) async {
           googleMapController = controller;
            await _setMapStyle(controller);
            setMapMarkers();
          },
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        );
      },
    );
  }
}
