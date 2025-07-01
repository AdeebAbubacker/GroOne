import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_Widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
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
  String? selectedDropDownValueId;
  String? routeDropDownValue;
  int? selectedFromLocation;
  int? selectedToLocation;
  final ScrollController _tabScrollController = ScrollController();
  final ScrollController _listController = ScrollController();
  int page = 1;

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

    final selectedType = _tabController!.index;
    lpLoadLocator.updateSelectedTabIndex(selectedType);

    if (selectedType == 0) {
      lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest());
    } else {
      // final loadStatus = selectedType >= 3 ? selectedType + 2 : selectedType + 1;
      final loadStatus = selectedType + 1;
      lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest(loadStatus: loadStatus));
    }

    _scrollToSelectedTab(selectedType);
  }

  void _scrollToSelectedTab(int index) {
    final double offset = index == 0 ? 50 :  (100 * index) - 15;
    _tabScrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final type = _tabController!.index + 1;
      lpLoadLocator.getLpLoadsByType(loadListApiRequest: LoadListApiRequest(loadStatus: type, search: query));
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
      noButtonText: 'Cancel',
      yesButtonText: 'Apply',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filter", style: AppTextStyle.body1.copyWith(fontSize: 20)),
          10.height,
          Text("Truck Type", style: AppTextStyle.body3),
          5.height,
          BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadTruckTypes;
                final truckTypes = uiState?.data?.data ?? [];
                return AppDropdown(
                  validator: (value) => Validator.fieldRequired(value),
                  dropdownValue: truckTypeDropDownValue,
                  mandatoryStar: true,
                  decoration: commonInputDecoration(fillColor: Colors.white),
                  dropDownList: truckTypes.map((e) => DropdownMenuItem(
                      value: e.id.toString(),
                      child: Text(e.subType.toString(), style: AppTextStyle.body)),
                  ).toList(),
                  onChanged: (onChangeValue) {
                    truckTypeDropDownValue = onChangeValue;
                    selectedDropDownValueId = onChangeValue;
                    setState(() {});
                  },
                );
              }
          ),
          15.height,
          Text("Route", style: AppTextStyle.body3),
          5.height,
          BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadRouteDetails;
                final routeList = uiState?.data?.routeDataList ?? [];
                return AppDropdown(
                  validator: (value) => Validator.fieldRequired(value),
                  dropdownValue: routeDropDownValue,
                  mandatoryStar: true,
                  decoration: commonInputDecoration(fillColor: Colors.white),
                  dropDownList: routeList.map((e) => DropdownMenuItem(
                    value: e.id.toString(),
                    child:  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6, // or any suitable width
                      child: Text(
                        "${e.fromLocation?.name ?? ''} → ${e.toLocation?.name ?? ''}",
                        style: AppTextStyle.body,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),),
                  ).toList(),
                  onChanged: (onChangeValue) {
                    routeDropDownValue = onChangeValue;
                    // Find selected route object
                    final selectedRoute = routeList.firstWhere(
                          (element) => element.id.toString() == onChangeValue,
                    );
                    selectedFromLocation = selectedRoute.fromLocationId;
                    selectedToLocation = selectedRoute.toLocationId;
                    },
                );
              }
          ),
          15.height,
          Text("Load Posted Date", style: AppTextStyle.body3),
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
              loadStatus: loadStatusType == 3 ? loadStatusType + 2 : loadStatusType + 1,
              fromLocationId: selectedFromLocation,
              toLocationId: selectedToLocation,
              truckTypeId: truckTypeDropDownValue,
              loadPostDate: loadPostedDateController.text
            ));
        clearAllFilterValues();
      },
    ));
  }

  void clearAllFilterValues() {
    selectedFromLocation = null;
    selectedToLocation = null;
    routeDropDownValue = null;
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
            buildLoadListWidget(),
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
  Widget buildLoadListWidget() {
    if (_tabController == null) {
      return const SizedBox();
    }

    return BlocBuilder<LpLoadCubit, LpLoadState>(
      builder: (context, state) {
        final uiState = state.lpLoadResponse;

        if (uiState == null || uiState.status == Status.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }

        final loadList = uiState.data ?? [];

        if (loadList.isEmpty) {
          return const Center(child: Text("No loads found."));
        }

        return ListView.builder(
          controller: _listController,
          padding: EdgeInsets.all(commonSafeAreaPadding),
          shrinkWrap: true,
          itemCount: loadList.length,
          itemBuilder: (context, index) {
            final loadItem = loadList[index];
            return GestureDetector(
              onTap: () {
                print('timer ${loadItem.matchingStartDate}');
                Navigator.push(
                  context,
                  commonRoute(
                    LpLoadsLocationDetailsScreen(loadId: loadItem.id),
                  ),
                );
              },
              child: LPLoadListBodyWidget(loadItem: loadItem,lpLoadLocator: lpLoadLocator).paddingSymmetric(vertical: 7),
            );
          },
        );
      },
    ).expand();
  }
}



