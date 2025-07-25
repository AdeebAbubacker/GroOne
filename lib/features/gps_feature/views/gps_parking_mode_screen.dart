import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../cubit/gps_parking_mode_cubit/gps_parking_mode_cubit.dart';
import '../cubit/gps_parking_mode_cubit/gps_parking_mode_state.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../models/gps_parking_model.dart';
import 'widgets/gps_parking_mode_scheduler.dart';
import 'gps_notification_screen.dart';
import 'package:collection/collection.dart';

class GpsParkingModeScreen extends StatefulWidget {
  const GpsParkingModeScreen({super.key});

  @override
  State<GpsParkingModeScreen> createState() => _GpsParkingModeScreenState();
}

class _GpsParkingModeScreenState extends State<GpsParkingModeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    final cubit = context.read<VehicleListCubit>();
    if (!cubit.hasLoadedData) {
      cubit.loadVehicleData();
    }
    context.read<GpsParkingModeCubit>().loadParkingModes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.parkingMode,
        centreTile: false,
        actions: [
          TextButton.icon(
            onPressed: () => context.read<GpsParkingModeCubit>().loadParkingModes(),
            icon: const Icon(Icons.refresh, color: Colors.blue),
            label: Text(context.appText.refresh, style: AppTextStyle.primaryColor12w400),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AppTextField(
              decoration: commonInputDecoration(
                hintText: context.appText.searchVehicle,
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => searchController.text = value);
                context.read<VehicleListCubit>().searchVehicles(value);
              },
              controller: searchController,
            ),
          ),
          BlocBuilder<GpsParkingModeCubit, GpsParkingModeState>(
            builder: (context, parkingState) {
              if (parkingState is GpsParkingModeLoading) {
                return CircularProgressIndicator();
              }

              final parkingModes =
                  parkingState is GpsParkingModeLoaded
                      ? parkingState.modes
                      : [];

              final vehicles =
                  context.watch<VehicleListCubit>().state.filteredVehicles;

              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  separatorBuilder: (_, __) => 10.height,
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    final deviceId = vehicle.deviceId;
                    final parkingEntry = parkingModes.firstWhereOrNull(
                          (e) => e.deviceId == deviceId,
                    ) ?? GpsParkingModeModel(
                      id: -1,
                      deviceId: deviceId ?? 0,
                      parkingMode: false,
                    );



                    return _buildVehicleTile(
                      context,
                      vehicle.vehicleNumber ?? '',
                      parkingEntry,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTile(
    BuildContext context,
    String vehicleNumber,
      GpsParkingModeModel parkingEntry,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
          child: SvgPicture.asset(AppIcons.svg.truck, width: 24),
        ),
        title: Text(vehicleNumber, style: AppTextStyle.h6),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: parkingEntry.parkingMode,
              activeTrackColor: AppColors.activeGreenColor,
              activeColor: Colors.white,
              onChanged: (val) async {
                context.read<GpsParkingModeCubit>().toggleParkingMode(parkingEntry, val);
              },
            ),
            IconButton(
              icon: Icon(Icons.schedule, color: AppColors.primaryColor),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) =>  GpsParkingModeScheduler(gpsParkingModeModel: parkingEntry,),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
