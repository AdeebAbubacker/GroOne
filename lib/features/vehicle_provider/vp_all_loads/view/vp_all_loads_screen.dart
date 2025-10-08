import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/ai_chat/model/chat_message.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/view/availabel_loads_filter_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_available_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_my_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/toast_messages.dart';
import '../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../../profile/cubit/profile/profile_cubit.dart';
import '../../../profile/model/profile_detail_model.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import '../bloc/vp_all_loads_bloc.dart';
import '../bloc/vp_all_loads_state.dart';

class VpAllLoadsScreen extends StatefulWidget {
  final int initialTabIndex;
  final LoadData? filterData; // Route data from chat

  const VpAllLoadsScreen({
    super.key,
    this.initialTabIndex = 0,
    this.filterData,
  });

  @override
  State<VpAllLoadsScreen> createState() => _VpAllLoadsScreenState();
}

class _VpAllLoadsScreenState extends BaseState<VpAllLoadsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();
  final ScrollController _loadListScrollController = ScrollController();

  List<LoadStatusResponse> tabLabels = [];

  String profileImage = "";
  final searchController = TextEditingController();
  ProfileDetailModel? profileResponse;
  final lpHomeBloc = locator<LpHomeBloc>();
  final loadFilterCubit = locator<LoadFilterCubit>();
  late VpLoadCubit vpLoadBloc;
  Timer? _debounce;
  StreamSubscription? _vpLoadSub;
  final lpLoadLocator = locator<LpLoadCubit>();

  /// filterContent
  int? commodityID;
  int? leneId;

  int? truckTypeId;
  int? previousFilter;

  // Store last applied filter data to avoid re-applying same filter
  String? _lastAppliedSource;
  String? _lastAppliedDestination;
  int? _lastAppliedRouteId;

  @override
  void initState() {
    super.initState();
    vpLoadBloc = locator<VpLoadCubit>();
    vpLoadBloc.fetchLoadStatus();
    _tabController = TabController(
      length: 0,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _vpLoadSub = vpLoadBloc.stream.listen(_onStatusChanged);
    _loadDataByTab(index: widget.initialTabIndex); // load initial tab
    _getFilterDataEntity();
    _fetchMoreLoads();

    // Auto-apply filter if coming from chat
    if (widget.filterData != null) {
      // Force clear any existing filter state first
      _forceClearFilterState();
      _autoApplyFilterFromChat();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _tabController.dispose();
    _vpLoadSub!.cancel();
    _clearFilter();
    super.dispose();
  }
    /// Updates tab controller when new tab labels arrive
void _updateTabs(List<LoadStatusResponse> newTabs) {
  if (!mounted) return;

  if (!listEquals(tabLabels, newTabs)) {
    tabLabels = newTabs;

    // Dispose old controller
    _tabController.dispose();
    _tabController = TabController(
      length: tabLabels.length,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, tabLabels.length - 1),
    );

    // Add listener to update UI on both tap and swipe
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {}); // refresh TabBar highlight

      // Optional: fetch data only on tab tap (indexIsChanging = true)
      if (!_tabController.indexIsChanging) {
        _loadDataByTab(index: _tabController.index);
      }
    });
   _tabController.addListener(() {
    if (!mounted) return;
    setState(() {}); 
  });
  _tabController.animation!.addListener(() {
    if (!mounted) return;
    setState(() {}); 
  });
  setState(() {}); // rebuild tabs
  }
}

  void _clearFilter() {
    loadFilterCubit.setIsFilterApplied(value: false);
    loadFilterCubit.setLensData(leneId: null, value: null);
    loadFilterCubit.setCommodityData(commodityId: null, value: null);
    loadFilterCubit.setTruckTypeData(truckTypeId: null, value: null);

    commodityID = null;
    leneId = null;
    truckTypeId = null;

    // Clear stored filter data
    _lastAppliedSource = null;
    _lastAppliedDestination = null;
    _lastAppliedRouteId = null;
  }

  /// Force clear all filter state - used when coming from chat screen
  void _forceClearFilterState() {
    // Clear filter variables
    commodityID = null;
    leneId = null;
    truckTypeId = null;

    // Clear stored filter data
    _lastAppliedSource = null;
    _lastAppliedDestination = null;
    _lastAppliedRouteId = null;

    // Clear filter cubit state completely
    loadFilterCubit.setIsFilterApplied(value: false);
    loadFilterCubit.setLensData(leneId: null, value: null);
    loadFilterCubit.setCommodityData(commodityId: null, value: null);
    loadFilterCubit.setTruckTypeData(truckTypeId: null, value: null);

    // Clear search text
    searchController.clear();
  }

   void _onStatusChanged(state) {
    if (!mounted) return;

    final loadStatusState = state.statuses;
    final status = loadStatusState?.status;

    if (status == Status.SUCCESS) {
      final newLength = loadStatusState?.data?.length ?? 0;
      if (_tabController.length != newLength) {
      final newTabs = loadStatusState?.data ?? [];

    // Use the helper method
    _updateTabs(newTabs);

      // Scroll adjustment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabScrollController.positions.isNotEmpty) {
          _tabScrollController.jumpTo(50);
        }
      });
      }}
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final type = _tabController.index + 1;
      vpLoadBloc.fetchVpLoads(
        truckTypeId: truckTypeId,
        landId: leneId,
        isInit: true,
        commodityId: commodityID,
        type: type,
        search: query,
      );
    });
  }

  void _loadDataByTab({required int index, bool forceRefresh = false}) {
    final type = index + 1;
    final search = searchController.text;
    vpLoadBloc.fetchVpLoads(
      truckTypeId: truckTypeId,
      landId: leneId,
      commodityId: commodityID,
      isInit: true,
      type: type,
      search: search,
      forceRefresh: forceRefresh,
    );
    setState(() {});
  }

  Future<void> _onPullToRefresh({
    bool forceRefresh = false,
    bool isInit = true,
  }) async {
    final type = _tabController.index + 1;
    final search = searchController.text;
    vpLoadBloc.fetchVpLoads(
      truckTypeId: truckTypeId,
      landId: leneId,
      commodityId: commodityID,
      isInit: isInit,
      type: type,
      search: search,
      forceRefresh: forceRefresh,
    );
    setState(() {});
  }

  /// Pagination
  void _fetchMoreLoads() {
    _loadListScrollController.addListener(() {
      if (_loadListScrollController.position.pixels >=
          _loadListScrollController.position.maxScrollExtent) {
        _onPullToRefresh(isInit: false);
      }
    });
  }

  Future<void> _getFilterDataEntity() async {
    await Future.wait([
      loadFilterCubit.getAllCommodityState(),
      loadFilterCubit.getAllVehicleType(),
      loadFilterCubit.getPreferLens(),
      lpLoadLocator.getRouteDetails(),
    ]);
  }

  /// Auto-apply filter from chat data without opening filter popup
  Future<void> _autoApplyFilterFromChat() async {
    if (widget.filterData?.source == null ||
        widget.filterData?.destination == null) {
      return;
    }

    // Check if this is the same filter data as last time
    final currentSource = widget.filterData!.source!;
    final currentDestination = widget.filterData!.destination!;
    final currentRouteId = widget.filterData!.routeId;

    if (_lastAppliedSource == currentSource &&
        _lastAppliedDestination == currentDestination &&
        _lastAppliedRouteId == currentRouteId) {
      return;
    }
    // Clear existing filter state first
    _clearFilter();

    // Reset filter variables
    commodityID = null;
    leneId = null;
    truckTypeId = null;

    // Wait for filter state to clear and route data to load
    await Future.delayed(const Duration(milliseconds: 1500));

    // Get route data from ProfileCubit
    final profileCubit = locator<ProfileCubit>();
    final routeList =
        profileCubit.state.profileDetailUIState?.data?.customer?.laneDetails ??
        [];

    if (routeList.isNotEmpty) {
      LaneDetailsResponse? matchingRoute;

      // First priority: Try to match by route ID if available
      if (widget.filterData?.routeId != null) {
        try {
          matchingRoute = routeList.firstWhere((route) {
            return route.masterLaneId == widget.filterData!.routeId;
          });
        } catch (e) {
          if (kDebugMode) {

          }
        }
      }

      // Second priority: Try to match by source and destination text
      if (matchingRoute == null) {
        final searchTerm =
            '${widget.filterData!.source} ${widget.filterData!.destination}';
        final matchingRoutes =
            routeList.where((route) {
              final laneText = route.lane?.toLowerCase() ?? '';
              final searchLower = searchTerm.toLowerCase();
              return laneText.contains(searchLower);
            }).toList();

        if (matchingRoutes.isNotEmpty) {
          matchingRoute = matchingRoutes.first;
        }
      }

      if (matchingRoute != null) {
        // Set the filter parameters
        leneId = matchingRoute.masterLaneId;

        // Mark filter as applied
        loadFilterCubit.setIsFilterApplied(value: true);

        // Update filter cubit
        loadFilterCubit.setLensData(
          leneId: matchingRoute.masterLaneId,
          value: matchingRoute.lane ?? '',
        );

        // Store the applied filter data to avoid re-applying
        _lastAppliedSource = currentSource;
        _lastAppliedDestination = currentDestination;
        _lastAppliedRouteId = currentRouteId;
        // Force UI update to show new filter immediately
        setState(() {});

        // Add a small delay to ensure filter is properly set before refreshing
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            // Refresh loads with applied filter
            _onPullToRefresh(forceRefresh: true);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            20.height,

            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.lightGreyBackgroundColor,
              ),
              padding: EdgeInsets.only(top: 2, bottom: 0, right: 6, left: 6),
              child:
                  (tabLabels.isEmpty)
                      ? const SizedBox(
                        height: 48, // same as TabBar height
                      )
                      : TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        dividerHeight: 0,
                        tabAlignment: TabAlignment.center,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        onTap: (value) {
                          if (value != previousFilter) {
                            _clearFilter();
                          }
                          previousFilter = value;
                        },
                        indicator: const BoxDecoration(),
                        splashFactory: NoSplash.splashFactory,
                        tabs: List.generate(tabLabels.length, (index) {
                          double animationValue =
                          _tabController.animation?.value ?? _tabController.index.toDouble();
                          bool isSelected = (animationValue - index).abs() < 0.5;
                          return Tab(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: commonContainerDecoration(
                                color:
                                    isSelected
                                        ? isSelected == 0
                                            ? AppColors.primaryColor
                                            : VpHelper.getColor(
                                              tabLabels[index].statusBgColor,
                                            )
                                        : Colors.transparent,

                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tabLabels[index].loadStatus,
                                style: AppTextStyle.body3.copyWith(
                                  color:
                                      isSelected
                                          ? isSelected == 0
                                              ? AppColors.white
                                              : VpHelper.getColor(
                                                tabLabels[index].statusTxtColor,
                                              )
                                          : AppColors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
            ).paddingSymmetric(horizontal: commonSafeAreaPadding),

            // Filter
            buildSearchBarAndFilterWidget(context),

            // Tab bar View
            Expanded(
              child:
                  tabLabels.isEmpty
                      ? const SizedBox()
                      : TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
                            bloc: locator<VpAcceptLoadBloc>(),
                            listener: (context, state) {
                              if (state is VpAcceptLoadSuccess) {
                                _loadDataByTab(index: 0, forceRefresh: true);
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (context.mounted) {
                                    AppDialog.show(
                                      context,
                                      child: SuccessDialogView(
                                        message:
                                            context
                                                .appText
                                                .loadAcceptedSuccessfully,
                                        afterDismiss: () {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    );
                                  }
                                });
                              }
                              if (state is VpAcceptLoadError) {
                                ToastMessages.error(
                                  message: getErrorMsg(
                                    errorType: state.errorType,
                                  ),
                                );
                              }
                            },
                            child: buildTab(tabIndex: 0),
                          ),
                          buildTab(tabIndex: 1),
                          buildTab(tabIndex: 2),
                          buildTab(tabIndex: 3),
                          buildTab(tabIndex: 4),
                          buildTab(tabIndex: 5),
                          buildTab(tabIndex: 6),

                          buildTab(tabIndex: 7),
                          buildTab(tabIndex: 8),
                          buildTab(tabIndex: 9, disabledOnTap: true),
                        ],
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: ChatActionButton(),
    );
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            AppSearchBar(
              searchController: searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                searchController.clear();
                _loadDataByTab(index: _tabController.index);
              },
            ).expand(),

            AppIconButton(
              onPressed: () async {
                filterPopUp(context);
              },
              style: AppButtonStyle.primaryIconButtonStyle,
              icon: SvgPicture.asset(
                AppIcons.svg.newFilter,
                width: 20,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            ),
          ],
        ),

        BlocBuilder<LoadFilterCubit, LoadFilterState>(
          buildWhen:
              (previous, current) =>
                  previous.isFilterApplied != current.isFilterApplied,
          builder: (context, state) {
            return Visibility(
              visible: state.isFilterApplied ?? false,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.appText.filterApplied),
                    GestureDetector(
                      onTap: () {
                        _clearFilter();
                        _onPullToRefresh();
                      },
                      child: Icon(Icons.cancel_outlined),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ).paddingOnly(
      left: commonSafeAreaPadding,
      right: commonSafeAreaPadding,
      top: commonSafeAreaPadding,
    );
  }

  Widget buildTab({bool disabledOnTap = false,required int tabIndex}) {
    return BlocBuilder<VpLoadCubit, VpLoadState>(
      bloc: vpLoadBloc,
      builder: (context, state) {
         if (_tabController.index != tabIndex || state.loads?.status == null) {
            return const Center(child: CircularProgressIndicator());
          }

        Status? status = state.loads?.status;
        if (status == Status.LOADING) {
          return const Center(child: CircularProgressIndicator());
        } else if (status == Status.SUCCESS) {
          List<VpRecentLoadData>? recentLoads = state.loads?.data;
          if (recentLoads == null || (recentLoads).isEmpty) {
            _onPullToRefresh;
            return genericErrorWidget(error: NoLoadsFoundError());
          }
          return VpHelper.withRefreshIndicator(
            child: ListView.builder(
              controller: _loadListScrollController,
              padding: EdgeInsets.all(commonSafeAreaPadding),
              shrinkWrap: true,
              itemCount: recentLoads.length,
              itemBuilder: (context, index) {
                if (_tabController.index == 0) {
                  return VpAllLoadAvailableLoadWidget(
                    onBack: () => _onPullToRefresh(),
                    data: recentLoads[index],
                  ).paddingSymmetric(vertical: 7);
                } else if (_tabController.index == 1) {
                  return IgnorePointer(
                    ignoring: disabledOnTap,
                    child: GestureDetector(
                      onTap: () async {
                        await context
                            .push(
                              AppRouteName.loadDetailsScreen,
                              extra: {"loadId": recentLoads[index].id},
                            )
                            .then((value) {
                              _onPullToRefresh();
                            });
                      },
                      child: VpAllLoadMyLoadWidget(
                        onServicesTab: disabledOnTap,
                        data: recentLoads[index],
                        onBack: () {
                          _onPullToRefresh();
                        },
                        onClickAssignDriver: () async {
                          await context
                              .push(
                                AppRouteName.loadDetailsScreen,
                                extra: {"loadId": recentLoads[index].id},
                              )
                              .then((value) {
                                _onPullToRefresh();
                              });
                        },
                      ).paddingSymmetric(vertical: 7),
                    ),
                  );
                } else {
                  return IgnorePointer(
                    ignoring: disabledOnTap,
                    child: GestureDetector(
                      onTap: () async {
                        await context
                            .push(
                              AppRouteName.loadDetailsScreen,
                              extra: {"loadId": recentLoads[index].id},
                            )
                            .then((value) {
                              _onPullToRefresh();
                            });
                      },
                      child: VpAllLoadMyLoadWidget(
                        onServicesTab: disabledOnTap,
                        data: recentLoads[index],

                        showButton: _tabController.index != 3,
                        onBack: () {
                          _onPullToRefresh();
                        },
                        onClickAssignDriver: () async {
                          await context
                              .push(
                                AppRouteName.loadDetailsScreen,
                                extra: {"loadId": recentLoads[index].id},
                              )
                              .then((value) {
                                _onPullToRefresh();
                              });
                        },
                      ).paddingSymmetric(vertical: 7),
                    ),
                  );
                }
              },
            ),
            _onPullToRefresh,
          );
        } else if (status == Status.ERROR) {
          return VpHelper.withSliverRefresh(
            _onPullToRefresh,
            child: Center(
              child: Text(
                getErrorMsg(
                  errorType: state.loads?.errorType ?? GenericError(),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void filterPopUp(BuildContext context) {
    AppDialog.show(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return CommonDialogView(
            crossAxisAlignment: CrossAxisAlignment.start,
            hideCloseButton: true,
            showYesNoButtonButtons: false,
            noButtonText: context.appText.cancel,
            yesButtonText: context.appText.apply,
            child: AvailableLoadsFilterScreen(
              initialRouteData: widget.filterData, // Pass route data from chat
              onFilterApplied: (data) {
                commodityID = data['commodityId'];
                leneId = data['lensType'];
                truckTypeId = data['truckTypeId'];
                _onPullToRefresh();
              },
            ),
          );
        },
      ),
    );
  }
}
