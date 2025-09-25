import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
import 'package:gro_one_app/features/ai_chat/model/chat_message.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
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
import '../../../load_provider/lp_loads/model/lp_load_route_response.dart';
import '../../../profile/model/profile_detail_model.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import '../bloc/vp_all_loads_bloc.dart';
import '../bloc/vp_all_loads_state.dart';

class VpAllLoadsScreen extends StatefulWidget {
  final int initialTabIndex;
  final LoadData? filterData; // Optional filter data from chat

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
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadDataByTab(index: _tabController.index);
      }
    });

    // Apply filter data from chat if present
    if (widget.filterData != null) {
      _applyFilterFromChat(widget.filterData!);
    }

    _loadDataByTab(index: widget.initialTabIndex); // load initial tab
    _getFilterDataEntity();
    _fetchMoreLoads();
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

  void _clearFilter() {
    loadFilterCubit.setIsFilterApplied(value: false);
    commodityID = null;
    leneId = null;
    truckTypeId = null;
  }

  void _onStatusChanged(state) {
    if (!mounted) return;

    final loadStatusState = state.statuses;
    final status = loadStatusState?.status;

    if (status == Status.SUCCESS) {
      final newLength = loadStatusState?.data?.length ?? 0;
      if (_tabController.length != newLength) {
        _tabController.dispose();
        _tabController = TabController(
          length: newLength,
          vsync: this,
          initialIndex: widget.initialTabIndex,
        );
        _tabController.addListener(() {
          if (_tabController.indexIsChanging) {
            _loadDataByTab(index: _tabController.index);
          }
        });
      }

      if (tabLabels.isEmpty) {
        _loadDataByTab(index: widget.initialTabIndex);
      }

      final newTabs = loadStatusState?.data ?? [];
      if (!listEquals(tabLabels, newTabs)) {
        setState(() {
          tabLabels = newTabs;
        });
      }

      // Scroll adjustment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabScrollController.positions.isNotEmpty) {
          _tabScrollController.jumpTo(50);
        }
      });
    }
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

    print('🔄 DEBUG: _onPullToRefresh called');
    print('🔄 DEBUG: truckTypeId: $truckTypeId');
    print('🔄 DEBUG: landId (leneId): $leneId');
    print('🔄 DEBUG: commodityId: $commodityID');
    print('🔄 DEBUG: search: $search');
    print('🔄 DEBUG: type: $type');
    print('🔄 DEBUG: forceRefresh: $forceRefresh');

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

  /// Apply filter parameters from chat load data
  void _applyFilterFromChat(LoadData loadData) {
    print('🚀 DEBUG: Applying filter from chat');
    print(
      '🚀 DEBUG: Source: ${loadData.source}, Destination: ${loadData.destination}',
    );

    // Set search text based on source and destination
    if (loadData.source != null && loadData.destination != null) {
      searchController.text = '${loadData.source} to ${loadData.destination}';
      print('🚀 DEBUG: Set search text to: ${searchController.text}');

      // Route selection will be handled by the filter screen
    } else if (loadData.source != null) {
      searchController.text = loadData.source!;
      print('🚀 DEBUG: Set search text to: ${searchController.text}');
    } else if (loadData.destination != null) {
      searchController.text = loadData.destination!;
      print('🚀 DEBUG: Set search text to: ${searchController.text}');
    }

    // Mark filter as applied
    loadFilterCubit.setIsFilterApplied(value: true);
    print('🚀 DEBUG: Marked filter as applied');

    // Load initial data with search text
    print(
      '🚀 DEBUG: About to call _onPullToRefresh with search: ${searchController.text}',
    );
    _onPullToRefresh(forceRefresh: true);
  }

  /// Find and set route ID based on source and destination names
  void _findAndSetRouteId(String source, String destination) {
    // Get route data from LpLoadCubit
    final routeState = lpLoadLocator.state.lpLoadRouteDetails;
    final routeList = routeState?.data?.data?.routeList ?? [];

    print('🔍 DEBUG: Looking for route from "$source" to "$destination"');
    print('🔍 DEBUG: Route state: ${routeState?.status}');
    print('🔍 DEBUG: Route data: ${routeState?.data}');
    print('🔍 DEBUG: Available routes count: ${routeList.length}');

    // If no routes available, try to load them
    if (routeList.isEmpty) {
      print('⚠️ DEBUG: No routes available, trying to load routes...');
      lpLoadLocator.getRouteDetails();
      return;
    }

    // Find matching route using firstWhereOrNull or try-catch
    RouteList? matchingRoute;
    try {
      matchingRoute = routeList.firstWhere((route) {
        final fromName = route.fromLocation?.name?.toLowerCase() ?? '';
        final toName = route.toLocation?.name?.toLowerCase() ?? '';
        final sourceLower = source.toLowerCase();
        final destLower = destination.toLowerCase();

        print('🔍 DEBUG: Checking route: "$fromName" to "$toName"');

        // More flexible matching - check for partial matches
        final sourceMatch =
            fromName.contains(sourceLower) ||
            sourceLower.contains(fromName) ||
            _isSimilarLocation(fromName, sourceLower);
        final destMatch =
            toName.contains(destLower) ||
            destLower.contains(toName) ||
            _isSimilarLocation(toName, destLower);

        print('🔍 DEBUG: Source match: $sourceMatch');
        print('🔍 DEBUG: Dest match: $destMatch');

        return sourceMatch && destMatch;
      });
      print(
        '✅ DEBUG: Found matching route: ${matchingRoute.fromLocation?.name} to ${matchingRoute.toLocation?.name}',
      );
    } catch (e) {
      // No matching route found, matchingRoute remains null
      print('❌ DEBUG: No matching route found');
      matchingRoute = null;
    }

    if (matchingRoute != null) {
      // Set the lane ID for filtering
      leneId = matchingRoute.masterLaneId;
      print('✅ DEBUG: Set leneId to: $leneId');

      // Also set the filter in the cubit
      loadFilterCubit.setLensData(
        leneId: matchingRoute.masterLaneId,
        value:
            '${matchingRoute.fromLocation?.name ?? ""} - ${matchingRoute.toLocation?.name ?? ""}',
      );
      print(
        '✅ DEBUG: Set filter cubit with leneId: ${matchingRoute.masterLaneId}',
      );
    }
  }

  /// Check if two location names are similar (handles common variations)
  bool _isSimilarLocation(String location1, String location2) {
    // Common city name variations
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

    // Check if they're in the same variation group
    for (final group in variations.values) {
      if (group.contains(loc1) && group.contains(loc2)) {
        return true;
      }
    }

    return false;
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
                          final isSelected = _tabController.index == index;
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
                        physics: const NeverScrollableScrollPhysics(),
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
                                          if (context.mounted)
                                            Navigator.pop(context);
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
                            child: buildTab(),
                          ),
                          buildTab(),
                          buildTab(),
                          buildTab(),
                          buildTab(),
                          buildTab(),
                          buildTab(),

                          buildTab(),
                          buildTab(),
                          buildTab(disabledOnTap: true),
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
                final data = await commonBottomSheetWithBGBlur(
                  context: context,
                  screen: AvailableLoadsFilterScreen(
                    initialRouteData:
                        widget.filterData, // Pass route data from chat
                  ),
                );

                commodityID = data != null ? data['commodityId'] : null;
                leneId = data != null ? data['lensType'] : null;
                truckTypeId = data != null ? data['truckTypeId'] : null;
                _onPullToRefresh();
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

  Widget buildTab({bool disabledOnTap = false}) {
    return BlocBuilder<VpLoadCubit, VpLoadState>(
      bloc: vpLoadBloc,
      builder: (context, state) {
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
}
