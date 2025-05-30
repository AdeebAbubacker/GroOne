import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' show GoogleMapController;
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  final String title;
  final String? address;
  const LpSelectPickPointScreen({super.key, required this.title, this.address});

  @override
  State<LpSelectPickPointScreen> createState() =>
      _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen>
    with TickerProviderStateMixin {
  TextEditingController addressTextController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  late final AnimatedMapController _animatedMapController;

  LatLng? centerLatLng;
  String _address = 'No address found';
  List<dynamic> suggestions = [];
  final String googlePlacesApiKey = "AIzaSyBZMCgOTw0CKqgLRahtLjOGBml0fmhQQtY";

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);

    addPostFrameCallback(() {
      Future.delayed(const Duration(milliseconds: 300), _getCurrentLocation);
    });
  }

  Future<void> _getCurrentLocation({bool animate = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      centerLatLng = latLng;
    });

    if (widget.title == "Pickup Point") {
      getAddressFromLatLng(latLng.latitude, latLng.longitude);
    }

    if (animate) {
      _animatedMapController.animateTo(dest: latLng, zoom: 15);
    }
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      setState(() {
        _address = '${place.street}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      CustomLog.error(this, "Error in getAddressFromLatLng", e);
      _address = '';
    }
    setState(() {});
  }


  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }


  Future<void> fetchSuggestions(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googlePlacesApiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      setState(() {
        suggestions = data['predictions'];
      });
    }
  }

  Future<void> fetchLatLngFromPlaceId(
    String placeId,
    String description,
  ) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googlePlacesApiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final location = data['result']['geometry']['location'];
      final formattedAddress = data['result']['formatted_address'];
      final latLng = LatLng(location['lat'], location['lng']);

      setState(() {
        centerLatLng = latLng;
        _address = formattedAddress;
        searchTextController.text = description;
        suggestions.clear();
      });

      _animatedMapController.animateTo(dest: latLng, zoom: 15);
    }
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    if (position.center != null) {
      setState(() {
        centerLatLng = position.center!;
      });
      if (widget.title == "Pickup Point") {
        getAddressFromLatLng(centerLatLng!.latitude, centerLatLng!.longitude);
      }
    }
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    addressTextController.dispose();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title),
      body: Stack(
        children: [
          Positioned.fill(
            child:
                centerLatLng == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                      mapController: _animatedMapController.mapController,
                      options: MapOptions(
                        initialCenter: centerLatLng!,
                        initialZoom: 15,
                        onPositionChanged: _onPositionChanged,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: centerLatLng!,
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
          Positioned(
            right: 10,
            bottom: 330,
            child: IconButton(
              icon: Icon(Icons.my_location, color: AppColors.primaryDarkColor),
              onPressed: () => _getCurrentLocation(animate: true),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 320.h,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location", style: AppTextStyle.textBlackColor16w400),
                  const SizedBox(height: 6),
                  if (widget.title == "Pickup Point")
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: AppColors.disableColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _address,
                        style: AppTextStyle.textBlackColor14w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Column(
                      children: [
                        AppTextField(
                          controller: searchTextController,
                          labelTextStyle: AppTextStyle.textBlackColor16w400,
                          onChanged: (value) {
                            if (value.length > 2) fetchSuggestions(value);
                          },
                        ),
                        if (suggestions.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = suggestions[index];
                                return ListTile(
                                  title: Text(suggestion['description']),
                                  onTap:
                                      () => fetchLatLngFromPlaceId(
                                        suggestion['place_id'],
                                        suggestion['description'],
                                      ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: addressTextController,
                    labelText: "Address",
                    labelTextStyle: AppTextStyle.textBlackColor16w400,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    title: "Continue",
                    onPressed: () {
                      final manualAddress = addressTextController.text.trim();
                      final detectedAddress = _address.trim();

                      // Normalize invalid address values
                      final isDetectedAddressValid = detectedAddress.isNotEmpty &&
                          detectedAddress != 'No address found' &&
                          !detectedAddress.startsWith('Error');

                      if (widget.title == "Pickup Point") {
                        if (!isDetectedAddressValid) {
                          // Use correct ScaffoldMessenger context
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to fetch current location address."),
                            ),
                          );
                          return;
                        }
                        context.pop(detectedAddress);
                        _address = '';
                      } else {
                        if (manualAddress.isEmpty && !isDetectedAddressValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please provide or select a location address."),
                            ),
                          );
                          return;
                        }

                        if (manualAddress.isNotEmpty) {
                          context.pop(manualAddress);
                          addressTextController.clear();
                        } else {
                          context.pop(detectedAddress);
                          _address = '';
                        }
                      }
                    },

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
