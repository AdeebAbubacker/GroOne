import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_show_hide_geofence_screen.dart';
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
import '../cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../helper/gps_helper.dart';
import '../service/notification_settings_service.dart';
import 'gps_notification_screen.dart';

class GpsSettingsScreen extends StatelessWidget {
  const GpsSettingsScreen({super.key});


  void showAlertVolumeSheet(BuildContext context, String selectedVolume, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Low', 'Medium', 'High'].map((volume) {
            return ListTile(
              title: Text(volume),
              trailing: selectedVolume == volume
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                Navigator.pop(context);
                onSelected(volume);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void showGpsNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: locator<GpsNotificationTypesSheetCubit>(),
          child: const GpsNotificationTypesSheet(),
        );
      },
    );
  }


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
                    showGpsNotificationSheet(context);
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
                  onTap: () async {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      final hasPermission = await GpsHelper.checkNotificationPermission();
                      if (!hasPermission) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enable notification permission to change tone")),
                        );
                        return;
                      }

                      final uri = await RingtonePicker.pickRingtone();
                      if (uri != null) {
                        print("Selected ringtone URI: $uri");
                        // Save or use the URI
                      }

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notification tone can only be changed on Android')),
                      );
                    }
                  },
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
                    Navigator.push(context, commonRoute(GpsShowHideGeofenceScreen()));
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
                // ListTile(
                //   title: Row(
                //     children: [
                //       Expanded(child: Text("Stop Duration Report",style: AppTextStyle.h5,)),
                //       Expanded(child: Text("5 Mins",style: AppTextStyle.h5GreyColor,textAlign: TextAlign.right,)),
                //       5.width,
                //       Icon(Icons.arrow_forward_ios, size: 16)
                //     ],
                //   ),
                //   onTap: () {},
                // ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 10),
          //   decoration: commonContainerDecoration(),
          //   child: Column(
          //     children: [
          //       SwitchListTile(
          //         title: Text("Require Password For Immobilization",style: AppTextStyle.h5,),
          //         value: true,
          //         onChanged: (val) {},
          //       ),
          //       SwitchListTile(
          //         title: Text("Show Selected Vehicle On App Restart",style: AppTextStyle.h5),
          //         value: true,
          //         onChanged: (val) {},
          //       ),
          //     ],
          //   ),
          // ),
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
