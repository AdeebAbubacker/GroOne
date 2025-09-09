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
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/widgets/trip_details.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

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

  void _addSelfOption() {
    driverDetails.add(
      DriverDetails(
        self: 1,
        name: context.appText.self,
        id: profileCubit.state.profileDetailUIState?.data?.customer?.customerId,
      ),
    );
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
                    (state.driverListResponse.data
                        .where((element) => element.status == 1)
                        .toList());

                // _addSelfOption();
                driverDetails.sort(
                  (a, b) => (b.self ?? 0).compareTo(a.self ?? 0),
                );
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
                        truckNoSearchableDropdown(context, truckType, (
                          truckId,
                        ) {
                          setState(() {
                            truckType = truckId;
                          });
                        }, vehicleDetail),

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
                        driverDropdown(context, driverType, (driverId) {
                          setState(() {
                            driverType = driverId;
                          });
                        }, driverDetails),
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
                                  vehicleId: truckType ?? "0",
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

  static Widget truckNoSearchableDropdown(
    BuildContext context,
    String? selectedTruckId,
    ValueChanged<String?> onTruckChanged,
    List<VehicleDetail> vehicleList,
  ) {
    // Build display string with truck type info
    final truckNumbers =
        vehicleList.map((e) {
          final type = e.truckType?.type ?? "";
          final subType = e.truckType?.subType ?? "";
          final typeInfo =
              (type.isNotEmpty || subType.isNotEmpty)
                  ? " ($type ${subType.isNotEmpty ? subType : ""})"
                  : "";
          return "${e.truckNumber}$typeInfo".trim();
        }).toList();

    return SearchableDropdown(
      labelText: context.appText.truckNumber,
      mandatoryStar: true,
      selectedItem:
          selectedTruckId != null
              ? (() {
                final selectedVehicle = vehicleList.firstWhere(
                  (v) => v.id == selectedTruckId,
                );
                final type = selectedVehicle.truckType?.type ?? "";
                final subType = selectedVehicle.truckType?.subType ?? "";
                final typeInfo =
                    (type.isNotEmpty || subType.isNotEmpty)
                        ? " ($type ${subType.isNotEmpty ? subType : ""})"
                        : "";
                return "${selectedVehicle.truckNumber}$typeInfo".trim();
              })()
              : null,
      items: truckNumbers,
      hintText: context.appText.select,
      onChanged: (String? newTruckDisplay) {
        if (newTruckDisplay != null) {
          final selectedVehicle = vehicleList.firstWhere((v) {
            final type = v.truckType?.type ?? "";
            final subType = v.truckType?.subType ?? "";
            final typeInfo =
                (type.isNotEmpty || subType.isNotEmpty)
                    ? " ($type ${subType.isNotEmpty ? subType : ""})"
                    : "";
            return "${v.truckNumber}$typeInfo".trim() == newTruckDisplay;
          });
          onTruckChanged(selectedVehicle.id);
        }
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null || selectedItem.isEmpty) {
          return const SizedBox.shrink();
        }
        return Row(children: [Text(selectedItem)]);
      },
      emptyBuilder:
          (context, _) => const Center(child: Text("No trucks found")),
    );
  }

  static Widget driverDropdown(
    BuildContext context,
    String? selectedDriverId,
    ValueChanged<String?> onDriverChanged,
    List<DriverDetails> driverList,
  ) {
    // Create a list of driver names with status label
    final driverNames =
        driverList.map((driver) {
          final status = (driver.activeStatus??"").trim().toLowerCase();
          final statusLabel = status == "inactive" ? " (On Trip)" : "";
          return "${driver.name}$statusLabel";
        }).toList();

    return SearchableDropdown(
      selectedItem: selectedDriverId != null
          ? driverList.firstWhere((v) => v.id == selectedDriverId).name
          : null,
      items: driverList.map((d) => d.name??"").toList() ,
      hintText: context.appText.selectDriver,
      onChanged: (value) {
        final driver = driverList.firstWhere((d) => d.name == value);
        onDriverChanged(driver.id);
      },
      popupItemBuilder: (context, item, isDisabled, isSelected) {
        final driver = driverList.firstWhere((d) => d.name == item);
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(driver.name??""),
              if (driver.activeStatus?.trim().toLowerCase() == "inactive")
                 Text(
                  context.appText.onAnotherTrip,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
          selected: isSelected,
          enabled: !isDisabled, // 👈 respect disabled state
        );
});
  }
}
