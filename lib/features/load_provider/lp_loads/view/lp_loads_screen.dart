import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/active_trips/view/active_trips.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/all_trip/view/all_trips.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/completed/view/completed.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/upcoming/view/upcoming_trips.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../../utils/app_colors.dart';

class LpLoadsScreen extends StatelessWidget {
  const LpLoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar:CommonAppBar(
          toolbarHeight: 50.h,
          title: Text("My Loads",style: AppTextStyle.textBlackColor18w500,),
          isLeading: false,
        ),

        body: Column(
          children: [
            TabBar(indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs:   [
                Tab(text:context.appText.allTrips ,),
                Tab(text: context.appText.activeTrips ),
                Tab(text: context.appText.upcomingTrips ),
                Tab(text: context.appText.completed ),
              ],
              indicatorColor: AppColors.primaryColor,
             // indicatorWeight: 2,

              labelColor: AppColors.primaryColor,
              //unselectedLabelColor: Colors.grey,
              labelStyle: AppTextStyle.textBlackColor12w400,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              isScrollable: false,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllTrips(),
                  ActiveTrips(),
                  UpcomingTrips(),
                  Completed()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
