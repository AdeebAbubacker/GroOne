import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/active_trips/active_trips.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/all_trip/all_trips.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/completed/completed.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/upcoming/upcoming_trips.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../../utils/app_colors.dart';

class LpLoadsScreen extends StatelessWidget {
  const LpLoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: const SizedBox(),
           centerTitle: true,
           title: Text("My Loads",style: AppTextStyle.textBlackColor18w500,),
        ),
        body: Column(
          children: [
            TabBar(indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'All Trips',),
                Tab(text: 'Active trips'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
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
