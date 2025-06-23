import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_Widget.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LpLoadsScreen extends StatefulWidget {
  final int initialTabIndex;

  const LpLoadsScreen({super.key, this.initialTabIndex = 1});

  @override
  State<LpLoadsScreen> createState() => _LpLoadsScreenState();
}

class _LpLoadsScreenState extends State<LpLoadsScreen>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  Timer? _debounce;
  final lpLoadLocator = locator<LpLoadCubit>();


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
    _tabController = TabController(
      length: 8,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        final selectedType = _tabController!.index;

        lpLoadLocator.updateSelectedTabIndex(selectedType);
        if (selectedType == 3) {
          lpLoadLocator.getLpLoadsByType(type: selectedType + 2);
        } else {
          lpLoadLocator.getLpLoadsByType(type: selectedType + 1);
        }
      }
    });
    lpLoadLocator.getLpLoadsByType(type: widget.initialTabIndex+1);
    setState(() {});
  });

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final type = _tabController!.index + 1;
      lpLoadLocator.getLpLoadsByType(type: type, search: query);
    });
  }

  void disposeFunction() => frameCallback(() {
    searchController.dispose();
    _debounce?.cancel();
    _tabController?.dispose();
  });

  void filterPopUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            10.height,
            buildTabBarWidget(),
            buildSearchBarAndFilterWidget(context),
            buildLoadListWidget(),
          ],
        ),
    ));
  }

  /// Tab Bar
  Widget buildTabBarWidget() {
    if (_tabController == null) {
      return const SizedBox();
    }

    return Container(
      height: 40.h,
      decoration: commonContainerDecoration(color: const Color(0xFFEFEFEF)),
      child: BlocBuilder<LpLoadCubit, LpLoadState>(
          builder: (context, state) {
          return TabBar(
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
          );
        }
      ),
    ).paddingOnly(top: 15.h, right: 15.w, left: 15.w);
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
          onPressed: () {},
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
        ),
      ],
    ).paddingAll(commonSafeAreaPadding);
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
          padding: EdgeInsets.all(commonSafeAreaPadding),
          shrinkWrap: true,
          itemCount: loadList.length,
          itemBuilder: (context, index) {
            final loadItem = loadList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  commonRoute(
                    LpLoadsLocationDetailsScreen(loadItem: loadItem),
                  ),
                );
              },
              child: LPLoadListBodyWidget(loadItem: loadItem).paddingSymmetric(vertical: 7),
            );
          },
        );
      },
    ).expand();
  }
}



