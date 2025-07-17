import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icons.dart';
import '../constants/app_constants.dart';
import '../model/gps_distance_data_model.dart';
import '../service/gps_realm_service.dart';

class GpsDashboardScreen extends StatefulWidget {
  const GpsDashboardScreen({super.key});

  @override
  State<GpsDashboardScreen> createState() => _GpsDashboardScreenState();
}

class _GpsDashboardScreenState extends State<GpsDashboardScreen> {
  String? selectedVehicleNumber;
  bool isLoading = true;
  List<DistanceData> _weeklyDistance = [];
  bool _isWeeklyDistanceLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<VehicleListCubit>();
      final vehicles = cubit.state.filteredVehicles;
      if (vehicles.isNotEmpty) {
        selectedVehicleNumber ??= vehicles.first.vehicleNumber;
        _loadWeeklyDistance(vehicles);
      }
    });
  }


  double _getMaxY(List<FlSpot> points) {
    final maxY = points
        .map((e) => e.y)
        .fold(0.0, (prev, y) => y > prev ? y : prev);
    return (maxY + 5).ceilToDouble(); // Add padding and round up
  }

  int getVehiclesInsideGeofence(List<GpsCombinedVehicleData> vehicles) {
    return vehicles.where((v) {
      try {
        final ids = jsonDecode(v.geofenceIds ?? '[]');
        return ids is List && ids.isNotEmpty;
      } catch (_) {
        return false;
      }
    }).length;
  }

  Future<void> _loadWeeklyDistance(List<GpsCombinedVehicleData> vehicles) async {
    if (selectedVehicleNumber == null || vehicles.isEmpty) return;

    final vehicle = vehicles.firstWhere(
          (v) => v.vehicleNumber == selectedVehicleNumber,
      orElse: () => vehicles.first,
    );

    if (vehicle.deviceId == null) return;

    final result = await GpsRealmService().getWeeklyDistanceGraph(vehicle.deviceId!);
    setState(() {
      _weeklyDistance = result;
      _isWeeklyDistanceLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: 'Dashboard',
        backgroundColor: Colors.white,
        elevation: 1,
        centreTile: false,
      ),
      body: BlocBuilder<VehicleListCubit, VehicleListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final vehicles = state.filteredVehicles;

          if (vehicles.isEmpty) {
            return const Center(child: Text('No vehicles available'));
          }

          final selectedVehicle = vehicles.firstWhere(
            (v) => v.vehicleNumber == selectedVehicleNumber,
            orElse: () {
              final fallback = vehicles.first;
              selectedVehicleNumber = fallback.vehicleNumber;
              return fallback;
            },
          );

          final insideFenceCount = getVehiclesInsideGeofence(vehicles);
          final outsideFenceCount = state.statusCount.total - insideFenceCount;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildTopGrid(state, insideFenceCount, outsideFenceCount),
                20.height,
                _buildStatusCircles(state),
                20.height,
                _buildTotalDistance(selectedVehicle),
                20.height,
                _buildGraphSection(vehicles),
                20.height,
                _buildBottomDistanceSummary(selectedVehicle),
                20.height
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopGrid(VehicleListState state, int insideFenceCount, int outsideFenceCount,) {
    return Column(
      children: [
        Row(
          children: [
            _infoCard(
              icon: AppIcons.svg.truck,
              title: 'Total Vehicles',
              count: '${state.statusCount.total}',
            ),
            10.width,
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInactive,
              title: 'Inactive',
              count: '${state.statusCount.inactive}',
            ),
          ],
        ),
        20.height,
        Row(
          children: [
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInsideFence,
              title: 'Inside Fence',
              count: '$insideFenceCount',
            ),
            10.width,
            _infoCard(
              icon: AppIcons.svg.gpsDashboardOutsideFence,
              title: 'Outside Fence',
              count: '$outsideFenceCount',
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoCard({required String icon, required String title, required String count,}) {
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

  Widget _buildStatusCircles(VehicleListState state) {
    final total =
        state.statusCount.total == 0
            ? 1
            : state.statusCount.total; // avoid divide by zero

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circularStatus(
          title: 'Idle',
          value: state.statusCount.idle,
          total: total,
          color: Colors.amber,
        ),
        _circularStatus(
          title: 'Ignition ON',
          value: state.statusCount.ignitionOn,
          total: total,
          color: Colors.green,
        ),
        _circularStatus(
          title: 'Ignition OFF',
          value: state.statusCount.ignitionOff,
          total: total,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _circularStatus({required String title, required int value, required int total, required Color color,}) {
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

  Widget _buildTotalDistance(GpsCombinedVehicleData vehicle) {
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
            'Total Distance - ',
            style: AppTextStyle.textDarkGreyColor14w500,
          ),
          Text(vehicle.odoReading ?? '0 Kms', style: AppTextStyle.h5),
        ],
      ),
    );
  }

  Widget _buildGraphSection(List<GpsCombinedVehicleData> vehicles) {
    final vehicleNumbers = vehicles
        .map((v) => v.vehicleNumber)
        .whereType<String>()
        .toSet()
        .toList();

    if (selectedVehicleNumber == null && vehicleNumbers.isNotEmpty) {
      selectedVehicleNumber = vehicleNumbers.first;
    }

    if (_isWeeklyDistanceLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_weeklyDistance.isEmpty) {
      return Center(child: Text('No distance data available',style: AppTextStyle.h5,));
    }

    final graphPoints = _weeklyDistance
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.distance))
        .toList();

    // final xLabels = _weeklyDistance.map((e) => e.startTime).toList();
    final xLabels = _weeklyDistance.map((e) {
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
          AppDropdown(
            dropdownValue: selectedVehicleNumber,
            dropDownList: vehicleNumbers.map((number) {
              return DropdownMenuItem<String>(
                value: number,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                      AppColors.primaryLightColor,
                      child: SvgPicture.asset(
                        AppIcons.svg.truck,
                        width: 20,
                      ),
                    ),
                    10.width,
                    Text(number),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedVehicleNumber = newValue!;
                _isWeeklyDistanceLoading = true;
              });
              _loadWeeklyDistance(vehicles);
            },
          ),
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
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                    isCurved: true, // smooth curves
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true, // show dots
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 0,
                          ),
                    ),
                    belowBarData: BarAreaData(show: false), // no shading below the line
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDistanceSummary(GpsCombinedVehicleData vehicle) {
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
                          'This Month',
                          style: AppTextStyle.h6GreyColor,
                        ),
                        5.height,
                        Text(
                          vehicle.odoReading ?? '0 km',
                          style: AppTextStyle.h5
                        ),
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
                          'Last 7 Days',
                          style: AppTextStyle.h6GreyColor,
                        ),
                        5.height,
                        Text(
                          vehicle.todayDistance ?? '0 km',
                          style: AppTextStyle.h5,
                        ),
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


// Widget _buildGraphSection(List<GpsCombinedVehicleData> vehicles) {
  //   final vehicleNumbers = vehicles
  //       .map((v) => v.vehicleNumber)
  //       .whereType<String>()
  //       .toSet()
  //       .toList();
  //   if (selectedVehicleNumber == null && vehicleNumbers.isNotEmpty) {
  //     selectedVehicleNumber = vehicleNumbers.first;
  //   }
  //
  //   return FutureBuilder<List<DistanceData>>(
  //     future: _loadWeeklyDistance(vehicles),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //
  //       final distanceData = snapshot.data!;
  //       if (distanceData.isEmpty) {
  //         return const Center(child: Text('No distance data available'));
  //       }
  //
  //       final graphPoints = distanceData
  //           .asMap()
  //           .entries
  //           .map((entry) => FlSpot(entry.key.toDouble(), entry.value.distance))
  //           .toList();
  //
  //       final xLabels = distanceData.map((e) => e.startTime).toList();
  //
  //       return Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.shade200,
  //               blurRadius: 6,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             AppDropdown(
  //               dropdownValue: selectedVehicleNumber,
  //               dropDownList: vehicleNumbers.map((number) {
  //                 return DropdownMenuItem<String>(
  //                   value: number,
  //                   child: Row(
  //                     children: [
  //                       const Icon(Icons.directions_car, size: 18),
  //                       const SizedBox(width: 10),
  //                       Text(number),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   selectedVehicleNumber = newValue!;
  //                 });
  //               },
  //             ),
  //             const SizedBox(height: 25),
  //             SizedBox(
  //               height: 220,
  //               child: LineChart(
  //                 LineChartData(
  //                   gridData: FlGridData(
  //                     show: true,
  //                     drawVerticalLine: false,
  //                     getDrawingHorizontalLine: (value) {
  //                       return FlLine(
  //                         color: Colors.grey.withOpacity(0.2),
  //                         strokeWidth: 1,
  //                       );
  //                     },
  //                   ),
  //                   titlesData: FlTitlesData(
  //                     bottomTitles: AxisTitles(
  //                       sideTitles: SideTitles(
  //                         showTitles: true,
  //                         reservedSize: 30,
  //                         getTitlesWidget: (value, meta) {
  //                           int index = value.toInt();
  //                           if (index >= 0 && index < xLabels.length) {
  //                             return Text(
  //                               xLabels[index],
  //                               style: const TextStyle(fontSize: 10),
  //                             );
  //                           }
  //                           return const Text('');
  //                         },
  //                       ),
  //                     ),
  //                     leftTitles: AxisTitles(
  //                       sideTitles: SideTitles(
  //                         showTitles: true,
  //                         reservedSize: 40,
  //                         getTitlesWidget: (value, meta) {
  //                           return Text(
  //                             '${value.toInt()} Kms',
  //                             style: const TextStyle(fontSize: 10),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   borderData: FlBorderData(show: false),
  //                   minX: 0,
  //                   maxX: graphPoints.length.toDouble() - 1,
  //                   minY: 0,
  //                   maxY: _getMaxY(graphPoints),
  //                   lineBarsData: [
  //                     LineChartBarData(
  //                       spots: graphPoints,
  //                       isCurved: true,
  //                       color: Colors.blue,
  //                       barWidth: 3,
  //                       dotData: FlDotData(show: true),
  //                       belowBarData: BarAreaData(show: false),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}