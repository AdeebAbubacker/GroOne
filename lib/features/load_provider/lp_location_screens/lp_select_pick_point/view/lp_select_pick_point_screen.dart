import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  const LpSelectPickPointScreen({super.key});

  @override
  State<LpSelectPickPointScreen> createState() => _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen> {
  TextEditingController address = TextEditingController(
    text: "Coca Cola Bottling Plant, Nemam, Vellavedu, Tamil Nadu 600124",
  );

  GoogleMapController? _mapController;
  bool locationDone = true;
  LatLng? centerLatLng;
  String _address = 'No address found';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation({bool fromAnimate = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    LatLng newLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      centerLatLng = newLatLng;
    });

    await getAddressFromLatLng(newLatLng.latitude, newLatLng.longitude);

    if (fromAnimate && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(newLatLng, 15.0),
      );
    }
  }

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

  void _onCameraMove(CameraPosition position) {
    centerLatLng = position.target;
  }

  void _onCameraIdle() {
    if (centerLatLng != null) {
      getAddressFromLatLng(centerLatLng!.latitude, centerLatLng!.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: locationDone ? "Select Pick Point Location" : "Select Destination",
      ),
      body: Stack(
        children: [
          if (centerLatLng == null)
            const Center(child: CircularProgressIndicator())
          else
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 500.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: centerLatLng!,
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                  ),
                  const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                  Positioned(
                    right: 10,
                    bottom: 30,
                    child: IconButton(
                      onPressed: () => _getCurrentLocation(fromAnimate: true),
                      icon: Icon(Icons.my_location, color: AppColors.primaryDarkColor),
                    ),
                  )
                ],
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 340.h,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: AppTextStyle.textBlackColor16w400),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.disableColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Text(
                        _address,
                        style: AppTextStyle.textBlackColor14w400.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: address,
                      labelText: "Address",
                      labelTextStyle: AppTextStyle.textBlackColor16w400,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
