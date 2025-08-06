import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

import '../constants/app_constants.dart';
import '../widgets/map_floating_menu.dart';
import '../widgets/nearby_places_bottom_sheet.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleListCubit = locator<VehicleListCubit>();

    // Only load data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vehicleListCubit.hasLoadedData) {
        vehicleListCubit.loadVehicleData();
      }
    });

    return BlocProvider.value(
      value: vehicleListCubit,
      child: VehicleListView(),
    );
  }
}

class VehicleListView extends StatelessWidget {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleListCubit, VehicleListState>(
      listener: (context, state) {
        if (state.vehicleDataState?.status == Status.ERROR) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Vehicle data failed: [${state.vehicleDataState?.errorType?.toString() ?? 'Unknown error'}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context),
                  BlocBuilder<VehicleListCubit, VehicleListState>(
                    builder: (context, state) {
                      if (state.expiringSoonCount > 0) {
                        return _buildExpiryAlert(
                          context,
                          state.expiringSoonCount,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  _buildStatusTabs(),
                  Expanded(
                    child: BlocBuilder<VehicleListCubit, VehicleListState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            _buildSearchBar(context),
                            Expanded(child: _buildVehicleList()),
                            _buildBottomBanner(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Add a button to navigate to VehicleMapScreen
              Positioned(
                right: 16,
                bottom: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  icon: Icon(
                    Icons.map_outlined,
                    color: AppConstants.primaryColor,
                  ),
                  label: Text(
                    context.appText.viewAllVehicles,
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    final vehicles =
                        context
                            .read<VehicleListCubit>()
                            .state
                            .vehicleDataState
                            ?.data ??
                        [];
                    context.push(
                      AppRouteName.vehicleMap,
                      extra: {
                        'vehicles': vehicles,
                        'initialSelectedVehicle': null,
                      },
                    );
                  },
                ),
              ),
              // Add the floating action menu only on map view
              BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, state) {
                  if (!state.showMapView) return const SizedBox.shrink();
                  return Positioned(
                    right: 16,
                    bottom: 180,
                    child: MapFloatingMenu(
                      onToggleTraffic:
                          () =>
                              context.read<VehicleListCubit>().toggleTraffic(),
                      onToggleMapType:
                          () =>
                              context.read<VehicleListCubit>().toggleMapType(),
                      onReachability: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reachability feature coming soon!'),
                          ),
                        );
                      },
                      onNearbyVehicles: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nearby Vehicles feature coming soon!',
                            ),
                          ),
                        );
                      },
                      onNearbyPlaces: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const NearbyPlacesBottomSheet(),
                        );
                      },
                      isTrafficEnabled: state.trafficEnabled,
                      isSatellite: state.mapType == MapType.satellite,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppConstants.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.textPrimaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              context.appText.sbMatricSchool,
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.svg.notification,
              width: 25,
              colorFilter: AppColors.svg(AppColors.primaryColor),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppConstants.primaryColor),
            onPressed: () {
              context.read<VehicleListCubit>().refreshData();
            },
          ),
          IconButton(
            onPressed: () {
              commonSupportDialog(context);
            },
            icon: SvgPicture.asset(
              AppIcons.svg.support,
              width: 25,
              colorFilter: AppColors.svg(AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        return Container(
          color: AppConstants.cardColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusTab(
                  context,
                  VehicleTabType.Total,
                  'Total (${state.statusCount.total})',
                  AppConstants.primaryColor,
                  state.selectedTab == VehicleTabType.Total,
                ),
                _buildStatusTab(
                  context,
                  VehicleTabType.IgnitionON,
                  'Ignition ON (${state.statusCount.ignitionOn})',
                  AppConstants.primaryColor,
                  state.selectedTab == VehicleTabType.IgnitionON,
                ),
                _buildStatusTab(
                  context,
                  VehicleTabType.IgnitionOFF,
                  'Ignition OFF (${state.statusCount.ignitionOff})',
                  AppConstants.errorColor,
                  state.selectedTab == VehicleTabType.IgnitionOFF,
                ),
                _buildStatusTab(
                  context,
                  VehicleTabType.Idle,
                  'Idle (${state.statusCount.idle})',
                  AppConstants.successColor,
                  state.selectedTab == VehicleTabType.Idle,
                ),
                _buildStatusTab(
                  context,
                  VehicleTabType.Inactive,
                  '${context.appText.inactive} (${state.statusCount.inactive})',
                  AppConstants.errorColor,
                  state.selectedTab == VehicleTabType.Inactive,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Common Support Dialog
  void commonSupportDialog(BuildContext context) {
    AppDialog.show(
      context,
      child: CommonDialogView(
        heading: "Call Customer Support",
        message: "Contact our Customer support agent",
        onSingleButtonText: "Call",
        onTapSingleButton: () async {
          await callRedirect("180012304567");
        },
        child: SvgPicture.asset(AppImage.svg.customerSupport, width: 200),
      ),
    );
  }

  Widget _buildStatusTab(
    BuildContext context,
    VehicleTabType tabType,
    String text,
    Color dotColor,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.read<VehicleListCubit>().selectTab(tabType),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppConstants.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  isSelected
                      ? AppConstants.primaryColor
                      : AppConstants.textSecondaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : AppConstants.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      color: AppConstants.cardColor,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onChanged:
              (value) => context.read<VehicleListCubit>().searchVehicles(value),
          decoration: InputDecoration(
            hintText: context.appText.search,
            prefixIcon: Icon(
              Icons.search,
              color: AppConstants.textSecondaryColor,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleList() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        return Column(
          children: [
            // Main content
            Expanded(child: _buildVehicleListContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildVehicleListContent(
    BuildContext context,
    VehicleListState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            ElevatedButton(
              onPressed: () => context.read<VehicleListCubit>().refreshData(),
              child: Text(context.appText.retry),
            ),
          ],
        ),
      );
    }

    final vehiclesToShow = state.filteredVehicles.withExpired;

    if (vehiclesToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              context.appText.noVehiclesFound,
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.appText.tryAdjustingSearchOrFilters,
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppConstants.backgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehiclesToShow.length,
        itemBuilder: (context, index) {
          final vehicle = vehiclesToShow[index];
          return _buildVehicleCard(context, vehicle);
        },
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
  ) {
    final isExpired = vehicle.expired == null || vehicle.expired == true;

    return GestureDetector(
      onTap:
          isExpired
              ? null
              : () {
                context.push(
                  AppRouteName.vehicleMap,
                  extra: {
                    'vehicles': [vehicle],
                    'initialSelectedVehicle': vehicle,
                  },
                );
              },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      (vehicle.vehicleNumber ?? context.appText.unknown)
                          .formatVehicleNumberForDisplay,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Show status duration only if not expired
                    if (!isExpired)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.successColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppConstants.successColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vehicle.statusDuration ??
                                  context.appText.notAvailable,
                              style: TextStyle(
                                color: AppConstants.successColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    _buildSignalIndicator(context, vehicle.networkSignal ?? 0),
                    const SizedBox(width: 8),
                    _buildGPSIndicator(context, vehicle.hasGPS ?? false),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  vehicle.lastUpdate?.toString() ??
                      context.appText.noUpdateTime,
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppConstants.textSecondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child:
                          vehicle.address != null && vehicle.address!.isNotEmpty
                              ? Text(
                                vehicle.address!,
                                style: TextStyle(
                                  color: AppConstants.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              )
                              : (vehicle.location != null &&
                                  vehicle.location!.contains(','))
                              ? FutureBuilder<String>(
                                future: () {
                                  final parts = vehicle.location!.split(',');
                                  final lat =
                                      double.tryParse(parts[0].trim()) ?? 0;
                                  final lng =
                                      double.tryParse(parts[1].trim()) ?? 0;
                                  return MapHelper.getAddressFromLatLngDoubles(
                                    lat,
                                    lng,
                                  );
                                }(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Fetching address...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      'No address found',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              )
                              : Text(
                                context.appText.locationNotAvailable,
                                style: TextStyle(
                                  color: AppConstants.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context.appText.odo,
                        vehicle.odoReading ?? 'N/A',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context.appText.today,
                        vehicle.todayDistance ?? 'N/A',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context.appText.lastSpeed,
                        vehicle.lastSpeed ?? 'N/A',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Expired banner overlay
          if (isExpired)
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EXPIRED',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSignalIndicator(BuildContext context, int strength) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.signal_cellular_alt,
          color: AppConstants.successColor,
          size: 16,
        ),
        Text(
          context.appText.network,
          style: TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildGPSIndicator(BuildContext context, bool hasGPS) {
    return Column(
      children: [
        Icon(
          Icons.location_on,
          color:
              hasGPS
                  ? AppConstants.successColor
                  : AppConstants.textSecondaryColor,
          size: 16,
        ),
        Text(
          context.appText.gps,
          style: TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBanner() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        return Container(
          color: AppConstants.buyBannerColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.appText.buyNewGpsAndTrack,
                  style: TextStyle(
                    color: AppConstants.textPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.buttonBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  context.appText.buyNow,
                  style: const TextStyle(
                    color: AppConstants.cardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpiryAlert(BuildContext context, int expiringCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppConstants.warningColor),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppConstants.errorColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.expiryAlert,
                  style: const TextStyle(
                    color: AppConstants.errorColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  // e.g. '3 Devices Is Expiring Soon'
                  '$expiringCount ${context.appText.devicesExpiringSoon}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              context.appText.renewPlan,
              style: const TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
