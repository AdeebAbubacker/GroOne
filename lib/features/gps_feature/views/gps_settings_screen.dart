import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/views/widgets/gps_notification_type_sheet.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../cubit/vehicle_list_cubit.dart';
import 'gps_notification_screen.dart';

class GpsSettingsScreen extends StatelessWidget {
  const GpsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: "App Settings",
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              final vehicleListCubit = locator<VehicleListCubit>();
              // Only load data if not already loaded
              if (!vehicleListCubit.hasLoadedData) {
                vehicleListCubit.loadVehicleData();
              } else {
                debugPrint(
                  "📍 GpsGeofenceScreen - Vehicle data already loaded, skipping loadVehicleData call",
                );
              }

              Navigator.push(
                context,
                commonRoute(
                  BlocProvider.value(
                    value: vehicleListCubit,
                    child: GpsNotificationScreen(),
                  ),
                ),
              );
            },
            icon: SvgPicture.asset(AppIcons.svg.notification, height: 20),
            iconColor: AppColors.primaryColor,
          ),
          AppIconButton(
            onPressed: () {},
            icon: Image.asset(AppIcons.png.moreVertical),
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text("Notification",style: AppTextStyle.h5,),
                  value: true,
                  onChanged: (val) {},
                ),
                ListTile(
                  title: Text("Types of Notifications",style: AppTextStyle.h5,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) => const GpsNotificationTypesSheet(),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Notification Tone",style: AppTextStyle.h5,)),
                      Expanded(child: Text("Sprinkle Theme",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Alert Volume",style: AppTextStyle.h5,)),
                      Expanded(child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.play_arrow, size: 20,color: AppColors.primaryColor,),
                          5.width,
                          Flexible(child: Text("Medium",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                        ],
                      )),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Online Vehicle Color",style: AppTextStyle.h5,)),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                      10.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Test Notification",style: AppTextStyle.h5,)),
                      Text("SEND",style: AppTextStyle.h5PrimaryColor,),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                ListTile(
                  title: Text("Show/Hide Geofence",style: AppTextStyle.h5,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                  },
                ),
                SwitchListTile(
                  title: Text("Show Market Label",style: AppTextStyle.h5,),
                  value: true,
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  title: Text("Show Marker Cluster",style: AppTextStyle.h5,),
                  value: true,
                  onChanged: (val) {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Stop Duration Report",style: AppTextStyle.h5,)),
                      Expanded(child: Text("5 Mins",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text("Require Password For Immobilization",style: AppTextStyle.h5,),
                  value: true,
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  title: Text("Show Selected Vehicle On App Restart",style: AppTextStyle.h5),
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Vehicle List Sort",style: AppTextStyle.h5,)),
                      Expanded(child: Text("Default",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("Vehicle Icon Size",style: AppTextStyle.h5,)),
                      Expanded(child: Text("Default",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
