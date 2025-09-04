import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/driver/driver_home/bloc/driver_loads/driver_loads_bloc.dart';
import 'package:gro_one_app/features/driver/driver_home/view/widgets/driver_load_widget.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/driver_load_details_screen.dart';
import 'package:gro_one_app/features/driver/driver_profile/cubit/driver_profile_cubit.dart';
import 'package:gro_one_app/features/driver/driver_profile/view/driver_profile_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/routes_dropdown.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/bloc/vp_all_loads_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class DriverHomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const DriverHomeScreen({super.key, this.initialTabIndex = 0});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with TickerProviderStateMixin {
  final searchController = TextEditingController();
  final loadPostedDateController = TextEditingController();
  Timer? _debounce;
  final driverLoadLocator = locator<DriverLoadsBloc>();
  final driverProfileCubit = locator<DriverProfileCubit>();
  final lpHomeBloc = locator<LpHomeBloc>();
  final loadCommodityBloc = locator<LoadCommodityBloc>();
  final lpLoadLocator = locator<LpLoadCubit>();
  late DriverLoadsBloc driverLoadBloc;
  String? truckTypeDropDownValue;
  String? selectedDropDownValueId;
  String? routeDropDownValue;
  int? selectedFromLocation;
  int? selectedToLocation;
  int? selectedTruckTypeId;
  int? selectedRoute;
  String? selectedCommodity;
  int? selectedCommodityId;
  int selectedTabIndex = 0;
  late VpLoadCubit vpLoadBloc;
  List<LoadStatusResponse> tabLabels = [];
  late TabController _tabController;
  final documentTypeCubit=locator<DocumentTypeCubit>();


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
    // Listen for load status loaded to update tabs
    vpLoadBloc.stream.listen((state) {
      if (!mounted) return;
      final loadStatusState=  state.statuses;
      Status? status=  loadStatusState?.status;
      if (status == Status.SUCCESS) {
        List<LoadStatusResponse> loadStatusResponse= loadStatusState?.data??[];


        // Filter statuses to exclude 2nd and 3rd items (Available and Confirmed)
        final filteredStatuses =
        loadStatusResponse.where((status) {
              final index = loadStatusResponse.indexOf(status);
              return index != 1 && index != 2;
            }).toList();
        _tabController = TabController(
          length: filteredStatuses.length,
          vsync: this,
          initialIndex: widget.initialTabIndex,
        );

        _tabController.addListener(() {
          if (_tabController.indexIsChanging) {
            _loadDataByTab(index: _tabController.index);
          }
        });

        // Load data for the initial tab after load status list received
        _loadDataByTab(index: widget.initialTabIndex);

        setState(() {
          tabLabels = filteredStatuses;
        });
      }
    });
    driverProfileCubit.fetchProfileDetail();
    lpLoadLocator.getTruckType();
    lpLoadLocator.getRouteDetails();
    loadCommodityBloc.add(LoadCommodity());
    setState(() {});
    driverLoadBloc = locator<DriverLoadsBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    _tabController.addListener(() {
      if (_tabController.index != selectedTabIndex &&
          !_tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _tabController.index;
          clearAllFilterValues();
          _loadDataByTab(index: selectedTabIndex);
          lpLoadLocator.getLpLoadsByType(
            loadListApiRequest: LoadListApiRequest(),
          );
          lpLoadLocator.getTruckType();
          lpLoadLocator.getRouteDetails();
        });
      }

      setState(() {});
    });

    _loadDataByTab(index: widget.initialTabIndex);
    initFunction();
    _callDocumentListingAPi();
  }



  _callDocumentListingAPi(){
    documentTypeCubit.getDocumentTypeList();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId();
    setState(() {});
  });

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final currentIndex = _tabController.index;
      int? loadStatus =
          (currentIndex < tabLabels.length) ? tabLabels[currentIndex].id : null;

      final parsedNumber = int.tryParse(query);
      driverLoadBloc.add(
        FetchDriverLoads(
          loadStatus: loadStatus,
          search: query,
          laneId: parsedNumber,
        ),
      );
    });
  }

  Future<void> _onPullToRefresh() async {
    final currentIndex = _tabController.index;
    int? loadStatus =
        (currentIndex < tabLabels.length) ? tabLabels[currentIndex].id : null;
    driverLoadBloc.add(
      FetchDriverLoads(forceRefresh: true, loadStatus: loadStatus),
    );
  }

  void filterPopUp() {
    var selectedTabIndexForFilter = lpLoadLocator.state.selectedTabIndex;
    var loadStatus =
        selectedTabIndexForFilter < tabLabels.length
            ? tabLabels[selectedTabIndexForFilter].id
            : null;
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
            Text(context.appText.truckType, style: AppTextStyle.body3),
            5.height,
            BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadTruckTypes;
                final truckTypes = uiState?.data ?? [];

                // Prepare the labels and mapping
                final truckTypeLabels =
                    truckTypes
                        .map((e) => '${e.type} Truck - ${e.subType}')
                        .toList();
                final truckTypeLabelIdMap = Map.fromEntries(
                  truckTypes.map(
                    (e) => MapEntry('${e.type} Truck - ${e.subType}', e.id),
                  ),
                );

                return SearchableDropdown(
                  hintText: context.appText.selectTruckType,
                  items: truckTypeLabels,
                  selectedItem: truckTypeDropDownValue,
                  onChanged: (value) {
                    truckTypeDropDownValue = value;
                    selectedTruckTypeId = truckTypeLabelIdMap[value];
                    setState(() {});
                  },
                );
              },
            ),

            15.height,
            BlocBuilder<LpLoadCubit, LpLoadState>(
              builder: (context, state) {
                final uiState = state.lpLoadRouteDetails;
                final routeList = uiState?.data?.data?.routeList ?? [];

                return RouteSearchableDropdown(
                  labelText: context.appText.routes,
                  hintText: '${context.appText.select} ${context.appText.route}',
                  routeList: routeList,
                  selectedRouteStatus: routeDropDownValue,
                  onRouteChanged: (RouteList? value) {
                    routeDropDownValue = value?.masterLaneId.toString();
                    selectedRoute = value?.masterLaneId;
                    setState(() {});
                  },
                );
              },
            ),
            15.height,
            BlocBuilder<LoadCommodityBloc, LoadCommodityState>(
              builder: (context, state) {
                if (state is LoadCommodityLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LoadCommoditySuccess) {
                  final commodities = state.commodityListModel;
                  final commodityNames =
                      commodities.map((e) => e.name).toList();
                  final commodityNameIdMap = {
                    for (var e in commodities) e.name: e.id,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.appText.commodity,
                        style: AppTextStyle.body3,
                      ),
                      5.height,
                      SearchableDropdown(
                        items: commodityNames,
                        selectedItem: selectedCommodity,
                        onChanged: (value) {
                          selectedCommodity = value;
                          selectedCommodityId = commodityNameIdMap[value];
                          setState(() {});
                        },

                        hintText: '${context.appText.select} ${context.appText.commodity}' ,
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
        onClickYesButton: () {
          Navigator.pop(context);
          driverLoadBloc.add(
            FetchDriverLoads(
              loadStatus: loadStatus,
              laneId: selectedRoute,
              truckTypeId: selectedTruckTypeId,
              commodityTypeId: selectedCommodityId,
            ),
          );
        },
        onClickNoButton: () {
          Navigator.pop(context);
          driverLoadBloc.add(FetchDriverLoads(loadStatus: loadStatus));
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
    selectedCommodity = null;
    selectedCommodityId = null;
    loadPostedDateController.clear();
  }

  void disposeFunction() => frameCallback(() {
    searchController.dispose();
    _debounce?.cancel();
    _tabController.dispose();
  });

  void _loadDataByTab({required int index, bool forceRefresh = false}) {
    final search = searchController.text;
    final loadStatus = index < tabLabels.length ? tabLabels[index].id : null;
    driverLoadBloc.add(
      FetchDriverLoads(
        loadStatus: loadStatus,
        search: search,
        forceRefresh: forceRefresh,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.lightGreyBackgroundColor,
              ),
              padding: EdgeInsets.only(top: 2, bottom: 0, right: 6, left: 6),
              child:
                  (tabLabels.isEmpty)
                      ? const SizedBox(height: 48)
                      : TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        dividerHeight: 0,
                        tabAlignment: TabAlignment.center,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
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
            //Search Field
            buildSearchBarAndFilterWidget(context),

            //Load List
            buildLoadListWidget(),
          ],
        ),
      ),
    );
  }

  //Appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      leading: Image.asset(
        AppIcons.png.appIcon,
      ).paddingLeft(commonSafeAreaPadding),
      actions: [
        // Profile
        BlocConsumer<DriverProfileCubit, DriverProfileState>(
          bloc: driverProfileCubit,
          listener: (context, state) {
            final status = state.profileDetailUIState?.status;

            if (status == Status.ERROR) {
              final error = state.profileDetailUIState?.errorType;
              ToastMessages.error(
                message: getErrorMsg(errorType: error ?? GenericError()),
              );
            }
          },
          builder: (context, state) {
            if (state.profileDetailUIState != null &&
                state.profileDetailUIState?.status == Status.SUCCESS) {
              if (state.profileDetailUIState?.data != null &&
                  state.profileDetailUIState?.data?.data != null) {
                final blueId =
                    state.profileDetailUIState!.data!.data?.customerId;
                return Row(
                  children: [
                    10.width,

                    // Profile
                    Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: commonContainerDecoration(
                            borderColor:
                                blueId != null && blueId.isNotEmpty
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                            borderWidth: 2,
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.extraLightBackgroundGray,
                          ),
                          child: Text(
                            getInitialsFromName(
                              this,
                              name:
                                  state
                                      .profileDetailUIState!
                                      .data!
                                      .data
                                      ?.name ??
                                  "",
                            ),
                          ),
                        )
                        .onClick(() {
                          Navigator.push(
                            context,
                            commonRoute(DriverProfileScreen(), isForward: true),
                          ).then((v) {
                            frameCallback(
                              () => driverProfileCubit.fetchProfileDetail(),
                            );
                          });
                        })
                        .paddingRight(commonSafeAreaPadding),
                  ],
                );
              }
            }
            return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: commonContainerDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.extraLightBackgroundGray,
                  ),
                  child: Text(getInitialsFromName(this, name: "")),
                )
                .onClick(() {
                  Navigator.push(
                    context,
                    commonRoute(DriverProfileScreen(), isForward: true),
                  );
                })
                .paddingRight(commonSafeAreaPadding);
          },
        ),
      ],
    );
  }

  /// Search and Filter
  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: _onSearchChanged,
          onClear: () {
            searchController.clear();
            commonHideKeyboard(context);
            final currentIndex = _tabController.index;
            int? loadStatus =
                (currentIndex < tabLabels.length)
                    ? tabLabels[currentIndex].id
                    : null;
            driverLoadBloc.add(
              FetchDriverLoads(forceRefresh: true, loadStatus: loadStatus),
            );
          },
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
  Widget buildLoadListWidget() {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: List.generate(tabLabels.length, (index) {
          return BlocListener<DriverLoadsBloc, DriverLoadsState>(
            bloc: driverLoadBloc,
            listener: (context, state) {
              if (state is DriverLoadsLoaded) {
                if (_tabController.index == index) {}
              }
            },
            child: buildDriverLoadTab(index,tabLabels[index].id, searchController.text),
          );
        }),
      ),
    );
  }

  Widget buildDriverLoadTab(int tabIndex,int loadStatus, String search) {
    return RefreshIndicator(
      onRefresh:
          () async => _loadDataByTab(index: tabIndex, forceRefresh: true),
      child: BlocConsumer<DriverLoadsBloc, DriverLoadsState>(
        bloc: driverLoadBloc,
        listener: (context, state) {
          if (state is DriverLoadStatusChanged) {
            ToastMessages.success(message: state.result.message);
            _loadDataByTab(index: tabIndex, forceRefresh: true);
          } else if (state is DriverLoadStatusChangeFailed) {
            ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
            _loadDataByTab(index: tabIndex, forceRefresh: true);
          }
        },
        builder: (context, state) {
          if (state is DriverLoadsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DriverLoadsLoaded) {
            if (state.loads.data.isEmpty) {
              _onPullToRefresh;
              return genericErrorWidget(error: NoLoadsFoundError());
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                    driverLoadBloc.add(
                  FetchDriverLoads(
                    loadMore: true,
                    loadStatus: loadStatus,
                    search: search
                  ),
                );
                    }
                    return false;
                  },
              child: ListView.builder(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                itemCount: state.loads.data.length,
                itemBuilder: (context, index) {
                  final load = state.loads.data[index];
                  return DriverLoadWidget(
                    driverLoadDetails: load,
                    onClickAssignDriver: () {
                      final currentStatus = load.loadStatusId;
                      if (currentStatus == 8) {
                        Navigator.push(
                          context,
                          commonRoute(
                            DriverLoadsLocationDetailsScreen(loadId: load.loadId),
                          ),
                        );
                      } else if (currentStatus <= 7) {
                        context.read<DriverLoadsBloc>().add(
                          ChangeDriverLoadStatus(
                            loadId: load.loadId,
                            loadStatus: currentStatus + 1,
                            customerId: load.vpCustomer?.customerId ?? '',
                          ),
                        );
                      }
                    },
                  ).paddingSymmetric(vertical: 7);
                },
              ),
            );
          } else if (state is DriverLoadsError) {
            return VpHelper.withSliverRefresh(
              _onPullToRefresh,
              child: Center(child: Text(state.errorType)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}


