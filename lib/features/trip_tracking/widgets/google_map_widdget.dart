import 'dart:ui';
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
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class GoogleMapWidget extends StatefulWidget {
  final String? pickupLocation;
  final String? dropLocation;

  // Pickup co-ordinate
  final String? pickUpLatLong;
  final String? dropLatLong;

  final double? driverLat;
  final double? driverLong;





  // Drop co-ordinate
  const GoogleMapWidget({super.key,this.pickupLocation,this.dropLocation,this.pickUpLatLong,this.dropLatLong, this.driverLat, this.driverLong});

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

  Future<BitmapDescriptor> getResizedBitmapDescriptor(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100,
    );
    final frame = await codec.getNextFrame();
    final ByteData? resizedImage = await frame.image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedImage!.buffer.asUint8List());
  }


  void setMapMarkers({bool addMarker=true,String? points}) async {
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(widget.pickUpLatLong??"0,0");
    final dropLatLng = TripTrackingHelper.getLatLngFromString(widget.dropLatLong??"0,0");

    BitmapDescriptor driverIcon = await getResizedBitmapDescriptor(
      AppImage.jpg.driverImaged,
    );

    frameCallback(() async {
     if(addMarker){
       _markers.value.add(
         Marker(
           markerId: MarkerId(navigatorKey.currentState!.context.appText.pickup),
           position: pickupLatLng,
           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
           infoWindow: InfoWindow(title: '${navigatorKey.currentState!.context.appText.pickup}: ${widget.pickupLocation}'),
         ),
       );
       _markers.value.add(
         Marker(
           markerId: MarkerId(navigatorKey.currentState!.context.appText.drop),
           position: dropLatLng,
           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
           infoWindow: InfoWindow(title: '${navigatorKey.currentState!.context.appText.drop}: ${widget.dropLocation}'),
         ),
       );

       double distanceInMeters = Geolocator.distanceBetween(
         pickupLatLng.latitude,
         pickupLatLng.longitude,
         dropLatLng.latitude,
         dropLatLng.longitude,
       );
       // Driver marker (if valid)
       if (widget.driverLat != null && widget.driverLong != null) {
         final driverLatLng = LatLng(widget.driverLat!, widget.driverLong!);
         _markers.value.add(
           Marker(
             markerId: MarkerId(navigatorKey.currentState!.context.appText.driver),
             position: driverLatLng,
             icon: driverIcon,
             infoWindow:  InfoWindow(title: navigatorKey.currentState!.context.appText.driverLocation),
           ),
         );
       }

       await vpDetailsCubit.getMapRouting(
           dropLong: dropLatLng.longitude.toString(),
           dropLat: dropLatLng.latitude.toString(),
           pickUpLat: pickupLatLng.latitude.toString(),pickUpLong:  pickupLatLng.longitude.toString());

     }else{
       _polylineCoordinates.clear();
       List<PointLatLng> result = PolylinePoints().decodePolyline(points ?? "");
       for (var point in result) {
         _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
       }

       // If driver position is available, split polyline
       if (widget.driverLat != null && widget.driverLong != null) {
         final driverLatLng = LatLng(widget.driverLat!, widget.driverLong!);


         int closestIndex = 0;
         double minDistance = double.infinity;

         for (int i = 0; i < _polylineCoordinates.length; i++) {
           final p = _polylineCoordinates[i];
           double distance = Geolocator.distanceBetween(
             driverLatLng.latitude,
             driverLatLng.longitude,
             p.latitude,
             p.longitude,
           );
           if (distance < minDistance) {
             minDistance = distance;
             closestIndex = i;
           }
         }

         final List<LatLng> greenSegment = _polylineCoordinates.sublist(0, closestIndex + 1);
         final List<LatLng> blueSegment = _polylineCoordinates.sublist(closestIndex);

         _polylines.clear();

         _polylines.add(Polyline(
           polylineId: PolylineId(navigatorKey.currentState!.context.appText.completed),
           color: Colors.green,
           width: 5,
           points: greenSegment,
         ));

         _polylines.add(Polyline(
           polylineId: PolylineId(navigatorKey.currentState!.context.appText.remainingDistance),
           color: AppColors.primaryColor.withOpacity(0.7),
           width: 5,
           points: blueSegment,
         ));

       } else {
         _polylines.clear();
         _polylines.add(Polyline(
           polylineId: PolylineId(navigatorKey.currentState!.context.appText.route),
           color: AppColors.primaryColor.withOpacity(0.7),
           width: 5,
           points: _polylineCoordinates,
         ));
       }


     }

     },);


    _markers.notifyListeners();

    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );

    // Move camera to show both markers
    LatLngBounds bounds;


    double padding;

    if (distanceInMeters < 10000) { // less than 10 km
      padding = 50;
    } else if (distanceInMeters < 50000) { // 10 km - 50 km
      padding = 80;
    } else if (distanceInMeters < 200000) { // 50 km - 200 km
      padding = 120;
    } else {
      padding = 150; // for long distances
    }

    bounds = LatLngBounds(
      southwest: LatLng(
        pickupLatLng.latitude < dropLatLng.latitude ? pickupLatLng.latitude : dropLatLng.latitude,
        pickupLatLng.longitude < dropLatLng.longitude ? pickupLatLng.longitude : dropLatLng.longitude,
      ),
      northeast: LatLng(
        pickupLatLng.latitude > dropLatLng.latitude ? pickupLatLng.latitude : dropLatLng.latitude,
        pickupLatLng.longitude > dropLatLng.longitude ? pickupLatLng.longitude : dropLatLng.longitude,
      ),
    );



    await Future.delayed(const Duration(milliseconds: 300));


    try {
      await googleMapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, padding),
      );
    } catch (e) {
      debugPrint("animateCamera failed: $e");
    }




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
                   // await _setMapStyle(controller);
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
