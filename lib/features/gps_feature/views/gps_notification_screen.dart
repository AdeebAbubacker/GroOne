import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';

class GpsNotificationScreen extends StatefulWidget {
  const GpsNotificationScreen({super.key});

  @override
  State<GpsNotificationScreen> createState() => _GpsNotificationScreenState();
}

class _GpsNotificationScreenState extends State<GpsNotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Ignition OFF alert:",
      "subtitle": "G5 - Route",
      "time": "23-09-2024, 06:30 PM",
      "icon": Icons.power_settings_new,
      "color": Colors.red.shade100,
    },
    {
      "title": "Geo-Fence IN alert (Zone1)",
      "subtitle": "G5 - Route",
      "time": "23-09-2024, 06:30 PM",
      "icon": Icons.location_on,
      "color": Colors.blue.shade100,
    },
    {
      "title": "Geo-Fence OUT alert (Zone1)",
      "subtitle": "G5 - Route",
      "time": "23-09-2024, 06:30 PM",
      "icon": Icons.exit_to_app,
      "color": Colors.orange.shade100,
    },
    {
      "title": "Low Battery",
      "subtitle": "G5 - Route",
      "time": "23-09-2024, 06:30 PM",
      "icon": Icons.battery_alert,
      "color": Colors.red.shade100,
    },
    {
      "title": "Vibration",
      "subtitle": "TN 12 WE 2334",
      "time": "23-09-2024, 06:30 PM",
      "icon": Icons.vibration,
      "color": Colors.orange.shade100,
    },
    {
      "title": "Power cut",
      "subtitle": "TN 12 AK 54332",
      "time": "1 min ago",
      "icon": Icons.power_off,
      "color": Colors.purple.shade100,
    },
    {
      "title": "Ignition ON",
      "subtitle": "TN 12 WE 3343",
      "time": "2 days ago",
      "icon": Icons.flash_on,
      "color": Colors.blue.shade100,
    },
  ];

  String selectedVehicle = 'R17-KA32C7098';

  final List<String> vehicles = ['R17-KA32C7098', 'MH12-DE3456', 'UP65-XY7890'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: 'Notifications',
      ),
      body: Column(
        children: [
          _buildDropdown(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  elevation: 0.5,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['color'],
                      child: Icon(item['icon'], color: Colors.black),
                    ),
                    title: Text(item['title'],
                        style: AppTextStyle.h5),
                    subtitle: Text(item['subtitle'],style: AppTextStyle.h5GreyColor,),
                    trailing: Text(item['time'],
                        style: AppTextStyle.h6GreyColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            dropdownValue: selectedVehicle,
            dropDownList:
            vehicles.map((vehicle) {
              return DropdownMenuItem<String>(
                value: vehicle,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.primaryLightColor,
                      child: SvgPicture.asset(
                        AppIcons.svg.truck,
                        width: 20,
                      ),
                    ),
                    10.width,
                    Text(vehicle, style: AppTextStyle.h6),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedVehicle = newValue!;
              });
            },
          ),
        ),
        10.width,
        AppIconButton(
          onPressed: () {

          },
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.newFilter, width: 20),
        )
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding,vertical: 10);
  }
}
