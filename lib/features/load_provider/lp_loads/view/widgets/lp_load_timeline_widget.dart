import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';


class LPLoadTimelineWidget extends StatelessWidget {
  final List<String> timelineTitle;
  final int currentTimeline;

  const LPLoadTimelineWidget({
    super.key,
    required this.timelineTitle,
    required this.currentTimeline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(timelineTitle.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TimeLine indicator (radio style)
            Column(
              children: [
                Icon(
                  index <= currentTimeline
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: index <= currentTimeline ? AppColors.primaryIconColor : AppColors.textGreyDetailColor,
                  size: 24,
                ),

                // Vertical line (except last item)
                if (index != timelineTitle.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.greyTextColor,
                  ),
              ],
            ),
            10.width,

            // TimeLine label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timelineTitle[index],
                    style: AppTextStyle.body2.copyWith(color: AppColors.black),
                  ),
                  5.height,
                  Text(
                    '03 Jan 2023 | 02:45 pm',
                    style: AppTextStyle.body4.copyWith(color: AppColors.textGreyDetailColor),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
