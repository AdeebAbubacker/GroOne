import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

import '../../../dependency_injection/locator.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../cubit/gps_notification_cubit/gps_notification_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';

class GpsNotificationScreen extends StatefulWidget {
  const GpsNotificationScreen({super.key});

  @override
  State<GpsNotificationScreen> createState() => _GpsNotificationScreenState();
}

class _GpsNotificationScreenState extends State<GpsNotificationScreen> {
  final gpsGeofenceCubit = locator<GpsGeofenceCubit>();

  Map<String, bool> filterOptions = {
    "Ignition OFF": true,
    "Ignition ON": true,
    "Geo-fence Enter": true,
    "Geo-fence Exit": true,
    "Device Over-speed": true,
    "Low Battery": true,
    "Power-Cut": true,
    "Vibration": true,
  };

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
  void initState() {
    // context.read<GpsNotificationCubit>().loadNotifications('163');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: 'Notifications',
      ),
      body: Column(
        children: [
          // _buildDropdown(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, vehicleState) {
                  if (vehicleState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState.error != null) {
                    return Center(child: Text('Error loading vehicles'));
                  } else {
                    // Extract unique vehicle numbers
                    final uniqueVehicleNumbers =
                    vehicleState.filteredVehicles
                        .map((v) => v.vehicleNumber)
                        .whereType<String>() // removes nulls
                        .toSet() // remove duplicates
                        .toList();

                    // If no vehicles found
                    if (uniqueVehicleNumbers.isEmpty) {
                      return Center(child: Text('No vehicles available'));
                    }

                    // Ensure selectedVehicle is in the dropdown
                    if (!uniqueVehicleNumbers.contains(selectedVehicle)) {
                      selectedVehicle = uniqueVehicleNumbers.first;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: AppDropdown(
                        labelText: "Select Vehicle",
                        dropdownValue:
                        selectedVehicle.isNotEmpty ? selectedVehicle : null,
                        dropDownList:
                        uniqueVehicleNumbers.map((vehicleNumber) {
                          return DropdownMenuItem<String>(
                            value: vehicleNumber,
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
                                const SizedBox(width: 10),
                                Text(vehicleNumber, style: AppTextStyle.h6),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedVehicle = newValue!;
                          });

                          final selectedVehicleData = vehicleState.filteredVehicles
                              .firstWhere((v) => v.vehicleNumber == selectedVehicle);
                          gpsGeofenceCubit.loadVehicleGeofences(
                            userId: "163", // Fetch from secured storage
                            deviceId: selectedVehicleData.deviceId.toString(),
                            vehicleId: selectedVehicle, // use vehicle number or ID
                          );
                        },
                      ),
                    );
                  }
                },
              ).expand(),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {
                    _showFilterDialog();
                  },
                ),
              ),
            ],
          ),
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
          // BlocBuilder<GpsNotificationCubit, GpsNotificationState>(
          //   builder: (context, state) {
          //     if (state is GpsNotificationLoading) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (state is GpsNotificationLoaded) {
          //       final notifications = state.notifications;
          //       if (notifications.isEmpty) {
          //         return const Center(child: Text("No notifications available"));
          //       }
          //       return ListView.builder(
          //         itemCount: notifications.length,
          //         itemBuilder: (context, index) {
          //           final item = notifications[index];
          //           return Card(
          //             elevation: 0.5,
          //             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //             child: ListTile(
          //               leading: CircleAvatar(
          //                 backgroundColor: Colors.blue.shade100,
          //                 child: Icon(Icons.notifications, color: Colors.black),
          //               ),
          //               title: Text(
          //                 "${item.type} alert",
          //                 style: AppTextStyle.h5,
          //               ),
          //               subtitle: Text(
          //                 "Speed: ${item.speed.toStringAsFixed(1)} km/h | Limit: ${item.speedLimit.toStringAsFixed(1)} km/h",
          //               ),
          //               trailing: Text(
          //                 "${DateFormat('dd-MM-yyyy, hh:mm a').format(item.fixTime)}",
          //                 style: AppTextStyle.h6GreyColor,
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     } else if (state is GpsNotificationError) {
          //       return Center(child: Text("Error: ${state.message}"));
          //     } else {
          //       return const SizedBox.shrink();
          //     }
          //   },
          // ).expand()
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Filter Notifications", style: AppTextStyle.h4),
                const SizedBox(height: 12),
                ...filterOptions.keys.map((key) {
                  return SwitchListTile(
                    title: Text(key, style: AppTextStyle.h5),
                    value: filterOptions[key]!,
                    onChanged: (bool value) {
                      setState(() {
                        filterOptions[key] = value;
                      });
                    },
                    secondary: Icon(
                      _getIconForType(key),
                      color: _getColorForType(key),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case "Ignition OFF":
        return Icons.power_settings_new;
      case "Ignition ON":
        return Icons.flash_on;
      case "Geo-fence Enter":
        return Icons.login;
      case "Geo-fence Exit":
        return Icons.logout;
      case "Device Over-speed":
        return Icons.speed;
      case "Low Battery":
        return Icons.battery_alert;
      case "Power-Cut":
        return Icons.power_off;
      case "Vibration":
        return Icons.vibration;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case "Ignition OFF":
        return Colors.red.shade100;
      case "Ignition ON":
        return Colors.green.shade100;
      case "Geo-fence Enter":
        return Colors.blue.shade100;
      case "Geo-fence Exit":
        return Colors.orange.shade100;
      case "Device Over-speed":
        return Colors.purple.shade100;
      case "Low Battery":
        return Colors.red.shade100;
      case "Power-Cut":
        return Colors.purple.shade100;
      case "Vibration":
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

}
