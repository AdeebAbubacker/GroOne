import 'package:flutter/material.dart';
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
      noButtonText: "Back",
      yesButtonText: "Customer Support",
      child: Column(
        children: [
          Lottie.asset(AppJSON.alert, repeat: true, frameRate: FrameRate(200)),
          Text("Low credit balance", style: AppTextStyle.h3.copyWith(fontSize: 26, color: AppColors.orangeTextColor)),
          10.height,
          Text("You cannot post this load due to your low credit balance", textAlign: TextAlign.center, style: AppTextStyle.body3),
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
