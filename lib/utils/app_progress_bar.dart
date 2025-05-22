import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 to 1.0

  const AppProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Progress", style:AppTextStyle.textBlackColor12w400),
            Text("$percentage%", style:AppTextStyle.textBlackColor12w400),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}