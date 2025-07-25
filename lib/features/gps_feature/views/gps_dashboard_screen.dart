import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/widgets/gps_screen_lifecycle_wrapper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/common_widgets.dart';
import '../constants/app_constants.dart';

class GpsDashboardScreen extends StatelessWidget {
  const GpsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GpsScreenLifecycleWrapper(
      screenType: GpsScreenType.other,
      child: _GpsDashboardContent(),
    );
  }
}

class _GpsDashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        // Initialize data if needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final cubit = context.read<VehicleListCubit>();
          if (!cubit.hasLoadedData) {
            cubit.loadVehicleData(isLoadAgain: true);
          } else if (cubit.state.selectedVehicleNumber == null &&
              cubit.state.filteredVehicles.isNotEmpty) {
            // Fallback initialization if somehow the vehicle wasn't selected during data load
            final activeVehicles =
                cubit.state.filteredVehicles
                    .where((vehicle) => vehicle.expired != true)
                    .toList();
            if (activeVehicles.isNotEmpty) {
              cubit.setSelectedVehicle(
                activeVehicles.first.vehicleNumber ?? '',
              );
            }
          }
        });

        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: CommonAppBar(
              title: context.appText.dashboard,
              backgroundColor: Colors.white,
              elevation: 1,
              centreTile: false,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state.error != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: CommonAppBar(
              title: context.appText.dashboard,
              backgroundColor: Colors.white,
              elevation: 1,
              centreTile: false,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${context.appText.error}: ${state.error}'),
                  ElevatedButton(
                    onPressed:
                        () => context.read<VehicleListCubit>().refreshData(),
                    child: Text(context.appText.retry),
                  ),
                ],
              ),
            ),
          );
        }

        final filteredVehicles = state.filteredVehicles;
        final vehicles =
            filteredVehicles
                .where((vehicle) => vehicle.expired != true)
                .toList();

        if (vehicles.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: CommonAppBar(
              title: context.appText.dashboard,
              backgroundColor: Colors.white,
              elevation: 1,
              centreTile: false,
            ),
            body: Center(child: Text(context.appText.noVehiclesFound)),
          );
        }

        final totalDistance = getTotalDistance(vehicles);
        final insideFenceCount = getVehiclesInsideGeofence(vehicles);
        final outsideFenceCount = state.statusCount.total - insideFenceCount;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CommonAppBar(
            title: context.appText.dashboard,
            backgroundColor: Colors.white,
            elevation: 1,
            centreTile: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Use the new GPS lifecycle extension
                  context.gpsManualRefresh();
                  context.read<VehicleListCubit>().refreshDashboardData();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Use the new GPS lifecycle extension
              await context.gpsManualRefresh();
              return context.read<VehicleListCubit>().refreshDashboardData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildTopGrid(
                    context,
                    state,
                    insideFenceCount,
                    outsideFenceCount,
                  ),
                  20.height,
                  _buildStatusCircles(context, state),
                  20.height,
                  _buildTotalDistance(context, totalDistance.toString()),
                  20.height,
                  _buildGraphSection(context, vehicles, state),
                  20.height,
                  _buildBottomDistanceSummary(context, state),
                  20.height,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTopGrid(
    BuildContext context,
    VehicleListState state,
    int insideFenceCount,
    int outsideFenceCount,
  ) {
    return Column(
      children: [
        Row(
          children: [
            _infoCard(
              icon: AppIcons.svg.truck,
              title: context.appText.totalVehicles,
              count: '${state.statusCount.total}',
            ),
            10.width,
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInactive,
              title: context.appText.inactive,
              count: '${state.statusCount.inactive}',
            ),
          ],
        ),
        20.height,
        Row(
          children: [
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInsideFence,
              title: context.appText.insideFence,
              count: '$insideFenceCount',
            ),
            10.width,
            _infoCard(
              icon: AppIcons.svg.gpsDashboardOutsideFence,
              title: context.appText.outsideFence,
              count: '$outsideFenceCount',
            ),
          ],
        ),
      ],
    );
  }

  static Widget _infoCard({
    required String icon,
    required String title,
    required String count,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 25),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  5.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        count,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusCircles(
    BuildContext context,
    VehicleListState state,
  ) {
    final total =
        state.statusCount.total == 0
            ? 1
            : state.statusCount.total; // avoid divide by zero

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circularStatus(
          title: context.appText.idle,
          value: state.statusCount.idle,
          total: total,
          color: Colors.amber,
        ),
        _circularStatus(
          title: context.appText.ignitionOn,
          value: state.statusCount.ignitionOn,
          total: total,
          color: Colors.green,
        ),
        _circularStatus(
          title: context.appText.ignitionOff,
          value: state.statusCount.ignitionOff,
          total: total,
          color: Colors.red,
        ),
      ],
    );
  }

  static Widget _circularStatus({
    required String title,
    required int value,
    required int total,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: AppTextStyle.h6),
            10.height,
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: value / total,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeWidth: 6,
                  ),
                ),
                Text('$value', style: AppTextStyle.h6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTotalDistance(BuildContext context, String total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.png.gpsDashboardRoad, height: 20),
          10.width,
          Text(
            '${context.appText.totalDistance} - ',
            style: AppTextStyle.textDarkGreyColor14w500,
          ),
          Text(total, style: AppTextStyle.h5),
        ],
      ),
    );
  }

  static double getTotalDistance(List<GpsCombinedVehicleData> vehicles) {
    double totalDistance = 0.0;

    for (var vehicle in vehicles) {
      double prevOdometer = 0.0;
      double currentTotalDistance = 0.0;
      try {
        prevOdometer = vehicle.attributes?.prevOdometer ?? 0.0;
        currentTotalDistance =
            double.tryParse(vehicle.totalDistance ?? '0') ?? 0.0;
      } catch (e) {
        // Vehicle attribute parsing error - continue with default values
      }
      totalDistance += (currentTotalDistance - prevOdometer) / 1000;
    }
    totalDistance = double.parse(totalDistance.toStringAsFixed(1));
    return totalDistance;
  }

  static Widget _buildGraphSection(
    BuildContext context,
    List<GpsCombinedVehicleData> vehicles,
    VehicleListState state,
  ) {
    final vehicleNumbers =
        vehicles
            .map((v) => v.vehicleNumber)
            .whereType<String>()
            .toSet()
            .toList();
    // Ensure we have a valid selected vehicle number from the available vehicles
    final currentSelectedVehicle = state.selectedVehicleNumber;
    final validSelectedVehicle =
        (currentSelectedVehicle != null &&
                vehicleNumbers.contains(currentSelectedVehicle))
            ? currentSelectedVehicle
            : vehicleNumbers.isNotEmpty
            ? vehicleNumbers.first
            : null;

    if (state.selectedVehicleNumber == vehicleNumbers.first) {
      context.read<VehicleListCubit>().setSelectedVehicle(vehicleNumbers.first);
    }

    if (state.isWeeklyDistanceLoading) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _vehicleDropdown(context, validSelectedVehicle, vehicleNumbers),
            25.height,
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }
    if (state.weeklyDistance.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _vehicleDropdown(context, validSelectedVehicle, vehicleNumbers),
            25.height,
            Center(
              child: Text(
                context.appText.noDistanceDataAvailable,
                style: AppTextStyle.h5,
              ),
            ),
          ],
        ),
      );
    }

    final graphPoints =
        state.weeklyDistance
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value.distance))
            .toList();

    final xLabels =
        state.weeklyDistance.map((e) {
          try {
            DateFormat inputFormat = DateFormat('d/M');
            DateTime date = inputFormat.parse(e.startTime);
            return DateFormat('d MMM').format(date); // e.g., 10 Jul
          } catch (_) {
            return e.startTime; // fallback to original string if parsing fails
          }
        }).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _vehicleDropdown(context, validSelectedVehicle, vehicleNumbers),
          25.height,
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      dashArray: [4, 4], // dotted horizontal grid lines
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < xLabels.length) {
                          return Text(
                            xLabels[index],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} Kms',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false, // remove chart borders
                ),
                minX: 0,
                maxX: graphPoints.length.toDouble() - 1,
                minY: 0,
                maxY: _getMaxY(graphPoints),
                lineBarsData: [
                  LineChartBarData(
                    spots: graphPoints,
                    isCurved: true,
                    // smooth curves
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true, // show dots
                      getDotPainter:
                          (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 0,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                    ), // no shading below the line
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBottomDistanceSummary(
    BuildContext context,
    VehicleListState state,
  ) {
    final monthlyDistance =
        state.selectedVehicleDistanceData['monthlyDistance'];
    final weeklyDistance = state.selectedVehicleDistanceData['weeklyDistance'];

    // Show loading indicator if data is explicitly loading
    if (state.isWeeklyDistanceLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // If distance data is not available yet, show placeholder values
    final displayMonthlyDistance = monthlyDistance?.toString() ?? '0 km';
    final displayWeeklyDistance = weeklyDistance?.toString() ?? '0 km';

    return Row(
      children: [
        // This Month Container
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Green vertical bar
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                10.width,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.appText.thisMonth,
                          style: AppTextStyle.h6GreyColor,
                        ),
                        5.height,
                        Text(displayMonthlyDistance, style: AppTextStyle.h5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        10.width,
        // Last 7 Days Container
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Orange vertical bar
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                10.width,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.appText.last7Days,
                          style: AppTextStyle.h6GreyColor,
                        ),
                        5.height,
                        Text(displayWeeklyDistance, style: AppTextStyle.h5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static double _getMaxY(List<FlSpot> points) {
    final maxY = points
        .map((e) => e.y)
        .fold(0.0, (prev, y) => y > prev ? y : prev);
    return (maxY + 5).ceilToDouble(); // Add padding and round up
  }

  static int getVehiclesInsideGeofence(List<GpsCombinedVehicleData> vehicles) {
    return vehicles.where((v) {
      final geofenceIds = v.geofenceIds;

      if (geofenceIds == null ||
          geofenceIds.trim().isEmpty ||
          geofenceIds.trim() == '[]') {
        return false;
      }
      try {
        final decoded = jsonDecode(geofenceIds);
        return decoded is List && decoded.isNotEmpty;
      } catch (_) {
        // Fallback: maybe it's already a List<String>
        return false;
      }
    }).length;
  }

  static Widget _vehicleDropdown(
    BuildContext context,
    String? selected,
    List<String> vehicleNumbers,
  ) {
    return DropdownSearch<String>(
      selectedItem: selected,
      items: (String filter, _) async {
        return vehicleNumbers
            .where((v) => v.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },
      popupProps: PopupProps.menu(
        // fit: FlexFit.loose,
        showSearchBox: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        emptyBuilder:
            (context, searchEntry) => Center(
              child: Text(context.appText.noVehiclesFound),
            ).withHeight(MediaQuery.of(context).size.height * 0.3),
        loadingBuilder:
            (context, searchEntry) =>
                const Center(child: CircularProgressIndicator()),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: commonInputDecoration(
          hintText: context.appText.selectState,
        ),
      ),
      itemAsString: (String? item) => item ?? "",
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null || selectedItem.isEmpty) {
          return Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primaryLightColor,
                child: SvgPicture.asset(AppIcons.svg.truck, width: 20),
              ),
              10.width,
              Text(
                context.appText.selectVehicle,
                style: AppTextStyle.h6GreyColor,
              ),
            ],
          );
        }
        return Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryLightColor,
              child: SvgPicture.asset(AppIcons.svg.truck, width: 20),
            ),
            10.width,
            Text(selectedItem, style: AppTextStyle.h6),
          ],
        );
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
          context.read<VehicleListCubit>().setSelectedVehicle(newValue);
        }
      },
    );
    // return AppDropdown(
    //   dropdownValue: selected,
    //   dropDownList: vehicleNumbers.map((number) {
    //     return DropdownMenuItem<String>(
    //       value: number,
    //       child: Row(
    //         children: [
    //           CircleAvatar(
    //             radius: 15,
    //             backgroundColor: AppColors.primaryLightColor,
    //             child: SvgPicture.asset(AppIcons.svg.truck, width: 20),
    //           ),
    //           10.width,
    //           Text(number),
    //         ],
    //       ),
    //     );
    //   }).toList(),
    //   onChanged: (String? newValue) {
    //     if (newValue != null) {
    //       context.read<VehicleListCubit>().setSelectedVehicle(newValue);
    //     }
    //   },
    // );
  }
}
