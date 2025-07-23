import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

import '../../../../routing/app_route_name.dart';
import '../../../../utils/app_image.dart';
import '../../constants/app_constants.dart';

class VehicleShareUpdateScreen extends StatelessWidget {
  const VehicleShareUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppConstants.textPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.appText.vehicleShareUpdate,
          style: const TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppConstants.textPrimaryColor,
            ),
            onPressed: () {},
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AppImage.png.customerSupport,
                height: 24,
                width: 24,
              ),
            ),
          ),
          SizedBox(width: AppConstants.smallPadding),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              _buildOptionCard(
                context,
                icon: Icons.speed,
                iconBgColor: Colors.orange.shade50,
                iconColor: Colors.orange,
                title: 'Overspeed Calibration',
                onTap: () {
                  context.push(AppRouteName.gpsVehicleSelectScreen,extra: 0);
                },
              ),
              SizedBox(height: AppConstants.smallPadding),
              _buildOptionCard(
                context,
                icon: Icons.share,
                iconBgColor: Colors.blue.shade50,
                iconColor: Colors.blue,
                title: 'Connect & Share',
                onTap: () {
                  context.push(AppRouteName.gpsVehicleSelectScreen,extra: 1);
                },
              ),
              SizedBox(height: AppConstants.smallPadding),
              _buildOptionCard(
                context,
                icon: Icons.directions_car,
                iconBgColor: Colors.green.shade50,
                iconColor: Colors.green,
                title: 'Edit Vehicle Info',
                onTap: () {
                  context.push(AppRouteName.gpsVehicleSelectScreen,extra: 2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
