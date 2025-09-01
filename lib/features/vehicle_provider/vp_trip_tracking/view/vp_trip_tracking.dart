import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class VpTripTracking extends StatefulWidget {
  const VpTripTracking({super.key});

  @override
  State<VpTripTracking> createState() => _VpTripTrackingState();
}

class _VpTripTrackingState extends State<VpTripTracking> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CommonAppBar(
          isLeading: false,
          title: context.appText.tripTracking,
          bottom: _buildTabBarWidget(),
        ),
        body: _buildBodyWidget(),
      ),
    );
  }

  PreferredSizeWidget _buildTabBarWidget() {
    return  TabBar(
      isScrollable: false,
      unselectedLabelColor: AppColors.disableColor,
      automaticIndicatorColorAdjustment: true,
      padding: EdgeInsets.zero,
      labelColor: AppColors.primaryColor,
      indicatorColor: AppColors.primaryColor,
      dividerColor: Colors.transparent,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      tabs: <Widget>[
        Tab(text: context.appText.allTrip),
        Tab(text: context.appText.activeTrips),
        Tab(text: context.appText.upcoming),
        Tab(text: context.appText.completed),
      ],
    );
  }

  Widget _buildBodyWidget(){
    return TabBarView(
      children: <Widget>[
        Center(child: Text("It's cloudy here")),
        Center(child: Text("It's rainy here")),
        Center(child: Text("It's sunny here")),
        Center(child: Text("It's sunny here")),
      ],
    );
  }

}
