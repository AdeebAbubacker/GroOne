import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_text_style.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: Text('Dashboard', style: AppTextStyle.appBar),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          spacing: 15,
          children: [
            _buildTopGrid(),
            _buildStatusCircles(),
            _buildTotalDistance(),
            _buildGraphSection(),
            _buildBottomDistanceSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGrid(){
    return Column(
      children: [
        Row(
          children: [
            _infoCard(icon: AppIcons.svg.truck, title: 'Total Vehicles', count: '23412'),
            10.width,
            _infoCard(icon: AppIcons.svg.gpsDashboardInactive, title: 'Inactive', count: '23412'),
          ],
        ),
        20.height,
        Row(
          children: [
            _infoCard(icon: AppIcons.svg.gpsDashboardInsideFence, title: 'Inside Fence', count: '23412'),
            10.width,
            _infoCard(icon: AppIcons.svg.gpsDashboardOutsideFence, title: 'Outside Fence', count: '23412'),
          ],
        ),
      ],
    );
  }

  Widget _infoCard({required String icon, required String title, required String count}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).expand();
  }

  Widget _buildStatusCircles() {
    List<Map<String, dynamic>> statuses = [
      {'title': 'Idle', 'value': 7580, 'color': Colors.amber},
      {'title': 'Ignition on', 'value': 7580, 'color': Colors.green},
      {'title': 'Ignition off', 'value': 7580, 'color': Colors.red},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statuses.map((status) {
        return Expanded(
          child: _circularStatus(
            title: status['title'],
            value: status['value'],
            color: status['color'],
          ),
        );
      }).toList(),
    );
  }

  Widget _circularStatus({required String title, required int value, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(title, style: AppTextStyle.h6),
          8.height,
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: 0.8,
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
    );
  }

  Widget _buildTotalDistance() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.png.gpsDashboardRoad,height: 20,),
          10.width,
          Text('Total Distance - ', style: AppTextStyle.textDarkGreyColor14w500),
          Text('10020 Kms', style: AppTextStyle.h5),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blue),
              SizedBox(width: 8),
              Text('R17-KA32C7098', style: TextStyle(fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(1, 20),
                      const FlSpot(2, 30),
                      const FlSpot(3, 20),
                      const FlSpot(4, 40),
                      const FlSpot(5, 50),
                      const FlSpot(6, 20),
                      const FlSpot(7, 20),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
                      TextStyle style = AppTextStyle.body4;
                      switch (value.toInt()) {
                        case 1:
                          return  Text('12 Jun', style: style);
                        case 2:
                          return  Text('13 Jun', style: style);
                        case 3:
                          return  Text('14 Jun', style: style);
                        case 4:
                          return  Text('15 Jun', style: style);
                        case 5:
                          return  Text('16 Jun', style: style);
                        case 6:
                          return  Text('17 Jun', style: style);
                        case 7:
                          return  Text('18 Jun', style: style);
                        default:
                          return const Text('');
                      }
                    }),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()} Kms', style: const TextStyle(fontSize: 10));
                    }),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 5,
                minY: 0,
                maxY: 50,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomDistanceSummary() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: commonContainerDecoration(),
            child: Column(
              children: const [
                Text('This Month', style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 5),
                Text('10020 Kms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ),
        10.height,
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                Text('Last 7 Days', style: TextStyle(color: Colors.grey, fontSize: 13)),
                5.height,
                Text('10020 Kms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

