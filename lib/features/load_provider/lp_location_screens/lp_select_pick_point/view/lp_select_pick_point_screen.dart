import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_location_screens/lp_select_pick_point/bloc/lp_map_select_pick_point_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  const LpSelectPickPointScreen({super.key});

  @override
  State<LpSelectPickPointScreen> createState() => _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen> {

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? mapController;

  final bloc = locator<LpMapSelectPickPointBloc>();

  TextEditingController address = TextEditingController(text: "Coca Cola Bottling Plant, Nemam, Vellavedu, Tamil Nadu 600124");



  bool locationDone = true;
  LatLng? centerLatLng;
  String _address = 'No address found';

  double zoomLevel = 12.0;

  @override
  void initState() {
    initFun();
    super.initState();
  }

  @override
  void dispose(){
    disposeFun();
    super.dispose();
  }


  initFun()=> addPostFrameCallback(() async {
    bloc.add(FetchCurrentLatLong());
  });

  disposeFun()=> addPostFrameCallback(() async {
  });

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

  //
  // Future<void> _getCurrentLocation({bool fromAnimate = false}) async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) return;
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) return;
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) return;
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.bestForNavigation,
  //   );
  //
  //   LatLng newLatLng = LatLng(position.latitude, position.longitude);
  //
  //   setState(() {
  //     centerLatLng = newLatLng;
  //   });
  //
  //   await getAddressFromLatLng(newLatLng.latitude, newLatLng.longitude);
  //
  //   if (fromAnimate && _mapController != null) {
  //     _mapController!.animateCamera(
  //       CameraUpdate.newLatLngZoom(newLatLng, 15.0),
  //     );
  //   }
  // }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      setState(() {
        _address =
        '${place.street}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        _address = 'Error: $e';
      });
    }
  }


  Future<BitmapDescriptor> _getMarkerIcon(String category) async {
    return BitmapDescriptor.defaultMarker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: locationDone ? "Select Pick Point Location" : "Select Destination",),
      body: BlocBuilder<LpMapSelectPickPointBloc, LpMapSelectPickPointState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is LatLongLoading) {
            return CircularProgressIndicator().center();
          } else if (state is LatLongSuccess) {
            return buildBodyWidget(lat: state.position.latitude, long: state.position.longitude);
          } else if (state is LatLongError) {
            return Text("Error: ${state.errorType}");
          }
          return 0.height;
        },
      ),
    );
  }

  // Body
  Widget buildBodyWidget({required double lat, required double long}){
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // Map view
          buildMapWidget(lat: lat, long: long),

          // Address
          buildAddressWidget(context),
        ],
      ),
    );
  }

  // Map View
  Widget buildMapWidget({required double lat, required double long}){
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 500.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Map
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: zoomLevel),
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              await _setMapStyle(controller);
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            onTap: (position){

            },
          ),

          // Marker
          Icon(CupertinoIcons.location_solid, color: AppColors.primaryColor, size: 30).paddingBottom(70),
        ],
      ),
    );
  }


  Widget buildAddressWidget(BuildContext context){
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: commonContainerDecoration(shadow: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(context.appText.location, style: AppTextStyle.body),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 50,
              decoration: commonContainerDecoration(),
              child: Text(
                _address,
                style: AppTextStyle.textBlackColor14w400.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            20.height,


            AppTextField(
              controller: address,
              labelText: context.appText.address,
              textInputAction: TextInputAction.done,
            ),
            30.height,


            AppButton(
              title: locationDone ? "Set Pickup Location" : "Continue",
              onPressed: () {
                if (!locationDone) {
                  context.pop();
                } else {
                  locationDone = false;
                  setState(() {});
                }
              },
            ).bottomButtonPadding(),
          ],
        ).paddingAll(commonSafeAreaPadding),
      ),
    );
  }


}
