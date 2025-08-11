import 'package:flutter/material.dart';
import 'package:gro_one_app/features/notification/widget/notification_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>    with SingleTickerProviderStateMixin {


  late TabController _tabController;

  @override
  void initState() {
    _initializeTabController();
    super.initState();
  }

  void _initializeTabController(){
    _tabController = TabController(
        length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.docViewCardBgColor,
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        title: context.appText.notification,
      ),
      body: Column(
        children: [
          15.height,
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)),
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
              controller: _tabController,
              tabAlignment:TabAlignment.center ,

              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              dividerHeight: 1,

              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.tabIndicatorColor,
              labelStyle: AppTextStyle.h6.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyle.h6,
              padding: EdgeInsets.zero,
              dividerColor: Color(0xffE4E8EE),
              tabs: [
                SizedBox(height: 30, child: Tab(text: "All")),
                SizedBox(
                  height: 30,
                  child: Tab(text: "Unread"),
                ),
                SizedBox(height: 30, child: Tab(text: "GPS")),
              ],
            ),
          ),
          20.height,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NotificationWidget(),
                NotificationWidget(),
                NotificationWidget(),
              ],
            ).paddingSymmetric(horizontal: 10),
          )
        ],
      ),
    );
  }
}


