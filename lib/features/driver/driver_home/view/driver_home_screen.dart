import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/driver/driver_home/bloc/driver_loads/driver_loads_bloc.dart';
import 'package:gro_one_app/features/driver/driver_home/view/widgets/driver_load_widget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';

class DriverHomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const DriverHomeScreen({super.key, this.initialTabIndex = 1});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final loadPostedDateController = TextEditingController();
  Timer? _debounce;
  final driverLoadLocator = locator<DriverLoadsBloc>();
  late DriverLoadsBloc driverLoadBloc;
  String? truckTypeDropDownValue;
  String? selectedDropDownValueId;
  String? routeDropDownValue;
  int? selectedFromLocation;
  int? selectedToLocation;
  final ScrollController _tabScrollController = ScrollController();
  final ScrollController _listController = ScrollController();
  int selectedTabIndex = 1;
  TabController? _tabController;
  final tabLabels = [
     'Available Loads',
     'My Loads',
     'Confirmed',
     'Assigned',
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
  driverLoadBloc = locator<DriverLoadsBloc>();
  _tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: widget.initialTabIndex,
  );

  _tabController!.addListener(() {
    if (_tabController!.indexIsChanging) {
      _loadDataByTab(index: _tabController!.index);
    }
  });

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _tabScrollController.jumpTo(50);
  });

  _loadDataByTab(index: widget.initialTabIndex);
});


  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
   _loadDataByTab(index: _tabController!.index);
  });
  }

  void disposeFunction() => frameCallback(() {
    _tabController!.dispose();
    searchController.dispose();
    _debounce?.cancel();
    _tabController?.dispose();
  });


   void _loadDataByTab({required int index,bool forceRefresh = false}) {
    final type = index + 1;
    final search = searchController.text;
    driverLoadBloc.add(FetchDriverLoads(type: type, search: search, forceRefresh: forceRefresh));
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
            buildTabBarWidget(),

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
        Row(
          children: [
            10.width,
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: commonContainerDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.greyIconBackgroundColor,
              ),
              child: Text(getInitialsFromName(this, name: 'dummy')),
            ).onClick(() {}).paddingRight(commonSafeAreaPadding),
          ],
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
      child: TabBar(
        controller: _tabController!,
        isScrollable: true,
        physics: const ClampingScrollPhysics(),
        indicator: const BoxDecoration(),
        dividerHeight: 0,
       tabs: List.generate(tabLabels.length, (index) {
  final isSelected = _tabController!.index == index;
  return Tab(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: commonContainerDecoration(
        color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tabLabels[index],
        style: AppTextStyle.body3.copyWith(
          color: isSelected ? AppColors.white : AppColors.black,
        ),
      ),
    ),
  );
}),

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
          onPressed: (){},
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
    if (_tabController == null) {
      return const SizedBox();
    }

    return Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabLabels.length, (index) {
                return BlocListener<DriverLoadsBloc, DriverLoadsState>(
                  bloc: driverLoadBloc,
                  listener: (context, state) {
                    if (state is DriverLoadsLoaded) {
                      if (_tabController!.index == index) {
                      
                      }
                    }
                  },
                  child: buildDriverLoadTab(index),
                );
              }),
            ),
          );
         }

        Widget buildDriverLoadTab(int tabIndex) {
        return BlocBuilder<DriverLoadsBloc, DriverLoadsState>(
          bloc: driverLoadBloc,
          builder: (context, state) {
            if (state is DriverLoadsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DriverLoadsLoaded) {
              if (state.loads.isEmpty) {
                return const Center(child: Text("No loads found."));
              }

              return ListView.builder(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                shrinkWrap: true,
                itemCount: state.loads.length,
                itemBuilder: (context, index) {
                  final load = state.loads[index];

                  // Return widgets dynamically based on tabIndex
                  switch (tabIndex) {
                    case 0: 
                  return   DriverLoadWidget(
                      driverLoadDetails: state.loads[index],
                onClickAssignDriver: () {
                },
              ).paddingSymmetric(vertical: 7);
            
          
                    case 1:
                    return   DriverLoadWidget( driverLoadDetails: state.loads[index],
                onClickAssignDriver: () {

                },
              ).paddingSymmetric(vertical: 7);
                    default:
                        return   DriverLoadWidget( driverLoadDetails: state.loads[index],
                onClickAssignDriver: () {
                },
              ).paddingSymmetric(vertical: 7);
                  }
                },
              );
            } else if (state is DriverLoadsError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }
}
