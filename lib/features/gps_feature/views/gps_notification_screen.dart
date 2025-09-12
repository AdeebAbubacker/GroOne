import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_notification_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_searchabledropdown.dart';
import '../cubit/gps_notification_cubit/gps_notification_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../model/gps_combined_vehicle_model.dart';

class GpsNotificationScreen extends StatefulWidget {
  const GpsNotificationScreen({super.key});

  @override
  State<GpsNotificationScreen> createState() => _GpsNotificationScreenState();
}

class _GpsNotificationScreenState extends State<GpsNotificationScreen> {
  Map<String, bool> filterOptions = {
    "Ignition OFF": true,
    "Ignition ON": true,
    "Geo-fence Enter": true,
    "Geo-fence Exit": true,
    "Device Over-speed": true,
    "Low Battery": true,
    "Power-Cut": true,
    "Vibration": true,
    "Other": true,
  };

  String selectedVehicle = '';

  @override
  void initState() {
    context.read<GpsNotificationCubit>().loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.notifications,
        centreTile: false,
        isLeading: true,
        actions: [
          AppIconButton(
            onPressed: () {
              context.read<GpsNotificationCubit>().loadNotifications();
            },
            icon: const Icon(Icons.refresh, size: 20),
            iconColor: AppColors.primaryColor,
          ),
          10.width,
        ],
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.appText.noData,
                            style: AppTextStyle.h5.copyWith(
                              color: AppColors.grayColor,
                            ),
                          ),
                          10.height,
                          Text(
                            'Unable to load vehicle data',
                            style: AppTextStyle.blackColor14w400.copyWith(
                              color: AppColors.grayColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Extract unique vehicle numbers
                    final uniqueVehicleNumbers =
                        vehicleState.filteredVehicles.withoutExpired
                            .map((v) => v.vehicleNumber)
                            .whereType<String>() // removes nulls
                            .toSet() // remove duplicates
                            .toList();

                    // If no vehicles found
                    if (uniqueVehicleNumbers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.appText.noData,
                              style: AppTextStyle.h5.copyWith(
                                color: AppColors.grayColor,
                              ),
                            ),
                            10.height,
                            Text(
                              context.appText.noVehiclesFound,
                              style: AppTextStyle.blackColor14w400.copyWith(
                                color: AppColors.grayColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    // Ensure selectedVehicle is in the dropdown
                    if (!uniqueVehicleNumbers.contains(selectedVehicle)) {
                      selectedVehicle = uniqueVehicleNumbers.first;
                    }
                    return SearchableDropdown(
                      selectedItem:
                          selectedVehicle.isNotEmpty ? selectedVehicle : null,
                      items: uniqueVehicleNumbers,
                      hintText: context.appText.selectState,
                      showSearchBox: true,
                      dropdownBuilder:
                          (context, selectedItem) => Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColors.primaryLightColor,
                                child: SvgPicture.asset(
                                  AppIcons.svg.truck,
                                  width: 20,
                                ),
                              ).paddingAll(5),
                              const SizedBox(width: 8),
                              Text(
                                selectedItem ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVehicle = newValue!;
                        });
                      },
                      emptyBuilder:
                          (context, searchEntry) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.appText.noData,
                                  style: AppTextStyle.h6.copyWith(
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                5.height,
                                Text(
                                  'No vehicles found',
                                  style: AppTextStyle.blackColor14w400.copyWith(
                                    color: AppColors.grayColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                    );
                  }
                },
              ).expand(),
              10.width,
              AppIconButton(
                icon: SvgPicture.asset(AppIcons.svg.newFilter, width: 20),
                style: AppButtonStyle.primaryIconButtonStyle,
                onPressed: () {
                  _showFilterDialog();
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 10),
          BlocBuilder<GpsNotificationCubit, GpsNotificationState>(
            builder: (context, state) {
              if (state is GpsNotificationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GpsNotificationLoaded) {
                final selectedVehicleData = context
                    .read<VehicleListCubit>()
                    .state
                    .filteredVehicles
                    .firstWhere(
                      (v) => v.vehicleNumber == selectedVehicle,
                      orElse: () => GpsCombinedVehicleData(),
                    );

                final selectedDeviceId = selectedVehicleData.deviceId;

                final filteredNotifications =
                    state.notifications.where((notif) {
                      final matchesVehicle = notif.deviceId == selectedDeviceId;
                      final matchesFilter =
                          filterOptions[notif.filterKey] ?? false;
                      return matchesVehicle && matchesFilter;
                    }).toList();

                if (filteredNotifications.isEmpty) {
                  return Center(
                    child: Text(
                      context.appText.noNotificationsAvailable,
                      style: AppTextStyle.h5,
                    ),
                  );
                }

                return Container(
                  color: AppColors.white,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      return Row(
                        children: [
                          SvgPicture.asset(
                            _getIconForFilter(item.filterKey),
                            width: 35,
                          ),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.filterKey} alert",
                                  style: AppTextStyle.h5,
                                ),
                                Text(
                                  "Device ID: ${item.deviceId}",
                                  style: AppTextStyle.h6GreyColor,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat(
                              'dd MMMM yyyy,\n h:mm a',
                            ).format(item.fixTime),
                            style: AppTextStyle.h6GreyColor,
                          ),
                        ],
                      ).paddingAll(15);
                    },
                  ),
                );
              } else if (state is GpsNotificationError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.appText.noData,
                        style: AppTextStyle.h5.copyWith(
                          color: AppColors.grayColor,
                        ),
                      ),
                      10.height,
                      Text(
                        context.appText.unableToLoadNotificationData,
                        style: AppTextStyle.blackColor14w400.copyWith(
                          color: AppColors.grayColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ).expand(),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.appText.filter,
                      style: AppTextStyle.h4,
                    ).paddingOnly(left: 15),
                    12.height,
                    ...filterOptions.keys.map((key) {
                      return SwitchListTile(
                        title: Text(key, style: AppTextStyle.h5),
                        value: filterOptions[key]!,
                        onChanged: (bool value) {
                          // Update both the modal UI and the main widget
                          setModalState(() {
                            filterOptions[key] = value;
                          });
                          setState(() {}); // Refresh the main screen too
                        },
                        secondary: SvgPicture.asset(
                          _getIconForFilter(key),
                          width: 30,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getIconForFilter(String type) {
    switch (type) {
      case "Ignition OFF":
        return AppIcons.svg.dashboardIgnitionOff;
      case "Ignition ON":
        return AppIcons.svg.dashboardIgnitionOn;
      case "Geo-fence Enter":
        return AppIcons.svg.dashboardGeofenceIn;
      case "Geo-fence Exit":
        return AppIcons.svg.dashboardGeofenceOut;
      case "Device Over-speed":
        return AppIcons.svg.dashboardOverSpeed;
      case "Low Battery":
        return AppIcons.svg.dashboardLowBattery;
      case "Power-Cut":
        return AppIcons.svg.dashboardPowerCut;
      case "Vibration":
        return AppIcons.svg.dashboardVibration;
      case "Other":
        return AppIcons.svg.gpsNotificationsOtherAlerts;
      default:
        return AppIcons.svg.dashboardIgnitionOff;
    }
  }
}
