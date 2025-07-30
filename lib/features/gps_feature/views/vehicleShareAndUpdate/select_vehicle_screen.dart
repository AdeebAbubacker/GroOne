import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/get_vehicle_extra_info_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_share_helper.dart';

import '../../../../routing/app_route_name.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_search_bar.dart';

class VehicleSelectScreen extends StatefulWidget {
  final int isFromId;

  const VehicleSelectScreen({super.key, required this.isFromId});

  @override
  State<VehicleSelectScreen> createState() => _VehicleSelectScreenState();
}

class _VehicleSelectScreenState extends State<VehicleSelectScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Simple search state variables
  String _searchQuery = '';
  List<GpsCombinedVehicleData> _allVehicles = [];
  List<GpsCombinedVehicleData> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredVehicles =
        _allVehicles.where((vehicle) {
          // Only search by vehicle number
          return _searchQuery.isEmpty ||
              vehicle.vehicleNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
        }).toList();
  }

  void _updateVehicles(List<GpsCombinedVehicleData> vehicles) {
    setState(() {
      _allVehicles = vehicles;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: locator<VehicleListCubit>()..loadVehicleData()..loadOfflineData(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            context.appText.vehicles,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppSearchBar(
                searchController: _searchController,
                onChanged: (text) {
                  setState(() {
                    _searchQuery = text;
                    _applyFilters();
                  });
                },
              ),

              SizedBox(height: AppConstants.defaultPadding),
              Expanded(
                child: BlocBuilder<VehicleListCubit, VehicleListState>(
                  builder: (context, state) {
                    final vehicleCubit = locator<VehicleListCubit>();

                    // Update vehicles when data changes
                    if (state.filteredVehicles.isNotEmpty && _allVehicles.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final vehiclesList = widget.isFromId == 2
                            ? state.filteredVehicles.withExpired
                            : state.filteredVehicles.withoutExpired;
                        _updateVehicles(vehiclesList);
                      });
                    }

                    // Check if offline data is empty and load from API
                    if (state.filteredVehicles.isEmpty && !state.isLoading && state.error == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        vehicleCubit.loadVehicleData();
                      });
                    }

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppConstants.textSecondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.appText.failedToLoadVehicles,
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                vehicleCubit.loadVehicleData();
                              },
                              child: Text(context.appText.retry),
                            ),
                          ],
                        ),
                      );
                    }

                    // Use filtered vehicles from our local state
                    // final vehiclesToShow =
                    //     _filteredVehicles.isNotEmpty ? _filteredVehicles : state.filteredVehicles;

                    final vehiclesToShow =
                    _searchQuery.isNotEmpty ? _filteredVehicles : (
                        widget.isFromId == 2
                            ? state.filteredVehicles.withExpired
                            : state.filteredVehicles.withoutExpired
                    );


                    if (vehiclesToShow.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_outlined,
                              size: 64,
                              color: AppConstants.textSecondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.appText.noVehiclesFound,
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? context.appText.noVehiclesMatchSearch
                                  : context.appText.noVehiclesFound,
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _applyFilters();
                                  });
                                },
                                child: Text(context.appText.clearSearch),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: vehiclesToShow.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehiclesToShow[index];
                        return VehicleCard(vehicle: vehicle, isFromId: widget.isFromId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final GpsCombinedVehicleData vehicle;
  final int isFromId;

  const VehicleCard({super.key, required this.vehicle, required this.isFromId});

  void _handleEditVehicle(BuildContext context) async {
    try {
      final cubit = locator<GpsVehicleExtraInfoCubit>();

      await cubit.getVehicleExtraInfo();

      if (context.mounted) {
        context.push(
          AppRouteName.gpsEditVehicleInfo,
          extra: {'vehicle': vehicle, 'vehicleExtraInfo': cubit.state.gpsVehicleInfoState},
        );
      }
    } catch (e) {
      CustomLog.error(this, e.toString(), e);
    }
  }

  Future<void> showSetSpeedLimitDialog(
    BuildContext context, {
    required GpsCombinedVehicleData vehicle,
    required bool initialEnabled,
    required String initialValue,
    required void Function(bool enabled, String speed) onApply,
  }) async {
    bool isEnabled = initialEnabled;
    TextEditingController controller = TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFFFF3E0),
                            child: Icon(Icons.speed, color: Color(0xFFFF9800)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.appText.setSpeedLimit,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            onChanged: (val) => setState(() => isEnabled = val),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (isEnabled) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(context.appText.enterSpeedLimit, style: TextStyle(fontSize: 15)),
                        ),
                        SizedBox(height: 8),
                        AppTextField(controller: controller, keyboardType: TextInputType.number),
                        SizedBox(height: 20),
                      ],
                      Row(
                        children: [
                          AppButton(
                            onPressed: () => Navigator.pop(context),
                            title: context.appText.cancel,
                            style: AppButtonStyle.outline,
                          ).expand(),
                          20.width,
                          AppButton(
                            onPressed: () async {
                              if (isEnabled) {
                                final speed = controller.text.trim();
                                final speedValue = double.tryParse(speed) ?? 0;
                                if (speed.isEmpty || speedValue <= 0 || speedValue >= 201) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.appText.enterValidSpeed)),
                                    );
                                  }
                                  return;
                                }
                                await sendOverSpeedCommand(
                                  context: context,
                                  enabled: true,
                                  speed: speed,
                                  deviceId: vehicle.deviceId!,
                                  token: AppConstants.token!,
                                );
                              } else {
                                await sendOverSpeedCommand(
                                  context: context,
                                  enabled: false,
                                  speed: "0",
                                  deviceId: vehicle.deviceId!,
                                  token: AppConstants.token!,
                                );
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            title: context.appText.apply,
                            style: AppButtonStyle.primary,
                          ).expand(),
                        ],
                      ),
                    ],
                  ),
            ),
          ),
        );
      },
    );
  }

  Future<void> sendOverSpeedCommand({
    required BuildContext context,
    required bool enabled,
    required String speed,
    required int deviceId,
    required String token,
  }) async {
    try {
      final repository = locator<GpsVehicleExtraInfoRepository>();
      final result = await repository.updateSpeedLimit(
        token: token,
        deviceId: deviceId,
        enabled: enabled,
        speed: speed,
      );

      if (context.mounted) {
        if (result is Success<bool>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.appText.speedLimitUpdatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.appText.speedLimitUpdateFailed), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showShareBottomSheet(BuildContext context) {
    AppShareHelper.showVehicleShareWidget(
      context: context,
      vehicleNumber: vehicle.vehicleNumber ?? '',
      location: vehicle.location,
      lastUpdate: vehicle.lastUpdate,
      deviceId: vehicle.deviceId,
      token: AppConstants.token,
      onLiveLocationShare: (token, deviceId, vehicleNumber, isLiveLocation, hours) async {
        try {
          final repository = locator<GpsVehicleExtraInfoRepository>();
          final result = await repository.shareVehicleLocation(
            token: token,
            deviceId: deviceId,
            vehicleNumber: vehicleNumber,
            isLiveLocation: isLiveLocation,
            hours: hours,
            location: vehicle.location ?? '',
            lastUpdate: vehicle.lastUpdate,
          );
          if (context.mounted) {
            if (result is Success<String>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result.value), backgroundColor: Colors.green),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(context.appText.multipleSharingFailed), backgroundColor: Colors.red),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(context.appText.multipleSharingFailed), backgroundColor: Colors.red),
            );
          }
        }
      },
      onCurrentLocationShare: (vehicleNumber, location, lastUpdate) async {
        try {
          final repository = locator<GpsVehicleExtraInfoRepository>();
          final result = await repository.shareVehicleLocation(
            token: AppConstants.token ?? '',
            deviceId: vehicle.deviceId!,
            vehicleNumber: vehicleNumber,
            isLiveLocation: false,
            hours: 0,
            location: location,
            lastUpdate: lastUpdate,
          );
          if (context.mounted) {
            if (result is Success<String>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result.value), backgroundColor: Colors.green),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text(context.appText.noLocationToShare),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No location data available for sharing'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.local_shipping_outlined, color: AppColors.primaryColor),
          ),
          title: Row(
            children: [
              Text(vehicle.vehicleNumber!, style: const TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(width: AppConstants.smallPadding),
              Icon(Icons.verified, color: Colors.green),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFromId == 1 ? Icons.share : Icons.arrow_forward_ios_outlined,
                size: isFromId == 1 ? 24 : 16,
                color: isFromId == 1 ? Colors.blue : Colors.black,
              ),
            ],
          ),
          onTap: () {
            if (isFromId == 0) {
              showSetSpeedLimitDialog(
                context,
                vehicle: vehicle,
                initialEnabled: true,
                initialValue: '',
                onApply: (enabled, speed) {
                  // Your logic here
                },
              );
            } else if (isFromId == 1) {
              _showShareBottomSheet(context);
            } else if (isFromId == 2) {
              _handleEditVehicle(context);
            }
          },
        ),
      ),
    );
  }
}
