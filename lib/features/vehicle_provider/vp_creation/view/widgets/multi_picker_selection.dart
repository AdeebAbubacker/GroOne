import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class MultiPickerSelection extends StatelessWidget {
  final String labelText;
  final String hintText;
  const MultiPickerSelection({super.key, required this.labelText, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(" $labelText", style: AppTextStyle.body3),
        6.height,
        Container(
          height: 50,
          width: double.infinity,
          decoration: commonContainerDecoration(color: AppColors.textFieldFillColor, borderColor: AppColors.borderColor, borderRadius: BorderRadius.circular(commonTexFieldRadius)),
        ),
      ],
    );
  }
}
