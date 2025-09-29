import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../widgets/endhan_order_list_tab.dart';
import '../widgets/fastag_order_list_tab.dart';
import '../widgets/gps_order_list_tab.dart';
import '../widgets/kavach_order_list_tab.dart';

class FleetMyOrdersScreen extends StatefulWidget {
  const FleetMyOrdersScreen({super.key});

  @override
  State<FleetMyOrdersScreen> createState() => _FleetMyOrdersScreenState();
}

class _FleetMyOrdersScreenState extends State<FleetMyOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {}); // to update selected state
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabLabels = [
      context.appText.fastag,
      context.appText.kavach,
      context.appText.fuelCardEn,
      context.appText.gps,
    ];

    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: Text(context.appText.myOrders, style: AppTextStyle.appBar),
        centreTile: true,
        isLeading: false,
      ),
      body: Column(
        children: [
          /// 🔹 Custom TabBar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: List.generate(tabLabels.length, (index) {
                final isSelected = _tabController.index == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  child: GestureDetector(
                    onTap: () => _tabController.animateTo(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: commonContainerDecoration(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.greyContainerBg,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        tabLabels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          /// 🔹 Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:  [
                FastagOrderListTabWidget(),
                KavachOrderListTabWidget(),
                EndhanOrderListTabWidget(),
                GpsOrderListTabWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ChatActionButton(),
    );
  }
}
