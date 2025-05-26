import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../../../utils/app_image.dart';

class LpPayNowAndTrackLoad extends StatefulWidget {
  const LpPayNowAndTrackLoad({super.key});

  @override
  State<LpPayNowAndTrackLoad> createState() => _LpPayNowAndTrackLoadState();
}

class _LpPayNowAndTrackLoadState extends State<LpPayNowAndTrackLoad> {
  late GoogleMapController mapController;
  final LatLng _bengaluru = LatLng(26.8467, 80.9462);
  final LatLng _chennai = LatLng(28.6139, 77.2090);
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  void _getRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyBZMCgOTw0CKqgLRahtLjOGBml0fmhQQtY',
      request: PolylineRequest(
        origin: PointLatLng(_bengaluru.latitude, _bengaluru.longitude),
        destination: PointLatLng(_chennai.latitude, _chennai.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Banglore - Chennai"),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _bengaluru,
              zoom: 7.5,
            ),
            markers: {
              Marker(markerId: MarkerId('start'), position: _bengaluru),
              Marker(markerId: MarkerId('end'), position: _chennai),
            },
            polylines: _polylines,
            onMapCreated: (controller) => mapController = controller,
          ),
          draggableSheet(
            child: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.h,
                  horizontal: 20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        5.height,
                        Text(
                          "Trip Lane",
                          style: AppTextStyle.veryLightGreyColor14w400,
                        ),
                        Text(
                          "Bangalore - Chennai",
                          style: AppTextStyle.lightBlackColor14w500,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        5.height,
                        Text(
                          "Trip Date",
                          style: AppTextStyle.veryLightGreyColor14w400,
                        ),
                        Text(
                          "Bangalore - Chennai",
                          style: AppTextStyle.lightBlackColor14w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.h,
                  horizontal: 20.w,
                ),

                color: AppColors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImage.png.bookAShipment,
                      height: 82.h,
                      width: 18.h,
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          bookShipmentWidget(
                            heading: "Pickup Point",
                            subHeading: "23, Whitefield, Bangalore",
                            onClick: () {},
                          ),

                          10.height,
                          bookShipmentWidget(
                            heading: "Drop Point",
                            subHeading: "1/34 A, Sriperumbuthur, Chennai",
                            onClick: () {},
                          ),
                          10.height,
                          Text(
                            "Estimated Time of Arrival - 8 May 2025, 8.30 PM",
                            style: AppTextStyle.textGreyColor12w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              tileWidget(
                headingText: "Vehicle Details",
                statusText: "Yet To Assign",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child1: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Text(
                      "Ashok Leyland - Boss 1920",
                      style: AppTextStyle.lightBlackColor14w500,
                    ),
                    5.height,
                    Text("TN02 UY4356", style: AppTextStyle.primaryColor14w700),
                  ],
                ),
              ),
              tileWidget(
                headingText: "Driver Details",
                statusText: "Yet To Assign",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child1: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Text(
                      "Dinesh Kumar",
                      style: AppTextStyle.lightBlackColor14w500,
                    ),
                    5.height,
                    Text(
                      "+91 9876543210",
                      style: AppTextStyle.primaryColor14w700,
                    ),
                  ],
                ),
              ),
              tileWidget(
                headingText: "Payment Details",
                statusText: "Pending",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child1: Column(
                  spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Text(
                      context.appText.advancePayment,
                      style: AppTextStyle.darkDividerColor16w400,
                    ),
                    Text(
                      "80% advance",
                      style: AppTextStyle.darkDividerColor16w400,
                    ),
                    Text(
                      '₹12000',
                      style: AppTextStyle.textBlackColor26w700.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
                child2: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.h,
                  children: [
                    15.height,
                    AppButton(
                      title: "Pay Now",
                      onPressed: () {
                        context.push(AppRouteName.lpPayNowScreen);
                      },
                    ),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Balance Payment",
                            style: AppTextStyle.darkDividerColor16w400,
                          ),
                        ),
                        statusButtonWidget(
                          statusBackgroundColor: AppColors.appRedColor,
                          statusTextColor: AppColors.textRed,
                          statusText: "Pending",
                        ),
                      ],
                    ),
                    Text(
                      '₹4000',
                      style: AppTextStyle.textBlackColor26w700.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
              tileWidget(
                headingText: "Trip Documents",
                statusText: "",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child2: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      trailing: Icon(
                        Icons.file_download_outlined,
                        color: AppColors.primaryColor,
                      ),
                      leading: Image.asset(
                        AppImage.png.doc,
                        height: 24.h,
                        width: 24.w,
                      ),
                      title: Text(
                        "Memo.PDF",
                        style: AppTextStyle.textBlackColor12w400,
                      ),
                      subtitle: Text(
                        "07-12-2024 | 02:52 pm",
                        style: AppTextStyle.textGreyColor10w400,
                      ),
                    ),
                  ),
                ),
              ),
              tileWidget(
                headingText: "Tracking",
                statusText: "",
                statusTextColor: AppColors.textRed,
                statusBackgroundColor: AppColors.appRedColor,
                child2: Column(
                  children: [
                    TimelinePage(),
                    AppButton(
                      title: "Back to Home",
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),

              20.height,
            ],
          ),
        ],
      ),
    );
  }

  tileWidget({
    required String headingText,
    required String statusText,
    required Color statusTextColor,
    required Color statusBackgroundColor,
    bool showStatus = true,
    Widget? child1,
    Widget? child2,
  }) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headingText, style: AppTextStyle.textBlackColor18w500),
          child1 != null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: child1 ?? const SizedBox()),
                  showStatus
                      ? statusButtonWidget(
                        statusBackgroundColor: statusBackgroundColor,
                        statusTextColor: statusTextColor,
                        statusText: statusText,
                      )
                      : const SizedBox(),
                ],
              )
              : const SizedBox(),
          child2 ?? const SizedBox(),
        ],
      ),
    );
  }

  bookShipmentWidget({
    required String heading,
    required String subHeading,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.h,
            children: [
              Text(heading, style: AppTextStyle.textGreyColor12w400),
              Text(subHeading, style: AppTextStyle.textBlackColor12w400),
            ],
          ),
        ],
      ),
    );
  }
}

class TimelinePage extends StatelessWidget {
  final List<TimelineEvent> events = [
    TimelineEvent("In Transit", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Kanchipuram", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Vellore", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached Hosur", "03 Jan 2023 | 02:45 pm"),
    TimelineEvent("Reached White Field", "03 Jan 2023 | 02:45 pm"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final event = events[index];
        return TimelineTile(
          axis: TimelineAxis.vertical,
          alignment: TimelineAlign.start,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == events.length - 1,
          indicatorStyle: IndicatorStyle(
            indicatorXY: 0.4,
            width: 20,
            color: index <= 2 ? Colors.white : AppColors.primaryDarkColor,
            // borderStyle: BorderStyle.solid,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= 2 ? Colors.white : AppColors.primaryDarkColor,
                border: Border.all(color: AppColors.primaryDarkColor, width: 2),
              ),
              child:
                  index <= 2
                      ? Icon(
                        Icons.circle,
                        size: 12,
                        color: AppColors.primaryDarkColor,
                      )
                      : const SizedBox(),
            ),
          ),
          beforeLineStyle: LineStyle(color: AppColors.black, thickness: 1.5),
          afterLineStyle: LineStyle(color: AppColors.black, thickness: 1.5),

          endChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(event.time, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimelineEvent {
  final String title;
  final String time;

  TimelineEvent(this.title, this.time);
}
