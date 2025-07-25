import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/privacy_policy/view/privacy_polcy_screen.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/terms_and_conditions/view/terms_and_conditions_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_switch_toggle.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/radio_button.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_text_style.dart';

class LpSetting extends StatefulWidget {
  const LpSetting({super.key});

  @override
  State<LpSetting> createState() => _LpSettingState();
}

class _LpSettingState extends State<LpSetting> {
  final profileCubit = locator<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(()  {
    profileCubit.fetchCustomerSettings();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.settings, style: AppTextStyle.body1),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
        final uiState = state.customerSettingsState;

        if (uiState == null || uiState.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }

        if (uiState.status == Status.ERROR) {
          ToastMessages.error(message: getErrorMsg(errorType: uiState.errorType ?? GenericError()));
        }

        final settings = uiState.data;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText(context.appText.notification),
              ..._buildSwitches(settings),
              dividerWidget(),
              10.height,
              headingText(context.appText.language),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [context.appText.english, context.appText.english, context.appText.english].map<Widget>((lang) {
                  final selected = settings?.language.toLowerCase() == lang.toLowerCase();
                  return languageRadio(lang, selected);
                }).toList(),
              ),
              20.height,
              dividerWidget(),
              10.height,
              headingText(context.appText.security),
              toggleRow(
                context.appText.enableAppLock,
                bool.parse(settings?.enableAppLock ?? ''),
                    (value) => _updateSetting(enableAppLock: value),
              ),
              dividerWidget(),
              buildLinks(context),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildSwitches(dynamic settings) {
    return [
      toggleRow(context.appText.loadUpdates, bool.parse(settings?.loadUpdates ?? ''), (value) => _updateSetting(loadUpdates: value)),
      toggleRow(context.appText.systemUpdates, bool.parse(settings?.systemUpdates ?? ''), (value) => _updateSetting(systemUpdates: value)),
      toggleRow(context.appText.paymentAlerts, bool.parse(settings?.paymentAlerts ?? ''), (value) => _updateSetting(paymentAlerts: value)),
      toggleRow(context.appText.offersAndPromotions, bool.parse(settings?.offersPromotions ?? ''), (value) => _updateSetting(offersPromotions: value)),
    ];
  }

  Widget toggleRow(String text, bool selected, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(text, style: AppTextStyle.body3), AppSwitchToggle(switchBool: selected, onChanged: onChanged)],
    ).paddingSymmetric(vertical: 15);
  }

  Widget languageRadio(String text, bool selected) {
    return InkWell(
      onTap: () {
        profileCubit.updateCustomerSettings(request: UpdateSettingsRequest(language: text));
        setState(() {});
      },
      child: Row(
        children: [
          RadioButton(radioBool: selected, onChanged: () {
            profileCubit.updateCustomerSettings(request: UpdateSettingsRequest(language: text));
            setState(() {});
          }),
          10.width,
          Text(text, style: AppTextStyle.blackColor14w400),
        ],
      ),
    );
  }

  Widget headingText(String text) =>
      Text(text, style: AppTextStyle.body2.copyWith(color: AppColors.textBlackDetailColor));

  Widget buildLinks(BuildContext context) {
    return Column(
      children: [
        linkTile(
          context,
          icon: AppIcons.svg.tAndCDoc,
          text: context.appText.termsAndConditions.capitalizeFirst,
          onTap: () => Navigator.push(context, commonRoute(TermsAndConditionsScreen())),
        ).paddingSymmetric(vertical: 20),
        linkTile(
          context,
          icon: AppIcons.svg.privacyLock,
          text: context.appText.privacyPolicy,
          onTap: () => Navigator.push(context, commonRoute(PrivacyPolicyScreen())),
        ),
      ],
    );
  }

  Widget linkTile(BuildContext context, {required String icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon, height: 20, width: 20),
          20.width,
          Text(text),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 12),
        ],
      ),
    );
  }

  void _updateSetting({
    bool? loadUpdates,
    bool? systemUpdates,
    bool? paymentAlerts,
    bool? offersPromotions,
    bool? enableAppLock,
  }) {
    profileCubit.updateCustomerSettings(
      request: UpdateSettingsRequest(
        loadUpdates: loadUpdates?.toString(),
        systemUpdates: systemUpdates?.toString(),
        paymentAlerts: paymentAlerts?.toString(),
        offersPromotions: offersPromotions?.toString(),
        enableAppLock: enableAppLock?.toString(),
      ),
    );
  }
}
