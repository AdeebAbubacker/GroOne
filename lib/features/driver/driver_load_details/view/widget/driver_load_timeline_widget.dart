import 'package:flutter/material.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
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

        // upcoming = first one that is not completed and not current
        final isUpcoming = !isCompleted &&
            !isCurrent &&
            timelineList.indexWhere(
                  (e) => e.status != 'completed' && e.status != 'current',
            ) ==
                index;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // Blinking only for upcoming
                isUpcoming
                    ? _BlinkingIcon(
                  color: LpHomeHelper.getColor(item.statusBgColor),
                )
                    : Icon(
                  isCurrent || isCompleted
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isCurrent || isCompleted
                      ? LpHomeHelper.getColor(item.statusBgColor)
                      : AppColors.textGreyDetailColor,
                  size: 24,
                ),
                if (index != timelineList.length - 1)
                  Container(
                    width: 2,
                    height: item.latestTransitData != null ? 50 : 40,
                    color: isCurrent || isCompleted
                        ? LpHomeHelper.getColor(item.statusBgColor)
                        : AppColors.greyTextColor,
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
                    style: AppTextStyle.body2.copyWith(
                      color: isCompleted || isCurrent || isUpcoming
                          ? AppColors.black
                          : AppColors.greyIconColor,
                    ),
                  ),
                  5.height,
                  Text(
                    ((isCompleted || isCurrent) && item.timestamp != null)
                        ? DateTimeHelper.formatCustomDateTimeIST(
                      item.timestamp!,
                    )
                        : '',
                    style: AppTextStyle.body4.copyWith(
                      color: AppColors.textGreyDetailColor,
                    ),
                  ),
                  if (item.latestTransitData != null) ...[
                    5.height,
                    Text(item.latestTransitData?.location ?? ''),
                    5.height,
                  ]
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

/// Blinking effect widget
class _BlinkingIcon extends StatefulWidget {
  final Color color;

  const _BlinkingIcon({required this.color});

  @override
  State<_BlinkingIcon> createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<_BlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Icon(
        Icons.radio_button_checked,
        color: widget.color,
        size: 24,
      ),
    );
  }
}