import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_text_field.dart';
import '../../../utils/common_widgets.dart';
import '../cubit/reachability_cubit/reachability_cubit.dart';
import '../model/gps_combined_vehicle_model.dart';
import '../models/reachability_model.dart';
import '../widgets/reachability_map_widget.dart';

class ReachabilityScreen extends StatefulWidget {
  final GpsCombinedVehicleData? preSelectedVehicle;

  const ReachabilityScreen({super.key, this.preSelectedVehicle});

  @override
  State<ReachabilityScreen> createState() => _ReachabilityScreenState();
}

class _ReachabilityScreenState extends State<ReachabilityScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // Autocomplete variables
  List<Map<String, dynamic>> _locationSuggestions = [];
  bool _showSuggestions = false;
  final ApiService _apiService = locator<ApiService>();

  @override
  void initState() {
    super.initState();
    _radiusController.text = '500';
  }

  @override
  void dispose() {
    _locationController.dispose();
    _radiusController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  // Fetch location suggestions
  Future<void> _fetchLocationSuggestions(String query) async {
    if (query.length < 3) {
      setState(() {
        _locationSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    try {
      final result = await _apiService.get(
        ApiUrls.mapAutoComplete,
        queryParams: {"input": query},
      );

      if (result is Success) {
        final data = result.value;
        final predictions = data['predictions'] as List<dynamic>? ?? [];

        setState(() {
          _locationSuggestions =
              predictions.map((prediction) {
                return {
                  'description': prediction['description'] ?? '',
                  'place_id': prediction['place_id'] ?? '',
                  'reference': prediction['reference'] ?? '',
                };
              }).toList();
          _showSuggestions = true;
        });
      }
    } catch (e) {
      setState(() {
        _locationSuggestions = [];
        _showSuggestions = false;
      });
    }
  }

  // Select location from suggestions
  void _selectLocation(Map<String, dynamic> location) {
    setState(() {
      _locationController.text = location['description'];
      _showSuggestions = false;
    });
    context.read<ReachabilityCubit>().setLocationAddress(
      location['description'],
    );
  }

  // Hide suggestions
  void _hideSuggestions() {
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: 'Reachability',
        centreTile: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => locator<ReachabilityCubit>()..initialize(),
        child: BlocConsumer<ReachabilityCubit, ReachabilityState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Reachability configuration created successfully!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return GestureDetector(
              onTap: _hideSuggestions,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoText(context),
                    const SizedBox(height: 20),
                    _buildSelectVehicleSection(context, state),
                    const SizedBox(height: 20),
                    _buildLocationMethodSection(context, state),
                    const SizedBox(height: 20),
                    _buildLocationInputSection(context, state),
                    const SizedBox(height: 20),
                    _buildMapSection(context, state),
                    const SizedBox(height: 20),
                    _buildDateTimeSection(context, state),
                    const SizedBox(height: 20),
                    _buildNotificationSection(context, state),
                    const SizedBox(height: 30),
                    _buildSaveButton(context, state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoText(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'Reachability notification & reports will only be available in the user\'s account that sees it.',
        style: AppTextStyle.body.copyWith(
          color: AppColors.primaryColor,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSelectVehicleSection(
    BuildContext context,
    ReachabilityState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Vehicle',
          style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: commonContainerDecoration(),
          child: DropdownButtonFormField<GpsCombinedVehicleData>(
            value: state.selectedVehicle,
            decoration: commonInputDecoration(hintText: 'Select a vehicle'),
            items:
                state.vehicles.map((vehicle) {
                  return DropdownMenuItem<GpsCombinedVehicleData>(
                    value: vehicle,
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping, size: 20),
                        const SizedBox(width: 8),
                        Text(vehicle.vehicleNumber ?? 'Unknown'),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (vehicle) {
              context.read<ReachabilityCubit>().selectVehicle(vehicle);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMethodSection(
    BuildContext context,
    ReachabilityState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Method',
          style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<LocationMethod>(
                title: const Text('New Location'),
                value: LocationMethod.newLocation,
                groupValue: state.locationMethod,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ReachabilityCubit>().setLocationMethod(value);
                  }
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<LocationMethod>(
                title: const Text('Existing Geofence'),
                value: LocationMethod.existingGeofence,
                groupValue: state.locationMethod,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ReachabilityCubit>().setLocationMethod(value);
                  }
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationInputSection(
    BuildContext context,
    ReachabilityState state,
  ) {
    if (state.locationMethod == LocationMethod.newLocation) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Location',
            style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              AppTextField(
                controller: _locationController,
                decoration: commonInputDecoration(
                  hintText: 'Enter location address',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                onChanged: (value) {
                  context.read<ReachabilityCubit>().setLocationAddress(value);
                  _fetchLocationSuggestions(value);
                },
              ),
              // Location suggestions dropdown
              if (_showSuggestions && _locationSuggestions.isNotEmpty)
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: commonContainerDecoration(shadow: true),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _locationSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _locationSuggestions[index];
                        return ListTile(
                          title: Text(
                            suggestion['description'],
                            style: AppTextStyle.body,
                          ),
                          onTap: () => _selectLocation(suggestion),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  controller: _radiusController,
                  decoration: commonInputDecoration(
                    hintText: 'Radius',
                    prefixIcon: const Icon(Icons.radio_button_unchecked),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final radius = double.tryParse(value);
                    if (radius != null) {
                      context.read<ReachabilityCubit>().setRadius(radius);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      'Km',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Geofence',
            style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: commonContainerDecoration(),
            child: DropdownButtonFormField<ReachabilityGeofence>(
              value: state.selectedGeofence,
              decoration: commonInputDecoration(
                hintText: 'Select a geofence',
                prefixIcon: const Icon(Icons.location_on),
              ),
              items:
                  state.geofences.map((geofence) {
                    return DropdownMenuItem<ReachabilityGeofence>(
                      value: geofence,
                      child: Text(geofence.name),
                    );
                  }).toList(),
              onChanged: (geofence) {
                context.read<ReachabilityCubit>().selectGeofence(geofence);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMapSection(BuildContext context, ReachabilityState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map',
          style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ReachabilityMapWidget(
              center:
                  state.mapCenter ??
                  const LatLng(12.9716, 77.5946), // Bangalore default
              onLocationSelected: (latLng) {
                context.read<ReachabilityCubit>().setMapCenter(latLng);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(BuildContext context, ReachabilityState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // Date picker
        GestureDetector(
          onTap: () => _selectDate(context, state),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.calendar_today, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      hintText: 'Pick a Date',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    readOnly: true,
                    enabled: false,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Time pickers
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectStartTime(context, state),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.access_time, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _startTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Start Time',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          readOnly: true,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectEndTime(context, state),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.access_time, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _endTimeController,
                          decoration: const InputDecoration(
                            hintText: 'End Time',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          readOnly: true,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    ReachabilityState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get Notified By',
          style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: commonContainerDecoration(),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Email'),
                value: state.notificationMethods.contains(
                  NotificationMethod.email,
                ),
                onChanged: (value) {
                  context.read<ReachabilityCubit>().toggleNotificationMethod(
                    NotificationMethod.email,
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('SMS'),
                value: state.notificationMethods.contains(
                  NotificationMethod.sms,
                ),
                onChanged: (value) {
                  context.read<ReachabilityCubit>().toggleNotificationMethod(
                    NotificationMethod.sms,
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Push Notification'),
                value: state.notificationMethods.contains(
                  NotificationMethod.push,
                ),
                onChanged: (value) {
                  context.read<ReachabilityCubit>().toggleNotificationMethod(
                    NotificationMethod.push,
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Web'),
                value: state.notificationMethods.contains(
                  NotificationMethod.web,
                ),
                onChanged: (value) {
                  context.read<ReachabilityCubit>().toggleNotificationMethod(
                    NotificationMethod.web,
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, ReachabilityState state) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed:
            state.isCreating
                ? null
                : () {
                  context.read<ReachabilityCubit>().createReachabilityConfig();
                },
        title: state.isCreating ? 'Creating...' : 'Save',
        isLoading: state.isCreating,
      ),
    );
  }

  // Date selection method
  Future<void> _selectDate(
    BuildContext context,
    ReachabilityState state,
  ) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: state.selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != state.selectedDate) {
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        context.read<ReachabilityCubit>().setSelectedDate(picked);
      }
    } catch (e) {
      print('Error selecting date: $e');
    }
  }

  // Start time selection method
  Future<void> _selectStartTime(
    BuildContext context,
    ReachabilityState state,
  ) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            state.selectedStartTime != null
                ? TimeOfDay.fromDateTime(state.selectedStartTime!)
                : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        _startTimeController.text = picked.format(context);
        final selectedTime = DateTime(
          state.selectedDate?.year ?? DateTime.now().year,
          state.selectedDate?.month ?? DateTime.now().month,
          state.selectedDate?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        context.read<ReachabilityCubit>().setSelectedStartTime(selectedTime);
      }
    } catch (e) {
      print('Error selecting start time: $e');
    }
  }

  // End time selection method
  Future<void> _selectEndTime(
    BuildContext context,
    ReachabilityState state,
  ) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            state.selectedEndTime != null
                ? TimeOfDay.fromDateTime(state.selectedEndTime!)
                : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        _endTimeController.text = picked.format(context);
        final selectedTime = DateTime(
          state.selectedDate?.year ?? DateTime.now().year,
          state.selectedDate?.month ?? DateTime.now().month,
          state.selectedDate?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        context.read<ReachabilityCubit>().setSelectedEndTime(selectedTime);
      }
    } catch (e) {
      print('Error selecting end time: $e');
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reachability Information'),
            content: const Text(
              'Reachability notifications help you track when vehicles reach specific locations or geofences. You can set up notifications for:\n\n'
              '• New locations with custom radius\n'
              '• Existing geofences\n'
              '• Multiple notification methods\n'
              '• Date and time preferences',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
