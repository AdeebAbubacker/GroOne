import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/helper/product_counter.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
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
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
      child: Row(
        children: [
          // Kavach Image
          Image.asset(AppImage.png.kavachProduct, width: 80),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Model Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("eN-Dhan Kavach", style: AppTextStyle.h5),
                  5.width,
                  SvgPicture.asset(AppIcons.svg.infOutline, width: 15, colorFilter: AppColors.svg(AppColors.greyIconColor),)
                ],
              ),
              Text("CS01K0001", style: AppTextStyle.bodyGreyColor),

              5.height,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$indianCurrencySymbol 1,499", style: AppTextStyle.h4PrimaryColor),
                      Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
                    ],
                  ).expand(),

                  // Counter
                  ProductCounter(
                    count: 1,
                    onIncrement: () {

                    },
                    onDecrement: () {

                    },
                  ),
                ],
              ),

            ],
          ).expand(),


        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
