import 'package:flutter/material.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/transaction_information.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class PaymentSummary extends StatelessWidget {
  final String? tripCost;
  final List<VpLog>? vpLogs;
  final List<VpLog>? lpLogs;

  const PaymentSummary({
    super.key,
    required this.tripCost,
    this.vpLogs,
    this.lpLogs,
  });

  @override
  Widget build(BuildContext context) {
    final logs = vpLogs ?? lpLogs ?? [];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: context.appText.paymentSummary),
      body: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Container(
              decoration: commonContainerDecoration(
                color: AppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${context.appText.agreedPrice}: ",
                    style: AppTextStyle.h3w500.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  Text(
                    tripCost.toString(),
                    style: AppTextStyle.h3PrimaryColor.copyWith(fontSize: 16),
                  ),
                ],
              ).paddingAll(12),
            ),
            12.height,
            TransactionInformation(
              vpLogs: logs,
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
