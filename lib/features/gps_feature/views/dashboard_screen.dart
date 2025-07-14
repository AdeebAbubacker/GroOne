import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_strings.dart';
import 'package:gro_one_app/features/gps_feature/cubit/dashboard_cubit.dart';
import 'package:gro_one_app/features/gps_feature/models/vehicle_data_response.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppConstants.textPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.dashboard,
          style: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
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
                    onPressed:
                        () => context.read<DashboardCubit>().refreshData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final data = state.vehicleData!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildVehicleStatsRow(data),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildStatusIndicators(data),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildTotalDistanceCard(data),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildVehicleDropdown(data),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildChart(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildDistanceCards(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleStatsRow(VehicleDataResponse data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            AppStrings.getVehicle,
            data.totalVehicles,
            AppConstants.chartBlue,
            Icons.directions_car,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: _buildStatCard(
            AppStrings.totalVehicle,
            data.activeVehicles,
            AppConstants.chartOrange,
            Icons.electric_car,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators(VehicleDataResponse data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            AppStrings.vehicleActive,
            data.activeVehicles,
            AppConstants.chartGreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatusCard(
            AppStrings.vehicleInactive,
            data.inactiveVehicles,
            AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicatorSection(VehicleDataResponse data) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCircularIndicator(
            AppStrings.idle,
            data.idleCount,
            AppConstants.chartOrange,
          ),
          _buildCircularIndicator(
            AppStrings.ignitionOn,
            data.ignitionOnCount,
            AppConstants.chartGreen,
          ),
          _buildCircularIndicator(
            AppStrings.ignitionOff,
            data.ignitionOffCount,
            AppConstants.chartRed,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(String label, int value, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / 10000,
                strokeWidth: 4,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalDistanceCard(VehicleDataResponse data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: AppConstants.warningColor,
            size: AppConstants.iconSize,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            '${AppStrings.totalDistance} ${data.totalDistance} ${AppStrings.kms}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDropdown(VehicleDataResponse data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.vehicleNumber,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppConstants.textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 150),
        painter: _LineChartPainter(),
      ),
    );
  }

  Widget _buildDistanceCards(VehicleDataResponse data) {
    return Row(
      children: [
        Expanded(
          child: _buildDistanceCard(
            AppStrings.todaysDistance,
            '${data.todaysDistance} ${AppStrings.kms}',
            AppConstants.chartOrange,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: _buildDistanceCard(
            AppStrings.yesterdaysDistance,
            '${data.yesterdaysDistance} ${AppStrings.kms}',
            AppConstants.chartGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppConstants.primaryColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();

    // Mock chart data points
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint =
        Paint()
          ..color = AppConstants.primaryColor
          ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
