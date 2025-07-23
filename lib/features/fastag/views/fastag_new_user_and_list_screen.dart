import 'package:flutter/material.dart';
import 'package:gro_one_app/features/fastag/model/fastag_model.dart';
import 'package:gro_one_app/features/fastag/widgets/fastag_card_widget.dart';
import 'package:gro_one_app/features/fastag/widgets/fastag_empty_state_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class FastagNewUserAndListScreen extends StatefulWidget {
  const FastagNewUserAndListScreen({super.key});

  @override
  State<FastagNewUserAndListScreen> createState() => _FastagNewUserAndListScreenState();
}

class _FastagNewUserAndListScreenState extends State<FastagNewUserAndListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FastagModel> _fastags = [];
  List<FastagModel> _filteredFastags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFastags();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFastags() {
    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        // For demo purposes, you can toggle between empty and populated list
        // Set _fastags = [] for empty state
        // Set _fastags = _getDemoFastags() for populated list
        _fastags = _getDemoFastags(); // Change this to [] for empty state
        _filteredFastags = _fastags;
      });
    });
  }

  List<FastagModel> _getDemoFastags() {
    return [
      FastagModel(
        id: '8387123010',
        vehicleNumber: 'TN12 BD 1234',
        status: 'Active',
        balance: 1500,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        canRecharge: true,
      ),
      FastagModel(
        id: '8387123010',
        vehicleNumber: 'TN12 BD 1234',
        status: 'Low Balance',
        balance: 40,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        canRecharge: true,
      ),
      FastagModel(
        id: '8387123010',
        vehicleNumber: 'TN12 BD 1234',
        status: 'Under Issuance',
        balance: 0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        canRecharge: false,
      ),
    ];
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFastags = _fastags;
      } else {
        _filteredFastags = _fastags.where((fastag) {
          return fastag.vehicleNumber.toLowerCase().contains(query.toLowerCase()) ||
                 fastag.id.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onRechargeTap(FastagModel fastag) {
    // Handle recharge action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recharge ${fastag.vehicleNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCardTap(FastagModel fastag) {
    // Handle card tap action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View details for ${fastag.vehicleNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onRefreshTap(FastagModel fastag) {
    // Handle refresh action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing balance for ${fastag.vehicleNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAddFastagTap() {
    // Handle add FASTag action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add new FASTag'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onMoreOptionsTap() {
    // Handle more options action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('More options'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        backgroundColor: Colors.white,
        title: context.appText.fastag,
        actions: [
          AppIconButton(
            onPressed: _onAddFastagTap,
            icon: Icons.add,
            iconColor: AppColors.primaryColor,
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
          8.width,
          AppIconButton(
            onPressed: _onMoreOptionsTap,
            icon: Icons.more_vert,
            iconColor: AppColors.greyIconColor,
          ),
          16.width,
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fastags.isEmpty
              ? const FastagEmptyStateWidget()
              : _buildFastagListView(),
    );
  }

  Widget _buildFastagListView() {
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(commonSafeAreaPadding),
          child: AppTextField(
            controller: _searchController,
            decoration: commonInputDecoration(
              hintText: context.appText.search,
              prefixIcon: const Icon(Icons.search, color: AppColors.greyIconColor),
              fillColor: Colors.white,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        
        // My Fastag section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
          child: Row(
            children: [
              Text(
                context.appText.myFastag,
                style: AppTextStyle.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        16.height,
        
        // FASTag list
        Expanded(
          child: _filteredFastags.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.greyIconColor,
                      ),
                      16.height,
                      Text(
                        'No FASTags found',
                        style: AppTextStyle.h4.copyWith(
                          color: AppColors.greyTextColor,
                        ),
                      ),
                      8.height,
                      Text(
                        'Try adjusting your search terms',
                        style: AppTextStyle.body2.copyWith(
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
                  itemCount: _filteredFastags.length,
                  itemBuilder: (context, index) {
                    final fastag = _filteredFastags[index];
                    return FastagCardWidget(
                      fastag: fastag,
                      onRechargeTap: () => _onRechargeTap(fastag),
                      onCardTap: () => _onCardTap(fastag),
                      onRefreshTap: () => _onRefreshTap(fastag),
                    );
                  },
                ),
        ),
      ],
    );
  }
}