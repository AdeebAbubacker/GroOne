import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_map_view_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_notification_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../dependency_injection/locator.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../models/gps_geofence_model.dart';

class GpsGeofenceScreen extends StatefulWidget {
  const GpsGeofenceScreen({super.key});

  @override
  State<GpsGeofenceScreen> createState() => _GpsGeofenceScreenState();
}

class _GpsGeofenceScreenState extends State<GpsGeofenceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final gpsGeofenceCubit = locator<GpsGeofenceCubit>();

  Map<String, Map<String, bool>> vehicleGeofenceStates =
      {}; // { vehicleId: { geofenceId: isEnabled } }

  String selectedVehicle = '';

  @override
  void initState() {
    super.initState();
    gpsGeofenceCubit.loadGeofences();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        final vehicleListState = locator<VehicleListCubit>().state;

        final uniqueVehicleNumbers =
            vehicleListState.filteredVehicles
                .map((v) => v.vehicleNumber)
                .whereType<String>() // removes nulls
                .toSet()
                .toList();

        if (selectedVehicle.isEmpty && uniqueVehicleNumbers.isNotEmpty) {
          selectedVehicle = uniqueVehicleNumbers.first;
        }

        if (selectedVehicle.isNotEmpty) {
          final selectedVehicleData = vehicleListState.filteredVehicles
              .firstWhere((v) => v.vehicleNumber == selectedVehicle);

          gpsGeofenceCubit.loadVehicleGeofences(
            deviceId: selectedVehicleData.deviceId.toString(),
            vehicleId: selectedVehicle,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getFormattedValue(GpsGeofenceModel item) {
    switch (item.shapeType) {
      case 'circle':
        return '${(item.radius ?? 0).toStringAsFixed(0)} m';
      case 'polygon':
      case 'polyline':
        // Use coveredArea directly from model
        return item.coveredArea ?? '';
      default:
        return '';
    }
  }

  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    bool enable,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AppDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Text(
                enable ? context.appText.addGeofence : context.appText.removeGeofence,
                style: AppTextStyle.h5,
              ),
              10.height,
              Text(
                enable
                    ? context.appText.confirmEnableGeofence
                    : context.appText.confirmDisableGeofence,
                style: AppTextStyle.blackColor14w400,
              ),
              20.height,
              Row(
                children: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    title: context.appText.no,
                    style: AppButtonStyle.outline,
                  ).expand(),
                  10.width,
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    title: context.appText.yes,
                    style: AppButtonStyle.primary,
                  ).expand(),
                ],
              ),
              20.height,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.geofence,
        isLeading: true,
        actions: [
          AppIconButton(
            onPressed: () {
              debugPrint("🔄 GpsGeofenceScreen - Refresh button pressed");
              gpsGeofenceCubit.refreshData();
            },
            icon: const Icon(Icons.refresh, size: 20),
            iconColor: AppColors.primaryColor,
          ),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: AppTextStyle.h5,
          tabs: [
            Tab(text: context.appText.geofence),
            Tab(text: context.appText.vehicles),
          ],
        ),
      ),
      bottomNavigationBar: buildAddNewGeofenceButtonWidget(),
      body: TabBarView(
        controller: _tabController,
        children: [buildGeofenceList(), buildVehiclesTab()],
      ),
    );
  }

  Widget buildGeofenceList() {
    return BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
      builder: (context, state) {
        if (state is GpsGeofenceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GpsGeofenceLoaded) {
          final geofences = state.geofences;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: geofences.length,
            itemBuilder: (context, index) {
              final item = geofences[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: AppColors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    '${item.name} (${_getFormattedValue(item)})',
                    style: AppTextStyle.h5,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      commonRoute(
                        GeofenceMapViewScreen(
                          geofence: item,
                          onSave: (updatedGeofence) {
                            // Handle the updated geofence data (e.g., save to database, API)
                            debugPrint(
                              "Geofence updated: ${updatedGeofence.name}, ID: ${updatedGeofence.id}",
                            );
                            if (updatedGeofence.shapeType == "circle") {
                              debugPrint(
                                "Center: ${updatedGeofence.center}, Radius: ${updatedGeofence.radius}",
                              );
                            } else if (updatedGeofence.shapeType == "polygon") {
                              debugPrint(
                                "Polygon Points: ${updatedGeofence.polygonPoints}",
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else if (state is GpsGeofenceError) {
          return Center(child: Text('${context.appText.error}: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  Widget buildVehiclesTab() {
    return Column(
      children: [
        BlocBuilder<VehicleListCubit, VehicleListState>(
          builder: (context, vehicleState) {
            if (vehicleState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (vehicleState.error != null) {
              return Center(child: Text(context.appText.errorLoadingVehicles));
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
                return Center(child: Text(context.appText.noVehiclesAvailable));
              }

              // Ensure selectedVehicle is in the dropdown
              if (!uniqueVehicleNumbers.contains(selectedVehicle)) {
                selectedVehicle = uniqueVehicleNumbers.first;
              }

              return Padding(
                padding: const EdgeInsets.all(15),
                child: AppDropdown(
                  labelText: context.appText.selectVehicle,
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
                      deviceId: selectedVehicleData.deviceId.toString(),
                      vehicleId: selectedVehicle, // use vehicle number or ID
                    );
                  },
                ),
              );
            }
          },
        ),
        Expanded(
          child: BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
            builder: (context, state) {
              if (state is GpsGeofenceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GpsGeofenceLoaded) {
                final gpsState = context.watch<GpsGeofenceCubit>().state;

                if (gpsState is GpsGeofenceLoaded) {
                  final activeGeofences =
                      gpsState.vehicleGeofenceMap[selectedVehicle] ?? {};

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: gpsState.geofences.length,
                    itemBuilder: (context, index) {
                      final item = gpsState.geofences[index];
                      final activeGeofences =
                          gpsState.vehicleGeofenceMap[selectedVehicle] ?? {};
                      final isEnabled = activeGeofences.contains(item.id);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: AppColors.white,
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            '${item.name} (${_getFormattedValue(item)})',
                            style: AppTextStyle.h6,
                          ),
                          trailing: Switch(
                            value: isEnabled,
                            // onChanged: (bool value) {
                            //   final selectedVehicleData = context
                            //       .read<VehicleListCubit>()
                            //       .state
                            //       .filteredVehicles
                            //       .firstWhere((v) => v.vehicleNumber == selectedVehicle);
                            //
                            //   gpsGeofenceCubit.toggleGeofenceForVehicle(
                            //     userId: "163", // Get this dynamically
                            //     deviceId: selectedVehicleData.deviceId.toString(),
                            //     vehicleId: selectedVehicle,
                            //     geofenceId: item.id,
                            //     enable: value,
                            //   );
                            // },
                            onChanged: (bool value) async {
                              final confirmed = await _showConfirmationDialog(
                                context,
                                value,
                              );
                              if (confirmed == true) {
                                final selectedVehicleData = context
                                    .read<VehicleListCubit>()
                                    .state
                                    .filteredVehicles
                                    .firstWhere(
                                      (v) => v.vehicleNumber == selectedVehicle,
                                    );

                                gpsGeofenceCubit.toggleGeofenceForVehicle(
                                  userId: "163",
                                  // Get this dynamically
                                  deviceId:
                                      selectedVehicleData.deviceId.toString(),
                                  vehicleId: selectedVehicle,
                                  geofenceId: item.id,
                                  enable: value,
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              } else if (state is GpsGeofenceError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget buildAddNewGeofenceButtonWidget() {
    // If current tab is "Vehicles" (index 1), hide the button
    if (_tabController.index == 1) {
      return const SizedBox.shrink(); // returns an empty widget
    }

    // Otherwise, show the button
    return AppButton(
      title: context.appText.addNewGeofence,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => GeofenceMapViewScreen(
                  geofence: null,
                  onSave: (newGeofence) {
                    debugPrint("New Geofence added: ${newGeofence.name}");
                  },
                ),
          ),
        );
      },
    ).bottomNavigationPadding();
  }
}
