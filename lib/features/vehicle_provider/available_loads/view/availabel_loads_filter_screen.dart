

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/routes_dropdown.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown_controller.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:collection/collection.dart';

class AvailableLoadsFilterScreen extends StatefulWidget {
  const AvailableLoadsFilterScreen({super.key});

  @override
  State<AvailableLoadsFilterScreen> createState() =>
      _AvailableLoadsFilterScreenState();
}

class _AvailableLoadsFilterScreenState
    extends State<AvailableLoadsFilterScreen> {
  final formKey = GlobalKey<FormState>();

  String? vehicleTypeDownValue;
  String? laneDropDownValue;
  String? loadTypeDropDownValue;

  final ScrollController scrollController = ScrollController();
  final lpLoadLocator = locator<LpLoadCubit>();
  final filterCubit = locator<LoadFilterCubit>();

  final SearchableDropdownController<RouteList> controller=SearchableDropdownController();

  /// Selected Data

  int? truckTypeId;
  int? laneId;
  int? commodityId;
  List<Item> preferLanesModel = [];

  @override
  void initState() {
    _setInitialFilterData();

    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  check() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {}
    });
  }

  void disposeFunction() => frameCallback(() {});

  void _getTruckType(
      String? selectedTruckType,
      TruckTypeModel? truckTypeModel
  ) {
    truckTypeId = truckTypeModel?.id;
    filterCubit.setTruckTypeData(
      truckTypeId: truckTypeModel?.id,
      value: selectedTruckType,
    );
  }

  void _getLaneId(RouteList? selectedItem) {
    laneId = selectedItem?.masterLaneId;
    filterCubit.setLensData(
      leneId: selectedItem?.masterLaneId,
      value: '${selectedItem?.fromLocation?.name ?? ""} - ${selectedItem?.toLocation?.name ?? ""}',
    );
  }

  void _getCommodity(LoadCommodityListModel? loadType, String? value) {
    commodityId = loadType?.id;
    filterCubit.setCommodityData(commodityId: loadType?.id, value: value);
  }

  Future<void> _setInitialFilterData() async {

    if (filterCubit.state.isFilterApplied == false) {
      return;
    }

    vehicleTypeDownValue = filterCubit.state.selectedTruckType?['value'];
    truckTypeId = filterCubit.state.selectedTruckType?['id'];


    laneDropDownValue = filterCubit.state.selectedLaneType?['value'];
    laneId = filterCubit.state.selectedLaneType?['id'];


    loadTypeDropDownValue = filterCubit.state.selectedCommodity?['value'];
    commodityId = filterCubit.state.selectedCommodity?['id'];



  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.filter,
      isCloseButton: false,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Vehicle Type
          BlocBuilder<LoadFilterCubit, LoadFilterState>(
            builder: (context, state) {
              final uiState = state.truckTypeUIState;
              final truckTypeList = uiState?.data ?? [];

              return VehicleTypeSearchableDropdown(
                labelText: context.appText.vehicleType,
                hintText: context.appText.selectVehicleType,
                fetchVehicleTypes: () async {
                  return truckTypeList;
                },
                selectedVehicleType: truckTypeList.firstWhereOrNull(
                      (t) => t.id == truckTypeId,
                ),
                onChanged: (TruckTypeModel? value) {
                  setState(() {
                    vehicleTypeDownValue = value?.id.toString();
                  });
                  _getTruckType(
                      "${value?.type} ${value?.subType}",
                      value
                  );
                },
                mandatoryStar: false,
              );
            },
          ),

          20.height,

          // Lane Type
          BlocBuilder<LpLoadCubit, LpLoadState>(
            builder: (context, state) {
              final uiState = state.lpLoadRouteDetails;
              final routeList = uiState?.data?.data?.routeList ?? [];
              RouteList? selectedItem=    routeList.firstWhereOrNull(
                    (r) => r.masterLaneId == laneId,
              );
              return RouteSearchableDropdown(
                labelText: context.appText.route,
                hintText: context.appText.searchRoutes,
                fetchRoutes: (page, searchKey) async {
                  await lpLoadLocator.getRouteDetails(
                    search: searchKey,
                    loadMore: page > 1,
                  );
                  return routeList;
                },
                selectedRoute: selectedItem,
                onChanged: (RouteList? value) {
                  setState(() {
                    laneDropDownValue = value?.masterLaneId.toString();
                    _getLaneId(value);
                  });
                },
                mandatoryStar: false,
              );
            },
          ),

          20.height,

          // Road Type
          BlocBuilder<LoadFilterCubit, LoadFilterState>(
            builder: (context, state) {
              final uiState = state.commodityResponseUIState;
              final loadTypeList = uiState?.data ?? [];

              return LoadTypeSearchableDropdown(
                labelText: context.appText.loadType,
                hintText: context.appText.selectRoadType,
                fetchLoadTypes: (page, searchKey) async {
                  return loadTypeList;
                },

                selectedLoadType: loadTypeList.firstWhereOrNull(
                      (t) => t.id == commodityId,
                ),

                onChanged: (LoadCommodityListModel? value) {
                  setState(() {
                    loadTypeDropDownValue = value?.id.toString();
                  });
                  _getCommodity(value, value?.name ?? '');
                },
              );
            },
          ),

          50.height,
          Row(
            children: [
              // Cancel
              AppButton(
                onPressed: () {
                  filterCubit.setIsFilterApplied(value: false);
                  context.pop();
                },
                title: context.appText.cancel,
                style: AppButtonStyle.outline,
              ).expand(),

              20.width,

              // Apply
              AppButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "commodityId": commodityId,
                    "truckTypeId": truckTypeId,
                    "lensType": laneId,
                  });
                  filterCubit.setIsFilterApplied(value: true);
                },
                title: context.appText.apply,
                style: AppButtonStyle.primary,
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
