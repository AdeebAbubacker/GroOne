import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_icons.dart';

class GpsTransactionScreen extends StatefulWidget {
  const GpsTransactionScreen({Key? key}) : super(key: key);

  @override
  State<GpsTransactionScreen> createState() => _GpsTransactionScreenState();
}

class _GpsTransactionScreenState extends State<GpsTransactionScreen> {
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
    List<Map<String, dynamic>> filtered = transactions.where((tx) {
      if (selectedTab == 1 && tx['status'] != 'Completed') return false;
      if (selectedTab == 2 && tx['status'] != 'Failed') return false;
      if (searchQuery.isNotEmpty &&
          !(tx['title'] as String).toLowerCase().contains(searchQuery.toLowerCase()) &&
          !(tx['number'] as String).toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        title: 'Transactions',
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
                    onTap: () => setState(() => selectedTab = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabLabels[i],
                        style: AppTextStyle.h5.copyWith(
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
          // Search and Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(AppIcons.svg.search, width: 20, height: 20, colorFilter: AppColors.svg(AppColors.iconColor)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.greyContainerBackgroundColor,
                    ),
                    style: AppTextStyle.textBlackColor14w400,
                    onChanged: (v) => setState(() => searchQuery = v),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _showFilterSheet(context),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(AppIcons.svg.newFilter, width: 24, height: 24, colorFilter: AppColors.svg(AppColors.primaryColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Transaction List
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('No transactions found', style: AppTextStyle.h5))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final tx = filtered[i];
                      final isCompleted = tx['status'] == 'Completed';
                      final isFailed = tx['status'] == 'Failed';
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.greyContainerBackgroundColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(AppIcons.svg.orderBox, width: 28, height: 28, colorFilter: AppColors.svg(AppColors.primaryColor)),
                            ),
                            const SizedBox(width: 12),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx['title'], style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(tx['number'], style: AppTextStyle.textGreyColor14w300),
                                  const SizedBox(height: 2),
                                  Text(DateFormat('dd MMM yyyy, h:mm a').format(tx['date']), style: AppTextStyle.textGreyColor14w300),
                                ],
                              ),
                            ),
                            // Amount & Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${tx['amount']}', style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppColors.boxGreen.withOpacity(0.15)
                                        : isFailed
                                            ? AppColors.appRedColor.withOpacity(0.15)
                                            : Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tx['status'],
                                    style: AppTextStyle.h6.copyWith(
                                      color: isCompleted
                                          ? AppColors.greenColor
                                          : isFailed
                                              ? AppColors.iconRed
                                              : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
      ),
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter', style: AppTextStyle.h4.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: SvgPicture.asset(AppIcons.svg.clearOutline, width: 22, height: 22, colorFilter: AppColors.svg(AppColors.iconColor)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('Transaction Type', style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: 'All Transaction',
              items: const [
                DropdownMenuItem(value: 'All Transaction', child: Text('All Transaction')),
                DropdownMenuItem(value: 'Renewal', child: Text('Renewal')),
                DropdownMenuItem(value: 'Purchase', child: Text('Purchase')),
              ],
              onChanged: (_) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: AppColors.greyContainerBackgroundColor,
              ),
              style: AppTextStyle.textBlackColor14w400,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            const SizedBox(height: 14),
            Text('Status', style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: 'Success',
              items: const [
                DropdownMenuItem(value: 'Success', child: Text('Success')),
                DropdownMenuItem(value: 'Failed', child: Text('Failed')),
              ],
              onChanged: (_) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: AppColors.greyContainerBackgroundColor,
              ),
              style: AppTextStyle.textBlackColor14w400,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            const SizedBox(height: 14),
            Text('From Date', style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: '15/04/2022',
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(AppIcons.svg.calendar, width: 18, height: 18, colorFilter: AppColors.svg(AppColors.iconColor)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: AppColors.greyContainerBackgroundColor,
              ),
              readOnly: true,
              onTap: () {},
              style: AppTextStyle.textBlackColor14w400,
            ),
            const SizedBox(height: 14),
            Text('To Date', style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: '15/04/2022',
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    child: Text('Download As PDF', style: AppTextStyle.primaryColor16w400),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: AppButtonStyle.primary,
                    child: Text('Show Transactions', style: AppTextStyle.whiteColor14w400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
