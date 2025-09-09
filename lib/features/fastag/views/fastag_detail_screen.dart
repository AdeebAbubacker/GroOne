import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart' show commonRoute;

import 'fastag_recharge_screen.dart';

class FastagDetailScreen extends StatefulWidget {
  const FastagDetailScreen({super.key});

  @override
  State<FastagDetailScreen> createState() => _FastagDetailScreenState();
}

class _FastagDetailScreenState extends State<FastagDetailScreen> {
  bool _showDownloadPopup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // FASTag Account Summary Card
                    _buildAccountSummaryCard(context),

                    const SizedBox(height: 16),

                    // Transaction History Section
                    _buildTransactionHistorySection(),

                    const SizedBox(height: 16),

                    // Transaction List
                    _buildTransactionList(),


                    const SizedBox(height: 10), // Space for popup
                  ],
                ),
              ),
            ),

            // Download Transactions Popup
            if (_showDownloadPopup) _buildDownloadPopup(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CommonAppBar(
      title: const Text('FASTag Details'),
      centreTile: true,
    );
  }

  Widget _buildAccountSummaryCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID
          Text(
            'ID - 8387123010',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          // Vehicle Information Row
          Row(
            children: [
              // IDFC Icon
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'IDFC',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Vehicle Number
              const Text(
                'TN12 BD 1234',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(width: 8),

              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: AppColors.greyTextColor, height: 1,),
          const SizedBox(height: 4),

          // Balance Section
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    context.appText.currentBalance,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Text(
                        '₹1,500',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.refresh,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Last Updated 21 May 2025, 7.30 AM',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Recharge Button
              SizedBox(
                width: 120,
                child: AppButton(
                      buttonHeight: 40,
                      onPressed: () {
                        // Handle recharge
                        Navigator.push(context, commonRoute(FastagRechargeScreen()));
                      },
                      title: 'Recharge',
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                      style: AppButtonStyle.primary,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const Spacer(),

          // Download Button
          GestureDetector(
            onTap: () {
              setState(() {
                _showDownloadPopup = true;
              });
            },
            child: Row(
              children: [
                const Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.download,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildTransactionCard(index);
      },
    );
  }

  Widget _buildTransactionCard(int index) {
    final transactions = [
      {
        'icon': Icons.local_hospital,
        'description': 'White Field Toll Plaza',
        'transactionId': 'TN505619846846535196',
        'amount': '- ₹170',
        'amountColor': Colors.black,
        'date': '22 Apr 2025, 3:45 PM',
      },
      {
        'icon': Icons.local_hospital,
        'description': 'Hosur Toll Plaza',
        'transactionId': 'TN505619846846535197',
        'amount': '- ₹170',
        'amountColor': Colors.black,
        'date': '22 Apr 2025, 2:30 PM',
      },
      {
        'icon': Icons.account_balance_wallet,
        'description': 'BBPS BILLER A/C Dr.',
        'transactionId': 'TN505619846846535198',
        'amount': '+ ₹500',
        'amountColor': Colors.green,
        'date': '22 Apr 2025, 1:15 PM',
      },
      {
        'icon': Icons.local_hospital,
        'description': 'White Field Toll Plaza',
        'transactionId': 'TN505619846846535199',
        'amount': '- ₹170',
        'amountColor': Colors.black,
        'date': '22 Apr 2025, 12:00 PM',
      },
      {
        'icon': Icons.local_hospital,
        'description': 'Hosur Toll Plaza',
        'transactionId': 'TN505619846846535200',
        'amount': '- ₹170',
        'amountColor': Colors.black,
        'date': '22 Apr 2025, 10:45 AM',
      },
    ];

    final transaction = transactions[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction['icon'] == Icons.local_hospital
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction['icon'] as IconData,
              color: transaction['icon'] == Icons.local_hospital
                  ? AppColors.primaryColor
                  : Colors.green,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  transaction['transactionId'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Amount and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: transaction['amountColor'] as Color,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                transaction['date'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadPopup() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Download Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const Spacer(),

                // Close Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showDownloadPopup = false;
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // From Date
            _buildDateField('From Date', '15/04/2022'),

            const SizedBox(height: 12),

            // To Date
            _buildDateField('To Date', '15/04/2022'),

            const SizedBox(height: 16),

            // Download Button
            AppButton(
              onPressed: () {
                // Handle download
                setState(() {
                  _showDownloadPopup = false;
                });
              },
              title: 'Download As PDF',
              style: AppButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}