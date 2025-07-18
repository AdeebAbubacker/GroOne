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

class GpsReportScreen extends StatefulWidget {
  const GpsReportScreen({super.key});

  @override
  State<GpsReportScreen> createState() => _GpsReportScreenState();
}

class _GpsReportScreenState extends State<GpsReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  GpsCombinedVehicleData? selectedVehicle;
  ReportType selectedReportType = ReportType.stops;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Set from date to start of day (00:00:00)
    fromDate = DateTime(now.year, now.month, now.day);
    // Set to date to end of day (23:59:59)
    toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  Future<void> _pickFromDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: fromDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDate != null) {
      setState(() {
        fromDate = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          0, 0, 0, 0,
        );
      });
    }
  }

  Future<void> _pickToDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: toDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDate != null) {
      setState(() {
        toDate = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          23, 59, 59, 999,
        );
      });
    }
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
                  // Other Reports functionality
                },
                child: const Text(
                  'Other Reports',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              _buildFilterSection(),
              Expanded(child: _buildReportBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return BlocBuilder<GpsReportCubit, GpsReportState>(
      builder: (context, state) {
        if (state.vehicleStatus == GpsDataStatus.success && selectedVehicle == null && state.vehicles.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedVehicle = state.vehicles.first;
            });
          });
        }
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Date row
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'From Date',
                      date: fromDate!,
                      onTap: () => _pickFromDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: 'To Date',
                      date: toDate!,
                      onTap: () => _pickToDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Vehicle selection
              _buildDropdownField(
                icon: Icons.directions_car,
                text: selectedVehicle?.vehicleNumber ?? 'Select Vehicle',
                onTap: () => _showSelectionSheet<GpsCombinedVehicleData>(
                  context: context,
                  title: 'Select Vehicle',
                  items: state.vehicles,
                  itemTitleBuilder: (vehicle) => vehicle.vehicleNumber ?? 'Unknown',
                  onSelected: (vehicle) => setState(() => selectedVehicle = vehicle),
                ),
              ),
              const SizedBox(height: 16),
              // Report type selection
              _buildDropdownField(
                icon: Icons.assignment,
                text: selectedReportType.displayName,
                onTap: () => _showSelectionSheet<ReportType>(
                  context: context,
                  title: 'Select Report Type',
                  items: ReportType.values,
                  itemTitleBuilder: (type) => type.displayName,
                  onSelected: (type) => setState(() => selectedReportType = type),
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
                    print("🔍 Search button pressed!");
                    print("  - Selected Vehicle: ${selectedVehicle?.vehicleNumber}");
                    print("  - Selected Report Type: $selectedReportType");
                    print("  - From Date: $fromDate");
                    print("  - To Date: $toDate");
                    
                    if (selectedVehicle != null) {
                      print("  - Vehicle ID: ${selectedVehicle!.deviceId}");
                      context.read<GpsReportCubit>().fetchReportData(
                        reportType: selectedReportType,
                        vehicleId: selectedVehicle?.deviceId ?? 0,
                        fromDate: fromDate!,
                        toDate: toDate!,
                      );
                    } else {
                      print("  - No vehicle selected!");
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
                  style:  TextStyle(
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
          border: Border.all(color:AppColors.disableColor),
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
      color: AppColors.white,
      child: BlocBuilder<GpsReportCubit, GpsReportState>(
        builder: (context, state) {
          print("🔍 Report body state: ${state.reportStatus}");
          print("  - Reports count: ${state.reports.length}");
          print("  - Error message: ${state.errorMessage}");
          
          if (state.reportStatus == GpsDataStatus.loading) {
            print("  - Showing loading indicator");
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          }
          if (state.reportStatus == GpsDataStatus.error) {
            print("  - Showing error: ${state.errorMessage}");
            return Center(
              child: Text(
                state.errorMessage ?? 'An error occurred.',
                style:  TextStyle(color: AppColors.grayColor),
              ),
            );
          }
          if (state.reportStatus == GpsDataStatus.success && state.reports.isEmpty) {
            print("  - Showing no reports found");
            return  Center(
              child: Text(
                'No reports found for the selected criteria.',
                style: TextStyle(color: AppColors.grayColor),
              ),
            );
          }
          if (state.reportStatus == GpsDataStatus.success) {
            print("  - Showing ${state.reports.length} reports");
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final item = state.reports[index];
                // THIS IS THE FULLY IMPLEMENTED SWITCH
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ReachabilityReportCard(report: item as ReachabilityReport),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          }
          return  Center(
            child: Text(
              "Select filters and tap 'Show Report' to begin.",
              style: TextStyle(color: AppColors.grayColor),
            ),
          );
        },
      ),
    );
  }
}

// Reusable Selection Sheet Widget
class SelectionSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemTitleBuilder;

  const SelectionSheet({ Key? key, required this.title, required this.items, required this.itemTitleBuilder }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  title: Text(itemTitleBuilder(item), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
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