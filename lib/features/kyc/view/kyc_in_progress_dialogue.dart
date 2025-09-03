import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class KycInProgressDialogue extends StatelessWidget {
  const KycInProgressDialogue({super.key,required this.onPressed});
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        20.height,
        SvgPicture.asset(AppImage.svg.kycPending, width: 150),
        30.height,
        Text(context.appText.kycInProgressText,style: AppTextStyle.orangeTextColor26w700),
        10.height,
        Text(context.appText.youCanPostOnlyOneLoad,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyGreyColor,
        ),
        40.height,
        AppButton(
          onPressed: onPressed,
          title: context.appText.continueText,
        )

      ],
    );
  }
}
