import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/fastag/model/fastag_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

class FastagCardWidget extends StatelessWidget {
  final FastagModel fastag;
  final VoidCallback? onRechargeTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onRefreshTap;

  const FastagCardWidget({
    super.key,
    required this.fastag,
    this.onRechargeTap,
    this.onCardTap,
    this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: commonContainerDecoration(
          shadow: true,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with ID and arrow
            Row(
              children: [
                Text(
                  '${context.appText.fastagId} - ${fastag.id}',
                  style: AppTextStyle.body2.copyWith(
                    color: AppColors.greyTextColor,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: AppColors.greyIconColor,
                  size: 20,
                ),
              ],
            ),
            12.height,
            
            // Vehicle number row
            Row(
              children: [
                Text(
                  fastag.vehicleNumber,
                  style: AppTextStyle.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.width,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'F',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            12.height,
            
            // Status row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(fastag.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    fastag.status,
                    style: AppTextStyle.body3.copyWith(
                      color: _getStatusTextColor(fastag.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                // Balance and refresh button
                Row(
                  children: [
                    Text(
                      '₹${NumberFormat('#,##0').format(fastag.balance)}',
                      style: AppTextStyle.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.width,
                    GestureDetector(
                      onTap: onRefreshTap,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyIconBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.refresh,
                          size: 16,
                          color: AppColors.greyIconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            12.height,
            
            // Recharge button (only show if canRecharge is true)
            if (fastag.canRecharge) ...[
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  title: context.appText.recharge,
                  onPressed: onRechargeTap ?? () {},
                  style: AppButtonStyle.outlineShrink,
                  buttonHeight: 36,
                ),
              ),
              12.height,
            ],
            
            // Last updated text
            Text(
              '${context.appText.lastUpdated} ${DateFormat('dd MMM yyyy, h:mm a').format(fastag.lastUpdated)}',
              style: AppTextStyle.body3.copyWith(
                color: AppColors.greyTextColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.boxGreen;
      case 'low balance':
        return AppColors.appRedColor;
      case 'under issuance':
        return AppColors.lightGreyIconBackgroundColor;
      default:
        return AppColors.lightGreyIconBackgroundColor;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.textGreen;
      case 'low balance':
        return AppColors.textRed;
      case 'under issuance':
        return AppColors.greyTextColor;
      default:
        return AppColors.greyTextColor;
    }
  }
} 