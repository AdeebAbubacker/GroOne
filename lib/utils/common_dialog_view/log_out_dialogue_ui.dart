import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:lottie/lottie.dart';

class LogOutDialogueUi extends StatelessWidget {
  const LogOutDialogueUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SvgPicture.asset(AppImage.svg.logOutImage, height: 200),

        // Title
        Text("${context.appText.logOut}?", style: AppTextStyle.h3),
        10.height,

        // Subtitle
        Text(context.appText.logoutSubHeading, style: AppTextStyle.bodyGreyColor, textAlign: TextAlign.center),
      ],
    );
  }
}


class DeleteAccountDialogueUi extends StatelessWidget {
  const DeleteAccountDialogueUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Lottie.asset(
              AppJSON.alertRed,
              repeat: true,
              frameRate: FrameRate(200),
            ),

        // Title
        Text(context.appText.deleteAccount, style: AppTextStyle.h3),
        10.height,

        // Subtitle
        Text(context.appText.deleteAccountSubHeading, style: AppTextStyle.bodyGreyColor, textAlign: TextAlign.center),
      ],
    );
  }
}