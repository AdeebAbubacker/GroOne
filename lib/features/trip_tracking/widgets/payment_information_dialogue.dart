import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Information", style: AppTextStyle.h3w500.copyWith(
            color: Color(0xff050505)
          )),
          16.height,
          Container(
            decoration:commonContainerDecoration(
              color: AppColors.primaryLightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trip Cost", style:AppTextStyle.h3w500.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textBlackColor
                )),
                Text("₹ ${tripCost.toString()}", style: AppTextStyle.h3PrimaryColor),
              ],
            ).paddingAll(12),
          ),
          16.height,
          Text("Advance payment (80%)", style:AppTextStyle.h4w500.copyWith(
            color: AppColors.darkDividerColor,
            fontSize: 16,
            fontWeight: FontWeight.w400
          )),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${advanceAmount.toString()}", style: AppTextStyle.h3w500.copyWith(
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
                  (isAdvanceCompleted??false) ? "Completed" : "Pending",
                  style: AppTextStyle.h3w500.copyWith(
                         fontSize: 12,
                         fontWeight: FontWeight.w100,
                         color: (isAdvanceCompleted??false) ?  AppColors.textGreen:AppColors.textRed
                  )).paddingSymmetric(horizontal: 5,vertical: 3),
                ),

            ],
          ),
          16.height,
          Container(
            decoration:commonContainerDecoration
              (
              color: AppColors.primaryLightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildInfoRow("Advance Received (80%)", "₹${advanceAmount.toString()}"),
                _buildInfoRow("Transaction ID", transactionId, ),
                _buildInfoRow("Payment mode", paymentMode),
                _buildInfoRow("Received on", receivedOn),
              ],
            ).paddingAll(12)
          ),
          16.height,
          Text("Balance payout", style: TextStyle(color: Colors.black54)),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${balancePayout.toString()}", style: AppTextStyle.h3w500.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
              )),
              Container(
                decoration: BoxDecoration(
                  color: !(isBalancePending??false) ? Colors.green.shade100 : Color(0xffFFD7D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (isBalancePending??false) ? "Pending" : "Completed",
                  style: TextStyle(color: (isBalancePending??false) ? AppColors.textRed: AppColors.greenColor),
                ).paddingSymmetric(horizontal: 12, vertical: 4),),
            ],
          ),

        ],
      ),
    );
  }
}



Widget _buildInfoRow(String? title, String? value, {bool isLink = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
          5.width,
          Text(title??"",
              style: AppTextStyle.h3w500.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w200
              )).expand(),
        ],
      ).expand(),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          value??"",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w400,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none,
          ),
        ).expand(),
      ),
    ],
  ).paddingSymmetric(vertical: 5);
}








