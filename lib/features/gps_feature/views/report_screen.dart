// lib/features/gps_feature/presentation/gps_report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../cubit/report_cubit.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../model/report_model.dart';
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

  Future<void> _pickDateRange(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: fromDate!, end: toDate!),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDateRange != null) {
      setState(() {
        // Set from date to start of day (00:00:00.000)
        fromDate = DateTime(
          newDateRange.start.year,
          newDateRange.start.month,
          newDateRange.start.day,
          0, // hour
          0, // minute
          0, // second
          0, // millisecond
        );
        // Set to date to end of day (23:59:59.999)
        toDate = DateTime(
          newDateRange.end.year,
          newDateRange.end.month,
          newDateRange.end.day,
          23, // hour
          59, // minute
          59, // second
          999, // millisecond
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
        backgroundColor: const Color(0xFFE0E0E0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: const Icon(Icons.arrow_back_ios, color: Colors.green, size: 20),
          titleSpacing: 0,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('v2.6D', style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(width: 8),
              Text('Reports', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.normal)),
            ],
          ),
          actions: [IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.black), onPressed: () => _pickDateRange(context))],
        ),
        body: Column(
          children: [
            _buildFilterSection(),
            Expanded(child: _buildReportBody()),
          ],
        ),
      ),
    ));
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
          color: const Color(0xFFE0E0E0),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFilterCard(
                text: 'Test GPS Login',
                onTap: () async {
                  print("🔍 Testing GPS Login...");
                  final gpsLoginRepository = locator<GpsLoginRepository>();
                  final loginResult = await gpsLoginRepository.login();
                  if (loginResult is Success) {
                    print("  - GPS Login successful!");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('GPS Login successful!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    print("  - GPS Login failed: ${(loginResult as Error).type}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('GPS Login failed: ${(loginResult as Error).type}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                isArrow: true,
              ),
              const SizedBox(height: 12),
              _buildFilterCard(
                text: '${DateFormat('yyyy-MM-dd').format(fromDate!)} - ${DateFormat('yyyy-MM-dd').format(toDate!)}',
                onTap: () => _pickDateRange(context),
              ),
              const SizedBox(height: 12),
              _buildFilterCard(
                text: selectedVehicle?.vehicleNumber ?? 'Select Vehicle',
                onTap: () => _showSelectionSheet<GpsCombinedVehicleData>(
                  context: context,
                  title: 'Select Vehicle',
                  items: state.vehicles,
                  itemTitleBuilder: (vehicle) => vehicle.vehicleNumber ?? 'Unknown',
                  onSelected: (vehicle) => setState(() => selectedVehicle = vehicle),
                ),
                isDropdown: true,
              ),
              const SizedBox(height: 12),
              _buildFilterCard(
                text: selectedReportType.displayName,
                onTap: () => _showSelectionSheet<ReportType>(
                  context: context,
                  title: 'Select Report Type',
                  items: ReportType.values,
                  itemTitleBuilder: (type) => type.displayName,
                  onSelected: (type) => setState(() => selectedReportType = type),
                ),
                isDropdown: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
                        const SnackBar(
                          content: Text('Please select a vehicle first'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.search, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportBody() {
    return Container(
      color: const Color(0xFF0D47A1),
      child: BlocBuilder<GpsReportCubit, GpsReportState>(
        builder: (context, state) {
          print("🔍 Report body state: ${state.reportStatus}");
          print("  - Reports count: ${state.reports.length}");
          print("  - Error message: ${state.errorMessage}");
          
          if (state.reportStatus == GpsDataStatus.loading) {
            print("  - Showing loading indicator");
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (state.reportStatus == GpsDataStatus.error) {
            print("  - Showing error: ${state.errorMessage}");
            return Center(child: Text(state.errorMessage ?? 'An error occurred.', style: const TextStyle(color: Colors.white)));
          }
          if (state.reportStatus == GpsDataStatus.success && state.reports.isEmpty) {
            print("  - Showing no reports found");
            return const Center(child: Text('No reports found for the selected criteria.', style: TextStyle(color: Colors.white)));
          }
          if (state.reportStatus == GpsDataStatus.success) {
            print("  - Showing ${state.reports.length} reports");
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final item = state.reports[index];
                // THIS IS THE FULLY IMPLEMENTED SWITCH
                switch (state.currentReportType) {
                  case ReportType.stops:
                    return StopReportCard(report: item as StopReport);
                  case ReportType.trips:
                    return TripReportCard(
                      report: item as TripReport,
                      addressResponse: context.read<GpsReportCubit>().getAddressForTrip(item.startPositionId),
                    );
                  case ReportType.daily:
                    return SummaryReportCard(report: item as SummaryReport);
                  case ReportType.dailyKm:
                    return DailyDistanceReportCard(report: item as DailyDistanceReport);
                  case ReportType.reachability:
                    return ReachabilityReportCard(report: item as ReachabilityReport);
                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          }
          return const Center(child: Text("Select filters and tap search to begin.", style: TextStyle(color: Colors.white70)));
        },
      ),
    );
  }

  Widget _buildFilterCard({ required String text, required VoidCallback onTap, bool isDropdown = false, bool isArrow = false }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: const TextStyle(fontSize: 16)),
              if (isDropdown) const Icon(Icons.check_box, color: Colors.green),
              if (isArrow) const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
            ],
          ),
        ),
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