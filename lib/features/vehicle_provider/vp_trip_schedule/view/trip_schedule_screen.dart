import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/cubit/vp_home_cubit.dart';
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
  final profileCubit = locator<ProfileCubit>();

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
    // _addSelfOption();

    //  Call your init methods
  });

  Future<void> addVehicleAndDriver(int index) async {
    await Navigator.of(
      context,
    ).push(commonRoute(MasterScreen(initialIndex: index), isForward: true));
    onRefresh();
  }

  // void _addSelfOption() {
  //   driverDetails.add(
  //     DriverDetails(
  //       self: 1,
  //       name: context.appText.self,
  //       id: profileCubit.state.profileDetailUIState?.data?.customer?.customerId,
  //     ),
  //   );
  // }

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
                    (state.driverListResponse.data
                        .where((element) => element.driverStatus == 1)
                        .toList());

                // // _addSelfOption();
                // driverDetails.sort(
                //   (a, b) => (b.self ?? 0).compareTo(a.self ?? 0),
                // );
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
                          selectedTruck:
                              (() {
                                final currentState =
                                    context.read<VpHomeCubit>().state;
                                return currentState.vehicleUIState?.data?.data
                                    .firstWhereOrNull(
                                      (v) => v.vehicleId == truckType,
                                    );
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
                               if(truckType == null || truckType!.isEmpty){
                                ToastMessages.error(
                                  message: context.appText.vehicleIsRequired,
                                );
                              }
                               if(driverType == null || driverType!.isEmpty){
                                ToastMessages.error(
                                  message: context.appText.driverIsRequired,
                                );
                              }  
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
                                  vehicleId: truckType ,
                                  driverId: driverType ,
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
        BlocBuilder<VpHomeCubit, VpsHomeState>(
          builder: (context, state) {
            return Container(
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
                requestItemCount: 10,
                dialogOffset: 0,
                // Initial selected value
                initialValue:
                    selectedDriver != null
                        ? SearchableDropdownMenuItem<DriverDetails>(
                          value: selectedDriver,
                          label: selectedDriver.name ?? "",
                          child: Text(selectedDriver.name ?? ""),
                        )
                        : null,

                // Pagination / Search
                paginatedRequest: (int page, String? searchKey) async {
                  final cubit = context.read<VpHomeCubit>();

                  // Call API with page + search
                  await cubit.fetchDrivers(
                    search: searchKey,
                    loadMore: page > 1,
                  );

                  final drivers = cubit.state.driverUIState?.data?.data ?? [];

                  return drivers.map((driver) {
                    final status = driver.activeStatus?.trim().toLowerCase();
                    final statusLabel =
                        status == "inactive" ? " (On Another Trip)" : "";
                    return SearchableDropdownMenuItem<DriverDetails>(
                      value: driver,
                      label: "${driver.name}$statusLabel",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(driver.name ?? ""),
                          if (driver.activeStatus?.trim().toLowerCase() ==
                              "inactive")
                            Text(
                              context.appText.onAnotherTrip,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },

                // Handle selection
                onChanged: (DriverDetails? newDriver) {
                  onDriverChanged(newDriver?.driverId);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget truckNoSearchableDropdown(
    BuildContext context,
    String? selectedTruckId,
    ValueChanged<String?> onTruckChanged, {
    VehicleDetail? selectedTruck,
  }) {
    return BlocBuilder<VpHomeCubit, VpsHomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.appText.truckNumber,
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
              child: SearchableDropdown<VehicleDetail>.paginated(
                hintText: Text(
                  context.appText.select,
                  style: AppTextStyle.textFieldHint,
                ),
                isDialogExpanded: false,
                requestItemCount: 10,
                dialogOffset: 0,
                /// Initial selected value
                initialValue:
                    selectedTruck != null
                        ? SearchableDropdownMenuItem<VehicleDetail>(
                          value: selectedTruck,
                          label:
                              "${selectedTruck.truckNo}${selectedTruck.truckType != null ? ' (${selectedTruck.truckType!.type} ${selectedTruck.truckType!.subType})' : ''}",
                          child: Text(
                            "${selectedTruck.truckNo}${selectedTruck.truckType != null ? ' (${selectedTruck.truckType!.type} ${selectedTruck.truckType!.subType})' : ''}",
                          ),
                        )
                        : null,

                /// Fetch trucks via Cubit (with local filtering)
                paginatedRequest: (int page, String? searchKey) async {
                  final cubit = context.read<VpHomeCubit>();

                  // Always fetch from API (with pagination/search if needed)
                  await cubit.fetchVehicles(
                    search: searchKey,
                    loadMore: page > 1,
                  );

                  final trucks = cubit.state.vehicleUIState?.data?.data ?? [];

                  return trucks.map((truck) {
                    final type = truck.truckType?.type ?? "";
                    final subType = truck.truckType?.subType ?? "";
                    final typeInfo =
                        (type.isNotEmpty || subType.isNotEmpty)
                            ? " ($type $subType)"
                            : "";      
                    return SearchableDropdownMenuItem<VehicleDetail>(
                      value: truck,
                      label: "${truck.truckNo}$typeInfo",
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Text("${truck.truckNo}$typeInfo"),
                          if (truck.activeStatus?.trim().toLowerCase() ==
                              "inactive")
                            Text(
                              context.appText.onAnotherTrip,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },

                onChanged: (VehicleDetail? newTruck) {
                  onTruckChanged(newTruck?.vehicleId);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
