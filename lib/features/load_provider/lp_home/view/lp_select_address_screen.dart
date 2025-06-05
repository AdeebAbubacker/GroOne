import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LPSelectAddressScreen extends StatefulWidget {
  final String title;
  final String? address;

  const LPSelectAddressScreen({super.key, required this.title, this.address});

  @override
  State<LPSelectAddressScreen> createState() =>
      _LPSelectAddressScreenState();
}

class _LPSelectAddressScreenState extends State<LPSelectAddressScreen> {
  GoogleMapController? _mapController;
  LatLng? _centerLatLng;
  String _locationField = '';
  final addressTextController = TextEditingController();
  final searchTextController = TextEditingController();
  List suggestions = [];
  bool _hasMovedMap = false;
  String latLngData = '';
  Set<Marker> _markers = {};

  final String _apiKey = "AIzaSyBZMCgOTw0CKqgLRahtLjOGBml0fmhQQtY";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.title == "Pickup Point") {
        await _handleCurrentLocation();
      } else {
        final pos = await MapHelper.getCurrentLocation();
        if (pos != null) {
          setState(() {
            _centerLatLng = pos;
            latLngData = "${pos.latitude},${pos.longitude}";
          });
          _setMarker(pos);
        }
      }
    });
  }

  Future<void> _handleCurrentLocation() async {
    final pos = await MapHelper.getCurrentLocation();
    if (pos != null) {
      setState(() {
        _centerLatLng = pos;
        latLngData = "${pos.latitude},${pos.longitude}";
      });

      if (widget.title == "Pickup Point") {
        final address = await MapHelper.getAddressFromLatLng(pos);
        setState(() => _locationField = address);
      }

      _setMarker(pos);
      if (_mapController != null) {
        await MapHelper.animateTo(_mapController!, pos);
      }
    }
  }

  void _setMarker(LatLng pos) {
    final marker = Marker(
      markerId: const MarkerId("selected_location"),
      position: pos,
    );
    setState(() {
      _markers = {marker};
    });
  }

  Future<void> _updateAddress(LatLng latLng) async {
    final address = await MapHelper.getAddressFromLatLng(latLng);
    setState(() {
      _locationField = address;
      if (widget.title != "Pickup Point" && _hasMovedMap) {
        searchTextController.text = address;
      }
    });
    _setMarker(latLng);
  }

  Future<void> _fetchSuggestions(String input) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$_apiKey&language=en';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      setState(() {
        suggestions = data['predictions'];
      });
    } else {
      setState(() => suggestions = []);
    }
  }

  Future<void> _onSuggestionTap(String placeId, String description) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final location = data['result']['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);
      final formattedAddress = data['result']['formatted_address'];

      setState(() {
        _centerLatLng = latLng;
        latLngData = "${latLng.latitude},${latLng.longitude}";
        _locationField = formattedAddress;
        searchTextController.text = description;
        suggestions.clear();
        _hasMovedMap = true;
      });

      _setMarker(latLng);
      if (_mapController != null) {
        await MapHelper.animateTo(_mapController!, latLng);
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerLatLng = position.target;
      latLngData = "${position.target.latitude},${position.target.longitude}";
    });

    if (widget.title == "Pickup Point") {
      _updateAddress(position.target);
    } else if (_hasMovedMap) {
      _updateAddress(position.target);
    } else {
      _hasMovedMap = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title),
      body: Stack(
        children: [
          Positioned.fill(
            top: 0,
            bottom: 320.h,
            child:
                _centerLatLng == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _centerLatLng!,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      onCameraMove: _onCameraMove,
                      markers: _markers,
                      zoomControlsEnabled: false,
                    ),
          ),
          Positioned(
            right: 12,
            top: 250,
            child: Column(
              children: [
                _floatingButton(
                  Icons.add,
                  () => MapHelper.zoomIn(_mapController!),
                ),
                const SizedBox(height: 8),
                _floatingButton(
                  Icons.remove,
                  () => MapHelper.zoomOut(_mapController!),
                ),
                const SizedBox(height: 8),
                _floatingButton(Icons.my_location, _handleCurrentLocation),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 320.h,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: AppTextStyle.textBlackColor16w400),
                    const SizedBox(height: 6),
                    if (widget.title == "Pickup Point")
                      _readonlyBox(_locationField)
                    else ...[
                      AppTextField(
                        controller: searchTextController,
                        onChanged: (value) {
                          if (value.length > 2) {
                            _fetchSuggestions(value);
                          } else {
                            setState(() => suggestions = []);
                          }
                        },
                      ),
                      const SizedBox(height: 6),
                      if (suggestions.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 150.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              itemCount: suggestions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = suggestions[index];
                                return ListTile(
                                  title: Text(item['description']),
                                  onTap:
                                      () => _onSuggestionTap(
                                        item['place_id'],
                                        item['description'],
                                      ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: addressTextController,
                      labelText: "Address",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      title: "Continue",
                      onPressed: () {
                        final manualAddress = addressTextController.text.trim();
                        final locationAddress = _locationField.trim();
                        final isValid =
                            locationAddress.isNotEmpty &&
                            locationAddress != 'No address found';

                        if (widget.title == "Pickup Point") {
                          if (manualAddress.isNotEmpty) {
                            context.pop({
                              "address": manualAddress,
                              "latLng": latLngData,
                            });
                          } else if (isValid) {
                            context.pop({
                              "address": locationAddress,
                              "latLng": latLngData,
                            });
                          } else {
                            _showError(
                              "Failed to fetch current location address.",
                            );
                          }
                        } else {
                          if (manualAddress.isEmpty && !isValid) {
                            _showError(
                              "Please provide or select a location address.",
                            );
                          } else {
                            final resultAddress =
                                manualAddress.isNotEmpty
                                    ? manualAddress
                                    : locationAddress;
                            context.pop({
                              "address": resultAddress,
                              "latLng": latLngData,
                            });
                          }
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

  Widget _floatingButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }

  Widget _readonlyBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: AppColors.disableColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: AppTextStyle.textBlackColor14w400),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
