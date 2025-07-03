import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class ProfileMyAccountTile extends StatelessWidget {
  final String imageString;
  final String text;
  final GestureTapCallback onTap;
  final bool showArrow;
  const ProfileMyAccountTile({super.key, required this.imageString, required this.text, required this.onTap, this.showArrow = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        child: Row(
          children: [
            SvgPicture.asset(imageString, height: 20, width: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: showArrow
                  ? AppTextStyle.blackColor14w400
                  : AppTextStyle.blackColor14w400.copyWith(color: Colors.red),
            ),
            const Spacer(),
            if (showArrow)
               Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.greyIconColor),
          ],
        ),
      ),
    );
  }
}
