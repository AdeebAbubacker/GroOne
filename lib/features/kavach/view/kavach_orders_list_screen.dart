import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_order_card_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/constant_variables.dart';
import 'kavach_models_screen.dart';

class KavachOrdersListScreen extends StatefulWidget {
  const KavachOrdersListScreen({super.key});

  @override
  State<KavachOrdersListScreen> createState() => _KavachOrdersListScreenState();
}

class _KavachOrdersListScreenState extends State<KavachOrdersListScreen> {
  final List<String> filters = [
    'All',
    'Order Placed',
    'Dispatched',
    'Delivered',
    'Failed',
    'Installed',
  ];

  String selectedFilter = 'All';

  final List<KavachOrderItem> orders = [
    KavachOrderItem('4546S846SFG3', 'eN-Dhan Kavach, +3', 'Order Placed', 7500),
    KavachOrderItem('4546S846SFG3', 'eN-Dhan Kavach, +3', 'Dispatched', 9500),
    KavachOrderItem('4546S846SFG3', 'eN-Dhan Kavach, +2', 'Delivered', 6200),
    KavachOrderItem('4546S846SFG3', 'eN-Dhan Kavach, +3', 'Failed', 6500),
    KavachOrderItem('4546S846SFG3', 'eN-Dhan Kavach, +5', 'Installed', 10500),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedFilter == 'All'
        ? orders
        : orders.where((o) => o.status == selectedFilter).toList();

    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.kavach,
        actions: [
          AppIconButton(
            onPressed: ()=> Navigator.of(context).push(commonRoute(KavachModelsScreen())),
            icon: Icon(Icons.add, color: Colors.white),
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
          AppIconButton(onPressed: (){}, icon: AppIcons.svg.support,  style: AppButtonStyle.circularIconButtonStyle),
          10.width,
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => 10.width,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: isSelected? AppTextStyle.whiteColor14w400:AppTextStyle.blackColor14w400,
                      ),
                    ),
                  );
                },
              ),
            ),
            10.height,
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  return KavachOrderCardWidget(order: filteredOrders[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}