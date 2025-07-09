import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';

import '../constants/app_constants.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<VehicleListCubit>()..loadVehicleData(),
      child: VehicleListView(),
    );
  }
}

class VehicleListView extends StatelessWidget {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapControllerCompleter =
        Completer<GoogleMapController>();

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
                  // _buildExpiryAlert(context, 5),
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
                            Expanded(
                              child:
                                  state.showMapView
                                      ? _buildVehicleMap(
                                        context,
                                        mapControllerCompleter,
                                      )
                                      : _buildVehicleList(),
                            ),
                            _buildBottomBanner(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, state) {
                  if (!state.showMapView) return const SizedBox.shrink();
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120, right: 16),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          bool isLoading = false;
                          return GestureDetector(
                            onTap: () async {
                              setState(() => isLoading = true);
                              try {
                                final controller =
                                    await mapControllerCompleter.future;
                                final latLng =
                                    await MapHelper.getCurrentLocation();
                                if (latLng != null) {
                                  await MapHelper.animateTo(controller, latLng);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Location unavailable or permission denied.',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to get current location.',
                                    ),
                                  ),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child:
                                    isLoading
                                        ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              AppConstants.primaryColor,
                                            ),
                                          ),
                                        )
                                        : SvgPicture.asset(
                                          AppIcons.svg.myLocation,
                                          width: 28,
                                          colorFilter: ColorFilter.mode(
                                            AppConstants.primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60, right: 16),
                      child: GestureDetector(
                        onTap: () {
                          context.read<VehicleListCubit>().toggleMapView(
                            !state.showMapView,
                          );
                        },
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  state.showMapView
                                      ? Icons.list
                                      : Icons.map_outlined,
                                  color: AppConstants.primaryColor,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  state.showMapView
                                      ? context.appText.listView
                                      : context.appText.viewAllVehicles,
                                  style: TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                      : AppConstants.textSecondaryColor.withOpacity(0.3),
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

    if (state.filteredVehicles.isEmpty) {
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
        itemCount: state.filteredVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = state.filteredVehicles[index];
          return _buildVehicleCard(context, vehicle);
        },
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    GpsCombinedVehicleData vehicle,
  ) {
    return Container(
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
                vehicle.vehicleNumber ?? context.appText.unknown,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withValues(alpha: 0.1),
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
                      vehicle.statusDuration ?? context.appText.notAvailable,
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
            vehicle.lastUpdate?.toString() ?? context.appText.noUpdateTime,
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
                child: Text(
                  vehicle.location ?? context.appText.locationNotAvailable,
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

  Widget _buildVehicleMap(
    BuildContext context,
    Completer<GoogleMapController> mapControllerCompleter,
  ) {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final vehicles = state.filteredVehicles;
        final markers = <Marker>{};
        for (final vehicle in vehicles) {
          final loc = vehicle.location;
          if (loc != null && loc.contains(',')) {
            final parts = loc.split(',');
            final lat = double.tryParse(parts[0].trim());
            final lng = double.tryParse(parts[1].trim());
            if (lat != null && lng != null) {
              markers.add(
                Marker(
                  markerId: MarkerId(vehicle.vehicleNumber ?? 'unknown'),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(title: vehicle.vehicleNumber),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow,
                  ),
                ),
              );
            }
          }
        }
        return GoogleMap(
          initialCameraPosition:
              markers.isNotEmpty
                  ? CameraPosition(target: markers.first.position, zoom: 12)
                  : const CameraPosition(
                    target: LatLng(20.5937, 78.9629),
                    zoom: 4,
                  ),
          markers: markers,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          onMapCreated: (controller) {
            if (!mapControllerCompleter.isCompleted) {
              mapControllerCompleter.complete(controller);
            }
          },
        );
      },
    );
  }

  Widget _buildBottomBanner() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        return Container(
          color: AppConstants.primaryColor,
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
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  context.appText.buyNow,
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
                  '${expiringCount} ${context.appText.devicesExpiringSoon}',
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
