import 'package:flutter/material.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class DriverLoadTimelineWidget extends StatelessWidget {
  final List<Timeline> timelineList;

  const DriverLoadTimelineWidget({
    super.key,
    required this.timelineList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(timelineList.length, (index) {
        final item = timelineList[index];
        final isCompleted = item.status == 'completed';
        final isCurrent = item.status == 'current';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  isCurrent || isCompleted
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isCurrent || isCompleted
                      ? AppColors.primaryIconColor
                      : AppColors.textGreyDetailColor,
                  size: 24,
                ),
                if (index != timelineList.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.greyTextColor,
                  ),
              ],
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTextStyle.body2.copyWith(color: isCompleted || isCurrent ? AppColors.black : AppColors.greyIconColor),
                  ),

                  5.height,
                  Text(
                    ((isCompleted || isCurrent) && item.timestamp != null)
                        ? DateTimeHelper.formatCustomDateTimeIST(item.timestamp!)
                        : '',
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
