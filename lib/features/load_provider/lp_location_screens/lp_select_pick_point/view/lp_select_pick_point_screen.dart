import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  final String title;
  final String? address;

  const LpSelectPickPointScreen({super.key, required this.title, this.address});

  @override
  State<LpSelectPickPointScreen> createState() =>
      _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen> {
  TextEditingController addressTextController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();

  GoogleMapController? _googleMapController;
  LatLng? centerLatLng;
  String _locationField = '';
  List<dynamic> suggestions = [];
  final String googlePlacesApiKey = "AIzaSyBZMCgOTw0CKqgLRahtLjOGBml0fmhQQtY";
  String latLngData = "";

  // New flag to track first map movement for destination mode
  bool _hasMovedMap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.title == "Pickup Point") {
        await _getCurrentLocation();
      } else {
        await _getCurrentLocation(fetchOnly: true);
      }
    });
  }

  Future<void> _getCurrentLocation({
    bool animate = false,
    bool fetchOnly = false,
  }) async {
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
      latLngData = "${latLng.latitude},${latLng.longitude}";
    });

    if (!fetchOnly && widget.title == "Pickup Point") {
      await _updateAddressFromLatLng(latLng);
    }

    if (animate && _googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    }
  }

  Future<void> _updateAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      Placemark place = placemarks.first;
      final address = '${place.street}, ${place.locality}, ${place.country}';

      setState(() {
        _locationField = address;
        if (widget.title != "Pickup Point") {
          // For destination, update searchTextController on map move (except first)
          if (_hasMovedMap) {
            searchTextController.text = address;
          }
        }
      });
    } catch (e) {
      setState(() {
        _locationField = 'No address found';
        if (widget.title != "Pickup Point") {
          if (_hasMovedMap) {
            searchTextController.text = '';
          }
        }
      });
    }
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
        latLngData = "${location['lat']},${location['lng']}";
        centerLatLng = latLng;
        _locationField = formattedAddress;
        searchTextController.text = description;
        suggestions.clear();

        // Once user picks suggestion, map moves, so set flag true:
        _hasMovedMap = true;
      });

      _googleMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      centerLatLng = position.target;
      latLngData = "${position.target.latitude},${position.target.longitude}";
    });

    if (widget.title == "Pickup Point") {
      // Always update pickup location immediately:
      _updateAddressFromLatLng(position.target);
    } else {
      // For destination: skip first move to prevent initial address update in search field
      if (!_hasMovedMap) {
        _hasMovedMap = true;
        return;
      }
      _updateAddressFromLatLng(position.target);
    }
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }

  @override
  void dispose() {
    addressTextController.dispose();
    searchTextController.dispose();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 420.h,
            child: centerLatLng == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: centerLatLng!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _googleMapController = controller,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Align(
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 250,
                  child: Column(
                    children: [
                      _buildFloatingButton(Icons.add, () async {
                        if (_googleMapController != null) {
                          final zoom = await _googleMapController!.getZoomLevel();
                          _googleMapController!.moveCamera(
                            CameraUpdate.zoomTo(zoom + 1),
                          );
                        }
                      }),
                      const SizedBox(height: 8),
                      _buildFloatingButton(Icons.remove, () async {
                        if (_googleMapController != null) {
                          final zoom = await _googleMapController!.getZoomLevel();
                          _googleMapController!.moveCamera(
                            CameraUpdate.zoomTo(zoom - 1),
                          );
                        }
                      }),
                      const SizedBox(height: 8),
                      _buildFloatingButton(Icons.my_location, () {
                        _getCurrentLocation(animate: true);
                      }),
                    ],
                  ),
                ),
              ],
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
                        _locationField,
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
                                  onTap: () => fetchLatLngFromPlaceId(
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
                      final locationAddress = _locationField.trim();

                      final isLocationValid = locationAddress.isNotEmpty &&
                          locationAddress != 'No address found' &&
                          !locationAddress.startsWith('Error');

                      if (widget.title == "Pickup Point") {
                        if (manualAddress.isNotEmpty) {
                          var data = {
                            "address": manualAddress,
                            "latLng": latLngData,
                          };
                          context.pop(data);
                          return;
                        }

                        if (!isLocationValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Failed to fetch current location address.",
                              ),
                            ),
                          );
                          return;
                        }

                        var data = {
                          "address": locationAddress,
                          "latLng": latLngData,
                        };
                        context.pop(data);
                      } else {
                        if (manualAddress.isEmpty && !isLocationValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please provide or select a location address.",
                              ),
                            ),
                          );
                          return;
                        }

                        var finalAddress =
                        manualAddress.isNotEmpty ? manualAddress : locationAddress;
                        var data = {
                          "address": finalAddress,
                          "latLng": latLngData,
                        };
                        context.pop(data);
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
