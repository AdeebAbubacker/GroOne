// lib/features/gps_feature/views/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:intl/intl.dart';

import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_searchabledropdown.dart';
import '../cubit/report_cubit.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../model/address_model.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../model/report_model.dart';
import '../widgets/daily_distance_report_card.dart';
import '../widgets/reachability_report_card.dart';
import '../widgets/stop_report_card.dart';
import '../widgets/summary_report_card.dart';
import '../widgets/trip_report_card.dart';
import 'other_reports_webview_screen.dart';

class GpsReportScreen extends StatefulWidget {
  final String? preSelectedReportType;
  final dynamic preSelectedVehicle;

  const GpsReportScreen({
    super.key,
    this.preSelectedReportType,
    this.preSelectedVehicle,
  });

  @override
  State<GpsReportScreen> createState() => _GpsReportScreenState();
}

class _GpsReportScreenState extends State<GpsReportScreen> {
  late GpsReportCubit _reportCubit;

  @override
  void initState() {
    super.initState();
    _reportCubit = locator.get<GpsReportCubit>()..loadInitialData();

    // Handle pre-selected values after the cubit is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePreSelectedValues();
    });
  }

  void _handlePreSelectedValues() {
    // Handle pre-selected report type
    if (widget.preSelectedReportType != null) {
      switch (widget.preSelectedReportType!.toLowerCase()) {
        case 'reachability':
          _reportCubit.selectReportType(ReportType.reachability);
          break;
        case 'stops':
          _reportCubit.selectReportType(ReportType.stops);
          break;
        case 'trips':
          _reportCubit.selectReportType(ReportType.trips);
          break;
        case 'daily':
          _reportCubit.selectReportType(ReportType.daily);
          break;
        case 'dailykm':
          _reportCubit.selectReportType(ReportType.dailyKm);
          break;
      }
    }

    // Handle pre-selected vehicle
    if (widget.preSelectedVehicle != null) {
      // Wait for vehicles to load, then select the pre-selected vehicle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = _reportCubit.state;
        if (state.vehicles.isNotEmpty) {
          final vehicle = state.vehicles.firstWhere(
            (v) => v.deviceId == widget.preSelectedVehicle?.deviceId,
            orElse: () => state.vehicles.first,
          );
          _reportCubit.selectVehicle(vehicle);

          // Automatically fetch reachability reports if reachability is pre-selected
          if (widget.preSelectedReportType?.toLowerCase() == 'reachability') {
            _reportCubit.fetchReports();
          }
        }
      });
    }
  }

  Future<void> _pickFromDate(BuildContext context) async {
    await context.read<GpsReportCubit>().pickFromDate(context);
  }

  Future<void> _pickToDate(BuildContext context) async {
    await context.read<GpsReportCubit>().pickToDate(context);
  }

  @override
  void dispose() {
    locator.get<GpsReportCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reportCubit,
      child: BlocListener<GpsReportCubit, GpsReportState>(
        listener: (context, state) {
          if (state.reportStatus == GpsDataStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? context.appText.errorOccurred,
                ),
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
            title: Text(
              context.appText.reports,
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
                child: Text(
                  context.appText.otherReports,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [_buildFilterSection(), _buildReportBody()],
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
                      label: context.appText.fromDate,
                      date: state.fromDate,
                      onTap: () => _pickFromDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: context.appText.toDate,
                      date: state.toDate,
                      onTap: () => _pickToDate(context),
                    ),
                  ),
                ],
              ),
              15.height,
              // Vehicle selection
              BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, vehicleState) {
                  if (vehicleState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState.error != null) {
                    return Center(
                      child: Text(context.appText.errorLoadingVehicles),
                    );
                  } else {
                    // final vehicles = vehicleState.filteredVehicles.withoutExpired;
                    //
                    // if (vehicles.isEmpty) {
                    //   return Text(context.appText.noVehiclesFound);
                    // }

                    final vehicles =
                        vehicleState.filteredVehicles.withoutExpired;

                    if (vehicles.isEmpty) {
                      return Text(context.appText.noVehiclesFound);
                    }

                    final reportCubit = context.read<GpsReportCubit>();
                    final selectedVehicle = reportCubit.state.selectedVehicle;

                    if (selectedVehicle == null) {
                      final firstVehicle = vehicles.first;
                      Future.microtask(() {
                        reportCubit.selectVehicle(firstVehicle);
                      });
                    }
                    return SearchableDropdown(
                      selectedItem: selectedVehicle?.vehicleNumber,
                      items:
                          vehicles.map((v) => v.vehicleNumber ?? '').toList(),
                      hintText: context.appText.selectVehicle,
                      onChanged: (selectedNumber) {
                        final selected = vehicles.firstWhere(
                          (v) => v.vehicleNumber == selectedNumber,
                          orElse: () => vehicles.first,
                        );
                        context.read<GpsReportCubit>().selectVehicle(selected);
                      },
                    );
                  }
                },
              ),
              15.height,
              // Report type selection
              SearchableDropdown(
                selectedItem: state.selectedReportType.displayName,
                items: ReportType.values.map((r) => r.displayName).toList(),
                hintText: context.appText.selectReportType,
                onChanged: (selectedDisplayName) {
                  final selectedType = ReportType.values.firstWhere(
                    (r) => r.displayName == selectedDisplayName,
                    orElse: () => ReportType.values.first,
                  );
                  context.read<GpsReportCubit>().selectReportType(selectedType);
                },
              ),
              25.height,
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
                          content: Text(context.appText.pleaseSelectVehicle),
                          backgroundColor: AppColors.appRedColor,
                        ),
                      );
                    }
                  },
                  child: Text(
                    context.appText.showReport,
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

  Widget _buildReportBody() {
    return Container(
      color: AppColors.greyContainerBackgroundColor,
      constraints: const BoxConstraints(minHeight: 200),
      child: BlocBuilder<GpsReportCubit, GpsReportState>(
        builder: (context, state) {
          if (state.reportStatus == GpsDataStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          if (state.reportStatus == GpsDataStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? context.appText.errorOccurred,
                style: TextStyle(color: AppColors.grayColor),
              ),
            );
          }
          if (state.reportStatus == GpsDataStatus.success &&
              state.reports.isEmpty) {
            String emptyMessage;
            switch (state.currentReportType) {
              case ReportType.reachability:
                emptyMessage = context.appText.noReachabilityAlerts;
                break;
              case ReportType.stops:
                emptyMessage = context.appText.noStopsFound;
                break;
              case ReportType.trips:
                emptyMessage = context.appText.noTripsFound;
                break;
              case ReportType.daily:
                emptyMessage = context.appText.noDailySummary;
                break;
              case ReportType.dailyKm:
                emptyMessage = context.appText.noDistanceData;
                break;
              default:
                emptyMessage = context.appText.noReportsFound;
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
                      color: AppColors.grayColor.withValues(alpha: 0.5),
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
                addressesLoading =
                    state.stopAddressStatus == GpsDataStatus.loading;
                break;
              case ReportType.trips:
                addressesLoading = state.addressStatus == GpsDataStatus.loading;
                break;
              case ReportType.daily:
                addressesLoading =
                    state.summaryAddressStatus == GpsDataStatus.loading;
                break;
              case ReportType.reachability:
                addressesLoading =
                    state.reachabilityAddressStatus == GpsDataStatus.loading;
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
                  addressErrorMessage =
                      context.appText.failedToLoadStopAddresses;
                }
                break;
              case ReportType.trips:
                if (state.addressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage =
                      context.appText.failedToLoadTripAddresses;
                }
                break;
              case ReportType.daily:
                if (state.summaryAddressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage =
                      context.appText.failedToLoadSummaryAddresses;
                }
                break;
              case ReportType.reachability:
                if (state.reachabilityAddressStatus == GpsDataStatus.error) {
                  addressLoadingFailed = true;
                  addressErrorMessage =
                      context.appText.failedToLoadReachabilityAddresses;
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
                        Icon(
                          Icons.warning,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: state.reports.length,
                  itemBuilder: (context, index) {
                    return _buildReportCard(context, state, index);
                  },
                ),
              ],
            );
          }
          return Center(
            child: Text(
              context.appText.selectFiltersHint,
              style: TextStyle(color: AppColors.grayColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    GpsReportState state,
    int index,
  ) {
    final item = state.reports[index];

    switch (state.currentReportType) {
      case ReportType.stops:
        return _buildStopReportCard(context, item as StopReport);
      case ReportType.trips:
        return _buildTripReportCard(context, item as TripReport);
      case ReportType.daily:
        return _buildSummaryReportCard(context, item as SummaryReport);
      case ReportType.dailyKm:
        return _buildDailyDistanceReportCard(item as DailyDistanceReport);
      case ReportType.reachability:
        return _buildReachabilityReportCard(
          context,
          item as ReachabilityReport,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStopReportCard(BuildContext context, StopReport stopReport) {
    final stopId = "${stopReport.deviceId}_${stopReport.startTime}";
    final stopAddressResponse = context
        .read<GpsReportCubit>()
        .getAddressForStop(stopId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StopReportCard(
        report: stopReport,
        addressResponse:
            stopAddressResponse != null
                ? AddressResponse(
                  positionId: 0,
                  deviceId: stopAddressResponse.deviceId,
                  startAddress: stopAddressResponse.address,
                  endAddress: stopAddressResponse.address,
                )
                : null,
      ),
    );
  }

  Widget _buildTripReportCard(BuildContext context, TripReport tripReport) {
    final addressResponse = context.read<GpsReportCubit>().getAddressForTrip(
      tripReport.startPositionId,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TripReportCard(
        report: tripReport,
        addressResponse: addressResponse,
      ),
    );
  }

  Widget _buildSummaryReportCard(
    BuildContext context,
    SummaryReport summaryReport,
  ) {
    final summaryId = "${summaryReport.deviceId}_${summaryReport.startTime}";
    final summaryAddressResponse = context
        .read<GpsReportCubit>()
        .getAddressForSummary(summaryId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SummaryReportCard(
        report: summaryReport,
        addressResponse: summaryAddressResponse,
      ),
    );
  }

  Widget _buildDailyDistanceReportCard(
    DailyDistanceReport dailyDistanceReport,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DailyDistanceReportCard(report: dailyDistanceReport),
    );
  }

  Widget _buildReachabilityReportCard(
    BuildContext context,
    ReachabilityReport reachabilityReport,
  ) {
    final reachabilityId = reachabilityReport.id.toString();
    final reachabilityAddressResponse = context
        .read<GpsReportCubit>()
        .getAddressForReachability(reachabilityId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReachabilityReportCard(
        report: reachabilityReport,
        addressResponse: reachabilityAddressResponse,
      ),
    );
  }

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
