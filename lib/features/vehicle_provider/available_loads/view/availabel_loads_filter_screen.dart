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
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown_controller.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:collection/collection.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class AvailableLoadsFilterScreen extends StatefulWidget {
  final Function(Map<String, dynamic> data) onFilterApplied;
  final LoadData? initialRouteData; // Route data from chat

  const AvailableLoadsFilterScreen({
    super.key,
    required this.onFilterApplied,
    this.initialRouteData,
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
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          print('🚀 DEBUG: Triggering auto-selection from initState');
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

  /// Find and select matching route based on source and destination
  void _findAndSelectMatchingRoute(List<LaneDetailsResponse> routeList) {
    if (widget.initialRouteData?.source == null ||
        widget.initialRouteData?.destination == null) {
      return;
    }

    print(
      '🎯 DEBUG: Finding matching route for "${widget.initialRouteData?.source}" to "${widget.initialRouteData?.destination}"',
    );

    LaneDetailsResponse? matchingRoute;
    try {
      matchingRoute = routeList.firstWhere((route) {
        final laneText = route.lane?.toLowerCase() ?? '';
        final sourceLower = widget.initialRouteData!.source!.toLowerCase();
        final destLower = widget.initialRouteData!.destination!.toLowerCase();

        print('🎯 DEBUG: Checking route: "$laneText"');

        // Check if the lane text contains both source and destination
        // More flexible matching - check for partial matches
        final sourceMatch =
            laneText.contains(sourceLower) ||
            sourceLower.contains(laneText) ||
            _isSimilarLocation(laneText, sourceLower);
        final destMatch =
            laneText.contains(destLower) ||
            destLower.contains(laneText) ||
            _isSimilarLocation(laneText, destLower);

        print('🎯 DEBUG: Source match: $sourceMatch, Dest match: $destMatch');

        return sourceMatch && destMatch;
      });

      print('✅ DEBUG: Found matching route: ${matchingRoute.lane}');

      // Set the route data
      setState(() {
        laneId = matchingRoute?.masterLaneId;
        laneDropDownValue = matchingRoute?.masterLaneId.toString();
      });

      // Update the filter cubit
      _getLaneId(matchingRoute);

      print(
        '✅ DEBUG: Route selected successfully with ID: ${matchingRoute?.masterLaneId}',
      );
    } catch (e) {
      print('❌ DEBUG: No exact matching route found, trying fallback...');

      // Try to find any route that contains either source or destination
      try {
        final fallbackRoute = routeList.firstWhere((route) {
          final laneText = route.lane?.toLowerCase() ?? '';
          final sourceLower = widget.initialRouteData!.source!.toLowerCase();
          final destLower = widget.initialRouteData!.destination!.toLowerCase();

          return laneText.contains(sourceLower) || laneText.contains(destLower);
        });

        print('🔄 DEBUG: Using fallback route: ${fallbackRoute.lane}');
        setState(() {
          laneId = fallbackRoute.masterLaneId;
          laneDropDownValue = fallbackRoute.masterLaneId.toString();
        });
        _getLaneId(fallbackRoute);
      } catch (e2) {
        print('❌ DEBUG: No fallback route found either');
      }
    }
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
      print('⚠️ DEBUG: Route list is empty, retrying in 1 second...');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _triggerAutoSelection();
        }
      });
    }
  }

  /// Auto-select the first matching route based on source and destination
  void _autoSelectFirstMatchingRoute(List<LaneDetailsResponse> routeList) {
    if (widget.initialRouteData?.source == null ||
        widget.initialRouteData?.destination == null) {
      print('❌ DEBUG: No chat data available for auto-selection');
      return;
    }

    print(
      '🎯 DEBUG: Starting auto-selection with ${routeList.length} routes available',
    );
    print(
      '🎯 DEBUG: Chat data - Source: ${widget.initialRouteData!.source}, Destination: ${widget.initialRouteData!.destination}',
    );

    final searchTerm =
        '${widget.initialRouteData!.source} ${widget.initialRouteData!.destination}';
    print('🎯 DEBUG: Searching for routes containing: "$searchTerm"');

    // Find routes that match the search term
    final matchingRoutes =
        routeList.where((route) {
          final laneText = route.lane?.toLowerCase() ?? '';
          final searchLower = searchTerm.toLowerCase();
          final matches = laneText.contains(searchLower);
          if (matches) {
            print(
              '✅ DEBUG: Found matching route: "${route.lane}" (ID: ${route.masterLaneId})',
            );
          }
          return matches;
        }).toList();

    print('🎯 DEBUG: Found ${matchingRoutes.length} matching routes');

    if (matchingRoutes.isNotEmpty) {
      final firstRoute = matchingRoutes.first;
      print(
        '✅ DEBUG: Auto-selecting first route: ${firstRoute.lane} (ID: ${firstRoute.masterLaneId})',
      );

      setState(() {
        laneId = firstRoute.masterLaneId;
        laneDropDownValue = firstRoute.masterLaneId.toString();
      });

      _getLaneId(firstRoute);
      print('✅ DEBUG: Route selection completed, laneId set to: $laneId');

      // Force a rebuild to ensure dropdown shows the selection
      if (mounted) {
        setState(() {});
      }

      // Automatically apply the filter after selection
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          print('🚀 DEBUG: Auto-applying filter with laneId: $laneId');
          widget.onFilterApplied({
            "commodityId": commodityId,
            "truckTypeId": truckTypeId,
            "lensType": laneId,
          });
          Navigator.pop(context);
          filterCubit.setIsFilterApplied(value: true);
        }
      });
    } else {
      print('❌ DEBUG: No matching routes found for: "$searchTerm"');
      print('❌ DEBUG: Available routes:');
      for (final route in routeList.take(5)) {
        print('   - ${route.lane}');
      }
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
                  print(
                    '🎯 DEBUG: Immediate auto-selection: ${firstRoute.lane}',
                  );

                  // Set the selection immediately
                  laneId = firstRoute.masterLaneId;
                  laneDropDownValue = firstRoute.masterLaneId.toString();
                  _getLaneId(firstRoute);

                  // Auto-apply filter after a short delay
                  Future.delayed(const Duration(milliseconds: 300), () {
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
                print(
                  '🎯 DEBUG: Looking for selected item with laneId: $laneId',
                );
                if (selectedItem != null) {
                  print('✅ DEBUG: Found selected item: ${selectedItem.lane}');
                } else {
                  print(
                    '❌ DEBUG: Selected item not found in current route list',
                  );
                }
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
                    print(
                      '🔍 DEBUG: Using chat data as search term: "$searchTerm"',
                    );
                  }

                  // Filter routes based on search term
                  if (searchTerm.isNotEmpty) {
                    final filteredRoutes =
                        routeList.where((route) {
                          final laneText = route.lane?.toLowerCase() ?? '';
                          final searchLower = searchTerm.toLowerCase();
                          return laneText.contains(searchLower);
                        }).toList();

                    print(
                      '🔍 DEBUG: Found ${filteredRoutes.length} matching routes for "$searchTerm"',
                    );
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
                    Navigator.pop(context);
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
