// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
// import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
// import '../../../../utils/app_application_bar.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/app_icon_button.dart';
// import '../../../../utils/app_icons.dart';
// import '../../../../utils/app_text_style.dart';
//
// class GpsTrackingHomeScreen extends StatelessWidget {
//   const GpsTrackingHomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         title: Text(context.appText.gps, style: AppTextStyle.appBar),
//         centreTile: false,
//         actions: [
//           AppIconButton(
//             onPressed: () {},
//             icon: AppIcons.svg.notification,
//             iconColor: AppColors.black,
//           ),
//           AppIconButton(
//             onPressed: () {},
//             icon: AppIcons.svg.filledSupport,
//             iconColor: AppColors.primaryButtonColor,
//           ),
//           4.width,
//         ],
//       ),
//       body: gpsBodyWidget(context),
//     );
//   }
//
//   static final List<GpsMenuItem> gpsMenuItems = [
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconDashboard,
//       title: 'Dashboard',
//       onTap: () {
//       },
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconGeofence,
//       title: 'Geofence',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconPoi,
//       title: 'POI',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconImmobilize,
//       title: 'Immobilize',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconSubscription,
//       title: 'Vehicle Share & Update',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconSubscription,
//       title: 'Subscription',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconFaq,
//       title: 'FAQ',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconSettings,
//       title: 'Settings',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconReports,
//       title: 'Reports',
//       onTap: () {},
//     ),
//     GpsMenuItem(
//       icon: AppIcons.svg.gpsIconOrders,
//       title: 'Orders',
//       onTap: () {},
//     ),
//   ];
//
//   Widget gpsBodyWidget(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _expiryAlertWidget(context),
//                 // allTabsWidget(context),
//                 _buildGridMenu(),
//                 _buildTrackMyVehicles(),
//                 _groBannerImageWidget(),
//               ],
//             ),
//           ),
//         ),
//         // Fixed bottom button
//         AppButton(
//           title: context.appText.buyNewGps,
//           onPressed: () {
//             Navigator.push(context,commonRoute(GpsDashboardScreen()));
//           },
//         ).paddingOnly(bottom: 30, left: 15, right: 15, top: 10),
//       ],
//     );
//   }
//
//   Widget _buildTrackMyVehicles() {
//     return Container(
//       padding: EdgeInsets.all(commonSafeAreaPadding),
//       margin: EdgeInsets.all(commonSafeAreaPadding),
//       decoration: BoxDecoration(
//         color: AppColors.lightBlueColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//               padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
//               child: SvgPicture.asset(AppIcons.svg.gpsIconTrack , width: 20, colorFilter: AppColors.svg(AppColors.primaryColor))),
//           12.width,
//           Expanded(
//             child: Text('Track My Vehicles',
//                 style: AppTextStyle.h5),
//           ),
//           Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryColor),
//         ],
//       ),
//     );
//   }
//
//   Widget _expiryAlertWidget(BuildContext context) {
//       return Container(
//         decoration: BoxDecoration(
//           color: AppColors.darkPurpleColor,
//         ),
//         padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
//         child: Row(
//           children: [
//             Icon(Icons.warning,color: AppColors.orangeColor,),
//             10.width,
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Expiry Alert',style: AppTextStyle.h6.copyWith(color: AppColors.orangeColor),),
//                   5.height,
//                   Text('3 Devices Are Expiring Soon',style: AppTextStyle.h6.copyWith(color: Colors.white),),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     padding:EdgeInsets.symmetric(horizontal: 10,),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
//                 onPressed: () {
//
//             }, child: Text('Renew Plan',style: AppTextStyle.h5PrimaryColor,)),
//           ],
//         ),
//       );
//   }
//
//   Widget _groBannerImageWidget() {
//     return Image.asset(AppImage.png.groBanner,width: double.infinity,fit: BoxFit.cover);
//   }
//
//   Widget _buildGridMenu() {
//     return GridView.count(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       crossAxisCount: 2,
//       childAspectRatio: 1.8,
//       mainAxisSpacing: 15,
//       crossAxisSpacing: 12,
//       padding: EdgeInsets.all(commonSafeAreaPadding),
//       children: gpsMenuItems.map((item) {
//         return Container(
//           decoration: BoxDecoration(
//             color: AppColors.lightBlueColor,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             onTap: item.onTap,
//             borderRadius: BorderRadius.circular(12),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   item.icon,
//                   width: 25,
//                   colorFilter: AppColors.svg(AppColors.primaryColor),
//                 ),
//                 5.height,
//                 Text(
//                   item.title,
//                   textAlign: TextAlign.center,
//                   style: AppTextStyle.h5,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
// }
//
// class GpsMenuItem {
//   final String icon;
//   final String title;
//   final VoidCallback onTap;
//
//   GpsMenuItem({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
// }
