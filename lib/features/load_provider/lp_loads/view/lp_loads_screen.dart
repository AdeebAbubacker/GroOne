import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_Widget.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
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
        setState(() {});
      }
    });
    setState(() {});
  });

  void disposeFunction() => frameCallback(() {
    searchController.dispose();
    _tabController?.dispose();
  });

  void _onSearchChanged(String query) {}

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
      ),
    );
  }

  /// Tab Bar
  Widget buildTabBarWidget() {
    if (_tabController == null) {
      return const SizedBox();
    }

    return Container(
      height: 40.h,
      decoration: commonContainerDecoration(color: const Color(0xFFEFEFEF)),
      child: TabBar(
        controller: _tabController!,
        isScrollable: true,
        physics: ClampingScrollPhysics(),  // tighter scroll behavior
        indicator: const BoxDecoration(),
        dividerHeight: 0,
        tabs: List.generate(8, (index) {
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
                style: AppTextStyle.body3.copyWith(color: isSelected ? AppColors.white : AppColors.black),
              ),
            ),
          );
        }),
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

    return ListView.builder(
      padding: EdgeInsets.all(commonSafeAreaPadding),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        switch (_tabController!.index) {
          case 0:
            return LPLoadListBodyWidget(type: 0).paddingSymmetric(vertical: 7);
          case 1:
            return LPLoadListBodyWidget(type: 1).paddingSymmetric(vertical: 7);
          case 2:
            return LPLoadListBodyWidget(type: 2).paddingSymmetric(vertical: 7);
          case 3:
            return LPLoadListBodyWidget(type: 3).paddingSymmetric(vertical: 7);
          default:
            return const SizedBox();
        }
      },
    ).expand();
  }
}



