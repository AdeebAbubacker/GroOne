import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_Widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
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
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';

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
  int? selectedFromLocation;
  int? selectedToLocation;
  int? selectedRoute;
  final ScrollController _tabScrollController = ScrollController();
  final ScrollController _listController = ScrollController();
  int page = 1;
  late LpLoadPaginationController paginationController;

  TabController? _tabController;
  final tabLabels = [
    'All Loads',
    'Matching',
    'Confirmed',
    'Assigned',
    'Loading',
    'In Transit',
    'Unloading',
    'Completed',
  ];

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
    lpLoadLocator.updateSelectedTabIndex(0);
    paginationController = lpLoadLocator.paginationController;
    _tabController = TabController(
      length: 8,
      vsync: this,
      initialIndex: lpLoadLocator.state.selectedTabIndex,
    )..addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {_tabScrollController.jumpTo(50);});

    lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest());
    lpLoadLocator.getTruckType();
    lpLoadLocator.getRouteDetails();

    setState(() {});
  });

  void _handleTabChange() {
    if (!_tabController!.indexIsChanging) return;

    paginationController.reset();

    final selectedType = _tabController!.index;
    lpLoadLocator.updateSelectedTabIndex(selectedType);

    final loadStatus = selectedType == 0 ? null : selectedType + 1;

    lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
          loadStatus: loadStatus, page: paginationController.currentPage),
    );

    _scrollToSelectedTab(selectedType);
  }

  void fetchNextPage() async {
    paginationController.isFetchingMore = true;

    final selectedType = _tabController!.index;
    final loadStatus = selectedType == 0 ? null : selectedType + 1;

    await lpLoadLocator.getLpLoadsByType(
      loadListApiRequest: LoadListApiRequest(
        loadStatus: loadStatus,
        page: paginationController.currentPage + 1,
      ),
      isNextPage: true
    );

    // Update pagination state from API response
    final pageMeta = lpLoadLocator.state.lpLoadResponse?.data?.pageMeta;
    if (pageMeta != null) {
      paginationController.updatePageMeta(pageMeta);
    }

    paginationController.isFetchingMore = false;
  }


  void _scrollToSelectedTab(int index) {
    final double offset = index == 0 ? 50 :  (100 * index) - 15;
    _tabScrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final selectedType = _tabController!.index;
      final loadStatus = selectedType == 0 ? null : selectedType + 1;
      lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest(loadStatus: loadStatus, search: query));
    });
  }

  void disposeFunction() => frameCallback(() {
    searchController.dispose();
    _debounce?.cancel();
    _tabController?.dispose();
  });

  void filterPopUp () {
    AppDialog.show(context, child: CommonDialogView(
      crossAxisAlignment: CrossAxisAlignment.start,
      hideCloseButton: true,
      showYesNoButtonButtons: true,
      noButtonText: context.appText.cancel,
      yesButtonText: context.appText.apply,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.filter, style: AppTextStyle.body1.copyWith(fontSize: 20)),
          10.height,
          Text(context.appText.truckType, style: AppTextStyle.body3),
          5.height,
          BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadTruckTypes;
                final truckTypes = uiState?.data ?? [];
                final truckTypeLabels = truckTypes.map((e) => '${e.type} Truck - ${e.subType}').toList();
                final truckTypeLabelIdMap = Map.fromEntries(
                    truckTypes.map((e) => MapEntry('${e.type} Truck - ${e.subType}', e.id))
                );

                return DropdownSearch<String>(
                validator: (value) => Validator.fieldRequired(value),
                items: (filter, _) => truckTypeLabels
                    .where((element) => element.toLowerCase().contains(filter.toLowerCase()))
                    .toList(),
                popupProps: PopupProps.menu(
                  menuProps: MenuProps(backgroundColor: AppColors.white)
                ),
                decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration()),
                selectedItem: truckTypeDropDownValue,
                onChanged: (value) {
                  truckTypeDropDownValue = value;
                  selectedTruckTypeId = truckTypeLabelIdMap[value];
                  setState(() {});
                },
              );
            }
          ),
          15.height,
          Text(context.appText.route, style: AppTextStyle.body3),
          5.height,
          BlocBuilder<LpLoadCubit, LpLoadState>(
            builder: (context, state) {
              final uiState = state.lpLoadRouteDetails;
              final routeList = uiState?.data?.data?.routeList ?? [];

              return DropdownSearch<RouteList>(
                validator: (value) => value == null ? "Field required" : null,

                // 👌 Static filtered list
                items: (filter, _) {
                  final filteredList = filter.isEmpty
                      ? routeList
                      : routeList.where((item) {
                    final fromName = (item.fromLocation?['name'] ?? '').toString().toLowerCase();
                    final toName = (item.toLocation?['name'] ?? '').toString().toLowerCase();
                    return fromName.contains(filter.toLowerCase()) ||
                        toName.contains(filter.toLowerCase());
                  }).toList();
                  return filteredList;
                },

                // 👌 Selected item
                selectedItem: routeList.where((e) => e.status.toString() == routeDropDownValue).firstOrNull,
                compareFn: (item, selectedItem) => item.status == selectedItem?.status,

                itemAsString: (item) =>
                "${item.fromLocation?['name'] ?? ''} → ${item.toLocation?['name'] ?? ''}",

                popupProps: PopupProps.menu(
                    constraints: const BoxConstraints(maxHeight: 200),
                    menuProps: MenuProps(backgroundColor: AppColors.white)
                ),

                decoratorProps: DropDownDecoratorProps(decoration: commonInputDecoration()),
                onChanged: (value) {
                  routeDropDownValue = value?.status.toString();
                  // selectedFromLocation = value?.fromLocationId;
                  // selectedToLocation = value?.toLocationId;
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
                    firstDate: DateTime.now(),
                    initialDate: DateTimeHelper.convertToDateTimeWithCurrentTime(loadPostedDateController.text),
                  );

                  if (date != null ) {
                    loadPostedDateController.text = DateTimeHelper.convertToDatabaseFormat2(date);
                    setState(() {});
                  }
                }
            ),
          ),
        ],
      ),
      onClickYesButton: () {

        Navigator.pop(context);
        var loadStatusType = lpLoadLocator.state.selectedTabIndex;
        lpLoadLocator.getLpLoadsByType(
            loadListApiRequest: LoadListApiRequest(
            // final loadStatus = selectedType == 0 ? null : selectedType + 1;
              loadStatus: loadStatusType == 0 ? null : loadStatusType + 1,
              // fromLocationId: selectedFromLocation,
              // toLocationId: selectedToLocation,
              laneId:selectedRoute,
              truckTypeId: selectedTruckTypeId.toString(),
              loadPostDate: loadPostedDateController.text
            ));
        clearAllFilterValues();
      },
    ));
  }

  void clearAllFilterValues() {
    selectedFromLocation = null;
    selectedToLocation = null;
    selectedRoute = null;
    routeDropDownValue = null;
    selectedTruckTypeId = null;
    truckTypeDropDownValue = null;
    loadPostedDateController.clear();
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
    ));
  }

  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      leading:  Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      actions: [
        // Notification
        IconButton(
          onPressed: () {},
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

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
      decoration: commonContainerDecoration(color: const Color(0xFFEFEFEF)),
      child: BlocBuilder<LpLoadCubit, LpLoadState>(
          builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _tabScrollController,
            child: TabBar(
              controller: _tabController!,
              isScrollable: true,
              physics: ClampingScrollPhysics(),  // tighter scroll behavior
              indicator: const BoxDecoration(),
              dividerHeight: 0,
              tabs: List.generate(8, (index) {
                final isSelected = state.selectedTabIndex == index;
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: commonContainerDecoration(
                      color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabLabels[index],
                      style: AppTextStyle.body3.copyWith(color: isSelected ? AppColors.white : AppColors.black),
                    ),
                  ),
                );
              }),
            ),
          );
        }
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
    ).paddingOnly(left: commonSafeAreaPadding,right: commonSafeAreaPadding, top: commonSafeAreaPadding);
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

        final loadList = uiState.data?.data ?? [];

        if (loadList.isEmpty) {
          return Center(child: Text(context.appText.noLoadFound));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!paginationController.isFetchingMore &&
                paginationController.hasMorePages &&
                scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
              fetchNextPage();
            }
            return false;
          },
          child: ListView.builder(
            controller: _listController,
            padding: EdgeInsets.all(commonSafeAreaPadding),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: loadList.length + (paginationController.isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < loadList.length) {
                final loadItem = loadList[index];
                return LPLoadListBodyWidget(
                  loadItem: loadItem,
                  lpLoadLocator: lpLoadLocator,
                ).paddingSymmetric(vertical: 7);
              } else {
                // loader for bottom pagination
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      },
    ).expand();
  }
}



