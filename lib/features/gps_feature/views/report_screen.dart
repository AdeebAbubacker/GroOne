import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dependency_injection/locator.dart';
import '../cubit/report_cubit.dart';
import '../widgets/report_card.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

class GpsReportScreen extends StatefulWidget {
  const GpsReportScreen({super.key});

  @override
  State<GpsReportScreen> createState() => _GpsReportScreenState();
}

class _GpsReportScreenState extends State<GpsReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedVehicle;
  String? selectedTripType;

  final List<String> vehicles = [
    'All Vehicles',
    'Truck 1',
    'Truck 2',
    'Truck 3',
  ];
  final List<String> tripTypes = ['Trips', 'Deliveries', 'Returns'];

  Future<void> pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<GpsReportCubit>()..loadReports(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Other Reports',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => pickDate(isFrom: true),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'From Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text:
                                        fromDate != null
                                            ? DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(fromDate!)
                                            : '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => pickDate(isFrom: false),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'To Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text:
                                        toDate != null
                                            ? DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(toDate!)
                                            : '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdown(
                              labelText: null,
                              hintText: 'Select Vehicle',
                              dropdownValue: selectedVehicle,
                              dropDownList:
                                  vehicles
                                      .map(
                                        (v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(v),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => selectedVehicle = val),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: AppDropdown(
                              labelText: null,
                              hintText: 'Trips',
                              dropdownValue: selectedTripType,
                              dropDownList:
                                  tripTypes
                                      .map(
                                        (v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(v),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => selectedTripType = val),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          title: 'Show Report',
                          onPressed: () {
                            // TODO: Call cubit with filters
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<GpsReportCubit, GpsReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ReportLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.reports.length,
                      itemBuilder: (context, index) {
                        return ReportCard(report: state.reports[index]);
                      },
                    );
                  } else if (state is ReportError) {
                    return Center(child: Text('Error:  {state.message}'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
