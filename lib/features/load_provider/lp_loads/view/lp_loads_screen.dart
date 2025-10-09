import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_load_card_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/routes_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/trucktype_dropdown.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/nullable_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class LpLoadsScreen extends StatefulWidget {
  const LpLoadsScreen({super.key});

  @override
  State<LpLoadsScreen> createState() => _LpLoadsScreenState();
}

class _LpLoadsScreenState extends State<LpLoadsScreen>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final loadPostedDateController = TextEditingController();
  Timer? _debounce;
  final lpLoadLocator = locator<LpLoadCubit>();
  String? truckTypeDropDownValue;
  int? selectedTruckTypeId;
  String? routeDropDownValue;
  int? selectedRoute;
  final ScrollController _listController = ScrollController();
  int page = 1;
  late LpLoadPaginationController paginationController;
  final analytics = locator<AnalyticsService>();

  TabController? _tabController;
  List<LoadStatusResponse> tabLabels = [];
  @override
  void initState() {
    super.initState();
    initFunction();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    lpLoadLocator.setIsFilterApplied(value: false);
    analytics.logEvent(AnalyticEventName.LP_MY_LOAD);
    lpLoadLocator.updateSelectedTabIndex(0);
    paginationController = lpLoadLocator.paginationController;
    await lpLoadLocator.getLoadStatus();

    final tabs = lpLoadLocator.state.loadStatus?.data ?? [];
    tabLabels = tabs;
     void _onTabChanged(int tabIndex) {
  paginationController.reset();
  clearAllFilterValues();
  searchController.clear();
  FocusManager.instance.primaryFocus?.unfocus();

  lpLoadLocator.updateSelectedTabIndex(tabIndex);

  final loadStatus =
      tabLabels[tabIndex].id == 1 ? null : tabLabels[tabIndex].id;

  lpLoadLocator.getLpLoadsByType(
    loadListApiRequest: LoadListApiRequest(
      loadStatus: loadStatus,
      page: paginationController.currentPage,
    ),
  );
}
    _tabController?.dispose(); 
    if (tabs.isNotEmpty) {
    _tabController?.dispose();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: lpLoadLocator.state.selectedTabIndex.clamp(0, tabs.length - 1),
    )..addListener(() {
      if (!_tabController!.indexIsChanging) {
        _onTabChanged(_tabController!.index);
      }
    });
    }
   
  _tabController!.addListener(() {
  if (!_tabController!.indexIsChanging) {
    _onTabChanged(_tabController!.index);
    }
  });

    // Removed unused _tabScrollController.jumpTo(50) call
    // The _tabScrollController is not attached to any scrollable widget

    lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest());
    lpLoadLocator.getTruckType();
    lpLoadLocator.getRouteDetails();
    _tabController?.animation!.addListener(() {
    setState(() {}); 
   });
    setState(() {});
  });
  
  
  void _handleTabChange() {
    if (!_tabController!.indexIsChanging) return;

    paginationController.reset();
    clearAllFilterValues();
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    final selectedType = _tabController!.index;
    lpLoadLocator.updateSelectedTabIndex(selectedType);

    final loadStatus =
        tabLabels[selectedType].id == 1 ? null : tabLabels[selectedType].id;

    lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
        loadStatus: loadStatus,
        page: paginationController.currentPage,
      ),
    );

    _scrollToSelectedTab(selectedType);
  }

  void fetchNextPage() async {
    paginationController.isFetchingMore = true;
    setState(() {});

    final selectedType = _tabController!.index;
    final loadStatus =
        tabLabels[selectedType].id == 1 ? null : tabLabels[selectedType].id;

    await lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
        loadStatus: loadStatus,
        page: paginationController.currentPage + 1,
      ),
      isNextPage: true,
    );

    // Update pagination state from API response
    final pageMeta = lpLoadLocator.state.lpLoadResponse?.data?.pageMeta;
    if (pageMeta != null) {
      paginationController.updatePageMeta(pageMeta);
    }

    paginationController.isFetchingMore = false;
  }

  void _scrollToSelectedTab(int index) {
    // Tab scrolling is handled by the TabController itself
    // No additional scroll controller needed for the TabBar
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final selectedType = _tabController!.index;
      final loadStatus =
          tabLabels[selectedType].id == 1 ? null : tabLabels[selectedType].id;
      lpLoadLocator.getLpLoadsByType(
        loadListApiRequest: LoadListApiRequest(
          loadStatus: loadStatus,
          search: query,
        ),
      );
    });
  }

  void disposeFunction() => frameCallback(() {
    searchController.dispose();
    _debounce?.cancel();
    _tabController?.dispose();
  });
  
     void _onTabChanged(int tabIndex) {
    paginationController.reset();
    clearAllFilterValues();
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    lpLoadLocator.updateSelectedTabIndex(tabIndex);

    final loadStatus =
        tabLabels[tabIndex].id == 1 ? null : tabLabels[tabIndex].id;

    lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
        loadStatus: loadStatus,
        page: paginationController.currentPage,
      ),
    );
  }
   
  void filterPopUp() {
    var loadStatusType = lpLoadLocator.state.selectedTabIndex;
    AppDialog.show(
      context,
      child: StatefulBuilder(
          builder: (context, setState) {
            return CommonDialogView(
              crossAxisAlignment: CrossAxisAlignment.start,
              hideCloseButton: true,
              showYesNoButtonButtons: true,
              noButtonText: context.appText.cancel,
              yesButtonText: context.appText.apply,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appText.filter,
                    style: AppTextStyle.body1.copyWith(fontSize: 20),
                  ),
                  10.height,                  
                BlocBuilder<LoadFilterCubit, LoadFilterState>(
                builder: (context, state) {
                final uiState = state.truckTypeUIState;
                final truckTypeList = uiState?.data ?? [];

                return VehicleTypeSearchableDropdown(
                  labelText: context.appText.vehicleType,
                  hintText: context.appText.selectVehicleType,
                  fetchVehicleTypes: () async {

                    await context.read<LoadFilterCubit>().getAllVehicleType();
                    return context
                            .read<LoadFilterCubit>()
                            .state
                            .truckTypeUIState
                            ?.data ??
                        [];
                  },
                  selectedVehicleType: truckTypeList.firstWhereOrNull(
                    (t) => t.id.toString() == truckTypeDropDownValue,
                  ),
                  onChanged: (TruckTypeModel? value) {
                    setState(() {
                      truckTypeDropDownValue = value?.id.toString();
                      selectedTruckTypeId = value?.id;
                    });
                  },
                  mandatoryStar: false,
                    );
                   },
                 ),
                  15.height,
                  BlocBuilder<LpLoadCubit, LpLoadState>(
                    builder: (context, state) {
                      final uiState = state.lpLoadRouteDetails;
                      final routeList = uiState?.data?.data?.routeList ?? [];

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
                          return lpLoadLocator
                              .state
                              .lpLoadRouteDetails
                              ?.data
                              ?.data
                              ?.routeList ??
                              [];
                        },
                        selectedRoute: routeList.firstWhereOrNull(
                              (r) => r.masterLaneId == selectedRoute,
                        ),
                        onChanged: (RouteList? value) {
                          setState(() {
                            routeDropDownValue = value?.status.toString();
                            selectedRoute = value?.masterLaneId;
                          });
                        },
                        mandatoryStar: false,
                      );
                    },
                  ),

                  15.height,
                  InkWell(
                    onTap: () async {
                      final String? date = await commonDatePicker(
                        context,
                        firstDate: DateTime(2025),
                        lastDate: DateTime.now(),
                        initialDate:
                        DateTimeHelper.convertToDateTimeWithCurrentTime(
                          loadPostedDateController.text,
                        ),
                      );
                      if (date != null) {
                        loadPostedDateController
                            .text =
                            DateTimeHelper.convertToDatabaseFormat2(date);
                        setState(() {});
                      }
                    },
                    child: buildReadOnlyField(
                      context.appText.loadPostedDate,
                      loadPostedDateController.text,
                      fillColor: Colors.white,
                    ),
                    // mandatoryStar: true,
                  ),
                ],
              ),
              onClickYesButton: () {
                if(truckTypeDropDownValue.isNull && routeDropDownValue.isNull && loadPostedDateController.text.isEmpty) {
                  ToastMessages.alert(message: context.appText.pleaseSelectOneFilter);
                } else {
                  lpLoadLocator.setIsFilterApplied(value: true);
                  Navigator.pop(context);
                  lpLoadLocator.getLpLoadsByType(
                    loadListApiRequest: LoadListApiRequest(
                      loadStatus: loadStatusType == 0 ? null : loadStatusType +
                          1,
                      laneId: selectedRoute,
                      truckTypeId: selectedTruckTypeId?.toString(),
                      loadPostDate:
                      loadPostedDateController.text.isEmpty
                          ? null
                          : loadPostedDateController.text,
                    ),
                  );
                }
              },
              onClickNoButton: () {
                Navigator.pop(context);
                lpLoadLocator.getLpLoadsByType(
                  loadListApiRequest: LoadListApiRequest(
                    loadStatus: loadStatusType == 0 ? null : loadStatusType + 1,
                  ),
                );
                clearAllFilterValues();
              },
            );
          }
      ),
    );
  }

  void clearAllFilterValues() {
    lpLoadLocator.setIsFilterApplied(value: false);
    selectedRoute = null;
    routeDropDownValue = null;
    selectedTruckTypeId = null;
    truckTypeDropDownValue = null;
    loadPostedDateController.clear();
  }

  Future<void> _onPullToRefresh() async {
    final selectedType = _tabController!.index;
    final loadStatus =
        tabLabels[selectedType].id == 1 ? null : tabLabels[selectedType].id;
    lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
        search: searchController.text,
        loadStatus: loadStatus,
        page: 1,
        laneId: selectedRoute,
        truckTypeId: selectedTruckTypeId?.toString(),
        loadPostDate:
            loadPostedDateController.text.isEmpty
                ? null
                : loadPostedDateController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: SafeArea(
        child: Column(
          children: [
            buildTabBarWidget(),
            buildSearchBarAndFilterWidget(context),
            buildLoadListWidget(context),
          ],
        ),
      ),
      floatingActionButton: ChatActionButton(),
    );
  }

  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      scrolledUnderElevation: 0,
      leading: Image.asset(
        AppIcons.png.appIcon,
      ).paddingLeft(commonSafeAreaPadding),
      actions: [
        // Notification
        // IconButton(
        //   onPressed: () {},
        //   icon: SvgPicture.asset(
        //     AppIcons.svg.notification,
        //     width: 30,
        //     colorFilter: AppColors.svg(AppColors.black),
        //   ),
        // ),
      ],
    );
  }

  /// Tab Bar
  Widget buildTabBarWidget() {
    if (_tabController == null) {
      return const SizedBox();
    }

    return Container(
      height: 40,
      decoration: commonContainerDecoration(
        color: AppColors.lightGreyBackgroundColor,
      ),
      child: BlocBuilder<LpLoadCubit, LpLoadState>(
        builder: (context, state) {
          final uiState = state.loadStatus;

          if (uiState == null || uiState.status == Status.LOADING) {
            return Container();
          }

          if (uiState.status == Status.ERROR) {
            return Container();
          }

          tabLabels = uiState.data ?? [];
         final List<Color> tabBgColors = tabLabels.map((tab) => LpHomeHelper.getColor(tab.statusBgColor)).toList();
        final List<Color> tabTextColors = tabLabels.map((tab) => LpHomeHelper.getColor(tab.statusTxtColor)).toList();

          return TabBar(
            controller: _tabController!,
            isScrollable: true,
            physics: ClampingScrollPhysics(), // tighter scroll behavior
            indicator: const BoxDecoration(),
            dividerHeight: 0,
            tabAlignment: TabAlignment.center,
            tabs: List.generate(tabLabels.length, (index) {
            var currentIndex = _tabController!.index;
            var animationValue = _tabController?.animation?.value ?? currentIndex.toDouble();
            bool isSelected = (animationValue - index).abs() < 0.3;
            Color bgColor = (index == 0 && isSelected)
                ? AppColors.primaryColor
                : (isSelected ? tabBgColors[index] : Colors.transparent);
            Color textColor = (index == 0 && isSelected)
                ? AppColors.white
                : (isSelected ? tabTextColors[index] : AppColors.black);
                
              return Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: commonContainerDecoration(
                    color:bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tabLabels[index].loadStatus,
                    style: AppTextStyle.body3.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    ).paddingOnly(top: 15, right: 15, left: 15);
  }

  /// Search and Filter
  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AppSearchBar(
              searchController: searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                searchController.clear();
                _onPullToRefresh();
              },
            ).expand(),
            8.width,
            AppIconButton(
              onPressed: filterPopUp,
              style: AppButtonStyle.primaryIconButtonStyle,
              icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
            ),
          ],
        ),
        BlocBuilder<LpLoadCubit, LpLoadState>(
            buildWhen: (previous, current) =>
            previous.isFilterApplied != current.isFilterApplied,
            builder: (context, state) {
              return Visibility(
                visible: lpLoadLocator.state.isFilterApplied ?? false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.appText.filterApplied),
                      GestureDetector(
                        onTap: () {
                          clearAllFilterValues();
                          _onPullToRefresh();
                        },
                        child: Icon(Icons.cancel_outlined),
                      )
                    ],
                  ),
                ),
              );
            })
      ],
    ).paddingOnly(
      left: commonSafeAreaPadding,
      right: commonSafeAreaPadding,
      top: commonSafeAreaPadding,
    );
  }

  /// Load List
Widget buildLoadListWidget(BuildContext context) {
  return Expanded(
    child: BlocBuilder<LpLoadCubit, LpLoadState>(
      builder: (context, state) {
        final tabs = state.loadStatus?.data ?? [];
        if (_tabController == null) return const SizedBox();

        return TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: List.generate(tabs.length, (tabIndex) {
            final tab = tabs[tabIndex]; 

            final loadList = state.lpLoadResponse?.data?.data ?? [];
            if (_tabController?.index != tabIndex) {
            return const Center(child: CircularProgressIndicator());
            }
            if (state.lpLoadResponse?.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.lpLoadResponse?.status == Status.ERROR) {
              return RefreshIndicator(
                onRefresh: _onPullToRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: genericErrorWidget(
                          error: state.lpLoadResponse!.errorType),
                    ),
                  ],
                ),
              );
            }

            if (loadList.isEmpty) {
              return RefreshIndicator(
                onRefresh: _onPullToRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: genericErrorWidget(error: NoLoadsFoundError()),
                    ),
                  ],
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!paginationController.isFetchingMore &&
                    paginationController.hasMorePages &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent) {
                  fetchNextPage();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: _onPullToRefresh,
                child: ListView.builder(
                  controller: _listController,
                  padding: EdgeInsets.all(commonSafeAreaPadding),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      loadList.length + (paginationController.isFetchingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < loadList.length) {
                      final loadItem = loadList[index];
                      return RepaintBoundary(
                        child: GestureDetector(
                          onTap: () {
                            if (tab.loadStatus.toLowerCase() == "unserviced")
                              return;

                            final extra = {"loadId": loadItem.loadId};
                            context
                                .push(
                                  AppRouteName.lpLoadsLocationDetails,
                                  extra: extra,
                                )
                                .then((value) => _onPullToRefresh());
                          },
                          child: LPLoadListBodyWidget(
                            loadItem: loadItem,
                            lpLoadLocator: lpLoadLocator,
                          ).paddingSymmetric(vertical: 7),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            );
          }),
        );
      },
    ),
  );
}
}
