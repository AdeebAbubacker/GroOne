import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_login_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_mobile_config_model.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_dashboard_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_order_benefits_and_order_list_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_parking_mode_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_settings_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_subscription_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/path_replay_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicle_list_screen.dart';
import 'package:gro_one_app/features/gps_feature/widgets/gps_screen_lifecycle_wrapper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../cubit/gps_settings_cubit/gps_settings_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../repository/gps_repository.dart';
import 'gps_notification_screen.dart';
import '../../../features/login/repository/user_information_repository.dart';
import 'gps_order/gps_models_screen.dart';

class GpsHomeScreen extends StatelessWidget {
  const GpsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GpsScreenLifecycleWrapper(
      screenType: GpsScreenType.home,
      child: _GpsHomeContent(),
    );
  }
}

class _GpsHomeContent extends StatelessWidget {
  void _handleBackNavigation(BuildContext context) {
    // Make navigation synchronous to avoid issues with onLeadingTap
    try {
      _navigateBackSynchronously(context);
    } catch (e) {
      // Fallback: try to pop or navigate to default route
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  void _navigateBackSynchronously(BuildContext context) {
    // Try multiple navigation approaches
    try {
      // First, try to pop
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }

      // If we can't pop, try to navigate to the appropriate dashboard
      _getUserRoleAndNavigate(context);
    } catch (e) {
      // Final fallback: try to go to default route
      try {
        if (context.mounted) {
          context.go(AppRouteName.lpBottomNavigationBar);
        }
      } catch (fallbackError) {
        // Handle fallback error silently
      }
    }
  }

  Future<void> _getUserRoleAndNavigate(BuildContext context) async {
    try {
      final userRepository = locator<UserInformationRepository>();
      final userRole = await userRepository.getUserRole();
      String targetRoute;
      if (userRole == 1 || userRole == 3) {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      } else if (userRole == 2) {
        targetRoute = AppRouteName.vpBottomNavigationBar;
      } else {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      }
      if (context.mounted) {
        context.go(targetRoute);
      }
    } catch (e) {
      // Fallback to default navigation
      if (context.mounted) {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  int? _calculateDaysLeft(String? expiryDate) {
    if (expiryDate == null) return null;
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now).inDays;
      return difference;
    } catch (_) {
      return null;
    }
  }

  Widget _buildExpiryAlert(BuildContext context, int expiringCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(color: AppConstants.warningColor),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppConstants.errorColor, size: 20),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.expiryAlert,
                  style: AppTextStyle.h6.copyWith(color: Colors.red),
                ),
                Text(
                  '$expiringCount ${context.appText.devicesExpiringSoon}',
                  style: AppTextStyle.h6WhiteColor,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                commonRoute(
                  BlocProvider.value(
                    value: locator<VehicleListCubit>()..loadVehicleData(),
                    child: GpsSubscriptionsScreen(),
                  ),
                ),
              );
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GpsLoginCubit gpsLoginCubit = locator<GpsLoginCubit>();

    // Auto-login on widget build only if data hasn't been loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!gpsLoginCubit.hasLoadedData) {
        gpsLoginCubit.loginAndFetchAllData();
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
          bottomNavigationBar: _buildBuyNewGpsButton(context),
          appBar: AppBar(
            backgroundColor: AppConstants.cardColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppConstants.textPrimaryColor,
              ),
              onPressed: () {
                _handleBackNavigation(context);
              },
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
              final vehicleListCubit = locator<VehicleListCubit>();
              final allVehicles =
                  vehicleListCubit.state.vehicleDataState?.data ?? [];

              final expiringCount =
                  allVehicles.where((vehicle) {
                    final daysLeft = _calculateDaysLeft(
                      vehicle.subscriptionExpiryDate,
                    );
                    return daysLeft != null && daysLeft <= 30;
                  }).length;

              return RefreshIndicator(
                onRefresh: () async {
                  // Use the new GPS lifecycle extension
                  await context.gpsManualRefresh();
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
                      if (expiringCount > 0)
                        _buildExpiryAlert(context, expiringCount),
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

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      _MenuItem(
        context.appText.dashboard,
        AppIcons.svg.gpsHomeDashboard,
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
        AppIcons.svg.gpsHomeGeofences,
        AppConstants.primaryColor,
        () {
          context.push(AppRouteName.gpsGeofence);
        },
      ),
      _MenuItem(
        context.appText.vehicleShareUpdate,
        AppIcons.svg.gpsHomeVehicleSharing,
        AppConstants.primaryColor,
        () {
          context.push(AppRouteName.gpsVehicleShareAndUpdate);
        },
      ),
      _MenuItem(
        context.appText.subscription,
        AppIcons.svg.gpsHomeSubscriptions,
        AppConstants.primaryColor,
        () {
          Navigator.push(
            context,
            commonRoute(
              BlocProvider.value(
                value: locator<VehicleListCubit>()..loadVehicleData(),
                child: GpsSubscriptionsScreen(),
              ),
            ),
          );
        },
      ),
      _MenuItem(
        context.appText.settings,
        AppIcons.svg.gpsHomeSettings,
        AppConstants.primaryColor,
        () {
          Navigator.push(
            context,
            commonRoute(
              BlocProvider(
                create: (_) => GpsSettingsCubit(locator<GpsRepository>()),
                child: GpsSettingsScreen(),
              ),
            ),
          );
        },
      ),
      _MenuItem(
        context.appText.reports,
        AppIcons.svg.gpsHomeReports,
        AppConstants.primaryColor,
        () {
          context.push(AppRouteName.gpsReports);
        },
      ),
      _MenuItem(
        context.appText.orders,
        AppIcons.svg.gpsHomeOrders,
        AppConstants.primaryColor,
        () {
          Navigator.push(
            context,
            commonRoute(GpsOrderBenefitsAndOrderListScreen()),
          );
        },
      ),
      _MenuItem(
        context.appText.parking,
        AppIcons.svg.gpsHomeParking,
        AppConstants.primaryColor,
        () {
          Navigator.push(
            context,
            commonRoute(
              BlocProvider.value(
                value: locator<VehicleListCubit>()..loadVehicleData(),
                child: GpsParkingModeScreen(),
              ),
            ),
          );
        },
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
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
              SvgPicture.asset(item.icon, width: 25, height: 25),
              8.height,
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: AppTextStyle.h6,
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
        title: Text(context.appText.trackMyVehicles, style: AppTextStyle.h5),
        // subtitle: Text(
        //   'Tap to view vehicles',
        //   style: const TextStyle(
        //     color: AppConstants.textSecondaryColor,
        //     fontSize: 12,
        //   ),
        // ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: AppConstants.primaryColor,
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
    return AppButton(
      onPressed: () {
        Navigator.push(context, commonRoute(GpsModelsScreen()));
      },
      title: context.appText.buyNewGps,
    ).bottomNavigationPadding();
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
  final String icon;
  final Color color;
  final VoidCallback onTap;

  _MenuItem(this.title, this.icon, this.color, this.onTap);
}
