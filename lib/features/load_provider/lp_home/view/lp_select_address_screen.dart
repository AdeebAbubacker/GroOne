import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
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

  String laneId = '0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (widget.address != null) {
      //   addressTextController.text = widget.address!;
      //   searchTextController.text = widget.location!;
      // }
      // await _handleCurrentLocation();
      if (widget.location != null && widget.location!.isNotEmpty) {
        final LatLng? fromAddress = await MapHelper.getLatLngFromAddress(widget.location!);
        if (fromAddress != null) {
          _updateMapToLocation(fromAddress);
        } else {
          await _handleCurrentLocation();
        }
      } else {
        await _handleCurrentLocation();
      }

      searchTextController.text = widget.location ?? '';
      addressTextController.text = widget.address ?? '';

    });
  }

  @override
  void dispose() {
    lpHomeCubit.resetAutoCompleteState();
    super.dispose();
  }



  Future<void> _handleCurrentLocation() async {
    try {
      // Use cached last known location first if available
      final cachedPos = await MapHelper.getLastKnownLocation();
      if (cachedPos != null) {
        _updateMapToLocation(cachedPos);
      }

      // Fetch fresh GPS location in background
      final currentPos = await MapHelper.getCurrentLocation();
      if (currentPos != null) {
        _updateMapToLocation(currentPos);
      }
    } catch (e) {
      CustomLog.error(this, "", e);
    }
  }

// Helper method to update map camera and marker
  void _updateMapToLocation(LatLng pos) {
    _centerLatLng ??= pos;
    latLngData = "${pos.latitude},${pos.longitude}";
    _setMarker(pos);
    if (_mapController != null) {
      MapHelper.animateTo(_mapController!, pos);
    }
    setState(() {});
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


  Future<void> _updateAddress(LatLng latLng) async => frameCallback(() async {
    final address = await MapHelper.getAddressFromLatLng(latLng);
    _locationField = address;
    _setMarker(latLng);
    setState(() {});
  });




  LatLng? getLatLngFromGMapResponse(dynamic data) {
    final location = data?.gMapResponse?.result?.geometry?.location;
    if (location?.lat != null && location?.lng != null) {
      return LatLng(location!.lat.toDouble(), location.lng.toDouble());
    }
    return null;
  }


  // Verify Location api call
  Future verifyLocationApiCall({required BuildContext context,required String placeId, required int type, required int locationId, required String selectedLocation}) async {
    final apiRequest = VerifyLocationApiRequest(
        placeId: placeId,
        locationId: locationId,
        type: type
    );
    await lpHomeCubit.verifyLocation(apiRequest);
    Status? status = lpHomeCubit.state.verifyLocationUIState?.status;
    if (status != null) {
      if(status == Status.SUCCESS){
        final data = lpHomeCubit.state.verifyLocationUIState?.data;
        if(data != null && data.locationdetails != null){
          LatLng? latLng = getLatLngFromGMapResponse(data);
          if (latLng != null) {
            if (_mapController != null) {
              await MapHelper.animateTo(_mapController!, latLng);
            }
            _setMarker(latLng);
          }
          // searchTextController.text = data.locationdetails?.wholeAddr ?? '';
          searchTextController.text = selectedLocation;
          if(widget.title == context.appText.pickupPoint) {
            lpHomeCubit.setPickupLocationDetailId(data.locationdetails!.id);
          } else {
            lpHomeCubit.setDestinationLocationDetailId(data.locationdetails!.id);
          }
          if(data.lane != null){
            lpHomeCubit.setLaneId(data.lane?.masterLaneId);
          }
          lpHomeCubit.resetAutoCompleteState();
        }
      }
      if(status == Status.ERROR){
        final error = lpHomeCubit.state.verifyLocationUIState?.errorType;
        if(error is BadRequestError){
          if(!context.mounted) return;
          serviceableDialog(context);
        } else {
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));

        }
      }
      setState(() {});
    }

  }


  // Service not available dialog
  void serviceableDialog(BuildContext context) {
    AppDialog.show(
        context,
        child: CommonDialogView(
          heading: context.appText.areaIsNotServiceable,
          headingColor: AppColors.orangeTextColor,
          message: context.appText.weWillLetYouKnowOnceWeStartOperatingHere,
          onSingleButtonText: context.appText.changeLocation,
          hideCloseButton: true,
          onTapSingleButton: (){
            searchTextController.clear();
            Navigator.pop(context);
            lpHomeCubit.resetAutoCompleteState();
          },
          child: SvgPicture.asset(AppImage.svg.kycPending, width: 150),
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title),
      body: SafeArea(
        child: Stack(
          children: [

            // Map
            buildGoogleMapWidget(),

            // Map Navigation
            buildMapNavigationWidget(),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                decoration: commonContainerDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Text Field
                      buildLocationTextFieldWidget(context),
                      20.height,


                      Stack(
                        children: [
                          // Address Text Field
                          AppTextField(
                            controller: addressTextController,
                            hintText: context.appText.enterYourAddress,
                            labelText: context.appText.address,
                            maxLines: 2,
                          ),

                          // Suggestion List
                          buildSuggestionListWidget(),
                        ],
                      ),
                      50.height,

                      // Select Location Button
                      buildSelectLocationButton(context),
                      20.height,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildGoogleMapWidget(){
    return Positioned.fill(
      top: 0,
      bottom: 320,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _centerLatLng ?? LatLng(0.0, 0.0), // default Chennai center
          zoom: 10,
        ),
        onMapCreated: (controller) async {
          _mapController = controller;
          // await _setMapStyle(controller);
        },
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        myLocationButtonEnabled: false,
        onCameraMove: (CameraPosition position) {
          _centerLatLng = position.target;
          latLngData = "${position.target.latitude},${position.target.longitude}";
        },
        onCameraIdle: () {
          if (_centerLatLng != null) {
            _updateAddress(_centerLatLng!);
          }
        },
        markers: _markers,
        zoomControlsEnabled: false,
      ),
    );
  }


  Widget buildLocationTextFieldWidget(BuildContext context){
    return AppTextField(
      controller: searchTextController,
      labelText: context.appText.location,
      decoration: commonInputDecoration(
          suffixIcon: Icon(Icons.clear, size: 20),
          hintText: context.appText.searchLocation,
          suffixOnTap: (){
            searchTextController.clear();
            lpHomeCubit.resetAutoCompleteState();
          }
      ),
      onChanged: (value) {
        if (value.isNotEmpty && value.length > 3) {
          lpHomeCubit.fetchAutoComplete(value);
        } else {
          lpHomeCubit.resetAutoCompleteState();
        }
      },
    );
  }


  Widget buildSuggestionListWidget(){
    return BlocConsumer<LPHomeCubit, LPHomeState>(
      bloc: lpHomeCubit,
      listenWhen: (previous, current) =>  previous.autoCompleteUIState != current.autoCompleteUIState,
      listener: (context , state){
        final status = state.autoCompleteUIState?.status;
        if (status == Status.ERROR) {
          final error = state.autoCompleteUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state){

        if(state.autoCompleteUIState != null && state.autoCompleteUIState!.status == Status.SUCCESS){
          if(state.autoCompleteUIState?.data != null && state.autoCompleteUIState!.data!.predictions.isNotEmpty){
            return  ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150),
              child: Container(
                decoration: commonContainerDecoration(shadow: true),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:  state.autoCompleteUIState!.data!.predictions.length,
                  itemBuilder: (context, index) {
                    final item =  state.autoCompleteUIState!.data!.predictions[index];
                    return ListTile(
                      title: Text(item.description, style: AppTextStyle.body),
                      onTap: () async {
                        // final locationDetails = LocationDetails(
                        //     id : widget.title == "Pickup Point" ? state.destinationLocationId : state.pickupLocationId,
                        //     name: item.description,
                        //     slug: item.description.toLowerCase(),
                        // );
                        final locationId = widget.title == context.appText.pickupPoint ? state.destinationLocationId : state.pickupLocationId;
                        final type = widget.title == context.appText.pickupPoint ? 1 : 2;
                        await verifyLocationApiCall(context: context, placeId: item.placeId, type: type, locationId: locationId ?? 0, selectedLocation: item.description);

                      },
                    );
                  },
                ),
              ),
            ).isAnimate();
          }
        }
       return Container();
      },
    );
  }


  Widget buildSelectLocationButton(BuildContext context){
    return AppButton(
      title: context.appText.continueText,
      onPressed: () {

        if (searchTextController.text.isEmpty){
          ToastMessages.error(message: widget.title == context.appText.pickupPoint ? context.appText.selectPickupLocation : context.appText.selectDestinationLocation);
          return;
        }

        if (lpHomeCubit.state.laneId == null && widget.title != context.appText.pickupPoint) {
          ToastMessages.error(message:"Something went wrong. [lane id : ${lpHomeCubit.state.laneId}]");
          return;
        }

        final destinationData = DestinationModel(
            address: addressTextController.text.capitalize,
            location: searchTextController.text.capitalize,
            latLng: latLngData,
            laneId: lpHomeCubit.state.laneId

        );

        final pickupData = PickUpModel(
            address: addressTextController.text.capitalize,
            location: searchTextController.text.capitalize,
            latLng: latLngData,
            laneId: lpHomeCubit.state.laneId

        );


        if(widget.title == context.appText.pickupPoint){
          lpHomeCubit.setPickup(pickupData);
          Navigator.of(context).pop(true);
        } else {
          lpHomeCubit.setDestination(destinationData);
          Navigator.of(context).pop(true);
        }

      },
    );
  }


  Widget buildMapNavigationWidget(){
    return Positioned(
      top: 15,
      right: 15,
      child: Column(
        children: [
          _floatingButton(Icons.add, () => MapHelper.zoomIn(_mapController!)),
          8.height,
          _floatingButton(Icons.remove, () => MapHelper.zoomOut(_mapController!)),
          8.height,
          _floatingButton(Icons.my_location, _handleCurrentLocation),
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
}
