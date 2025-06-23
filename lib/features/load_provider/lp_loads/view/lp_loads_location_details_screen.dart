import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/helper/LpLoadsHelper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_validate_memo.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_load_timeline_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_validate_memo.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


class LpLoadsLocationDetailsScreen extends StatefulWidget {
  final LpLoadItem loadItem;

  const LpLoadsLocationDetailsScreen({super.key, required this.loadItem});

  @override
  State<LpLoadsLocationDetailsScreen> createState() => _LpLoadsLocationDetailsScreenState();
}

class _LpLoadsLocationDetailsScreenState extends State<LpLoadsLocationDetailsScreen> {

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String kilometers = '';


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


  void setMapMarkers() async {
    final pickupLatLng = _getLatLngFromString(widget.loadItem.pickUpLatlon);
    final dropLatLng = _getLatLngFromString(widget.loadItem.dropLatlon);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Pickup: ${widget.loadItem.pickUpAddr}'),
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('drop'),
          position: dropLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop: ${widget.loadItem.dropAddr}'),
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

    if (pickupLatLng.latitude > dropLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: dropLatLng,
        northeast: pickupLatLng,
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: dropLatLng,
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            buildGoogleMapWidget(),
            buildTopLocationWidget(),
            buildBottomLoadDetailsWidget(),
            buildSupportWidget(),
          ],
        ),
      ),
    );
  }

  /// Google Map
  Widget buildGoogleMapWidget(){
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
                setMapMarkers();
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
  Widget buildTopLocationWidget() {
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
                Text('#GRO${widget.loadItem.loadId}', style: AppTextStyle.body3),
                Spacer(),
                Text(
                  widget.loadItem.dueDate != null ? DateTimeHelper.formatCustomDate(widget.loadItem.dueDate!) : "--",
                  style: AppTextStyle.body4PrimaryColor.copyWith(fontSize: 10),
                ),
              ],
            ),
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.loadItem.pickUpAddr.capitalizeFirst, style: AppTextStyle.body2.copyWith(color: AppColors.black)),
                    Text(
                        widget.loadItem.pickUpDateTime != null ? DateTimeHelper.getFormattedDate(widget.loadItem.pickUpDateTime!) : "--",
                        style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor)),
                  ],
                ),
                20.width,
                Icon(Icons.arrow_forward),
                20.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.loadItem.dropAddr.capitalizeFirst, style: AppTextStyle.body2.copyWith(color: AppColors.black)),
                    Text(
                        widget.loadItem.expectedDeliveryDateTime != null ? DateTimeHelper.getFormattedDate(widget.loadItem.expectedDeliveryDateTime!) : "--",
                        style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor)),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: commonContainerDecoration(
                          color: LpLoadsHelper.getLoadStatusColor(widget.loadItem.loadStatus.toInt())
                      ),
                      width: 80.w,
                      child: Text(
                        LpLoadsHelper.getLoadTypeDisplayText(widget.loadItem.loadStatus.toInt()),
                        style: AppTextStyle.body3.copyWith(color: LpLoadsHelper.getLoadStatusTextColor(widget.loadItem.loadStatus.toInt())),
                      ).center().paddingAll(4),
                    ),
                    4.height,
                    if(widget.loadItem.loadStatus == 2)
                    Text(LpHomeHelper.getMatchingTime(widget.loadItem.createdAt.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5)
                  ],
                )
              ],
            ),
          ],
        ).paddingAll(commonRadius),
      ),
    );
  }


  /// Load Details
  Widget buildBottomLoadDetailsWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
        decoration: commonContainerDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Truck Type Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppImage.png.truck, width: 57.w, height: 42.h),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(widget.loadItem.loadStatus < 4)
                            ...[
                              Text('Requested', style: AppTextStyle.body3.copyWith(color: Colors.grey)),
                              4.height,
                              Text('${widget.loadItem.truckType!.type} - ${widget.loadItem.vehicleLength}', style: AppTextStyle.body1.copyWith(fontSize: 14, color: AppColors.black)),
                            ],
                          if(widget.loadItem.loadStatus > 3)
                            ...[
                              5.height,
                              Row(
                                children: [
                                  Container(
                                      decoration: commonContainerDecoration(color: Color(0xffFFC100), borderRadius: BorderRadius.circular(4)),
                                      padding: EdgeInsets.symmetric(horizontal: 2),
                                      child: Text('TN 12 AK 6465', style: AppTextStyle.body3.copyWith(color: AppColors.black))),
                                  5.width,
                                  Text('Closed Body (22Ft)',  style: AppTextStyle.body3.copyWith(color: AppColors.greyIconColor)),
                                ],
                              ),
                              5.height,
                              Row(
                                children: [
                                  Text('Driver:  ', style: AppTextStyle.body3.copyWith(color: AppColors.greyIconColor)),
                                  Text('Krishna Kumar Rajan', style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.black)),
                                ],
                              ),
                              5.height
                            ],
                          if(widget.loadItem.loadStatus > 2)
                            ...[
                              4.height,
                              Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: commonContainerDecoration(
                                      color: Color(0xffE5EBFF), borderRadius: BorderRadius.circular(6)),
                                  child: Text("VP: Gogovan Transports",style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)))
                            ]
                        ],
                      ),
                      if(widget.loadItem.loadStatus > 3)
                        ...[
                          Spacer(),
                          CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(Icons.call,color: AppColors.white,))
                        ]

                    ],
                  ),

                  16.height,

                  // Source & Destination card
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: commonContainerDecoration(
                      color: AppColors.lightPrimaryColor2,
                      borderColor: AppColors.borderColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          children: [
                            Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
                            SizedBox(
                              height: 70,
                              child: DottedLine(
                                direction: Axis.vertical,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.grey,
                                dashGapLength: 3.0,
                              ).paddingOnly(top: 5,bottom: 5),
                            ),

                            Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
                          ],
                        ),
                        10.width,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Source (Pick Up)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.source, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(widget.loadItem.pickUpLocation, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                            commonDivider(),

                            // Destination
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                                6.height,
                                Text(widget.loadItem.dropLocation, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                              ],
                            ),

                          ],
                        ).expand()
                      ],
                    ),
                  ),

                  16.height,
                  Container(
                    decoration: commonContainerDecoration(
                      color: AppColors.primaryLightColor,
                      borderRadius: BorderRadius.circular(commonPadding),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Agreed Price", style: AppTextStyle.body2),
                        Text(
                          "$indianCurrencySymbol${widget.loadItem.rate}",
                          style: AppTextStyle.h4.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ).paddingAll(8),

                  ),

                  16.height,

                  // Meta icons row
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20.h,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.orderBox, width: 20,color: Colors.black,),
                          8.width,
                          Text(widget.loadItem.commodity!.name, style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.kgWeight, width: 20,color: Colors.black,),
                          8.width,
                          Text('${widget.loadItem.consignmentWeight} Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.distance, width: 20,color: Colors.black,),
                          8.width,
                          Text(kilometers, style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                        ],
                      ),
                    ],
                  ),

                  25.height,

                  if(widget.loadItem.loadStatus != 2)
                    ...[
                      Text("Timeline", style: AppTextStyle.h4),
                      20.height,

                      LPLoadTimelineWidget(
                        timelineTitle: ['Load Posted', 'Load Confirmed', 'Driver Assigned','Memo Signed', 'Documents Updated', 'Advance Paid', 'In Transit', 'Hosur', 'Reached Destination', 'POD Uploaded', 'Unloading complete', 'POD Dispatched', 'Load Statement Generated', 'Balance Paid'],
                        currentTimeline: 1,
                      )
                    ]

                ],
              ).paddingAll(16),
            ).expand(),
            if(widget.loadItem.loadStatus == 5)
              CustomSwipeButton(price:widget.loadItem.rate == "" ? 0 : int.parse(widget.loadItem.rate),  loadId: widget.loadItem.loadId)
          ],
        ),
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

