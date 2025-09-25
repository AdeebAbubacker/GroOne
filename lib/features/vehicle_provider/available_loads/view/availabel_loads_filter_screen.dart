import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/ai_chat/model/chat_message.dart';
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
  final LoadData? initialRouteData; // Route data from chat

  const AvailableLoadsFilterScreen({super.key, this.initialRouteData});

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

  final SearchableDropdownController<RouteList> controller =
      SearchableDropdownController();

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
    TruckTypeModel? truckTypeModel,
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
      value:
          '${selectedItem?.fromLocation?.name ?? ""} - ${selectedItem?.toLocation?.name ?? ""}',
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

  /// Handle initial route data from chat
  Future<void> _handleInitialRouteData() async {
    if (widget.initialRouteData?.source == null ||
        widget.initialRouteData?.destination == null) {
      return;
    }

    print('🎯 DEBUG: Handling initial route data from chat');
    print(
      '🎯 DEBUG: Source: ${widget.initialRouteData?.source}, Destination: ${widget.initialRouteData?.destination}',
    );

    // Wait for route data to load
    await Future.delayed(const Duration(milliseconds: 500));

    // Get route data from LpLoadCubit
    final routeState = lpLoadLocator.state.lpLoadRouteDetails;
    final routeList = routeState?.data?.data?.routeList ?? [];

    print('🎯 DEBUG: Available routes count: ${routeList.length}');

    if (routeList.isEmpty) {
      print('🎯 DEBUG: No routes available, loading routes...');
      await lpLoadLocator.getRouteDetails();
      // Retry after loading
      Future.delayed(const Duration(seconds: 1), () {
        _findAndSelectMatchingRoute();
      });
      return;
    }

    _findAndSelectMatchingRoute();
  }

  /// Find and select matching route based on source and destination
  void _findAndSelectMatchingRoute() {
    if (widget.initialRouteData?.source == null ||
        widget.initialRouteData?.destination == null) {
      return;
    }

    final routeState = lpLoadLocator.state.lpLoadRouteDetails;
    final routeList = routeState?.data?.data?.routeList ?? [];

    print(
      '🎯 DEBUG: Finding matching route for "${widget.initialRouteData?.source}" to "${widget.initialRouteData?.destination}"',
    );

    RouteList? matchingRoute;
    try {
      matchingRoute = routeList.firstWhere((route) {
        final fromName = route.fromLocation?.name?.toLowerCase() ?? '';
        final toName = route.toLocation?.name?.toLowerCase() ?? '';
        final sourceLower = widget.initialRouteData!.source!.toLowerCase();
        final destLower = widget.initialRouteData!.destination!.toLowerCase();

        print('🎯 DEBUG: Checking route: "$fromName" to "$toName"');

        // Check for exact match or partial match
        final sourceMatch =
            fromName.contains(sourceLower) ||
            sourceLower.contains(fromName) ||
            _isSimilarLocation(fromName, sourceLower);
        final destMatch =
            toName.contains(destLower) ||
            destLower.contains(toName) ||
            _isSimilarLocation(toName, destLower);

        return sourceMatch && destMatch;
      });

      print(
        '✅ DEBUG: Found matching route: ${matchingRoute.fromLocation?.name} to ${matchingRoute.toLocation?.name}',
      );

      // Set the route data
      setState(() {
        laneId = matchingRoute?.masterLaneId;
        laneDropDownValue = matchingRoute?.masterLaneId.toString();
      });

      // Update the filter cubit
      _getLaneId(matchingRoute);
    } catch (e) {
      print('❌ DEBUG: No matching route found');
    }
  }

  /// Check if two location names are similar (handles common variations)
  bool _isSimilarLocation(String location1, String location2) {
    final variations = {
      'bangalore': ['bengaluru', 'bangaluru'],
      'bengaluru': ['bangalore', 'bangaluru'],
      'bangaluru': ['bangalore', 'bengaluru'],
      'mumbai': ['bombay'],
      'bombay': ['mumbai'],
      'kolkata': ['calcutta'],
      'calcutta': ['kolkata'],
      'chennai': ['madras'],
      'madras': ['chennai'],
      'pune': ['punekar'],
      'delhi': ['new delhi'],
      'new delhi': ['delhi'],
    };

    final loc1 = location1.toLowerCase();
    final loc2 = location2.toLowerCase();

    for (final group in variations.values) {
      if (group.contains(loc1) && group.contains(loc2)) {
        return true;
      }
    }

    return false;
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
                  _getTruckType("${value?.type} ${value?.subType}", value);
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

              // Auto-select route from chat data if available
              if (widget.initialRouteData?.source != null &&
                  widget.initialRouteData?.destination != null &&
                  laneId == null &&
                  routeList.isNotEmpty) {
                _findAndSelectMatchingRoute();
              }

              RouteList? selectedItem = routeList.firstWhereOrNull(
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
                  if (lpLoadLocator.isRoutesLastPage &&
                      page > lpLoadLocator.rootsCurrentPage) {
                    return [];
                  }
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
