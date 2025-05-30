import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class SuccessDialogView extends StatelessWidget {
  const SuccessDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Image.asset(AppImage.png.successGif),
        SizedBox(height: 50),
        Text(
          "Load Posted Successfully",
          textAlign: TextAlign.center,
          style: AppTextStyle.greenColor20w700,
        ),
        30.height,
        Text(
          "We will assign the vehicle and\ndriver soon.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        12.height,
      ],
    );
  }
}
