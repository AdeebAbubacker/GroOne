import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class AdvancePaymentDialog extends StatefulWidget {
  const AdvancePaymentDialog({super.key});

  @override
  State<AdvancePaymentDialog> createState() => _AdvancePaymentDialogState();
}

class _AdvancePaymentDialogState extends State<AdvancePaymentDialog> {

  int selectedPercentage = 80;
  int baseAmount = 15000;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.appText.advancePayment, style: AppTextStyle.appBar),
            AppIconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.clear, color: AppColors.iconColor))
          ],
        ),
        30.height,


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
          [70, 80, 85].map((percent) {
            final isSelected = percent == selectedPercentage;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPercentage = percent;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: commonContainerDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderColor: isSelected ? AppColors.primaryColor :AppColors.lightBorderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$percent%', style: isSelected ? AppTextStyle.h5WhiteColor : AppTextStyle.h5GreyColor,
                ),
              ),
            );
          }).toList(),
        ),
        30.height,
        Text('₹1000', style: AppTextStyle.h2),
        30.height,

        AppButton(
          onPressed: (){},
          title: context.appText.pay,
        )
      ],
    );
  }
}
