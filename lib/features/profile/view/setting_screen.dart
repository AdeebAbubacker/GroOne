import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/core/localization_bloc/localization_bloc.dart';
import 'package:gro_one_app/core/localization_bloc/localization_event.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/privacy_policy/view/privacy_polcy_screen.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/settings_response.dart';
import 'package:gro_one_app/features/terms_and_conditions/view/terms_and_conditions_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_switch_toggle.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/radio_button.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_text_style.dart';

class LpSetting extends StatefulWidget {
  const LpSetting({super.key});

  @override
  State<LpSetting> createState() => _LpSettingState();
}

class _LpSettingState extends State<LpSetting> {
  final profileCubit = locator<ProfileCubit>();
  final prefs = locator<SecuredSharedPreferences>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(()  async{
    await profileCubit.fetchSettings();
    await profileCubit.fetchCustomerSettings();
    final savedLangCode = await prefs.get(AppString.sessionKey.selectedLanguage);
    _updateLanguage(savedLangCode ?? '');
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.settings, style: AppTextStyle.body1),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final settingState = state.settingsState;
          final customerState = state.customerSettingsState;

          if (settingState?.status == Status.LOADING || customerState?.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (settingState?.status == Status.ERROR) {
            return genericErrorWidget(error: settingState?.errorType ?? customerState?.errorType);
          }

          final settingsList = (settingState?.data ?? [])
              .where((element) => element.section != "Security")
              .toList();

          final customerData = customerState?.data;

          // Group settings by section
          final Map<String, List<SettingsResponse>> groupedSettings = {};
          for (var setting in settingsList) {
            groupedSettings.putIfAbsent(setting.section, () => []).add(setting);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: ListView(
              children: groupedSettings.entries.map((entry) {
                final section = entry.key;
                final settings = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(section),
                    ...settings.map((setting) {
                      final key = setting.key;
                      final value = CustomerSettingsMapper.getValue(key, customerData, setting.defaultValue);


                      if (setting.type == 'toggle') {
                        if (setting.key == 'offers_promotions') {
                          return const SizedBox.shrink();
                        }
                        return toggleRow(
                          setting.label,
                          value == 'true',
                              (bool newVal) {
                                final request = CustomerSettingsMapper.buildRequest(key, newVal.toString());

                            if (request != null) {
                              profileCubit.updateCustomerSettings(request: request);
                            }
                          },
                        );
                      } else if (setting.type == 'radio') {
                        final options = setting.options.split(',');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...options.map((opt) => languageRadio(opt, value == opt))
                            ],
                          ),
                        );
                      } else if (setting.type == 'link') {
                        return linkTile(
                          context,
                          icon: setting.key == 'privacy_policy'
                              ? AppIcons.svg.privacyLock
                              : AppIcons.svg.tAndCDoc,
                          text: setting.label,
                          onTap: () {
                            if (setting.key == 'privacy_policy') {
                              Navigator.push(context, commonRoute(PrivacyPolicyScreen()));
                            } else if (setting.key == 'terms_conditions') {
                              Navigator.push(context, commonRoute(TermsAndConditionsScreen()));
                            }
                          },
                        ).paddingSymmetric(vertical: 20);
                      } else {
                        return const SizedBox();
                      }
                    }),
                    dividerWidget(),
                    10.height,
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
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
        _updateLanguage(text);
      },
      child: Row(
        children: [
          RadioButton(radioBool: selected, onChanged: () {
            _updateLanguage(text);
          }),
          Text(text, style: AppTextStyle.blackColor14w400),
        ],
      ),
    );
  }
  void _updateLanguage(String languageCode) async {
    final locale = Locale(languageCode.toLowerCase().substring(0, 2));
    final localeBloc = context.read<LocaleBloc>();

    profileCubit.updateCustomerSettings(
      request: UpdateSettingsRequest(language: languageCode),
    );

    await prefs.saveKey(AppString.sessionKey.selectedLanguage, languageCode);
    localeBloc.add(ChangeLocale(locale));
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
}