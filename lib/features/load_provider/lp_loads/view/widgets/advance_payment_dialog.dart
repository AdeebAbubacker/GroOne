import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_validate_memo.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class AdvancePaymentDialog extends StatefulWidget {
  const AdvancePaymentDialog({super.key});

  @override
  State<AdvancePaymentDialog> createState() => _AdvancePaymentDialogState();
}

class _AdvancePaymentDialogState extends State<AdvancePaymentDialog> {

  int selectedPercentage = 90;
  int totalAmount = 15000;
  int percentAmount = 0;

  @override
  Widget build(BuildContext context) {
    percentAmount = (totalAmount * selectedPercentage ~/ 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(context.appText.advancePayment, style: AppTextStyle.body2.copyWith(color: AppColors.darkDividerColor)),
        15.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
          [80, 90, 100].map((percent) {
            final isSelected = percent == selectedPercentage;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPercentage = percent;
                  percentAmount = (totalAmount * selectedPercentage ~/ 100);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: commonContainerDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderColor:  AppColors.primaryColor,
                ),
                child: Text('$percent%', style:  AppTextStyle.body2.copyWith(color: isSelected ? AppColors.white : AppColors.primaryColor)),
              ),
            );
          }).toList(),
        ),
        15.height,
        Text('$indianCurrencySymbol$percentAmount', style: AppTextStyle.h2),
        40.height,

        AppButton(
          onPressed: (){
            context.pop();
            Navigator.push(context, commonRoute(LpLoadValidateMemo()));
          },
          title: context.appText.verifyAdvance,
        ),
        20.height
      ],
    );
  }
}
