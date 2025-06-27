import 'package:dotted_line/dotted_line.dart' show DottedLine;
import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class SourceDestinationWidget extends StatelessWidget {
  final String? pickUpLocation;
  final String? dropLocation;
  const SourceDestinationWidget({super.key,this.pickUpLocation,this.dropLocation});

  @override
  Widget build(BuildContext context) {
    return _buildSourceDestinationView(context);
  }

  Widget _buildSourceDestinationView(BuildContext context){
    return  Container(
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(
        color: AppColors.lightPrimaryColor2,
        borderColor: AppColors.borderColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
              SizedBox(
                height: 70,
                child: DottedLine(
                  direction: Axis.vertical,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.grey,
                  dashGapLength: 3.0,
                ).paddingOnly(top: 5,bottom: 5),
              ),


              Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
            ],
          ),
          10.width,


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // Source (Pick Up)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.source, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                  6.height,
                  Text(pickUpLocation??"", style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                ],
              ),


              commonDivider(),


              // Destination
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                  6.height,
                  Text(dropLocation??"", style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                ],
              ),


            ],
          ).expand()
        ],
      ),
    );
  }


}
