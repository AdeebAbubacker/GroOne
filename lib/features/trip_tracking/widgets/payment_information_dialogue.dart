import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/transaction_information.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class PaymentInformationDialogView  extends StatelessWidget {
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


  const PaymentInformationDialogView({
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
    return SizedBox(
      child:Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.paymentInformation, style: AppTextStyle.h3w500.copyWith(
            color: Color(0xff050505),
            fontSize: 16
          )),
          12.height,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textBlackColor
                )),
                Expanded(child: FittedBox(child: Text(tripCost.toString(), style: AppTextStyle.h3PrimaryColor))),
              ],
            ).paddingAll(12),
          ),

          12.height,
          TransactionInformation(
            vpLogs: vpLogs,
            advancedPer: advancedPercentage,
          ),
        /*  12.height,
          Text("${context.appText.advancedPayment} ($advancedPercentage%)", style:AppTextStyle.h4w500.copyWith(
            color: AppColors.darkDividerColor,
            fontSize: 16,
            fontWeight: FontWeight.w400
          )),
          5.height,*/
         /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(advanceAmount.toString(), style: AppTextStyle.h3w500.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700
              )
              ),
              SizedBox(width: 8),
              Container(
                height: 24,
                decoration: commonContainerDecoration(
                    color: (isAdvanceCompleted??false) ? Colors.green.shade100 :  Color(0xffFFD7D9),
                    borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (isAdvanceCompleted??false) ? context.appText.completed : context.appText.pending,
                  style: AppTextStyle.h3w500.copyWith(
                         fontSize: 12,
                         fontWeight: FontWeight.w100,
                         color: (isAdvanceCompleted??false) ?  AppColors.textGreen:AppColors.textRed
                  )).paddingSymmetric(horizontal: 5,vertical: 3),
                ),

            ],
          ),*/


          // 16.height,
          // Container(
          //   decoration:commonContainerDecoration
          //     (
          //     color: Color(0xffE9F3FA).withOpacity(0.8),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Column(
          //     children: [
          //       _buildInfoRow("${context.appText.advancedReceived} (80%)", advanceAmount.toString()),
          //       _buildInfoRow(context.appText.transactionID, transactionId, ),
          //       _buildInfoRow(context.appText.paymentMode, paymentMode),
          //       _buildInfoRow(context.appText.receivedOn, receivedOn),
          //     ],
          //   ).paddingAll(12)
          // ),
          // 16.height,
          // Text(context.appText.balancePayout, style: TextStyle(color: Colors.black54)),
          // 10.height,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(balancePayout.toString(), style: AppTextStyle.h3w500.copyWith(
          //         fontSize: 20,
          //         fontWeight: FontWeight.w700
          //     )),
          //     Container(
          //       decoration: BoxDecoration(
          //         color: !(isBalancePending??false) ? Colors.green.shade100 : Color(0xffFFD7D9),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Text(
          //         (isBalancePending??false) ? context.appText.pending : context.appText.completed,
          //         style: TextStyle(color: (isBalancePending??false) ? AppColors.textRed: AppColors.greenColor),
          //       ).paddingSymmetric(horizontal: 12, vertical: 4),),
          //   ],
          // ),

        ],
      ),
    );
  }
}













