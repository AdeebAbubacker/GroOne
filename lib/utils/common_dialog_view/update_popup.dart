import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/global_variables.dart' hide isAndroid;
import 'package:url_launcher/url_launcher.dart';

import '../app_image.dart';
import 'common_dialog_view.dart';


showUpdatePopUp(update) {
  AppDialog.show(
    appContext,
    blurBackground: true,
    child: CommonDialogView(
      hideCloseButton: true,
      onSingleButtonText: appContext.appText.updateNow,
      onTapSingleButton: () {
        launchUrl(Uri.parse(isAndroid ? playStoreUrl : appStoreUrl));
      },
      child: Column(
        children: [
          SvgPicture.asset(AppImage.svg.customerSupport, width: 200),
          Text(
            appContext.appText.updateRequired,
            style: AppTextStyle.h4,
          ),
          10.height,
          Text.rich(
            TextSpan(
              text: appContext.appText.updateAppText1,
              style: AppTextStyle.h5,
              children: [
                TextSpan(
                  text: update.version,
                  style: AppTextStyle.h4,
                ),
                TextSpan(text: appContext.appText.updateAppText2,
                    style: AppTextStyle.h5),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}