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
    return SizedBox(
      height: 40,
      child: ListTile(
        minLeadingWidth: 0,
        onTap: onTap,
        leading: SvgPicture.asset(imageString, height: 20, width: 20),
        title:  Text(
          text,
            style : AppTextStyle.body3.copyWith(color: showArrow ? AppColors.black : AppColors.red)
        ),
        trailing: showArrow ? Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.greyIconColor) : null,
      ),
    );
  }
}
