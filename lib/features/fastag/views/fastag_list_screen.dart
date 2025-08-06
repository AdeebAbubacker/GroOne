import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_search_bar.dart';
import 'buy_new_fastag_screen.dart';
import 'fastag_detail_screen.dart';
import 'fastag_recharge_screen.dart';

class FastagListScreen extends StatelessWidget {
  FastagListScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: Text(context.appText.fastag, style: AppTextStyle.appBar),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuyNewFastagScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
          4.width,
          AppIconButton(
            onPressed: () {
              // More options
            },
            icon: Image.asset(AppIcons.png.moreVertical),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            10.height,
            // Search Bar
            _buildSearchBar(context),
            10.height,
            // Section Title
            Text(
              'My Fastag',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ).paddingSymmetric(horizontal: 16.0),
            // FASTag List
            _buildFastagList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      searchController: _searchController,
      hintText: context.appText.search,
      onChanged: (val) {},
      onClear: () {},
    ).paddingSymmetric(horizontal: 16.0);
  }

  Widget _buildFastagList(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card 1 - Active Status
          _buildFastagCard(
            id: '8387123010',
            vehicleNumber: 'TN12 BD 1234',
            status: 'Active',
            statusColor: Colors.green,
            balance: '₹1,500',
            lastUpdated: '21 May 2025, 7.30 AM',
            context: context,
          ),

          12.height,

          // Card 2 - Low Balance Status
          _buildFastagCard(
            id: '8387123010',
            vehicleNumber: 'TN12 BD 1234',
            status: 'Low Balance',
            statusColor: Colors.red,
            balance: '₹40',
            lastUpdated: '21 May 2025, 7.30 AM',
            context: context,
          ),

          12.height,

          // Card 3 - Under Issuance Status
          _buildFastagCard(
            id: '8387123010',
            vehicleNumber: 'TN12 BD 1234',
            status: 'Under Issuance',
            statusColor: Colors.grey,
            balance: '₹0',
            lastUpdated: '21 May 2025, 7.30 AM',
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildFastagCard({
    required String id,
    required String vehicleNumber,
    required String status,
    required Color statusColor,
    required String balance,
    required String lastUpdated,
    // required bool showRechargeButton,
    // required bool showRefreshIcon,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: commonContainerDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        shadow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ID
                    Text('ID - $id', style: AppTextStyle.textGreyColor12w400),

                    8.height,
                    // Vehicle Number Row
                    Row(
                      children: [
                        // Vehicle Icon (Red square with white symbol)
                        Image.asset(AppIcons.png.fastagListCardIcon),
                        8.width,
                        // Vehicle Number
                        Text(vehicleNumber, style: AppTextStyle.h4),
                        15.width,
                        // Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyle.h6.copyWith(color: statusColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Navigation Arrow
              AppIconButton(
                onPressed: () {
                  Navigator.push(context, commonRoute(FastagDetailScreen()));
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.black,
                ),
                style: AppButtonStyle.circularIconButtonStyle,
              ),
            ],
          ),
          12.height,
          Divider(color: AppColors.greyTextColor, height: 1),
          4.height,

          // Balance Section
          if(status != 'Under Issuance') Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Balance', style: AppTextStyle.body3GreyColor),

              Row(
                children: [
                  Text(
                    balance,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          status == 'Under Issuance'
                              ? Colors.grey
                              : AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Refresh Icon
                  const Icon(Icons.refresh, size: 16, color: Colors.grey),
                  const Spacer(),
                  // Recharge Button (if applicable)
                    AppButton(
                      buttonHeight: 40,
                      onPressed: () {
                        // Handle recharge
                        Navigator.push(
                          context,
                          commonRoute(FastagRechargeScreen()),
                        );
                      },
                      title: 'Recharge',
                      style: AppButtonStyle.primary,
                    ).expand(),
                ],
              ),
              2.height,
              // Last Updated
              Text(
                'Last Updated $lastUpdated',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          
          if(status == 'Under Issuance')Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Requested On: 21-09-2025, 6:30 PM',style: AppTextStyle.body,),
              10.height,
              AppButton(
                style: AppButtonStyle.outline,
                onPressed: () {
                commonSupportDialog(context);
              },
              title: 'Contact Support',
              )
            ],
          )
        ],
      ),
    );
  }
}
