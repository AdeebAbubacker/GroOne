import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class EndhanCardItem extends StatelessWidget {
  final Map<String, dynamic> card;
  const EndhanCardItem({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        shadow: true
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'DIGITAL CARD',
              style: AppTextStyle.body4.copyWith(
                color: AppColors.greyTextColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          10.height,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  card['image'],
                  width: 70,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),

              12.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['cardNumber'],
                    style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                  2.height,
                  Text(
                    card['vehicleNumber'],
                    style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ).expand(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: commonContainerDecoration(
                      color: AppColors.boxGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card['status'],
                      style: AppTextStyle.body3.copyWith(
                        color: AppColors.textGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),


          12.height,
          Divider(),
          Row(
            children: [
              /// TODO: Add amount and date time later
              // Text(
              //   card['amount'],
              //   style: AppTextStyle.h5.copyWith(
              //     color: AppColors.primaryColor,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
             // 4.width,
              // Icon(Icons.refresh, color: AppColors.textBlackColor, size: 18),
              // const Spacer(),
              Text(
                'Mob Num: ',
                style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
              ),
              Text(
                card['mobile'],
                style: AppTextStyle.body3.copyWith(
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          8.height,
          // Text(
          //   card['dateTime'],
          //   style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
          // ),
        ],
      ).paddingAll(12.0),
    );
  }
}
