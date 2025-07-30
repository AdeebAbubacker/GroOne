import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class InformationView extends StatelessWidget {
 final String? title;
 final String? amount;
  const InformationView({super.key,this.title,this.amount});

  @override
  Widget build(BuildContext context) {
    final style= AppTextStyle.body4.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 16
    );
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text((title??"").capitalizeFirst,style: style
        ),
        Text(amount??"",style: style.copyWith(
          color: AppColors.primaryColor
        ),)
      ],
    );
  }
}
