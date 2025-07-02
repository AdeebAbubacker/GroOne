import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

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
  final vpDetailsCubit = locator<LoadDetailsCubit>();

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }


  @override
  void initState() {

    super.initState();
  }

  void setMapMarkers() async {
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(widget.pickUpLatLong??"0,0");
    final dropLatLng = TripTrackingHelper.getLatLngFromString(widget.dropLatLong??"0,0");

   frameCallback(() {
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
     vpDetailsCubit.getMapRouting(
         dropLong: dropLatLng.longitude.toString(),
         dropLat: dropLatLng.latitude.toString(),
         pickUpLat: pickupLatLng.latitude.toString(),pickUpLong:  pickupLatLng.longitude.toString());
   },);


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
