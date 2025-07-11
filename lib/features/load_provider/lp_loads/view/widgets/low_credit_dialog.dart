import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:lottie/lottie.dart';

class LowCreditDialog extends StatelessWidget {
  const LowCreditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialogView(
      hideCloseButton: true,
      showYesNoButtonButtons: true,
      noButtonText: context.appText.back,
      yesButtonText: context.appText.support,
      child: Column(
        children: [
          Lottie.asset(AppJSON.alert, repeat: true, frameRate: FrameRate(200)),
          Text(context.appText.lowCreditBalance, style: AppTextStyle.h3.copyWith(fontSize: 26, color: AppColors.orangeTextColor)),
          10.height,
          Text(context.appText.lowCreditBalanceAlertMsg, textAlign: TextAlign.center, style: AppTextStyle.body3),
          10.height,
        ],
      ),
      onClickYesButton: () {
        Navigator.pop(context);
        commonSupportDialog(context);
      },
    );
  }
}
