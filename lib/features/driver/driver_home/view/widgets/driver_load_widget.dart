import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/driver/driver_home/helper/driver_load_helper.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/driver_load_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../../utils/app_button.dart';
import '../../../../../utils/app_button_style.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_text_style.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/common_widgets.dart';
import '../../../../../utils/constant_variables.dart';

class DriverLoadWidget extends StatefulWidget {  
  final void Function()? onClickAssignDriver;
  final DriverLoadDetails driverLoadDetails;
  const DriverLoadWidget({super.key, required this.onClickAssignDriver,required this.driverLoadDetails});

  @override
  State<DriverLoadWidget> createState() => _DriverLoadWidgetState();
}

class _DriverLoadWidgetState extends State<DriverLoadWidget> {
final bool isConsentGiven = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DriverLoadsLocationDetailsScreen(loadId: widget.driverLoadDetails.loadId,);
        },));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
          color: AppColors.blackishWhite,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppImage.png.truckMyLoad,
                  width: 50,
                ).paddingSymmetric(vertical: 10),
                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.driverLoadDetails.loadSeriesId, style: AppTextStyle.h5),
                    Text(
                    formatDateTimeKavach(widget.driverLoadDetails.createdAt?.toString()??DateTime.now().toString()),
                    style: AppTextStyle.primaryColor12w400,
                    ),
                  ],
                ).expand(),
                5.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      children: [
                        Text(
                         widget.driverLoadDetails.loadRoute?.pickUpAddr ?? "",
                          style: AppTextStyle.blackColor15w500,
                          maxLines: 2,
                        ),
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: AppColors.primaryColor,
                        ).paddingSymmetric(horizontal: 2),
                        Text(
                          widget.driverLoadDetails.loadRoute?.dropAddr ?? "",
                          style: AppTextStyle.blackColor15w500,
                          maxLines: 2,
                        ),
                      ],
                    ),
                   Container(
              decoration: commonContainerDecoration(
                color: LpHomeHelper.getLoadStatusColor(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? '')
              ),
              width: 100,
              child: Text(
                LpHomeHelper.getLoadTypeDisplayText(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? ''),
                style: AppTextStyle.body3.copyWith(color: LpHomeHelper.getLoadStatusTextColor(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? '')),
              ).center().paddingAll(4),
            ), 
                  ],
                ).expand(),
              ],
            ),
      
            commonDivider(),
            //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
           
      
          //  progressBarWidget(progressValue: 0.5,),
          //  commonDivider(),
      
         widget.driverLoadDetails.driverConsent == 0  
          ? Column(
              children: [
                Text(
                  "No SIM tracking consent from driver",
                  style: AppTextStyle.textBlackColor16w400.copyWith(
                    color: AppColors.iconRed,
                  ),
                ),
                commonDivider(),
              ],
            )
          : Column(
              children: [       
                Text(
                  "Driver consent given",
                  style: AppTextStyle.textBlackColor16w400.copyWith(
                    color: AppColors.iconRed,
                  ),
                ),
                commonDivider(),
              ],
            ),
            Row(
              children: [
                detailWidget(
                   text: widget.driverLoadDetails.truckType?.type ?? "__",
                  iconSvg: AppIcons.svg.deliveryTruckSpeed,
                ),
                detailWidget(
                   text: widget.driverLoadDetails.truckType?.subType ?? "__",
                  iconSvg: AppIcons.svg.deliveryTruckSpeed,
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                detailWidget(
                  text: widget.driverLoadDetails.commodity?.name ?? "__",
                  iconSvg: AppIcons.svg.package,
                ),
                detailWidget(
                  text: "${widget.driverLoadDetails.weightage?.value} Tonn",
                  iconSvg: AppIcons.svg.weight,
                ),
              ],
            ),
            15.height,
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryLightColor,
              ),
              child: Row(
                children: [
                  Text(
                    "Accepted Price",
                    style: AppTextStyle.textBlackColor18w400,
                    textAlign: TextAlign.center,
                  ).expand(),
                  Text(
                    "$indianCurrencySymbol 1000",
                    style: AppTextStyle.h4PrimaryColor,
                    textAlign: TextAlign.center,
                  ).expand(),
                ],
              ),
            ),
            10.height,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    commonSupportDialog(context);
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppIcons.svg.support,
                      width: 25,
                      colorFilter: AppColors.svg(AppColors.primaryColor),
                    ),
                  ),
                ),
                10.width,
              DriverLoadHelper.loadStatusButtonWidget(
                statusId: 5,
                 onPressed: widget.onClickAssignDriver ?? () {},
              ).expand(),  
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget detailWidget({required String text, required String iconSvg}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSvg,
          width: 18,
          colorFilter: AppColors.svg(AppColors.black),
        ),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    ).expand();
  }
}


Widget progressBarWidget({required double progressValue}) {
  final percent = (progressValue * 100).round();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress',
            style: AppTextStyle.body3.copyWith(
              fontSize: 12,
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$percent%',
            style: AppTextStyle.body3.copyWith(
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progressValue,
          minHeight: 6,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      ),
    ],
  );
}



