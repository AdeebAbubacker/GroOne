import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_switch_toggle.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/radio_button.dart';

import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_image.dart';
import '../../../../../../utils/app_text_style.dart';

class LpSetting extends StatefulWidget {
  const LpSetting({super.key});

  @override
  State<LpSetting> createState() => _LpSettingState();
}

class _LpSettingState extends State<LpSetting> {
  bool loadUpdate = false;
  bool systemUpdates = false;
  bool paymentAlerts = false;
  bool offerPromotions = false;
  bool enableAppLock = false;
  bool english = true;
  bool hindi = false;
  bool tamil = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          context.appText.settings,
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30.h,
          children: [
            headingText(text: "Notification"),
            10.width,

            notificationSwitchWidget(
              text: "Load Updates",
              selected: loadUpdate,
              onChange: (value) {
                loadUpdate = value;
                setState(() {});
              },
            ),
            notificationSwitchWidget(
              text: "System Updates",
              selected: systemUpdates,
              onChange: (value) {
                systemUpdates = value;
                setState(() {});
              },
            ),
            notificationSwitchWidget(
              text: "Payment Alerts",
              selected: paymentAlerts,
              onChange: (value) {
                paymentAlerts = value;
                setState(() {});
              },
            ),
            notificationSwitchWidget(
              text: "Offers & Promotions",
              selected: offerPromotions,
              onChange: (value) {
                offerPromotions = value;
                setState(() {});
              },
            ),
            dividerWidget(),
            headingText(text: context.appText.language),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                languageRadioButtonWidget(
                  text: "English",
                  onTap: () {
                    english = true;
                    if (english = true) {
                      hindi = false;
                      tamil = false;
                    }
                    setState(() {

                    });
                  },
                  selected: english,
                ),
                languageRadioButtonWidget(text: "Hindi",selected: hindi, onTap: () { hindi = true;
                if (hindi = true) {
                  english = false;
                  tamil = false;
                }
                setState(() {

                });}),
                languageRadioButtonWidget(text: "Tamil",selected: tamil, onTap: () {
                  tamil = true;
                  if (tamil = true) {
                    hindi = false;
                    english = false;
                  }   setState(() {

                  });
                }),
              ],
            ),
            dividerWidget(),
            headingText(text: "Security"),
            notificationSwitchWidget(
              text: "Enable App Lock",
              selected: enableAppLock,
              onChange: (value) {
                enableAppLock = value;
                setState(() {});
              },
            ),
            Column(
              children: [
                profileWidget(
                  imageString: AppImage.png.document,
                  text: "Terms & Conditions",
                  onTap: () {},
                ),
                profileWidget(
                  imageString: AppImage.png.privacy,
                  text: "Privacy Policy",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  languageRadioButtonWidget({
    required String text,
    bool selected = false,
    required GestureTapCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          RadioButton(radioBool: selected, onChanged: onTap),
          10.width,
          Text(text, style: AppTextStyle.blackColor14w400),
        ],
      ),
    );
  }

  notificationSwitchWidget({
    required String text,
    bool selected = false,
    required Function(bool) onChange,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: AppTextStyle.textBlackDetailColor14w400),

        AppSwitchToggle(switchBool: selected, onChanged: onChange),
      ],
    );
  }
}
