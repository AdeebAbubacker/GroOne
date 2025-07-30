import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_field.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/common_widgets.dart';
import '../constants/app_constants.dart';
import '../cubit/vehicle_list_cubit.dart';
import 'gps_notification_screen.dart';

class GpsSubscriptionsScreen extends StatefulWidget {
  const GpsSubscriptionsScreen({super.key});

  @override
  State<GpsSubscriptionsScreen> createState() => _GpsSubscriptionsScreenState();
}

class _GpsSubscriptionsScreenState extends State<GpsSubscriptionsScreen> {
  TextEditingController searchController = TextEditingController();
  List<GpsCombinedVehicleData> _allVehicles = [];
  List<GpsCombinedVehicleData> _filteredVehicles = [];

  int? _calculateDaysLeft(String? expiryDate) {
    if (expiryDate == null) return null;
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now).inDays;

      return difference; // May be negative
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.mySubscriptions,
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              final vehicleListCubit = locator<VehicleListCubit>();
              // Only load data if not already loaded
              if (!vehicleListCubit.hasLoadedData) {
                vehicleListCubit.loadVehicleData();
              } else {
                debugPrint(
                  "📍 GpsGeofenceScreen - Vehicle data already loaded, skipping loadVehicleData call",
                );
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
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<VehicleListCubit, VehicleListState>(
        builder: (context, state) {
          _allVehicles = state.vehicleDataState?.data ?? [];

          // _filteredVehicles = _allVehicles.where((vehicle) {
          //   final query = searchController.text.toLowerCase();
          //   final matchesSearch = vehicle.vehicleNumber?.toLowerCase().contains(query) ?? false;
          //   final hasValidDate = vehicle.subscriptionExpiryDate != null;
          //   return matchesSearch && hasValidDate;
          // }).toList();
          _filteredVehicles = _allVehicles
              .where((vehicle) {
            final query = searchController.text.toLowerCase();
            final matchesSearch = vehicle.vehicleNumber?.toLowerCase().contains(query) ?? false;
            final hasValidDate = vehicle.subscriptionExpiryDate != null;
            return matchesSearch && hasValidDate;
          })
              .toList();

// Sort: Expired first, then by ascending days left
          _filteredVehicles.sort((a, b) {
            final aDays = _calculateDaysLeft(a.subscriptionExpiryDate);
            final bDays = _calculateDaysLeft(b.subscriptionExpiryDate);

            if (aDays == null && bDays == null) return 0;
            if (aDays == null) return 1;
            if (bDays == null) return -1;

            if (aDays < 0 && bDays >= 0) return -1;
            if (aDays >= 0 && bDays < 0) return 1;

            return aDays.compareTo(bDays); // ascending
          });



          final expiringCount =
              _allVehicles.where((vehicle) {
                final daysLeft = _calculateDaysLeft(
                  vehicle.subscriptionExpiryDate,
                );
                return daysLeft != null && daysLeft <= 30;
              }).length;

          for(var vehicle in _filteredVehicles){
            debugPrint('Total Vehicles ${_filteredVehicles.length}');
            debugPrint('vehicle: ${vehicle.vehicleNumber}, expiry: ${vehicle.subscriptionExpiryDate}');
          }

          return Column(
            children: [
              if (expiringCount > 0) _buildAlertCard(context, expiringCount),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: AppTextField(
                  decoration: commonInputDecoration(
                    hintText: context.appText.searchVehicle,
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchController,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _filteredVehicles[index];
                    final daysLeft = _calculateDaysLeft(
                      vehicle.subscriptionExpiryDate,
                    );
                    final isInvalidDate = daysLeft == null;
                    final isExpired = daysLeft != null && daysLeft < 0;
                    final isExpiringSoon = daysLeft != null && daysLeft <= 30;

                    return Container(
                      decoration: commonContainerDecoration(),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.1,
                          ),
                          child: SvgPicture.asset(
                            AppIcons.svg.truck,
                            width: 24,
                          ),
                        ),
                        title: Text(
                          vehicle.vehicleNumber ?? '-',
                          style: AppTextStyle.h5,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              (isExpired || isExpiringSoon || isInvalidDate)
                                  ? Icons.warning
                                  : Icons.check,
                              color:
                                  (isExpired || isExpiringSoon || isInvalidDate)
                                      ? AppColors.red
                                      : AppColors.greenColor,
                            ),
                            5.width,
                            Text(
                              isInvalidDate
                                  ? context.appText.notAvailable
                                  : isExpired
                                  ? context.appText.expired
                                  : '$daysLeft ${context.appText.daysLeft}',
                              style: AppTextStyle.body4.copyWith(
                                color:
                                    (isExpired ||
                                            isExpiringSoon ||
                                            isInvalidDate)
                                        ? AppColors.red
                                        : AppColors.greenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColors.lightBlueColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.appText.renewal,
                      style: AppTextStyle.h5PrimaryColor,
                    ),
                    5.height,
                    Text(
                      context.appText.renewDescription,
                      style: AppTextStyle.body,
                    ),
                    15.height,
                    AppButton(
                      onPressed: () {
                        commonSupportDialog(context);
                      },
                      title: context.appText.contactCustomerSupport,
                    ).paddingSymmetric(horizontal: 40, vertical: 15),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, int expiringCount) {
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
                  '$expiringCount ${context.appText.devicesExpiringSoon}!',
                  style: AppTextStyle.h6WhiteColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
