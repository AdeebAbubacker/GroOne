import 'package:dotted_line/dotted_line.dart' show DottedLine;
import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';


class DriverSourceDestinationWidget extends StatelessWidget {
  final String? pickUpLocation;
  final String? dropLocation;
  const DriverSourceDestinationWidget({
    super.key,
    this.pickUpLocation,
    this.dropLocation,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSourceDestinationView(context);
  }

  Widget _buildSourceDestinationView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(
        color: AppColors.lightPrimaryColor2,
        borderColor: AppColors.borderColor,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 20,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 38,
                    left: 9,
                    child: DottedLine(
                      direction: Axis.vertical,
                      dashLength: 4,
                      dashGapLength: 3,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.gps_fixed,
                      color: AppColors.greenColor,
                      size: 20,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.activeRedColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appText.source,
                    style: AppTextStyle.body3.copyWith(
                      fontSize: 14,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    pickUpLocation ?? "",
                    style: AppTextStyle.body3.copyWith(
                      fontSize: 12,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  Divider(),
                  Text(
                    context.appText.destination,
                    style: AppTextStyle.body3.copyWith(
                      fontSize: 14,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    dropLocation ?? "",
                    style: AppTextStyle.body3.copyWith(
                      fontSize: 12,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
