import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_load_timeline_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


class LpLoadsLocationDetailsScreen extends StatefulWidget {
  const LpLoadsLocationDetailsScreen({super.key});

  @override
  State<LpLoadsLocationDetailsScreen> createState() => _LpLoadsLocationDetailsScreenState();
}

class _LpLoadsLocationDetailsScreenState extends State<LpLoadsLocationDetailsScreen> {

  GoogleMapController? _mapController;


  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
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
            buildBottomLoadDetailsWidget()
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
                target: LatLng(0,0),
                zoom: 10,
              ),
              onMapCreated: (controller) async {
                _mapController = controller;
                await _setMapStyle(controller);
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
                Text('#GRO22334', style: AppTextStyle.body3),
                Spacer(),
                Text(
                  '12 Jul 2025, 6:30 AM',
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
                    Text("Bangalore", style: AppTextStyle.body2.copyWith(color: AppColors.black)),
                    Text("21-09-2025", style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor)),
                  ],
                ),
                20.width,
                Icon(Icons.arrow_forward),
                20.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chennai", style: AppTextStyle.body2.copyWith(color: AppColors.black)),
                    Text("21-09-2025", style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor)),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurpleColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Matching..',
                        style: AppTextStyle.body4.copyWith(
                          color: AppColors.purpleColor,
                        ),
                      ),
                    ),
                    4.height,
                    Text(
                      '63 Mins to Match',
                      style: AppTextStyle.body4.copyWith(color: Colors.green),
                    )
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Truck Type Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppImage.png.truck, width: 57.w, height: 42.h),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Requested', style: AppTextStyle.body3.copyWith(color: Colors.grey)),
                      4.height,
                      Text('Closed - 30 Ft SXL', style: AppTextStyle.body1.copyWith(fontSize: 14, color: AppColors.black)),
                    ],
                  )
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
                            Text("Coca Cola Bottling Plant, Nemam, Vellavedu, Tamil Nadu 600124", style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                          ],
                        ),

                        commonDivider(),

                        // Destination
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                            6.height,
                            Text("Coca Cola Bottling Plant, Nemam, Vellavedu, Tamil Nadu 600124", style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
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
                      "₹75000 - ₹85000",
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
                      Icon(Icons.local_shipping_outlined, size: 20),
                      8.width,
                      Text('Agricultural Products', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.scale, size: 20),
                      8.width,
                      Text('5 - 6 Ton', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.pin_drop_outlined, size: 20),
                      8.width,
                      Text('534 KM', style: AppTextStyle.body3.copyWith(color: AppColors.veryLightGreyColor)),
                    ],
                  ),
                ],
              ),

              25.height,

              Text("Timeline", style: AppTextStyle.h4),
              20.height,

              LPLoadTimelineWidget(
                timelineTitle: ['Load Posted', 'Load Confirmed', 'Driver Assigned','Memo Signed', 'Documents Updated', 'Advance Paid', 'In Transit', 'Hosur', 'Reached Destination', 'POD Uploaded', 'Unloading complete', 'POD Dispatched', 'Load Statement Generated', 'Balance Paid'],
                currentTimeline: 1,
              )

            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}


