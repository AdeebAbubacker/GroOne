
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

/// Master Vehicle Widget
Widget masterVehicleInfoWidget({
  required String name,
  required String phone,
  required int driverStatus,
  // required VoidCallback onEdit,
  required VoidCallback onDelete,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              child: SvgPicture.asset(
                AppIcons.svg.truck,
                color: AppColors.primaryColor,
              ),
            ),
            10.width,

            // Name, Verified and Phone Number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: AppTextStyle.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: AppColors.textBlackDetailColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      6.width,
                      SvgPicture.asset(AppIcons.svg.tick),
                    ],
                  ),
                  4.height,
                  Text(
                    phone,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Active Tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          driverStatus == 1
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      driverStatus == 1
                          ? context.appText.active
                          : context.appText.inactive,
                      style: AppTextStyle.body.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color:
                            driverStatus == 1
                                ? Color(0XFF0E6027)
                                : Color(0XFFE31B25),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   onPressed: onEdit,
                      //   icon: SvgPicture.asset(
                      //     AppIcons.svg.edit,
                      //     color: AppColors.primaryColor,
                      //   ),
                      //   splashRadius: 20,
                      // ),
                      IconButton(
                        onPressed: onDelete,
                        icon: SvgPicture.asset(
                          AppIcons.svg.delete,
                          color: AppColors.iconRed,
                        ),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        8.height,
      ],
    ),
  );
}
