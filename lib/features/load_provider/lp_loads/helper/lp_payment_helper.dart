import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/payments/view/payments_screen.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';


enum PaymentMethod { neft, online }

class LpPaymentHelper {
  /// Show bank details popup
  static void showBankDetailsDialog(BuildContext context, BankDetails? bankDetails) {
    AppDialog.show(
      context,
      dismissible: true,
      child: Builder(
        builder: (dialogContext) {
          return CommonDialogView(
            hideCloseButton: true,
            onSingleButtonText: context.appText.continueText,
            onTapSingleButton: () => Navigator.pop(dialogContext),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  context.appText.bankDetails,
                  style: AppTextStyle.h5.copyWith(
                    color: AppColors.textBlackColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _buildBankRow(context.appText.beneficiaryName, bankDetails?.beneficiaryName ?? ''),
                _buildBankRow(context.appText.bankName, bankDetails?.bankName ?? ''),
                _buildBankRow(context.appText.accountNumber, bankDetails?.accountNumber ?? ''),
                _buildBankRow(context.appText.ifscCode, bankDetails?.ifscCode ?? ''),
                _buildBankRow(context.appText.branchName, bankDetails?.branchName ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildBankRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.body3),
        Text(value, style: AppTextStyle.body2),
      ],
    );
  }

  /// Show NEFT / Online payment options
  static Future<void> showPaymentMethodDialog({
    required BuildContext context,
    required bool isLoading,
    required VoidCallback onOnlineTap,
    required VoidCallback onNeftTap,
  }) async {
    PaymentMethod selectedMethod = PaymentMethod.online;

    AppDialog.show(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return CommonDialogView(
            showYesNoButtonButtons: true,
            hideCloseButton: true,
            yesButtonLoading: isLoading,
            onClickYesButton: () {
              Navigator.pop(context);
              if (selectedMethod == PaymentMethod.neft) {
                onNeftTap();
              } else {
                onOnlineTap();
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
                  onChanged: (value) => setState(() => selectedMethod = value!),
                ),
                RadioListTile<PaymentMethod>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.appText.onlinePay),
                  value: PaymentMethod.online,
                  groupValue: selectedMethod,
                  onChanged: (value) => setState(() => selectedMethod = value!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Launch online payment flow
  static Future<void> navigateToPaymentScreen({
    required BuildContext context,
    required String loadId,
    required CreateOrderIdRequest request,
    required LpLoadCubit lpLoadCubit,
    required VoidCallback onSuccess,
  }) async {
    await lpLoadCubit.createOrder(
      loadId: loadId,
      createOrderIdRequest: request,
    );

    final createOrderState = lpLoadCubit.state.lpCreateOrder;

    if (createOrderState?.status == Status.SUCCESS) {
      final url = createOrderState?.data?.data?.data?.tinyUrl;
      if (url != null && url.isNotEmpty) {
        final result = await Navigator.of(context).push(
          commonRoute(PaymentsScreen(url: url, loadId: loadId)),
        );

        if (result == true) {
          onSuccess();
        } else {
          ToastMessages.error(message: context.appText.paymentFailed);
        }
      } else {
        ToastMessages.error(message: 'CC Avenue url is empty');
      }
    } else {
      Navigator.pop(context);
      final error = createOrderState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
    }
  }


  /// Optional payment CTA button
  static Widget buildPaymentActionButton({
    required BuildContext context,
    required String label,
    required bool showWarningIcon,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      title: label,
      onPressed: onPressed,
      richTextWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showWarningIcon)
            SvgPicture.asset(AppIcons.svg.alertWarning, height: 18, width: 18),
          8.width,
          Text(label, style: AppTextStyle.buttonWhiteTextColor),
        ],
      ),
    );
  }
}
