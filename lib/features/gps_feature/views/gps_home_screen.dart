import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_login_cubit.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_dashboard_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicle_list_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_image.dart';

import '../../../utils/app_route.dart';
import '../cubit/vehicle_list_cubit.dart';

class GpsHomeScreen extends StatelessWidget {
  const GpsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GpsLoginCubit gpsLoginCubit = locator<GpsLoginCubit>();

    // Auto-login on widget build only if data hasn't been loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!gpsLoginCubit.hasLoadedData) {
        gpsLoginCubit.loginAndFetchAllData();
      } else {
        print("🚀 GpsHomeScreen - Data already loaded, skipping login call");
      }
    });

    return BlocProvider.value(
      value: gpsLoginCubit,
      child: BlocListener<GpsLoginCubit, GpsLoginState>(
        listener: (context, state) {
          // Only show snackbars for errors during initial load, not success messages
          if (state.loginState?.status == Status.ERROR) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'GPS Login failed: ${state.loginState?.errorType?.toString() ?? 'Unknown error'}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.dataFetchState?.status == Status.ERROR) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Data fetch failed: ${state.dataFetchState?.errorType?.toString() ?? 'Unknown error'}',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        child: Scaffold(
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
              context.appText.gpsHome,
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
                onTap: () {
                  // TODO: Implement customer care bottom sheet
                },
                child: Image.asset(
                  AppImage.png.customerSupport,
                  height: 32,
                  width: 32,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: BlocBuilder<GpsLoginCubit, GpsLoginState>(
            builder: (context, state) {
              // Only show loading overlay during manual refresh, not initial silent load
              final isLoading =
                  false; // Disable loading overlay for initial load

              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      print("🔄 GpsHomeScreen - Pull to refresh triggered");
                      await gpsLoginCubit.refreshData();
                      // Show success message for manual refresh
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('GPS data refreshed successfully!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Alert Card (expiring soon)
                          _buildAlertCard(context),
                          // Main content
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                AppConstants.defaultPadding,
                              ),
                              child: Column(
                                children: [
                                  _buildMenuGrid(context),
                                  const SizedBox(
                                    height: AppConstants.defaultPadding,
                                  ),
                                  _buildTrackVehiclesCard(context),
                                ],
                              ),
                            ),
                          ),
                          // Bottom banner
                          _buildBottomBannerImageWidget(),
                          // Buy New GPS button
                          _buildBuyNewGpsButton(context),
                        ],
                      ),
                    ),
                  ),
                  // Loading overlay
                  if (isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading GPS data...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(color: AppConstants.warningColor),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppConstants.errorColor, size: 16),
          const SizedBox(width: AppConstants.smallPadding),
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
                  context.appText.devicesExpiringSoon,
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

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      _MenuItem(
        context.appText.dashboard,
        Icons.dashboard_outlined,
        AppConstants.primaryColor,
        () {
          // context.push(AppRouteName.gpsDashboard);
          Navigator.push(
            context,
            commonRoute(
              BlocProvider.value(
                value: locator<VehicleListCubit>()..loadVehicleData(),
                child: GpsDashboardScreen(),
              ),
            ),
          );
        },
      ),
      _MenuItem(
        context.appText.geofence,
        Icons.location_on_outlined,
        AppConstants.primaryColor,
        () {
          context.push(AppRouteName.gpsGeofence);
        },
      ),
      _MenuItem(
        context.appText.foi,
        Icons.my_location_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.immobilise,
        Icons.flash_off_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.vehicleShareUpdate,
        Icons.share_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.subscription,
        Icons.credit_card_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.faq,
        Icons.help_outline,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.settings,
        Icons.settings_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.reports,
        Icons.assessment_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        context.appText.orders,
        Icons.shopping_cart_outlined,
        AppConstants.primaryColor,
        () {},
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuCard(item);
      },
    );
  }

  Widget _buildMenuCard(_MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.lightBlueBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 28, color: item.color),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackVehiclesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.lightBlueBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          context.appText.trackMyVehicles,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          'Tap to view vehicles',
          style: const TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppConstants.textSecondaryColor,
        ),
        onTap: () {
          // Navigate to vehicle list screen
          _navigateToVehicleList(context);
        },
      ),
    );
  }

  Widget _buildBottomBannerImageWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        AppImage.png.signUpBanner,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildBuyNewGpsButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          context.appText.buyNewGps,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToVehicleList(BuildContext context) {
    // Navigate to vehicle list screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehicleListScreen()),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _MenuItem(this.title, this.icon, this.color, this.onTap);
}
