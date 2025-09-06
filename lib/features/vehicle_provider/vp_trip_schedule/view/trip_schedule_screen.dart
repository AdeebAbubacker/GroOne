import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/widgets/trip_details.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/searchable_dropdown_menu_item.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';
import 'package:gro_one_app/utils/app_route.dart';
// import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:collection/collection.dart';

class TripScheduleScreen extends StatefulWidget {
  final String? loadId;

  const TripScheduleScreen({super.key, this.loadId});

  @override
  State<TripScheduleScreen> createState() => _TripScheduleScreenState();
}

class _TripScheduleScreenState extends State<TripScheduleScreen> {
  List<VehicleDetail> vehicleDetail = [];
  List<DriverDetails> driverDetails = [];
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final cubit = locator<LoadDetailsCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();

  String? truckType;
  String? driverType;
  List<VehicleDetail> vehicleList = [];

  String? possibleDeliveryDate;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  void clearValues() => frameCallback(() {
    cubit.resetTripScheduleUIState();
  });

  Future onRefresh() async => frameCallback(() => initFunction());

  void initFunction() => frameCallback(() async {
    cubit.resetState();
    String? userId = await vpHomeScreenBloc.getUserId() ?? "0";

    vpHomeScreenBloc.add(VpVehicleListRequested(userId: userId.toString()));
    vpHomeScreenBloc.add(VpDriverDetailsRequested(userId: userId.toString()));
    //  Call your init methods
  });

  Future<void> addVehicleAndDriver(int index) async {
    await Navigator.of(
      context,
    ).push(commonRoute(MasterScreen(initialIndex: index), isForward: true));
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CommonAppBar(
          backgroundColor: AppColors.white,
          title: context.appText.tripScheduling,
        ),
        body: _buildBodyWidget(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      child: SingleChildScrollView(
        child: BlocListener(
          bloc: vpHomeScreenBloc,
          listener: (context, state) {
            if (state is VpVehicleListSuccess) {
              setState(() {
                vehicleDetail =
                    state.vehicleListResponse.data
                        .where((element) => element.status == 1)
                        .toList();
              });
            }
            if (state is VpDriverListSuccess) {
              setState(() {
                driverDetails =
                    state.driverListResponse.data
                        .where((element) => element.driverStatus == 1)
                        .toList();
              });
            }
          },
          child: BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
            bloc: cubit,
            builder: (context, state) {
              LoadDetailModelData? loadDetails =
                  state.loadDetailsUIState?.data?.data;
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    TripDetails(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        truckNoSearchableDropdown(
                          context,
                          truckType,
                          (truckId) {
                            setState(() {
                              truckType = truckId;
                            });
                          },
                          // Paginated fetch function using BLoC
                          (page, searchKey) async {
                            final userId =
                                await vpHomeScreenBloc.getUserId() ?? "0";

                            // Trigger BLoC event to fetch vehicle list
                            vpHomeScreenBloc.add(
                              VpVehicleListRequested(
                                userId: userId,
                                search: searchKey,
                              ),
                            );

                            // Wait for the BLoC to emit success state
                            final completer = Completer<List<VehicleDetail>>();

                            final subscription = vpHomeScreenBloc.stream.listen(
                              (state) {
                                if (state is VpVehicleListSuccess) {
                                  // Filter based on searchKey
                                  final filtered =
                                      state.vehicleListResponse.data
                                          .where(
                                            (v) =>
                                                searchKey == null ||
                                                v.truckNumber
                                                    .toLowerCase()
                                                    .contains(
                                                      searchKey.toLowerCase(),
                                                    ),
                                          )
                                          .toList();
                                  completer.complete(filtered);
                                } else if (state is VpMyLoadListError) {
                                  completer.complete([]);
                                }
                              },
                            );

                            final vehicles = await completer.future;
                            await subscription.cancel();
                            return vehicles;
                          },
                          // Optional: initial selected truck
                          selectedTruck:
                              (() {
                                final currentState = vpHomeScreenBloc.state;
                                if (currentState is VpVehicleListSuccess) {
                                  return currentState.vehicleListResponse.data
                                      .firstWhereOrNull(
                                        (v) => v.id == truckType,
                                      );
                                }
                                return null;
                              })(),
                        ),

                        GestureDetector(
                          onTap: () => addVehicleAndDriver(2),
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline, size: 15),
                              5.width,
                              Text(context.appText.addVehicle),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        driverDropdown(
                          context,
                          driverType,
                          (driverId) {
                            setState(() {
                              driverType = driverId;
                            });
                          },
                          vpHomeScreenBloc,
                          selectedDriver:
                              (() {
                                final currentState = vpHomeScreenBloc.state;
                                if (currentState is VpDriverListSuccess) {
                                  return currentState.driverListResponse.data
                                      .firstWhereOrNull(
                                        (d) => d.driverStatus == driverType,
                                      );
                                }
                                return null;
                              })(),
                        ),

                        GestureDetector(
                          onTap: () => addVehicleAndDriver(3),
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline, size: 15),
                              5.width,
                              Text(context.appText.addDriver),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///Scheduled Pickup Date
                    buildReadOnlyField(
                      context.appText.schedulePickUpDate,
                      DateTimeHelper.formatCustomDate(
                        loadDetails?.pickUpDateTime ?? DateTime.now(),
                      ),
                      fillColor: Color(0xffEBEBEB),
                    ),

                    ///Expected Delivery date
                    buildReadOnlyField(
                      context.appText.expectedDeliveryDate,
                      DateTimeHelper.formatCustomDate(
                        loadDetails?.expectedDeliveryDateTime ?? DateTime.now(),
                      ),
                      fillColor: Color(0xffEBEBEB),
                    ),

                    ///Possible Delivery date
                    InkWell(
                      onTap: () async {
                        final String? date = await commonDatePicker(
                          context,
                          firstDate: loadDetails?.pickUpDateTime?.add(
                            Duration(days: 1),
                          ),
                          initialDate: loadDetails?.pickUpDateTime?.add(
                            Duration(days: 1),
                          ),
                        );
                        if (!context.mounted) return;
                        final String? time = await commonTimePicker(context);

                        if (date != null && time != null) {
                          cubit.updatePossibleDeliveryDateDate("$date, $time");
                          possibleDeliveryDate =
                              DateTimeHelper.convertToApiDateTime(date, time);
                        }
                      },
                      child: buildReadOnlyField(
                        context.appText.possibleDeliveryDate,
                        state.possibleDeliveryDate ?? "Possible Pickup Date",
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),

                    BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
                      listener: (context, state) {
                        if (state.scheduleTripResponse?.status ==
                            Status.SUCCESS) {
                          cubit.acceptLoad(4);
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          isLoading:
                              state.scheduleTripResponse?.status ==
                              Status.LOADING,
                          title: context.appText.scheduleTrip,
                          style: AppButtonStyle.primary.copyWith(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (possibleDeliveryDate == null) {
                                ToastMessages.error(
                                  message:
                                      context
                                          .appText
                                          .possibleDeliveryDateValidation,
                                );
                                return;
                              }

                              String? userId =
                                  await vpHomeScreenBloc.getUserId();
                              cubit.scheduleTripApi(
                                ScheduleTripRequest(
                                  loadId: loadDetails?.loadId ?? "",
                                  expectedDeliveryDate:
                                      loadDetails?.expectedDeliveryDateTime
                                          ?.toString(),
                                  vehicleId: truckType,
                                  driverId: driverType ?? "0",
                                  acceptedBy: userId ?? "",
                                  etaForPickUp:
                                      (loadDetails?.pickUpDateTime.toString() ??
                                              DateTime.now())
                                          .toString(),
                                  possibleDeliveryDate: possibleDeliveryDate,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),

                    10.height,
                  ],
                ).paddingSymmetric(horizontal: 15),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(
    String label,
    String value, {
    Color? fillColor,
    bool mandatoryStar = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyle.textFiled),
            if (mandatoryStar)
              Text(
                " *",
                style: AppTextStyle.textFiled.copyWith(color: Colors.red),
              ),
          ],
        ),
        6.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: commonContainerDecoration(
            color: fillColor ?? AppColors.lightGreyBackgroundColor,
            borderRadius: BorderRadius.circular(commonTexFieldRadius),
            borderColor: AppColors.borderDisableColor,
          ),
          child: Text(value, style: AppTextStyle.textFiled),
        ),
      ],
    );
  }

  static Widget driverDropdown(
    BuildContext context,
    String? selectedDriverId,
    ValueChanged<String?> onDriverChanged,
    // BLoC instance
    VpHomeBloc vpHomeScreenBloc, {
    DriverDetails? selectedDriver,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.appText.driverNameAndNumber,
              style: AppTextStyle.textFiled,
            ),
            const SizedBox(width: 2),
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<DriverDetails>.paginated(
            hintText: Text(
              context.appText.select,
              style: AppTextStyle.textFieldHint,
            ),
            isDialogExpanded: false,
            requestItemCount: 10,

            // Initial selected value
            initialValue:
                selectedDriver != null
                    ? SearchableDropdownMenuItem<DriverDetails>(
                      value: selectedDriver,
                      label: selectedDriver.name,
                      child: Text(selectedDriver.name),
                    )
                    : null,

            // Pagination request
            paginatedRequest: (int page, String? searchKey) async {
              final userId = await vpHomeScreenBloc.getUserId() ?? "0";

              // Trigger BLoC event
              vpHomeScreenBloc.add(
                VpDriverDetailsRequested(userId: userId, search: searchKey),
              );

              // Wait for BLoC to emit success state
              final completer = Completer<List<DriverDetails>>();
              final subscription = vpHomeScreenBloc.stream.listen((state) {
                if (state is VpDriverListSuccess) {
                  final filtered =
                      state.driverListResponse.data
                          .where(
                            (driver) =>
                                searchKey == null ||
                                driver.name.toLowerCase().contains(
                                  searchKey.toLowerCase(),
                                ),
                          )
                          .toList();
                  completer.complete(filtered);
                } else if (state is VpMyLoadListError) {
                  completer.complete([]);
                }
              });

              final drivers = await completer.future;
              await subscription.cancel();
              return drivers.map((driver) {
                final status = driver.activeStatus.trim().toLowerCase();
                final statusLabel =
                    status == "inactive" ? " (On Another Trip)" : "";
                return SearchableDropdownMenuItem<DriverDetails>(
                  value: driver,
                  label: "${driver.name}$statusLabel",
                  child: Text("${driver.name}$statusLabel"),
                );
              }).toList();
            },

            onChanged: (DriverDetails? newDriver) {
              if (newDriver != null) {
                onDriverChanged(newDriver.driverId);
              } else {
                onDriverChanged(null);
              }
            },
          ),
        ),
      ],
    );
  }

  static Widget truckNoSearchableDropdown(
    BuildContext context,
    String? selectedTruckId,
    ValueChanged<String?> onTruckChanged,
    Future<List<VehicleDetail>> Function(int page, String? searchKey)
    fetchTrucks, {
    VehicleDetail? selectedTruck,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.truckNumber, style: AppTextStyle.textFiled),
            const SizedBox(width: 2),
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<VehicleDetail>.paginated(
            hintText: Text(
              context.appText.select,
              style: AppTextStyle.textFieldHint,
            ),
            isDialogExpanded: false,
            requestItemCount: 10,

            // Initial selected value
            initialValue:
                selectedTruck != null
                    ? SearchableDropdownMenuItem<VehicleDetail>(
                      value: selectedTruck,
                      label:
                          "${selectedTruck.truckNumber}${selectedTruck.truckType != null ? ' (${selectedTruck.truckType!.type} ${selectedTruck.truckType!.subType ?? ''})' : ''}",
                      child: Text(
                        "${selectedTruck.truckNumber}${selectedTruck.truckType != null ? ' (${selectedTruck.truckType!.type} ${selectedTruck.truckType!.subType ?? ''})' : ''}",
                      ),
                    )
                    : null,

            // Pagination request
            paginatedRequest: (int page, String? searchKey) async {
              final trucks = await fetchTrucks(page, searchKey);
              return trucks.map((truck) {
                final type = truck.truckType?.type ?? "";
                final subType = truck.truckType?.subType ?? "";
                final typeInfo =
                    (type.isNotEmpty || subType.isNotEmpty)
                        ? " ($type ${subType.isNotEmpty ? subType : ""})"
                        : "";
                return SearchableDropdownMenuItem<VehicleDetail>(
                  value: truck,
                  label: "${truck.truckNumber}$typeInfo",
                  child: Text("${truck.truckNumber}$typeInfo"),
                );
              }).toList();
            },

            onChanged: (VehicleDetail? newTruck) {
              if (newTruck != null) {
                onTruckChanged(newTruck.id);
              } else {
                onTruckChanged(null);
              }
            },
          ),
        ),
      ],
    );
  }
}
