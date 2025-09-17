import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/helper/lp_payment_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../../utils/app_icons.dart';
import '../../model/lp_load_get_by_id_response.dart';

enum PaymentMethod { neft, online }


class PaymentWidget extends StatelessWidget {
  PaymentWidget({super.key, required this.loadItem, required this.loadStatus});
  final LoadData loadItem;
  final LoadStatus loadStatus;


  final lpLoadCubit = locator<LpLoadCubit>();

  @override
  Widget build(BuildContext context) {

    final createOrderStatus = lpLoadCubit.state.lpCreateOrder;
    final addPaymentStatus = lpLoadCubit.state.lpAddCustomerPaymentOption;

    final isLoading = createOrderStatus?.status == Status.LOADING || addPaymentStatus?.status == Status.LOADING;

    final paymentData = loadItem.lpPaymentsData;

    final String paymentAgreedPrice = paymentData?.agreedPrice ?? '';
    final String paymentAdvanceDue = paymentData?.receivableAdvance ?? '';
    final String paymentBalanceDue = paymentData?.receivableBalance ?? '';

    final isAdvancePaid = paymentData?.receivableAdvancePaidFlg ?? false;
    final isBalancePaid = paymentData?.receivableBalancePaidFlg ?? false;

    final agreedPriceToShow =  paymentAgreedPrice;
    final advanceDueToShow = paymentAdvanceDue;
    final balanceDueToShow = paymentBalanceDue;
    final paymentActionType = (paymentData?.receivableAdvancePaidFlg ?? false) ? 'balance' : 'advance';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,

          /// Agreed price
          _buildPaymentRow(
            title: context.appText.agreedPrice,
            amount: agreedPriceToShow,
            context: context,
          ),
          8.height,


          /// advance
          _buildPaymentRow(
            title: isAdvancePaid ? context.appText.advancePaid : context.appText.payableAdvance,
            amount: advanceDueToShow,
            context: context,
            isPending: loadStatus.index >= LoadStatus.inTransit.index && !isAdvancePaid,
            isPaid: isAdvancePaid
          ),

          8.height,

          /// balance
            if (isAdvancePaid && paymentBalanceDue != '0.00')
              _buildPaymentRow(
              title: isBalancePaid ? context.appText.balancePaid : context.appText.payableBalance,
              amount: balanceDueToShow,
              context: context,
              isPaid: isBalancePaid,
              isPending: loadStatus == LoadStatus.completed && !isBalancePaid
            ),

          12.height,


          if(!isBalancePaid && paymentBalanceDue != '0.00')
            // Action Button
            AppButton(
                title: context.appText.payAdvance,
                onPressed: () async {
                  PaymentMethod selectedMethod = PaymentMethod.online;

                  AppDialog.show(
                    context,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return CommonDialogView(
                          showYesNoButtonButtons: true,
                          hideCloseButton: true,
                          yesButtonLoading: isLoading,
                          onClickYesButton: () async {
                            if(selectedMethod == PaymentMethod.neft) {
                              Navigator.pop(context);
                              LpPaymentHelper.showBankDetailsDialog(context, loadItem.bankDetails);
                            } else {
                              final selectedAmountString = isAdvancePaid ? balanceDueToShow : advanceDueToShow;
                              final paymentAmount = selectedAmountString;
                              LpPaymentHelper.navigateToPaymentScreen(
                                context: context,
                                loadId: loadItem.loadId,
                                lpLoadCubit: lpLoadCubit,
                                request: CreateOrderIdRequest(
                                  memoid: loadItem.loadMemoDetails?.id ?? '',
                                  lpId: loadItem.customer?.customerSeriesNo.toString() ?? '',
                                  lpName: loadItem.customer?.customerName ?? '',
                                  lpEmailId: loadItem.customer?.emailId ?? '',
                                  lpMobile: loadItem.customer?.mobileNumber ?? '',
                                  vpId: loadItem.vpCustomer?.customerSeriesNo.toString() ?? '',
                                  loadSeriesId: loadItem.loadSeriesId,
                                  netFreight: loadItem.loadMemoDetails?.netFreight ?? '',
                                  advance: loadItem.loadMemoDetails?.advance ?? '',
                                  advancePercentage: loadItem.loadMemoDetails?.advancePercentage ?? '',
                                  balance: loadItem.loadMemoDetails?.balance ?? '',
                                  balancePercentage: loadItem.loadMemoDetails?.balancePercentage ?? '',
                                  vpAdvance: loadItem.loadMemoDetails?.vpAdvance ?? '',
                                  vpAdvancePercentage: loadItem.loadMemoDetails?.vpAdvancePercentage ?? '',
                                  vpBalance: loadItem.loadMemoDetails?.vpBalance ?? '',
                                  vpBalancePercentage: loadItem.loadMemoDetails?.vpBalancePercentage ?? '',
                                  amount: paymentAmount,
                                  type: 'online',
                                  action: paymentActionType,
                                  vpAmount: loadItem.loadMemoDetails?.vpAmount ?? ''
                                ),
                                onSuccess: () {
                                  Navigator.pop(context);
                                  lpLoadCubit.getLpLoadsById(loadId: loadItem.loadId);
                                },
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(context.appText.selectPaymentMethod, style: AppTextStyle.h3),
                              10.height,
                              RadioListTile<PaymentMethod>(
                                contentPadding: EdgeInsets.zero,
                                title: Text(context.appText.neft),
                                value: PaymentMethod.neft,
                                groupValue: selectedMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMethod = value!;
                                  });
                                },
                              ),
                              RadioListTile<PaymentMethod>(
                                contentPadding: EdgeInsets.zero,
                                title: Text(context.appText.onlinePay),
                                value: PaymentMethod.online,
                                groupValue: selectedMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMethod = value!;
                                  });
                                },
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                richTextWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if((loadStatus.index >= LoadStatus.inTransit.index && !isAdvancePaid) || (loadStatus == LoadStatus.completed && !isBalancePaid))
                      SvgPicture.asset(
                        AppIcons.svg.alertWarning,
                        height: 18,
                        width: 18,
                      ),
                    8.width,
                    Text(
                      isAdvancePaid ? context.appText.payBalance : context.appText.payAdvance,
                      style: AppTextStyle.buttonWhiteTextColor,
                    ),
                  ],
                )

            ),

          if(paymentData?.lpLogs.isNotEmpty ?? false)
          ...[
            10.height,
            GestureDetector(
              onTap: () {
                final extra = {
                  "lpLogs": loadItem.lpPaymentsData?.lpLogs ?? [],
                  "tripCost": PriceHelper.formatINR(agreedPriceToShow),
                };
                context.push(AppRouteName.paymentSummary, extra: extra);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Transaction Details',
                    style: AppTextStyle.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required String title,
    required String amount,
    required BuildContext context,
    bool isPaid = false,
    bool isPending = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyle.body2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlackColor,
                ),
              ),
              if (isPaid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: commonContainerDecoration(color: AppColors.boxGreen),
                  child: Text(
                    context.appText.paid,
                    style: AppTextStyle.body.copyWith(
                      fontSize: 12,
                      color: AppColors.greenColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else if (isPending)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                    4.width,
                    Text(
                      context.appText.pending,
                      style: AppTextStyle.body4.copyWith(color: AppColors.iconRed),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Text(
          PriceHelper.formatINR(amount),
          style: AppTextStyle.h4,
        ),
      ],
    );
  }
}
