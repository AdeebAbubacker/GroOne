import 'package:flutter/material.dart';
import '../model/report_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(report.date, style: AppTextStyle.textBlackColor16w500),
                Row(
                  children: [
                    Text('Color Code', style: AppTextStyle.textGreyColor12w400),
                    SizedBox(width: 4),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor:
                          report.colorCode == "green"
                              ? AppColors.greenColor
                              : AppColors.activeRedColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              '${report.safetyCount} Safety count',
              style: AppTextStyle.greenColor20w700.copyWith(fontSize: 12),
            ),
            SizedBox(height: 8),
            ...report.locations
                .take(2)
                .map(
                  (loc) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          loc.isSafe ? Icons.check_circle : Icons.error,
                          color:
                              loc.isSafe
                                  ? AppColors.greenColor
                                  : AppColors.activeRedColor,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            loc.address,
                            style: AppTextStyle.textBlackColor14w400,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(loc.time, style: AppTextStyle.textGreyColor12w400),
                      ],
                    ),
                  ),
                ),
            SizedBox(height: 8),
            Row(
              children: [
                _infoTile(
                  context,
                  Icons.route,
                  'Distance',
                  '${report.distance} Kms',
                ),
                _infoTile(
                  context,
                  Icons.speed,
                  'Avg. Speed',
                  '${report.avgSpeed} Km/hr',
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _infoTile(context, Icons.power, 'Engine ON', report.engineOn),
                _infoTile(context, Icons.timer, 'Idle Time', report.idleTime),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backGroundBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: AppColors.primaryColor),
                SizedBox(width: 4),
                Text(
                  value,
                  style: AppTextStyle.textBlackColor14w400.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(title, style: AppTextStyle.textGreyColor12w400),
          ],
        ),
      ),
    );
  }
}
