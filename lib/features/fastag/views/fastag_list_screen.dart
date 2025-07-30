import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),

            SizedBox(height: 10),
            
            // Search Bar
            _buildSearchBar(context),

             SizedBox(height: 10),
            
            // Section Title
            _buildSectionTitle(),
            
            // FASTag List
            Expanded(
              child: _buildFastagList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: Text(context.appText.fastag),
      centreTile: false,
      actions: [
        AppIconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyNewFastagScreen()));
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
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return  AppSearchBar(
                        searchController: _searchController,
                        hintText: context.appText.search,
                        onChanged: (val) {
                         
                        },
                        onClear: () {
                        
                        },
                      ).paddingSymmetric(horizontal: 16.0);
  
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'My Fastag',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastagList(BuildContext context) {
    return ListView(
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
          showRechargeButton: true,
          showRefreshIcon: true,
          context: context,
        ),
        
        const SizedBox(height: 12),
        
        // Card 2 - Low Balance Status
        _buildFastagCard(
          id: '8387123010',
          vehicleNumber: 'TN12 BD 1234',
          status: 'Low Balance',
          statusColor: Colors.red,
          balance: '₹40',
          lastUpdated: '21 May 2025, 7.30 AM',
          showRechargeButton: true,
          showRefreshIcon: true,
          context: context,
        ),
        
        const SizedBox(height: 12),
        
        // Card 3 - Under Issuance Status
        _buildFastagCard(
          id: '8387123010',
          vehicleNumber: 'TN12 BD 1234',
          status: 'Under Issuance',
          statusColor: Colors.grey,
          balance: '₹0',
          lastUpdated: '21 May 2025, 7.30 AM',
          showRechargeButton: false,
          showRefreshIcon: true,
          context: context,
        ),
      ],
    );
  }

  Widget _buildFastagCard({
    required String id,
    required String vehicleNumber,
    required String status,
    required Color statusColor,
    required String balance,
    required String lastUpdated,
    required bool showRechargeButton,
    required bool showRefreshIcon,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: commonContainerDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        shadow: true
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 // ID
              Text(
               'ID - $id',
               style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 8),
 // Vehicle Number Row
          Row(
            children: [
              // Vehicle Icon (Red square with white symbol)
              Image.asset(AppIcons.png.fastagListCardIcon),
              
              const SizedBox(width: 8),
              
              // Vehicle Number
               Text(
                  vehicleNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              
                const SizedBox(width: 15),
              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
             
            ],
          ),
          
            
              ],
             ) ,
              // Navigation Arrow
              AppIconButton(
                onPressed: (){
                  Navigator.push(context, commonRoute(FastagDetailScreen()));
                },
                icon:  Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black,),
                style: AppButtonStyle.circularIconButtonStyle,
              ),
              
            ],
          ),
          
         
          const SizedBox(height: 12),

          Divider(color: AppColors.greyTextColor, height: 1,),
          const SizedBox(height: 4),
          
          // Balance Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 14,
                  color: status == 'Under Issuance' ? Colors.grey : Colors.grey,
                ),
              ),
              
              
              Row(
                children: [
                  Text(
                    balance,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: status == 'Under Issuance' ? Colors.grey : AppColors.primaryColor,
                    ),
                  ),
                  
                  if (showRefreshIcon) ...[
                    const SizedBox(width: 8),
                    // Refresh Icon
                    const Icon(
                      Icons.refresh,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Recharge Button (if applicable)
                  if (showRechargeButton)
                  
                     AppButton(
                      buttonHeight: 40,
                      onPressed: () {
                        // Handle recharge
                        Navigator.push(context, commonRoute(FastagRechargeScreen()));
                      },
                      title: 'Recharge',
                      style: AppButtonStyle.primary,
                    ).expand()
                   
                ],
              ),
            ],
          ),
          
        SizedBox(height: 2),
          
          // Last Updated
          Text(
            'Last Updated $lastUpdated',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  
  }
}