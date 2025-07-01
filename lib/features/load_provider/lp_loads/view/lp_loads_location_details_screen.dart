import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_load_bottom_widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../model/lp_load_get_by_id_response.dart';

class LpLoadsLocationDetailsScreen extends StatefulWidget {
  final int loadId;

  const LpLoadsLocationDetailsScreen({super.key,
    required this.loadId
  });


  @override
  State<LpLoadsLocationDetailsScreen> createState() => _LpLoadsLocationDetailsScreenState();
}

class _LpLoadsLocationDetailsScreenState extends State<LpLoadsLocationDetailsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String kilometers = '';
  final lpLoadLocator = locator<LpLoadCubit>();


  @override
  void initState() {
    super.initState();
    lpLoadLocator.getLpLoadsById(loadId: widget.loadId);
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

  LatLng _getLatLngFromString(String latLng) {
    if (latLng.isEmpty || !latLng.contains(',')) {
      return const LatLng(0, 0);
    }
    final parts = latLng.split(',');
    return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
  }


  void setMapMarkers(loadItem) async {
    final pickupLatLng = _getLatLngFromString(loadItem.pickUpLatlon);
    final dropLatLng = _getLatLngFromString(loadItem.dropLatlon);


    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Pickup: ${loadItem.pickUpAddr}'),
        ),
      );


      _markers.add(
        Marker(
          markerId: MarkerId('drop'),
          position: dropLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop: ${loadItem.dropAddr}'),
        ),
      );
    });


    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );


    kilometers = '${(distanceInMeters / 1000).toStringAsFixed(2)} KM';


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


    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: BlocBuilder<LpLoadCubit, LpLoadState>(
            builder: (context, state) {
              final uiState = state.lpLoadById;

              if (uiState == null || uiState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              final loadItem = uiState.data?.loadData as LoadData;

              if (loadItem == null) {
                return const Center(child: Text("No loads found."));
              }
              return Stack(
                children: [
                  buildGoogleMapWidget(loadItem),
                  buildTopLocationWidget(loadItem),
                  LpLoadBottomWidget(loadItem: loadItem, kilometers: kilometers),
                  buildSupportWidget(),
                ],
              );
            }
        ),
      ),
    );
  }


  /// Google Map
  Widget buildGoogleMapWidget(loadItem){
    return Positioned.fill(
        top: 0,
        child: Builder(
          builder: (context) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(12.993959463114383,80.17066519707441),
                zoom: 10,
              ),
              markers: _markers,

              onMapCreated: (controller) async {
                _mapController = controller;
                await _setMapStyle(controller);
                setMapMarkers(loadItem);
              },
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            );
          },
        )
    );
  }

  /// Location Details
  Widget buildTopLocationWidget(LoadData loadItem) {
    return Positioned(
      top: 30,
      left: 16,
      right: 16,
      child: Container(
        decoration: commonContainerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(onTap: () {
                  Navigator.pop(context);
                },child: Icon(Icons.arrow_back)),
                8.width,
                Text('#${loadItem.loadId}', style: AppTextStyle.body3),
                Spacer(),
                Text(
                  loadItem.dueDate != null ? DateTimeHelper.formatCustomDateIST(loadItem.dueDate!) : "--",
                  style: AppTextStyle.body4PrimaryColor.copyWith(fontSize: 10),
                ),
              ],
            ),
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Pickup address & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.pickUpLocation,
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      loadItem.pickUpDateTime != null
                          ? DateTimeHelper.getFormattedDate(loadItem.pickUpDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ),
                20.width,
                Icon(Icons.arrow_forward),
                20.width,

                // Drop location & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.dropLocation,
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      loadItem.expectedDeliveryDateTime != null
                          ? DateTimeHelper.getFormattedDate(loadItem.expectedDeliveryDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ),
                Spacer(),

                // Load status & matching time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: commonContainerDecoration(
                        color: LpHomeHelper.getLoadStatusColor(loadItem.loadStatusDetails?.loadType ?? ''),
                      ),
                      width: 100,
                      child: Text(
                        LpHomeHelper.getLoadTypeDisplayText(loadItem.loadStatusDetails?.loadType ?? ''),
                        style: AppTextStyle.body3.copyWith(
                          color: LpHomeHelper.getLoadStatusTextColor(loadItem.loadStatusDetails?.loadType ?? ''),
                        ),
                      ).center().paddingAll(4),
                    ),
                    4.height,
                    if (loadItem.loadStatus == 1)
                      Text(
                        LpHomeHelper.getKycPendingTimeLeft(loadItem.customer!.kycPendingDate.toString()),
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingRight(5),
                    if (loadItem.loadStatus == 2)
                      Text(
                        LpHomeHelper.getMatchingTime(loadItem.matchingStartDate.toString()),
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingRight(5)
                  ],
                ),
              ],
            )
          ],
        ).paddingAll(commonRadius),
      ),
    );
  }


  /// Support
  Widget buildSupportWidget() {
    return Positioned(right: 5,bottom: 20,top: 0,child: IconButton(
        onPressed: () {
          commonSupportDialog(context);
        },
        icon: Container(
          padding: EdgeInsets.all(4),
          decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
          child: SvgPicture.asset(
            AppIcons.svg.support,
            width: 25,
            colorFilter: AppColors.svg(AppColors.primaryColor),
          ),
        )
    ));


  }
}

