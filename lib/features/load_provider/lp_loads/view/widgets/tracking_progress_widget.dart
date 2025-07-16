import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

// class TrackingProgress extends StatelessWidget {
//    TrackingProgress({super.key});
//
//   final lpLoadLocator = locator<LpLoadCubit>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     var data = lpLoadLocator.state.trackingDistance?.data;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Radial Progress
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: 40,
//               height: 40,
//               child: CircularProgressIndicator(
//                 // value: progressPercentage / 100,
//                 value: (data?.percentage ?? 0) / 100,
//                 strokeWidth: 4,
//                 backgroundColor: Colors.grey.shade200,
//                 valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
//               ),
//             ),
//             Text(
//               "${data?.percentage.toInt()}%",
//               style: AppTextStyle.radialProgressText,
//             ),
//           ],
//         ),
//
//         const SizedBox(width: 12),
//
//         // Main content with distance/ETA
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Remaining Distance
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.appText.remainingDistance,
//                   style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),
//                 ),
//                 const SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: data?.currentdistance,
//                         style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w600, fontSize: 14, ),
//                       ),
//                       TextSpan(
//                         text: ' / ${data?.overalldistance}',
//                         style: AppTextStyle.body4.copyWith(color: AppColors.darkDividerColor),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             // Vertical Divider
//             Container(
//               width: 1,
//               height: 35,
//               color: Colors.grey.shade300,
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//             ),
//
//             // ETA
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.appText.estArrivalTime,
//                   style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(data?.durationValue.toString() ?? '', style: AppTextStyle.body3),
//               ],
//             ),
//           ],
//         ).expand(),
//       ],
//     );
//   }
// }

class TrackingProgress extends StatelessWidget {
  final int progressPercentage;
  final String remainingDistance;
  final String totalDistance;
  final int eta;

  const TrackingProgress({
    super.key,
    required this.progressPercentage,
    required this.remainingDistance,
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
          children: [
            // Distance
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Distance Covered",
                  style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),
                ),
                4.height,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${calculateDistanceCovered(totalDistance,remainingDistance)} km",
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
            ),
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
                  style: AppTextStyle.body3SoftGrey.copyWith(color: AppColors.subtleTextGreyColor),
                ),
                4.height,
                Text(DateTimeHelper.getCurrentDateTimeWithAddedDuration(eta), style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  int calculateDistanceCovered(String totalDistance, String remainingDistance) {
    int total = int.tryParse(totalDistance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int remaining = int.tryParse(remainingDistance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return total - remaining;
  }



}

