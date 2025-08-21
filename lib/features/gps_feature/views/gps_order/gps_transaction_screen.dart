import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/enhanced_dispose.dart';

class GpsTransactionScreen extends StatefulWidget {
  const GpsTransactionScreen({Key? key}) : super(key: key);

  @override
  State<GpsTransactionScreen> createState() => _GpsTransactionScreenState();
}

class _GpsTransactionScreenState extends State<GpsTransactionScreen>
    with EnhancedDisposeMixin {
  int selectedTab = 0;
  String searchQuery = '';
  List<Map<String, dynamic>> transactions = [
    {
      'title': 'Renewal TN18 AB 5684',
      'number': 'TN50561984646353196',
      'date': DateTime(2025, 4, 22, 15, 45),
      'amount': 1000,
      'status': 'Completed',
    },
    {
      'title': 'Renewal TN18 BS 9862',
      'number': 'TN50561984646353196',
      'date': DateTime(2025, 4, 22, 15, 45),
      'amount': 1000,
      'status': 'Completed',
    },
    {
      'title': 'GPS Purchased TN18 AB 5642',
      'number': 'TN50561984646353196',
      'date': DateTime(2025, 4, 22, 15, 45),
      'amount': 1000,
      'status': 'Completed',
    },
    {
      'title': 'Renewal TN18 BS 9862',
      'number': 'TN50561984646353196',
      'date': DateTime(2025, 4, 22, 15, 45),
      'amount': 1000,
      'status': 'Completed',
    },
    {
      'title': 'Renewal TN18 AB 5684',
      'number': 'TN50561984646353196',
      'date': DateTime(2025, 4, 22, 15, 45),
      'amount': 1000,
      'status': 'Failed',
    },
  ];

  final List<String> tabLabels = ['All', 'Completed', 'Failed'];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered =
        transactions.where((tx) {
          if (selectedTab == 1 && tx['status'] != 'Completed') return false;
          if (selectedTab == 2 && tx['status'] != 'Failed') return false;
          if (searchQuery.isNotEmpty &&
              !(tx['title'] as String).toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) &&
              !(tx['number'] as String).toLowerCase().contains(
                searchQuery.toLowerCase(),
              )) {
            return false;
          }
          return true;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        title: context.appText.transactions,
        centreTile: true,
        isLeading: true,
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(tabLabels.length, (i) {
                final isSelected = selectedTab == i;
                return Expanded(
                  child: GestureDetector(
                    onTap:
                        () => safeSetState(
                          () => selectedTab = i,
                        ), // ✅ Safe setState
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabLabels[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.greyContainerBackgroundColor,
              ),
              onChanged: (value) {
                safeSetState(() {
                  // ✅ Safe setState
                  searchQuery = value;
                });
              },
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final tx = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tx['title'],
                              style: AppTextStyle.h5.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  tx['status'] == 'Completed'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tx['status'],
                              style: TextStyle(
                                color:
                                    tx['status'] == 'Completed'
                                        ? Colors.green
                                        : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transaction ID: ${tx['number']}',
                        style: AppTextStyle.textBlackColor14w400.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(tx['date'])}',
                        style: AppTextStyle.textBlackColor14w400.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount: ₹${tx['amount']}',
                            style: AppTextStyle.h5.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle transaction details
                            },
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog(context);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.appText.filter),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 18),
                  Text(
                    context.appText.transactionType,
                    style: AppTextStyle.h5.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: context.appText.allTransaction,
                    items: [
                      DropdownMenuItem(
                        value: context.appText.allTransaction,
                        child: Text(context.appText.allTransaction),
                      ),
                      DropdownMenuItem(
                        value: context.appText.renewal,
                        child: Text(context.appText.renewal),
                      ),
                      DropdownMenuItem(
                        value: context.appText.purchase,
                        child: Text(context.appText.purchase),
                      ),
                    ],
                    onChanged: (_) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: AppColors.greyContainerBackgroundColor,
                    ),
                    style: AppTextStyle.textBlackColor14w400,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.appText.status,
                    style: AppTextStyle.h5.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: context.appText.success,
                    items: [
                      DropdownMenuItem(
                        value: context.appText.success,
                        child: Text(context.appText.success),
                      ),
                      DropdownMenuItem(
                        value: context.appText.failed,
                        child: Text(context.appText.failed),
                      ),
                    ],
                    onChanged: (_) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: AppColors.greyContainerBackgroundColor,
                    ),
                    style: AppTextStyle.textBlackColor14w400,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.appText.fromDate,
                    style: AppTextStyle.h5.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: '15/04/2022',
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          AppIcons.svg.calendar,
                          width: 18,
                          height: 18,
                          colorFilter: AppColors.svg(AppColors.iconColor),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: AppColors.greyContainerBackgroundColor,
                    ),
                    readOnly: true,
                    onTap: () {},
                    style: AppTextStyle.textBlackColor14w400,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.appText.toDate,
                    style: AppTextStyle.h5.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: '15/04/2022',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: AppColors.greyContainerBackgroundColor,
                    ),
                    readOnly: true,
                    onTap: () {},
                    style: AppTextStyle.textBlackColor14w400,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: AppButtonStyle.outline,
                          child: Text(
                            context.appText.downloadAsPdf,
                            style: AppTextStyle.primaryColor16w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: AppButtonStyle.primary,
                          child: Text(
                            context.appText.showTransactions,
                            style: AppTextStyle.whiteColor14w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
