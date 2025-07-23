import 'package:flutter/material.dart';
import 'package:gro_one_app/features/privacy_policy/view/privacy_polcy_screen.dart';
import 'package:gro_one_app/features/profile/view/widgets/profile_my_account_tile.dart';
import 'package:gro_one_app/features/terms_and_conditions/view/terms_and_conditions_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_switch_toggle.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/radio_button.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_style.dart';

class DriverProfileSettingScreen extends StatefulWidget {
  const DriverProfileSettingScreen({super.key});

  @override
  State<DriverProfileSettingScreen> createState() => _DriverProfileSettingScreenState();
}

class _DriverProfileSettingScreenState extends State<DriverProfileSettingScreen> {
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
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          context.appText.settings,
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
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
                  ProfileMyAccountTile(
                    imageString:  AppIcons.svg.tAndCDoc,
                    text: "Terms & Conditions",
                    onTap: () {
                        Navigator.of(context).push(commonRoute(TermsAndConditionsScreen(), isForward: true));
                    },
                  ),
                  ProfileMyAccountTile(
                    imageString:  AppIcons.svg.privacyLock,
                    text: "Privacy Policy",
                    onTap: () {
                        Navigator.of(context).push(commonRoute(PrivacyPolicyScreen(), isForward: true));
                    },
                  ),
                ],
              ),
            ],
          ),
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
