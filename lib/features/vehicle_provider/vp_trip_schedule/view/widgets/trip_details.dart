import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/number_symbols_data.dart';

import '../../../../../utils/app_dropdown.dart' show AppDropdown;
import '../../../../../utils/common_widgets.dart' show commonInputDecoration;
import '../../../../../utils/constant_variables.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return _tripDetailsWidget(context);
  }

  Widget _tripDetailsWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blackishWhite,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        children: [
          Row(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xffDFE6FF),
                  shape: BoxShape.circle,
                ),
                child: Center(child: SvgPicture.asset(AppIcons.svg.orderBox)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "GD 34567",
                              style: AppTextStyle.h5w500.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Row(
                              children: [
                                Text("Bangalore "),
                                Icon(Icons.arrow_forward, size: 12),
                                Text("Chennai"),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bloom Cosmetic Pvt Ltd",
                                  style: AppTextStyle.h5w500.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textGreyDetailColor,
                                  ),
                                ),
                                Text(
                                  "12 Jul 2025, 6.30 AM",
                                  style: AppTextStyle.h3PrimaryColor.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: SvgPicture.asset(AppImage.svg.support),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 20),






          Divider(
              indent: 30,
              endIndent: 30,
              thickness: 0.5),

          10.height,

          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildTripEntityTiles(AppIcons.svg.deliveryTruckSpeed,"Closed Truck"),
                  _buildTripEntityTiles(AppIcons.svg.package,"Construction Material")
                ],
              ),

              Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripEntityTiles(AppIcons.svg.deliveryTruckSpeed,"20 ft SLX"),
                  _buildTripEntityTiles(AppIcons.svg.weight,"5 Ton"),
                ],
              ),



            ],
          ).paddingSymmetric(horizontal: 20),
          15.height,

          Container(
            padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor,
            borderRadius: BorderRadius.circular(8)
          ),
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPriceBreakDownWidget("Accepted Price","73000"),
                _buildPriceBreakDownWidget("Advance Amount","65,000"),
                _buildPriceBreakDownWidget("Balance Amount","8000"),
              ],
            ),
          ).paddingSymmetric(horizontal: 20),
          15.height,







        ],
      ),
    );
  }

  Widget _buildTripEntityTiles(String icon,String title){
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(icon),
        Text(title)
      ],
    );
  }


  Widget _buildPriceBreakDownWidget(String title,String price){
return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(title,style: AppTextStyle.h5.copyWith(
      fontSize: 16,
      color: AppColors.textBlackColor,
      fontWeight: FontWeight.w200

    ),),
    Text("$indianCurrencySymbol $price",style:  AppTextStyle.h5.copyWith(
        fontSize: 16,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w200

    ),)
  ],
);
  }




}
