import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/common_functions.dart';

import '../../../../dependency_injection/locator.dart';
import '../../../../routing/app_route_name.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../constants/app_constants.dart';
import '../../cubit/vehicle_list_cubit.dart';
import '../gps_notification_screen.dart';

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
          AppIconButton(
            onPressed: () {
              final vehicleListCubit = locator<VehicleListCubit>();
              // Only load data if not already loaded
              if (!vehicleListCubit.hasLoadedData) {
                vehicleListCubit.loadVehicleData();
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
          InkWell(
            onTap: () {
              commonSupportDialog(context);
            },
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
                title: context.appText.overSpeedCalibration,
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
                title: context.appText.connectAndShare,
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
                title: context.appText.editVehicleInfo,
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
