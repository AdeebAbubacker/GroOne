// lib/features/gps_feature/presentation/gps_report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../cubit/report_cubit.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../model/report_model.dart';
import '../model/address_model.dart';
import '../repository/gps_login_repository.dart';
import '../widgets/stop_report_card.dart';
import '../widgets/summary_report_card.dart';
import '../widgets/trip_report_card.dart';
import '../widgets/reachability_report_card.dart';
import '../widgets/daily_distance_report_card.dart';
import '../widgets/address_skeleton.dart';
import 'other_reports_webview_screen.dart';

class GpsReportScreen extends StatelessWidget {
  const GpsReportScreen({super.key});

  Future<void> _pickFromDate(BuildContext context) async {
    await context.read<GpsReportCubit>().pickFromDate(context);
  }

  Future<void> _pickToDate(BuildContext context) async {
    await context.read<GpsReportCubit>().pickToDate(context);
  }

  void _showSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) itemTitleBuilder,
    required ValueChanged<T> onSelected,
  }) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SelectionSheet<T>(title: title, items: items, itemTitleBuilder: itemTitleBuilder),
    );
    if (result != null) {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<GpsReportCubit>()..loadInitialData(),
      child: BlocListener<GpsReportCubit, GpsReportState>(
        listener: (context, state) {
          if (state.reportStatus == GpsDataStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Reports',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OtherReportsWebViewScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Other Reports',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor, size: 16),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildFilterSection(),
                _buildReportBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return BlocBuilder<GpsReportCubit, GpsReportState>(
      builder: (context, state) {
        return Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Date row
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'From Date',
                      date: state.fromDate,
                      onTap: () => _pickFromDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: 'To Date',
                      date: state.toDate,
                      onTap: () => _pickToDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Vehicle selection
              _buildDropdownField(
                icon: Icons.directions_car,
                text: state.selectedVehicle?.vehicleNumber ?? 'Select Vehicle',
                onTap: () => _showSelectionSheet<GpsCombinedVehicleData>(
                  context: context,
                  title: 'Select Vehicle',
                  items: state.vehicles,
                  itemTitleBuilder: (vehicle) => vehicle.vehicleNumber ?? 'Unknown',
                  onSelected: (vehicle) => context.read<GpsReportCubit>().selectVehicle(vehicle),
                ),
              ),
              const SizedBox(height: 16),
              // Report type selection
              _buildDropdownField(
                icon: Icons.assignment,
                text: state.selectedReportType.displayName,
                onTap: () => _showSelectionSheet<ReportType>(
                  context: context,
                  title: 'Select Report Type',
                  items: ReportType.values,
                  itemTitleBuilder: (type) => type.displayName,
                  onSelected: (type) => context.read<GpsReportCubit>().selectReportType(type),
                ),
              ),
              const SizedBox(height: 24),
              // Show Report button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (state.selectedVehicle != null) {
                      context.read<GpsReportCubit>().fetchReports();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a vehicle first'),
                          backgroundColor: AppColors.appRedColor,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Show Report',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.disableColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('dd-MM-yyyy').format(date),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.disableColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grayColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportBody() {
    return Container(
      color: AppColors.greyContainerBackgroundColor,
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      child: BlocBuilder<GpsReportCubit, GpsReportState>(
        builder: (context, state) {
          if (state.reportStatus == GpsDataStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          }
          if (state.reportStatus == GpsDataStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'An error occurred.',
                style: TextStyle(color: AppColors.grayColor),
              ),
            );
          }
          if (state.reportStatus == GpsDataStatus.success && state.reports.isEmpty) {
            String emptyMessage;
            switch (state.currentReportType) {
              case ReportType.reachability:
                emptyMessage = 'No reachability alerts found for the selected period.';
                break;
              case ReportType.stops:
                emptyMessage = 'No stops found for the selected period.';
                break;
              case ReportType.trips:
                emptyMessage = 'No trips found for the selected period.';
                break;
              case ReportType.daily:
                emptyMessage = 'No daily summary found for the selected period.';
                break;
              case ReportType.dailyKm:
                emptyMessage = 'No distance data found for the selected period.';
                break;
              default:
                emptyMessage = 'No reports found for the selected period.';
            }
            
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getEmptyStateIcon(state.currentReportType),
                      size: 64,
                      color: AppColors.grayColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.reportStatus == GpsDataStatus.success) {
            // Check if addresses are still loading for report types that need addresses
            bool addressesLoading = false;
            switch (state.currentReportType) {
              case ReportType.stops:
                addressesLoading = state.stopAddressStatus == GpsDataStatus.loading;
                break;
              case ReportType.trips:
                addressesLoading = state.addressStatus == GpsDataStatus.loading;
                break;
              case ReportType.daily:
                addressesLoading = state.summaryAddressStatus == GpsDataStatus.loading;
                break;
              case ReportType.reachability:
                addressesLoading = state.reachabilityAddressStatus == GpsDataStatus.loading;
                break;
              case ReportType.dailyKm:
                // This report type doesn't need addresses
                addressesLoading = false;
                break;
              default:
                addressesLoading = false;
            }

            // Note: Individual cards will show skeleton for addresses if they're still loading

            // Check if address loading failed but still show reports without addresses
            bool addressLoadingFailed = false;
            String? addressErrorMessage;
            switch (state.currentReportType) {
              case ReportType.stops:
                if (state.stopAddressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage = 'Failed to load stop addresses';
                }
                break;
              case ReportType.trips:
                if (state.addressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage = 'Failed to load trip addresses';
                }
                break;
              case ReportType.daily:
                if (state.summaryAddressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage = 'Failed to load summary addresses';
                }
                break;
              case ReportType.reachability:
                if (state.reachabilityAddressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage = 'Failed to load reachability addresses';
                }
                break;
              default:
                break;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show error banner if address loading failed
                if (addressLoadingFailed && addressErrorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            addressErrorMessage!,
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Reports list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.reports.length,
                  itemBuilder: (context, index) {
                final item = state.reports[index];
                // Render different card types based on current report type
                switch (state.currentReportType) {
                  case ReportType.stops:
                    final stopReport = item as StopReport;
                    final stopId = "${stopReport.deviceId}_${stopReport.startTime}";
                    final stopAddressResponse = context.read<GpsReportCubit>().getAddressForStop(stopId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: StopReportCard(
                        report: stopReport,
                        // Convert StopAddressResponse to AddressResponse format for compatibility
                        addressResponse: stopAddressResponse != null 
                          ? AddressResponse(
                              positionId: 0, // Not used for stops
                              deviceId: stopAddressResponse.deviceId,
                              startAddress: stopAddressResponse.address,
                              endAddress: stopAddressResponse.address, // Same address for stops
                            )
                          : null,
                      ),
                    );
                  case ReportType.trips:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TripReportCard(
                        report: item as TripReport,
                        addressResponse: context.read<GpsReportCubit>().getAddressForTrip(item.startPositionId),
                      ),
                    );
                  case ReportType.daily:
                    final summaryReport = item as SummaryReport;
                    final summaryId = "${summaryReport.deviceId}_${summaryReport.startTime}";
                    final summaryAddressResponse = context.read<GpsReportCubit>().getAddressForSummary(summaryId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SummaryReportCard(
                        report: summaryReport,
                        addressResponse: summaryAddressResponse,
                      ),
                    );
                  case ReportType.dailyKm:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DailyDistanceReportCard(report: item as DailyDistanceReport),
                    );
                  case ReportType.reachability:
                    final reachabilityReport = item as ReachabilityReport;
                    final reachabilityId = reachabilityReport.id.toString();
                    final reachabilityAddressResponse = context.read<GpsReportCubit>().getAddressForReachability(reachabilityId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ReachabilityReportCard(
                        report: reachabilityReport,
                        addressResponse: reachabilityAddressResponse,
                      ),
                    );
                                        default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            );
          }
          return Center(
            child: Text(
              "Select filters and tap 'Show Report' to begin.",
              style: TextStyle(color: AppColors.grayColor),
            ),
          );
        },
      ),
    );
  }
  // Helper method to get appropriate icon for empty states
  IconData _getEmptyStateIcon(ReportType? reportType) {
    switch (reportType) {
      case ReportType.reachability:
        return Icons.gps_not_fixed;
      case ReportType.stops:
        return Icons.pause_circle_outline;
      case ReportType.trips:
        return Icons.route;
      case ReportType.daily:
        return Icons.calendar_today;
      case ReportType.dailyKm:
        return Icons.straighten;
      default:
        return Icons.assignment;
    }
  }
}

// Reusable Selection Sheet Widget
class SelectionSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemTitleBuilder;

  const SelectionSheet({
    Key? key,
    required this.title,
    required this.items,
    required this.itemTitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(
                    itemTitleBuilder(item),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}