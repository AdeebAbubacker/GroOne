import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/utils/app_colors.dart';
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

  final ValueNotifier<Set<Marker>> _markers = ValueNotifier({});
  String kilometers = '';
  GoogleMapController? googleMapController;
  final vpDetailsCubit = locator<LoadDetailsCubit>();
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }


  @override
  void initState() {
    super.initState();
  }

  void setMapMarkers({bool addMarker=true,String? points}) async {
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(widget.pickUpLatLong??"0,0");
    final dropLatLng = TripTrackingHelper.getLatLngFromString(widget.dropLatLong??"0,0");


    frameCallback(() async {
     if(addMarker){
       _markers.value.add(
         Marker(
           markerId: MarkerId('pickup'),
           position: pickupLatLng,
           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
           infoWindow: InfoWindow(title: 'Pickup: ${widget.pickupLocation}'),
         ),
       );
       _markers.value.add(
         Marker(
           markerId: MarkerId('drop'),
           position: dropLatLng,
           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
           infoWindow: InfoWindow(title: 'Drop: ${widget.dropLocation}'),
         ),
       );
       double distanceInMeters = Geolocator.distanceBetween(
         pickupLatLng.latitude,
         pickupLatLng.longitude,
         dropLatLng.latitude,
         dropLatLng.longitude,
       );
       await vpDetailsCubit.getMapRouting(
           dropLong: dropLatLng.longitude.toString(),
           dropLat: dropLatLng.latitude.toString(),
           pickUpLat: pickupLatLng.latitude.toString(),pickUpLong:  pickupLatLng.longitude.toString());
     }else{
       _polylineCoordinates.clear();
       List<PointLatLng> result = PolylinePoints().decodePolyline(points??"");
       for (var point in result) {
         _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
       }
       _polylines.add(Polyline(
         polylineId: PolylineId("route"),
         color: AppColors.primaryColor.withOpacity(0.7),
         width: 5,
         points: _polylineCoordinates,
       ));

     }

     },);


    _markers.notifyListeners();



    // googleMapController?.animateCamera(
    //   CameraUpdate.newLatLngBounds(bounds, 120),
    // );
  }




  @override
  Widget build(BuildContext context) {
    return buildGoogleMapWidget();
  }

  Widget buildGoogleMapWidget(){
    return BlocBuilder<LoadDetailsCubit,LoadDetailsState>(
      builder:(context, state)  {
        if(state.directionApiResponse?.status==Status.SUCCESS){
          if((state.directionApiResponse?.data?.routes??[]).isNotEmpty){
            setMapMarkers(addMarker: false,points: state.directionApiResponse?.data?.routes.first.overviewPolyline.points);
          }

        }
        return ValueListenableBuilder(
          valueListenable: _markers,

          builder: (context, value, child)  {
            return GoogleMap(
               initialCameraPosition: CameraPosition(
                target: LatLng(12.993959463114383,80.17066519707441),
                zoom: 10,
              ),
              markers: value,
              polylines: _polylines,
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
          }
        );
      },
    );
  }
}
