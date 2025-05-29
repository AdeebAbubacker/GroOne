import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:latlong2/latlong.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  final String title;
  final String? address;
  const LpSelectPickPointScreen({super.key, required this.title, this.address});

  @override
  State<LpSelectPickPointScreen> createState() => _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen> with TickerProviderStateMixin {

  TextEditingController addressTextController = TextEditingController();
  late final AnimatedMapController _animatedMapController;

  @override
  void initState() {
    init();
    _animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
    _getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  void init()=> addPostFrameCallback((){
    addressTextController.text = widget.address ?? "";
  });

  bool locationDone = true;

  LatLng? centerLatLng; // Initial center (Adichunchanagiri area)
  String _address = 'No address found';

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      _address = '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
      print('datata  ${place.locality}, ${place.country}');
    } catch (e) {
      setState(() {
        _address = 'Error: $e';
      });
    }
  }

  Future<void> _getCurrentLocation({bool fromAnimate = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    setState(() {
      debugPrint("Position ${position.heading}");
      centerLatLng = LatLng(position.latitude, position.longitude);
      getAddressFromLatLng(position.latitude, position.longitude);
      if (fromAnimate) {
        _animateToLocation(LatLng(position.latitude, position.longitude));
      }
    });
  }

  void _animateToLocation(LatLng latLng) {
    _animatedMapController.animateTo(
      dest: latLng,
      zoom: 15.0, // Adjust zoom level as needed
    );
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    if (position.center != null &&
        !position.center!.latitude.isNaN &&
        !position.center!.longitude.isNaN) {

      setState(() {
        centerLatLng = position.center!;
        getAddressFromLatLng(centerLatLng!.latitude, centerLatLng!.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("centerLatLng ${centerLatLng}");
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.title,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child:
            SizedBox(
              height: 500.h,
              width: double.infinity,
              child: centerLatLng == null
                  ? Center(child: CircularProgressIndicator())
                  :Stack(
                alignment: Alignment.center,
                children: [
                  FlutterMap(
                    mapController: _animatedMapController.mapController,
                    options: MapOptions(
                      // initialCenter: centerLatLng!,
                      initialCenter: centerLatLng!,
                      initialZoom: 15.0,
                      onPositionChanged: _onPositionChanged,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        //change base_snow_map to pistes
                        subdomains: ['a', 'b', 'c'],
                      ),

                      // MarkerLayer to display markers on the map
                      MarkerLayer(
                        markers: [
                          Marker(
                            // The marker's point is always the current map center.
                            point: centerLatLng!,
                            width: 80.0,
                            height: 80.0,
                            // Builder function to define the appearance of the marker.
                            child: const Icon(
                              Icons.location_pin,
                              // Using a standard location pin icon
                              color:
                              Colors
                                  .red, // Red color for visibility
                              size: 40.0, // Size of the icon
                            ),

                            // Anchor point for the marker (bottom center for a pin)
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 30,
                    child: IconButton(
                      onPressed: () {
                        _getCurrentLocation(fromAnimate: true);
                      },
                      icon: Icon(
                        Icons.my_location,
                        color: AppColors.primaryDarkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Location", style: AppTextStyle.textBlackColor16w400),
                    // const SizedBox(height: 6),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(12),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: AppColors.disableColor),
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.grey.shade200,
                    //   ),
                    //   child: Text(
                    //     _address,
                    //     style: AppTextStyle.textBlackColor14w400.copyWith(
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ),
                    // ),
                    //

                    const SizedBox(height: 16),
                    AppTextField(
                      controller: addressTextController,
                      labelText: "Address",
                      labelTextStyle: AppTextStyle.textBlackColor16w400,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 50),
                    AppButton(
                      title: "Continue",
                      onPressed: () {
                        // if (locationDone == false) {
                        //   context.pop();
                        // } else {
                        //   locationDone = false;
                        //   setState(() {});
                        // }

                        if (widget.title == "Pickup Point") {
                          context.pop(widget.address ?? addressTextController.text);
                        } else {
                          context.pop(widget.address ?? addressTextController.text);
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

