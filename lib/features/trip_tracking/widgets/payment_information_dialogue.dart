import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/transaction_information.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class VpPaymentSummary  extends StatelessWidget {
  final String? tripCost;
  final String? advanceAmount;
  final bool? isAdvanceCompleted;
  final String? transactionId;
  final String? paymentMode;
  final String? receivedOn;
  final String? balancePayout;
  final bool? isBalancePending;
  final VoidCallback? onProceed;
 final String? advancedPercentage;
  final List<VpLog>? vpLogs;


  const VpPaymentSummary({
    super.key,
    required this.tripCost,
    required this.advanceAmount,
    required this.isAdvanceCompleted,
    required this.transactionId,
    required this.paymentMode,
    required this.receivedOn,
    required this.balancePayout,
    required this.isBalancePending,
    required this.onProceed,
    required this.advancedPercentage,
    required this.vpLogs,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CommonAppBar(title: context.appText.paymentSummary),
        body: SizedBox(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Container(
              decoration:commonContainerDecoration(
                color: Color(0xffE9F3FA).withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${context.appText.agreedPrice}: ", style:AppTextStyle.h3w500.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                      color: AppColors.textBlackColor
                  )),
                  Text(tripCost.toString(), style: AppTextStyle.h3PrimaryColor.copyWith(
                    fontSize: 16
                  )),
                ],
              ).paddingAll(12),
            ),
            12.height,
            TransactionInformation(
              vpLogs: vpLogs,
              advancedPer: advancedPercentage,
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 15),
    );



  }
}













