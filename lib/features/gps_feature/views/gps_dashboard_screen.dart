import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:realm/realm.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icons.dart';
import '../constants/app_constants.dart';
import '../model/gps_combined_vehicle_realm_model.dart';

class GpsDashboardScreen extends StatefulWidget {
  const GpsDashboardScreen({super.key});

  @override
  State<GpsDashboardScreen> createState() => _GpsDashboardScreenState();
}

class _GpsDashboardScreenState extends State<GpsDashboardScreen> {
  String? selectedVehicleNumber;
  List<GpsCombinedVehicleData> _vehicles = [];
  bool isLoading = true;

  int total = 0, ignitionOn = 0, ignitionOff = 0, idle = 0, inactive = 0;
  int insideFence = 0, outsideFence = 0;
  double totalDistance = 0.0;
  late Realm _realm;



  @override
  void initState() {
    super.initState();
    final config = Configuration.local([GpsCombinedVehicleRealmData.schema]);
    _realm = Realm(config);

    _loadDashboardFromRealm();
  }

  Future<void> _loadDashboardFromRealm() async {
    setState(() => isLoading = true);

    final realmVehicles = _realm.all<GpsCombinedVehicleRealmData>();

    _vehicles = realmVehicles.map((e) => e.toDomain()).toList();

    total = _vehicles.length;
    ignitionOn = 0;
    ignitionOff = 0;
    idle = 0;
    inactive = 0;
    insideFence = 0;
    outsideFence = 0;
    totalDistance = 0;

    for (var vehicle in _vehicles) {
      final status = vehicle.status?.toUpperCase();

      if (vehicle.location?.contains('Inside Fence') ?? false) {
        insideFence++;
      } else {
        outsideFence++;
      }

      if (status == 'IGNITION_ON') {
        ignitionOn++;
      } else if (status == 'IGNITION_OFF') {
        ignitionOff++;
      } else if (status == 'IDLE') {
        idle++;
      } else if (status == 'INACTIVE') {
        inactive++;
      }

      if (vehicle.odoReading != null &&
          vehicle.odoReading!.contains('km')) {
        totalDistance += double.tryParse(
          vehicle.odoReading!.replaceAll('km', '').replaceAll(',', '').trim(),
        ) ??
            0;
      }
    }

    setState(() => isLoading = false);
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

          // selectedVehicleNumber ??= vehicles.first.vehicleNumber;
          // final selectedVehicle = vehicles.firstWhere(
          //       (v) => v.vehicleNumber == selectedVehicleNumber,
          //   orElse: () => vehicles.first,
          // );
          final selectedVehicle = vehicles.firstWhere(
                (v) => v.vehicleNumber == selectedVehicleNumber,
            orElse: () {
              final fallback = vehicles.first;
              selectedVehicleNumber = fallback.vehicleNumber;
              return fallback;
            },
          );

          // Calculate inside/outside fence counts
          final insideFenceCount = vehicles
              .where((v) => v.location!.contains('Inside Fence'))
              .length;
          final outsideFenceCount = vehicles
              .where((v) => v.location!.contains('Outside Fence'))
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildTopGrid(state, insideFenceCount, outsideFenceCount),
                const SizedBox(height: 20),
                _buildStatusCircles(state),
                const SizedBox(height: 20),
                _buildTotalDistance(selectedVehicle),
                const SizedBox(height: 20),
                _buildGraphSection(vehicles),
                const SizedBox(height: 20),
                _buildBottomDistanceSummary(selectedVehicle),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopGrid(
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
              title: 'Total Vehicles',
              count: '${state.statusCount.total}',
            ),
            const SizedBox(width: 10),
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInactive,
              title: 'Inactive',
              count: '${state.statusCount.inactive}',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _infoCard(
              icon: AppIcons.svg.gpsDashboardInsideFence,
              title: 'Inside Fence',
              count: '$insideFenceCount',
            ),
            const SizedBox(width: 10),
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

  Widget _infoCard({
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
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
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
    final total = state.statusCount.total == 0 ? 1 : state.statusCount.total; // avoid divide by zero

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

  Widget _circularStatus({
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
            const SizedBox(height: 8),
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
          const SizedBox(width: 10),
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

    // if (selectedVehicleNumber == null || !vehicleNumbers.contains(selectedVehicleNumber)) {
    //   selectedVehicleNumber = vehicleNumbers.isNotEmpty ? vehicleNumbers.first : null;
    // }

    // Filter and prepare data for the graph
    final selectedVehicleData = vehicles
        .where((v) => v.vehicleNumber == selectedVehicleNumber)
        .toList()
      ..sort((a, b) => a.lastUpdate?.compareTo(b.lastUpdate ?? DateTime.now()) ?? 0);

    final List<FlSpot> graphPoints = [];
    int index = 1;

    for (var data in selectedVehicleData) {
      // Convert todayDistance to double
      double distanceValue = 0;
      if (data.todayDistance != null && data.todayDistance!.contains("km")) {
        distanceValue = double.tryParse(
          data.todayDistance!.replaceAll("km", "").trim(),
        ) ??
            0;
      }
      graphPoints.add(FlSpot(index.toDouble(), distanceValue));
      index++;
    }

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
                    const Icon(Icons.directions_car, size: 18),
                    const SizedBox(width: 10),
                    Text(number),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedVehicleNumber = newValue!;
              });
            },
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
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
                        // Show date labels on X axis
                        final int index = value.toInt() - 1;
                        if (index >= 0 && index < selectedVehicleData.length) {
                          final date = selectedVehicleData[index].lastUpdate;
                          return Text(
                            date != null
                                ? "${date.day}/${date.month}"
                                : "",
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text("");
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} Kms',
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: graphPoints.length.toDouble(),
                minY: 0,
                maxY: _getMaxY(graphPoints), // Dynamic max Y
                lineBarsData: [
                  LineChartBarData(
                    spots: graphPoints,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


// Helper to calculate dynamic maxY
//   double _getMaxY(List<FlSpot> points) {
//     final maxY = points.map((e) => e.y).fold(0.0, (prev, y) => y > prev ? y : prev);
//     return maxY + 10; // Add a little padding
//   }
  double _getMaxY(List<FlSpot> points) {
    final maxY = points.map((e) => e.y).fold(0.0, (prev, y) => y > prev ? y : prev);
    return (maxY + 5).ceilToDouble(); // Add padding and round up
  }


  Widget _buildBottomDistanceSummary(GpsCombinedVehicleData vehicle) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('This Month',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 5),
                Text(vehicle.odoReading ?? '0 Kms', style: AppTextStyle.h5),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Last 7 Days',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 5),
                Text(vehicle.todayDistance ?? '0 Kms', style: AppTextStyle.h5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



// class GpsDashboardScreen extends StatefulWidget {
//   const GpsDashboardScreen({super.key});
//
//   @override
//   State<GpsDashboardScreen> createState() => _GpsDashboardScreenState();
// }
//
// class _GpsDashboardScreenState extends State<GpsDashboardScreen> {
//   String selectedVehicle = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: CommonAppBar(
//         title: Text('Dashboard', style: AppTextStyle.appBar),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppConstants.defaultPadding),
//         child: Column(
//           children: [
//             _buildTopGrid(),
//             _buildStatusCircles(),
//             _buildTotalDistance(),
//             _buildGraphSection(),
//             _buildBottomDistanceSummary(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopGrid() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             _infoCard(
//               icon: AppIcons.svg.truck,
//               title: 'Total Vehicles',
//               count: '23412',
//             ),
//             10.width,
//             _infoCard(
//               icon: AppIcons.svg.gpsDashboardInactive,
//               title: 'Inactive',
//               count: '23412',
//             ),
//           ],
//         ),
//         20.height,
//         Row(
//           children: [
//             _infoCard(
//               icon: AppIcons.svg.gpsDashboardInsideFence,
//               title: 'Inside Fence',
//               count: '23412',
//             ),
//             10.width,
//             _infoCard(
//               icon: AppIcons.svg.gpsDashboardOutsideFence,
//               title: 'Outside Fence',
//               count: '23412',
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _infoCard({
//     required String icon,
//     required String title,
//     required String count,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           SvgPicture.asset(icon, width: 25),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontSize: 13, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       count,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Icon(
//                       Icons.arrow_forward_ios,
//                       size: 12,
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).expand();
//   }
//
//   Widget _buildStatusCircles() {
//     List<Map<String, dynamic>> statuses = [
//       {'title': 'Idle', 'value': 7580, 'color': Colors.amber},
//       {'title': 'Ignition on', 'value': 7580, 'color': Colors.green},
//       {'title': 'Ignition off', 'value': 7580, 'color': Colors.red},
//     ];
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children:
//           statuses.map((status) {
//             return Expanded(
//               child: _circularStatus(
//                 title: status['title'],
//                 value: status['value'],
//                 color: status['color'],
//               ),
//             );
//           }).toList(),
//     );
//   }
//
//   Widget _circularStatus({
//     required String title,
//     required int value,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(title, style: AppTextStyle.h6),
//           8.height,
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 width: 60,
//                 height: 60,
//                 child: CircularProgressIndicator(
//                   value: 0.8,
//                   backgroundColor: Colors.grey.shade200,
//                   valueColor: AlwaysStoppedAnimation(color),
//                   strokeWidth: 6,
//                 ),
//               ),
//               Text('$value', style: AppTextStyle.h6),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTotalDistance() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Image.asset(AppIcons.png.gpsDashboardRoad, height: 20),
//           10.width,
//           Text(
//             'Total Distance - ',
//             style: AppTextStyle.textDarkGreyColor14w500,
//           ),
//           Text('10020 Kms', style: AppTextStyle.h5),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGraphSection() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BlocBuilder<VehicleListCubit, VehicleListState>(
//             builder: (context, vehicleState) {
//               if (vehicleState.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (vehicleState.error != null) {
//                 return Center(child: Text('Error loading vehicles'));
//               } else {
//                 // Extract unique vehicle numbers
//                 final uniqueVehicleNumbers =
//                     vehicleState.filteredVehicles
//                         .map((v) => v.vehicleNumber)
//                         .whereType<String>() // removes nulls
//                         .toSet() // remove duplicates
//                         .toList();
//
//                 // If no vehicles found
//                 if (uniqueVehicleNumbers.isEmpty) {
//                   return Center(child: Text('No vehicles available'));
//                 }
//
//                 // Ensure selectedVehicle is in the dropdown
//                 if (!uniqueVehicleNumbers.contains(selectedVehicle)) {
//                   selectedVehicle = uniqueVehicleNumbers.first;
//                 }
//
//                 return AppDropdown(
//                   dropdownValue:
//                       selectedVehicle.isNotEmpty ? selectedVehicle : null,
//                   dropDownList:
//                       uniqueVehicleNumbers.map((vehicleNumber) {
//                         return DropdownMenuItem<String>(
//                           value: vehicleNumber,
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 15,
//                                 backgroundColor: AppColors.primaryLightColor,
//                                 child: SvgPicture.asset(
//                                   AppIcons.svg.truck,
//                                   width: 20,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Text(vehicleNumber, style: AppTextStyle.h6),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedVehicle = newValue!;
//                     });
//                   },
//
//                   // onChanged: (String? newValue) {
//                   //   setState(() {
//                   //     selectedVehicle = newValue!;
//                   //   });
//                   //
//                   //   // Find deviceId for selectedVehicle
//                   //   final selectedVehicleData = vehicleState.filteredVehicles.firstWhere(
//                   //         (v) => v.vehicleNumber == selectedVehicle,
//                   //     orElse: () => GpsCombinedVehicleData(),
//                   //   );
//                   //
//                   //   final selectedDeviceId = selectedVehicleData.deviceId;
//                   //
//                   //   // Load notifications only for this deviceId
//                   //   if (selectedDeviceId != null) {
//                   //     context.read<GpsNotificationCubit>().loadNotifications(selectedDeviceId.toString());
//                   //   }
//                   // },
//                 );
//               }
//             },
//           ),
//           25.height,
//           SizedBox(
//             height: 250,
//             child: LineChart(
//               LineChartData(
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: [
//                       const FlSpot(1, 20),
//                       const FlSpot(2, 30),
//                       const FlSpot(3, 20),
//                       const FlSpot(4, 40),
//                       const FlSpot(5, 50),
//                       const FlSpot(6, 20),
//                       const FlSpot(7, 20),
//                     ],
//                     isCurved: true,
//                     color: Colors.blue,
//                     barWidth: 3,
//                     belowBarData: BarAreaData(show: false),
//                     dotData: FlDotData(show: true),
//                   ),
//                 ],
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         TextStyle style = AppTextStyle.body4;
//                         switch (value.toInt()) {
//                           case 1:
//                             return Text('12 Jun', style: style);
//                           case 2:
//                             return Text('13 Jun', style: style);
//                           case 3:
//                             return Text('14 Jun', style: style);
//                           case 4:
//                             return Text('15 Jun', style: style);
//                           case 5:
//                             return Text('16 Jun', style: style);
//                           case 6:
//                             return Text('17 Jun', style: style);
//                           case 7:
//                             return Text('18 Jun', style: style);
//                           default:
//                             return const Text('');
//                         }
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()} Kms',
//                           style: const TextStyle(fontSize: 10),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 gridData: FlGridData(show: true),
//                 borderData: FlBorderData(show: false),
//                 minX: 1,
//                 maxX: 5,
//                 minY: 0,
//                 maxY: 50,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomDistanceSummary() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: commonContainerDecoration(),
//             child: Column(
//               children: const [
//                 Text(
//                   'This Month',
//                   style: TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   '10020 Kms',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         10.height,
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: commonContainerDecoration(),
//             child: Column(
//               children: [
//                 Text(
//                   'Last 7 Days',
//                   style: TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//                 5.height,
//                 Text(
//                   '10020 Kms',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTrackVehiclesCard(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppConstants.cardColor,
//         borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppConstants.primaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             Icons.location_on,
//             color: AppConstants.primaryColor,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           AppStrings.trackMyVehicles,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: AppConstants.textPrimaryColor,
//             fontSize: 15,
//           ),
//         ),
//         subtitle: Text(
//           'View and manage all your vehicles',
//           style: TextStyle(
//             color: AppConstants.textSecondaryColor,
//             fontSize: 12,
//           ),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 14,
//           color: AppConstants.textSecondaryColor,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, AppRouteName.vehicleList);
//         },
//       ),
//     );
//   }
// }
