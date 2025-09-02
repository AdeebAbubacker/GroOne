import 'dart:async';

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
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

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
  final ScrollController _tabScrollController = ScrollController();
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

  void initFunction() => frameCallback(() {
    analytics.logEvent(AnalyticEventName.LP_MY_LOAD);
    lpLoadLocator.updateSelectedTabIndex(0);
    paginationController = lpLoadLocator.paginationController;
    _tabController = TabController(
      length: 9,
      vsync: this,
      initialIndex: lpLoadLocator.state.selectedTabIndex,
    )..addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabScrollController.jumpTo(50);
    });

    lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest());
    lpLoadLocator.getTruckType();
    lpLoadLocator.getRouteDetails();
    lpLoadLocator.getLoadStatus();

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
    final double offset = index == 0 ? 50 : (100 * index) - 15;
    _tabScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

  void filterPopUp() {
    var loadStatusType = lpLoadLocator.state.selectedTabIndex;
    AppDialog.show(
      context,
      child: CommonDialogView(
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
            BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadTruckTypes;
                final truckTypes = uiState?.data ?? [];

                return TruckTypeSearchableDropdown(
                  selectedTruckTypeId: selectedTruckTypeId?.toString(),
                  onTruckTypeChanged: (String? idString) {
                    setState(() {
                      selectedTruckTypeId =
                          idString != null ? int.tryParse(idString) : null;
                    });
                  },
                  truckTypeList: truckTypes,
                  labelText: context.appText.truckType,
                  hintText: context.appText.searchTruckTypes,
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
                  routeList: routeList,
                  selectedRouteStatus: routeDropDownValue,
                  onRouteChanged: (RouteList? value) {
                    routeDropDownValue = value?.status.toString();
                    selectedRoute = value?.masterLaneId;
                    setState(() {});
                  },
                );
              },
            ),

            15.height,
            Text(context.appText.loadPostedDate, style: AppTextStyle.body3),
            5.height,
            AppTextField(
              controller: loadPostedDateController,
              decoration: commonInputDecoration(
                suffixIcon: Icon(Icons.calendar_today_outlined),
                suffixOnTap: () async {
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
                        .text = DateTimeHelper.convertToDatabaseFormat2(date);
                    setState(() {});
                  }
                },
              ),
            ),
          ],
        ),
        onClickYesButton: () {
          Navigator.pop(context);
          lpLoadLocator.getLpLoadsByType(
            loadListApiRequest: LoadListApiRequest(
              loadStatus: loadStatusType == 0 ? null : loadStatusType + 1,
              laneId: selectedRoute,
              truckTypeId: selectedTruckTypeId?.toString(),
              loadPostDate: loadPostedDateController.text.isEmpty ? null : loadPostedDateController.text,
            ),
          );
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
      ),
    );
  }

  void clearAllFilterValues() {
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
        loadStatus: loadStatus,
        page: paginationController.currentPage,
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

          return TabBar(
            controller: _tabController!,
            isScrollable: true,
            physics: ClampingScrollPhysics(), // tighter scroll behavior
            indicator: const BoxDecoration(),
            dividerHeight: 0,
            tabAlignment: TabAlignment.center,
            tabs: List.generate(9, (index) {
              final isSelected = state.selectedTabIndex == index;
              return Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: commonContainerDecoration(
                    color:
                        isSelected
                            ? state.selectedTabIndex == 0
                                ? AppColors.primaryColor
                                : LpHomeHelper.getColor(
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
                              ? state.selectedTabIndex == 0
                                  ? AppColors.white
                                  : LpHomeHelper.getColor(
                                    tabLabels[index].statusTxtColor,
                                  )
                              : AppColors.black,
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
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: _onSearchChanged,
        ).expand(),
        8.width,
        AppIconButton(
          onPressed: filterPopUp,
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
        ),
      ],
    ).paddingOnly(
      left: commonSafeAreaPadding,
      right: commonSafeAreaPadding,
      top: commonSafeAreaPadding,
    );
  }

  /// Load List
  Widget buildLoadListWidget(BuildContext context) {
    if (_tabController == null) {
      return const SizedBox();
    }

    return BlocBuilder<LpLoadCubit, LpLoadState>(
      builder: (context, state) {
        final uiState = state.lpLoadResponse;

        if (uiState == null || uiState.status == Status.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }

        if (uiState.status == Status.ERROR) {
          return RefreshIndicator(
            onRefresh: _onPullToRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: genericErrorWidget(error: uiState.errorType),
                ),
              ],
            ),
          );
        }

        final loadList = uiState.data?.data ?? [];

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
          onNotification: (ScrollNotification scrollInfo) {
            if (!paginationController.isFetchingMore &&
                paginationController.hasMorePages &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent) {
              fetchNextPage();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _onPullToRefresh();
            },
            child: ListView.builder(
              controller: _listController,
              padding: EdgeInsets.all(commonSafeAreaPadding),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  loadList.length +
                  (paginationController.isFetchingMore ? 1 : 0),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                if (index < loadList.length) {
                  final loadItem = loadList[index];
                  return RepaintBoundary(
                    child: GestureDetector(
                      onTap: () {
                        final extra = {"loadId": loadItem.loadId};
                        context.push(AppRouteName.lpLoadsLocationDetails, extra: extra).then((value) {
                          _onPullToRefresh();
                        });
                      },
                      child: LPLoadListBodyWidget(
                        loadItem: loadItem,
                        lpLoadLocator: lpLoadLocator,
                      ).paddingSymmetric(vertical: 7),
                    ),
                  );
                } else {
                  // loader for bottom pagination
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        );
      },
    ).expand();
  }
}
