import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_Widget.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 8,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

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

  Widget buildTabBarWidget() {
    return  Container(
      height: 40.h,
      decoration: commonContainerDecoration(color: Color(0xFFEFEFEF)),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        physics: ClampingScrollPhysics(),  // tighter scroll behavior
        indicator: const BoxDecoration(),
        dividerHeight: 0,
        tabs: List.generate(8, (index) {
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
          final isSelected = _tabController.index == index;
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color:
                isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabLabels[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    ).paddingOnly(top: 15.h, right: 15.w, left: 15.w);
  }

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

  Widget buildLoadListWidget() {
    return ListView.builder(
      padding: EdgeInsets.all(commonSafeAreaPadding),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        if (_tabController.index == 0) {
        } else if (_tabController.index == 1) {
          return LpLoadsWidget(type:1).paddingSymmetric(vertical: 7);
        } else if (_tabController.index == 2) {
          return LpLoadsWidget(type:2).paddingSymmetric(vertical: 7);
        } else if (_tabController.index == 3) {
          return LpLoadsWidget(type:3).paddingSymmetric(vertical: 7);
        } else {
          return null;
        }
        return null;
      },
    ).expand();
  }
}


// class LpLoadsScreen extends StatelessWidget {
//   const LpLoadsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return   DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar:CommonAppBar(
//           toolbarHeight: 50.h,
//           title: Text("My Loads",style: AppTextStyle.textBlackColor18w500,),
//           isLeading: false,
//         ),
//
//         body: Column(
//           children: [
//             TabBar(indicatorSize: TabBarIndicatorSize.tab,
//               indicatorWeight: 3,
//               tabs:   [
//                 Tab(text:context.appText.allTrips ,),
//                 Tab(text: context.appText.activeTrips ),
//                 Tab(text: context.appText.upcomingTrips ),
//                 Tab(text: context.appText.completed ),
//               ],
//               indicatorColor: AppColors.primaryColor,
//               // indicatorWeight: 2,
//
//               labelColor: AppColors.primaryColor,
//               //unselectedLabelColor: Colors.grey,
//               labelStyle: AppTextStyle.textBlackColor12w400,
//               unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//               isScrollable: false,
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   AllTrips(),
//                   ActiveTrips(),
//                   UpcomingTrips(),
//                   Completed()
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

