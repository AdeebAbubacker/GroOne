import 'package:flutter/material.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class TrackingProgress extends StatelessWidget {
  final int progressPercentage;
  final String coveredDistance;
  final String totalDistance;
  final int eta;

  const TrackingProgress({
    super.key,
    required this.progressPercentage,
    required this.coveredDistance,
    required this.totalDistance,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: progressPercentage / 100,
                strokeWidth: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text(
              "${progressPercentage.toInt()}%",
              style: AppTextStyle.radialProgressText,
            ),
          ],
        ),
        15.width,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distance
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.distanceCovered,
                  style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),
                  maxLines: 1,
                ),
                4.height,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: coveredDistance,
                        style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w600, fontSize: 14),

                      ),
                      TextSpan(
                        text: ' / $totalDistance',

                        style: AppTextStyle.body4.copyWith(color: AppColors.darkDividerColor),
                      ),
                    ],
                  ),
                ),
              ],
            ).expand(),
            Container(
              width: 1,
              height: 35,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
             // 6.width,
            // ETA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.estArrivalTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),

                ),
                4.height,
                Text(DateTimeHelper.getCurrentDateTimeWithAddedDuration(eta), style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                ),
              ],
            ).expand(),
          ],
        ).expand(),
      ],
    );
  }

  int calculateDistanceCovered(String totalDistance, String remainingDistance) {
    int total = int.tryParse(totalDistance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int remaining = int.tryParse(remainingDistance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return total - remaining;
  }



}

