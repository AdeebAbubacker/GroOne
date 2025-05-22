import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class KavachModelsListBody extends StatelessWidget {
  const KavachModelsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
      child: Row(
        children: [
          // Kavach Image
          Image.asset(AppImage.png.kavachProduct, width: 100),
          10.width,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kavach Model 1", style: AppTextStyle.h4PrimaryColor),
              5.height,
              Text("$indianCurrencySymbol 1,499", style: AppTextStyle.h5),
            ],
          ).expand(),
          10.width,

          Icon(Icons.circle_outlined, color: AppColors.greyIconColor)

        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
