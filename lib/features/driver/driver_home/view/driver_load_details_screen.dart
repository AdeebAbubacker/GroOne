// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gro_one_app/features/driver/driver_home/view/widgets/driver_load_bottom_widget.dart';
// import 'package:gro_one_app/features/trip_tracking/widgets/google_map_widdget.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
// import 'package:gro_one_app/helpers/date_helper.dart';
// import 'package:gro_one_app/utils/app_colors.dart';
// import 'package:gro_one_app/utils/app_icons.dart';
// import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
//
// class DriverLoadDetailsScreen extends StatefulWidget {
//   const DriverLoadDetailsScreen({super.key});
//
//   @override
//   State<DriverLoadDetailsScreen> createState() =>
//       _DriverLoadDetailsScreenState();
// }
//
// class _DriverLoadDetailsScreenState extends State<DriverLoadDetailsScreen> {
//   final LoadDetailModelData mockLoadDetails = LoadDetails(
//   loadSeriesID: '1',
//   consignee: null,
//   loadId: "LOAD123",
//   laneId: "LANE001",
//   rateId: 1,
//   customerId: '1',
//   commodityId: 1,
//   truckTypeId: 1,
//   pickUpAddr: "Guindy, Chennai",
//   pickUpLocation: "Guindy, Chennai",
//   assignStatus: 1,
//   pickUpLatlon: "13.0067,80.2206",
//   dropAddr: "Majestic, Bangalore",
//   dropLocation: "Majestic, Bangalore",
//   dropLatlon: "12.9763,77.5712",
//   dueDate: DateTime.parse("2024-08-12T12:00:00Z"),
//   consignmentWeight: 10,
//   notes: "Handle with care",
//   rate: "40",
//   vpRate: "30",
//   vpMaxRate: "40",
//   status: 1,
//   loadStatus: 4,
//   vehicleLength: "20 ft",
//   pickUpDateTime: "2024-08-10T10:00:00Z",
//   expectedDeliveryDateTime: DateTime.parse("2024-08-11T18:30:00Z"),
//   handlingCharges: 300,
//   acceptedBy: '2',
//   createdAt: DateTime.parse("2024-08-09T15:30:00Z"),
//   updatedAt: null,
//   deletedAt: null,
//   commodity: null,
//   truckType: null,
//   customer: null,
//   timeline: [],
//   trip: null,
// );
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             // Google Map
//             Positioned.fill(
//               child: GoogleMapWidget(
//              pickupLocation: mockLoadDetails.pickUpLocation,
//               dropLocation: mockLoadDetails.dropLocation,
//               pickUpLatLong: mockLoadDetails.pickUpLatlon,
//               dropLatLong: mockLoadDetails.dropLatlon,
//               ),
//             ),
//
//             Positioned(
//             top: 15,
//             left: 15,
//             right: 15,
//             child: buildSourceAndDestinationWidget(
//                     mockLoadDetails),
//                 ),
//            DriverLoadBottomWidget()
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Build Source And Destination
//   Widget buildSourceAndDestinationWidget(LoadDetails loadDetails) {
//         return Container(
//           height: 110,
//           width: MediaQuery.of(context).size.width * 0.80,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   IconButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: SvgPicture.asset(
//                       AppIcons.svg.goBack,
//                       colorFilter: AppColors.svg(Colors.black),
//                     ),
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.only(top: 13),
//                     child: Text(
//                       "${loadDetails.loadId}",
//                       style: TextStyle(color: AppColors.textBlackDetailColor),
//                     ),
//                   ),
//
//                   if ((loadDetails.loadStatus ?? 0) > 3) Spacer(),
//
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       top: 15,
//                       left: 10,
//                       right: 10,
//                     ),
//                     child: Text(
//                       DateTimeHelper.formatCustomDate(
//                         loadDetails.createdAt ?? DateTime.now(),
//                       ),
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ),
//
//
//                     Spacer(),
//
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 15,
//                         ),
//                         child: SvgPicture.asset(
//                           height: 24,
//                           width: 24,
//                           AppIcons.svg.share,
//                         ),
//                       ),
//                     ),
//
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildLocationDetailsTileWidget(
//                     loadDetails.pickUpLocation,
//                     DateTimeHelper.getFormattedDate(
//                      DateTime.now(),
//                     ),
//                   ),
//                   Icon(Icons.arrow_forward).expand(),
//                   _buildLocationDetailsTileWidget(
//                     loadDetails.dropLocation,
//                     DateTimeHelper.getFormattedDate(
//                       loadDetails.expectedDeliveryDateTime ?? DateTime.now(),
//                     ),
//                   ),
//                     LoadStatusLabel(loadStatus: LoadStatus.assigned),
//                 ],
//               ).paddingSymmetric(horizontal: 5),
//             ],
//           ),
//         );
//
//   }
//
//   /// Google Map
//
//   /// Location Details
//   _buildLocationDetailsTileWidget(String? location, String? date) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           (location ?? "").split(",")[0],
//           style: TextStyle(color: AppColors.black, fontSize: 16),
//           maxLines: 1,
//         ),
//         Text(date ?? "", style: TextStyle(color: AppColors.grayColor)),
//       ],
//     ).expand();
//   }
// }
