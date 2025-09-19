import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

/// Master Address Widget
Widget masterInfoWidget({
  required String title,
  required String address,
  required bool isPrimary,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  required VoidCallback onSetPrimary,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: commonContainerDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyle.h5).expand(),
            Spacer(),
            IconButton(
              onPressed: onEdit,
              icon: SvgPicture.asset(
                AppIcons.svg.edit,
                color: AppColors.primaryColor,
              ),
              splashRadius: 20,
            ),
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
        4.height,
        Text(
          address,
          style: AppTextStyle.body3.copyWith(
            color: AppColors.lightGreyTextColor,
          ),
        ),

        15.height,

        InkWell(
          onTap: () => onSetPrimary(),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: commonContainerDecoration(
                  borderColor: AppColors.primaryColor,
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(5),
                ),
                child:
                    isPrimary
                        ? Center(child: Icon(Icons.check, size: 15))
                        : const SizedBox(),
              ),
              10.width,
              Text(
                isPrimary
                    ? context.appText.primaryAddress
                    : context.appText.setAsPrimaryAddress,
                style: AppTextStyle.body3PrimaryColor.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ).expand(),
            ],
          ),
        ),
        10.height,
      ],
    ),
  );
}
