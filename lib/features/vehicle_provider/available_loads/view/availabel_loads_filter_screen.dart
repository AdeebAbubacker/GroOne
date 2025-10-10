import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/ai_chat/model/chat_message.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/routes_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/vp_lans_dropdown.dart'
    hide VehicleTypeSearchableDropdown, LoadTypeSearchableDropdown;
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown_controller.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:collection/collection.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class AvailableLoadsFilterScreen extends StatefulWidget {
  final Function(Map<String, dynamic> data) onFilterApplied;
  final LoadData? initialRouteData; // Route data from chat
  final VoidCallback? onFilterCleared;

  const AvailableLoadsFilterScreen({
    super.key,
    required this.onFilterApplied,
    this.initialRouteData,
    this.onFilterCleared,
  });

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

    // Trigger auto-selection after a delay to ensure data is loaded
    if (widget.initialRouteData?.source != null &&
        widget.initialRouteData?.destination != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _triggerAutoSelection();
        }
      });
    }

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

  void _getLaneId(LaneDetailsResponse? selectedItem) {
    laneId = selectedItem?.masterLaneId;
    filterCubit.setLensData(
      leneId: selectedItem?.masterLaneId,
      value: '${selectedItem?.lane}',
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


  /// Trigger auto-selection when data is available
  void _triggerAutoSelection() {
    // Get the current route data from ProfileCubit
    final profileCubit = locator<ProfileCubit>();
    final routeList =
        profileCubit.state.profileDetailUIState?.data?.customer?.laneDetails ??
        [];

    if (routeList.isNotEmpty) {
      _autoSelectFirstMatchingRoute(routeList);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _triggerAutoSelection();
        }
      }
      );
    }
  }

  /// Auto-select the first matching route based on source and destination
  void _autoSelectFirstMatchingRoute(List<LaneDetailsResponse> routeList) {
    if (widget.initialRouteData?.source == null ||
        widget.initialRouteData?.destination == null) {
      return;
    }
    final searchTerm =
        '${widget.initialRouteData!.source} ${widget.initialRouteData!.destination}';

    // Find routes that match the search term
    final matchingRoutes =
        routeList.where((route) {
          final laneText = route.lane?.toLowerCase() ?? '';
          final searchLower = searchTerm.toLowerCase();
          final matches = laneText.contains(searchLower);
          return matches;
        }).toList();

    if (matchingRoutes.isNotEmpty) {
      final firstRoute = matchingRoutes.first;
      setState(() {
        laneId = firstRoute.masterLaneId;
        laneDropDownValue = firstRoute.masterLaneId.toString();
      });
      _getLaneId(firstRoute);
      // Force a rebuild to ensure dropdown shows the selection
      if (mounted) {
        setState(() {});
      }
      // Automatically apply the filter after selection
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          widget.onFilterApplied({
            "commodityId": commodityId,
            "truckTypeId": truckTypeId,
            "lensType": laneId,
          });
          Navigator.pop(context);
          filterCubit.setIsFilterApplied(value: true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.appText.filter,
          style: AppTextStyle.body1.copyWith(fontSize: 20),
        ),
        _buildBody(context: context),
      ],
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
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final uiState = state.profileDetailUIState;
              final routeList = uiState?.data?.customer?.laneDetails ?? [];

              // Auto-select route from chat data if available
              if (widget.initialRouteData?.source != null &&
                  widget.initialRouteData?.destination != null &&
                  laneId == null &&
                  routeList.isNotEmpty) {
                // Immediate auto-selection within the BlocBuilder
                final searchTerm =
                    '${widget.initialRouteData!.source} ${widget.initialRouteData!.destination}';
                final matchingRoutes =
                    routeList.where((route) {
                      final laneText = route.lane?.toLowerCase() ?? '';
                      final searchLower = searchTerm.toLowerCase();
                      return laneText.contains(searchLower);
                    }).toList();

                if (matchingRoutes.isNotEmpty) {
                  final firstRoute = matchingRoutes.first;
                  // Set the selection immediately
                  laneId = firstRoute.masterLaneId;
                  laneDropDownValue = firstRoute.masterLaneId.toString();
                  _getLaneId(firstRoute);

                  // Auto-apply filter after a short delay
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted) {
                      widget.onFilterApplied({
                        "commodityId": commodityId,
                        "truckTypeId": truckTypeId,
                        "lensType": laneId,
                      });
                      Navigator.pop(context);
                      filterCubit.setIsFilterApplied(value: true);
                    }
                  });
                }
              }

              // Find the selected item and ensure it's visible in the dropdown
              LaneDetailsResponse? selectedItem;
              if (laneId != null) {
                selectedItem = routeList.firstWhereOrNull(
                  (r) => r.masterLaneId == laneId,
                );
              }

              return VpRouteSearchableDropdown(
                labelText: context.appText.route,
                hintText: context.appText.searchRoutes,
                fetchRoutes: (page, searchKey) async {
                  // If we have chat data and no search key, use source + destination as search
                  String searchTerm = searchKey ?? '';
                  if (widget.initialRouteData?.source != null &&
                      widget.initialRouteData?.destination != null &&
                      searchKey == null) {
                    searchTerm =
                        '${widget.initialRouteData!.source} ${widget.initialRouteData!.destination}';
                  }

                  // Filter routes based on search term
                  if (searchTerm.isNotEmpty) {
                    final filteredRoutes =
                        routeList.where((route) {
                          final laneText = route.lane?.toLowerCase() ?? '';
                          final searchLower = searchTerm.toLowerCase();
                          return laneText.contains(searchLower);
                        }).toList();
                    return filteredRoutes;
                  }

                  return routeList;
                },
                selectedRoute: selectedItem,
                onChanged: (LaneDetailsResponse? value) {
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
                  if (widget.onFilterCleared != null) widget.onFilterCleared!();
                  context.pop();
                },
                title: context.appText.cancel,
                style: AppButtonStyle.outline,
              ).expand(),

              20.width,

              // Apply
              AppButton(
                onPressed: () {
                  if (commodityId != null ||
                      truckTypeId != null ||
                      laneId != null) {
                    Map<String, dynamic> body = {
                      "commodityId": commodityId,
                      "truckTypeId": truckTypeId,
                      "lensType": laneId,
                    };

                    widget.onFilterApplied(body);
                    Navigator.pop(navigatorKey.currentContext!);
                    filterCubit.setIsFilterApplied(value: true);
                  } else {
                    ToastMessages.alert(
                      message: context.appText.filterEmptyWarning,
                    );
                  }
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
