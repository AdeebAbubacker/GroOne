import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../../utils/app_json.dart';

class LPSelectAddressScreen extends StatefulWidget {
  final String title;
  final String? address;
  final String? location;
  const LPSelectAddressScreen({super.key, required this.title, this.address, this.location});

  @override
  State<LPSelectAddressScreen> createState() =>
      _LPSelectAddressScreenState();
}

class _LPSelectAddressScreenState extends State<LPSelectAddressScreen> {

  final lpHomeCubit = locator<LPHomeCubit>();

  GoogleMapController? _mapController;
  LatLng? _centerLatLng;
  String _locationField = '';
  final addressTextController = TextEditingController();
  final searchTextController = TextEditingController();
  List suggestions = [];
  String latLngData = '';
  Set<Marker> _markers = {};

  final String _apiKey = "AIzaSyBZMCgOTw0CKqgLRahtLjOGBml0fmhQQtY";

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.address != null) {
        addressTextController.text = widget.address!;
        searchTextController.text = widget.location!;
      }
      await _handleCurrentLocation();
    });
  }


  void printPrettyJson(dynamic data) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(data);
    log('Data:\n$prettyJson');
  }


  Future<void> _handleCurrentLocation() async {
    final pos = await MapHelper.getCurrentLocation();
    if (pos != null) {
      setState(() {
        _centerLatLng = pos;
        latLngData = "${pos.latitude},${pos.longitude}";
      });
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
      if (widget.address == null) {
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
      printPrettyJson(suggestions);
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
      });
      if (_mapController != null) {
        await MapHelper.animateTo(_mapController!, latLng);
      }
      _setMarker(latLng);
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerLatLng = position.target;
      latLngData = "${position.target.latitude},${position.target.longitude}";
    });
    _updateAddress(position.target);
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
                        zoom: 10,
                      ),
                      onMapCreated:(controller) async {
                        _mapController = controller;
                        await _setMapStyle(controller);
                      },
                      onCameraMove: _onCameraMove,
                      markers: _markers,
                      zoomControlsEnabled: false,
                    ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Column(
              children: [
                _floatingButton(
                  Icons.add,
                  () => MapHelper.zoomIn(_mapController!),
                ),
                8.height,
                _floatingButton(
                  Icons.remove,
                  () => MapHelper.zoomOut(_mapController!),
                ),
                8.height,
                _floatingButton(Icons.my_location, _handleCurrentLocation),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: AppTextStyle.textBlackColor14w400),
                    6.height,
                    AppTextField(
                      controller: searchTextController,
                      hintText: "Search location...",
                      decoration: commonInputDecoration(
                        suffixIcon: Icon(Icons.clear, size: 20),
                        suffixIconColor: AppColors.lightGreyIconBackgroundColor,
                        suffixOnTap: (){
                          searchTextController.clear();
                        }
                      ),
                      onChanged: (value) {
                        if (value.length > 2) {
                          _fetchSuggestions(value);
                        } else {
                          setState(() => suggestions = []);
                        }
                      },
                    ),
                    if (suggestions.isNotEmpty)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 120.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: suggestions.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = suggestions[index];
                              return ListTile(
                                title: Text(item['description']),
                                onTap: () => _onSuggestionTap(
                                  item['place_id'],
                                  item['description'],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    12.height,

                    AppTextField(
                      controller: addressTextController,
                      labelText: "Address",
                      maxLines: 3,
                    ),
                    30.height,

                    AppButton(
                      title: "Continue",
                      onPressed: () {

                        final locationAddress = _locationField;

                        final isValid = locationAddress.isNotEmpty && locationAddress != 'No address found';

                        debugPrint("title ${widget.title}");
                        debugPrint("locationAddress ${locationAddress}");
                        setState(() {});

                        if (addressTextController.text.isEmpty) {
                          _showError("Please provide a address");
                          return;
                        }
                        if (!isValid){
                          _showError("Please select a valid location address.");
                          return;
                        }

                        Map<String, dynamic> data = {
                          "address": addressTextController.text,
                          "location": locationAddress,
                          "latLng": latLngData,
                        };


                        if(widget.title == "Pickup Point"){
                          lpHomeCubit.setPickup(data);
                          Navigator.of(context).pop(true);
                        } else {
                          lpHomeCubit.setDestination(data);
                          Navigator.of(context).pop(true);
                        }

                      },
                    ),
                    15.height
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

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
