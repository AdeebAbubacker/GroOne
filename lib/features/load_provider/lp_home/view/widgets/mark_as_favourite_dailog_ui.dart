import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class MarkAsFavouriteDialogUi extends StatefulWidget {
  const MarkAsFavouriteDialogUi({super.key});

  @override
  State<MarkAsFavouriteDialogUi> createState() => _MarkAsFavouriteDialogUiState();
}

class _MarkAsFavouriteDialogUiState extends State<MarkAsFavouriteDialogUi> {

  @override
  void initState() {
// TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
// TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() {
//  Call your init methods
  });

  void disposeFunction() => frameCallback(() {

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: AppIconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppColors.greyIconColor),
          ),
        ),
        20.height,

        // Image
        Image.asset(AppImage.png.markAsFavourite, height: 150),
        30.height,

        // Title
         Text(context.appText.markAsFavouriteTitle,  textAlign: TextAlign.center, style: AppTextStyle.h3),
        5.height,

        // Subtitle
         Text(context.appText.markAsFavouriteSubtitle, textAlign: TextAlign.center, style: AppTextStyle.bodyGreyColor),
        30.height,

        // Button
        Row(
          children: [
            AppButton(
              onPressed: (){},
              title: context.appText.no,
              style: AppButtonStyle.outline,
            ).expand(),
            15.width,

            AppButton(
              onPressed: (){},
              title: context.appText.yes,
            ).expand()
          ],
        )

      ],
    );
  }
}
