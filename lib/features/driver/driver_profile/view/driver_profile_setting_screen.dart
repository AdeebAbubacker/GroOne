import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/driver/driver_profile/cubit/driver_profile_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_switch_toggle.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/log_out_dialogue_ui.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/radio_button.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/core/localization_bloc/localization_bloc.dart';
import 'package:gro_one_app/core/localization_bloc/localization_event.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/settings_response.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class DriverProfileSettingScreen extends StatefulWidget {
  const DriverProfileSettingScreen({super.key});

  @override
  State<DriverProfileSettingScreen> createState() =>
      _DriverProfileSettingScreenState();
}

class _DriverProfileSettingScreenState
    extends State<DriverProfileSettingScreen> {
  final profileCubit = locator<ProfileCubit>();
  final driverProfileCubit = locator<DriverProfileCubit>();
  final prefs = locator<SecuredSharedPreferences>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchSettings();
    await profileCubit.fetchCustomerSettings();
    final savedLangCode = await prefs.get(
      AppString.sessionKey.selectedLanguage,
    );
    _updateLanguage(savedLangCode ?? 'English');
  });

  void disposeFunction() => frameCallback(() {
    profileCubit.resetLogoutUIState();
  });

  void deleteAccountDialogPopUp(BuildContext context) {
    AppDialog.show(
      context,
      child: BlocBuilder<DriverProfileCubit, DriverProfileState>(
        bloc: driverProfileCubit,
        builder: (context, state) {
          final isLoading =
              state.deleteAccountUIState?.status == Status.LOADING;
          return CommonDialogView(
            yesButtonText: context.appText.delete,
            noButtonText: context.appText.cancel,
            showYesNoButtonButtons: true,
            hideCloseButton: true,
            yesButtonTextStyle: OutlinedButton.styleFrom(
              backgroundColor: AppColors.red,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onClickYesButton:
                () => !isLoading ? driverProfileCubit.deleteAccount() : () {},
            yesButtonLoading: isLoading,
            child: DeleteAccountDialogueUi(),
          );
        },
      ),
    );
  }

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

          if (settingState?.status == Status.LOADING ||
              customerState?.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (settingState?.status == Status.ERROR) {
            return genericErrorWidget(
              error: settingState?.errorType ?? customerState?.errorType,
            );
          }

          final settingsList =
              (settingState?.data ?? [])
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
              children:
                  groupedSettings.entries.map((entry) {
                    final section = entry.key;
                    final settings = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: section!="Notification",
                            child: headingText(section)),
                        ...settings.map((setting) {
                          final key = setting.key;
                          final value = DriverCustomerSettingsMapper.getValue(
                            key,
                            customerData,
                            setting.defaultValue,
                          );

                          if (setting.type == 'toggle') {
                            if (setting.key == 'offers_promotions' ||
                                setting.key == 'payment_alerts') {
                              return const SizedBox.shrink();
                            }
                            return Visibility(
                              visible: section!="Notification",
                              child: toggleRow(setting.label, value == 'true', (
                                bool newVal,
                              ) {
                                final request =
                                    DriverCustomerSettingsMapper.buildRequest(
                                      key,
                                      newVal.toString(),
                                    );
                              
                                if (request != null) {
                                  profileCubit.updateCustomerSettings(
                                    request: request,
                                  );
                                }
                              }),
                            );
                          } else if (setting.type == 'radio') {
                            final options = setting.options.split(',');
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ...options.map(
                                    (opt) => languageRadio(opt, value == opt),
                                  ),
                                ],
                              ),
                            );
                          } else if (setting.type == 'link') {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                linkTile(
                                  context,
                                  icon:
                                      setting.key == 'privacy_policy'
                                          ? AppIcons.svg.privacyLock
                                          : AppIcons.svg.tAndCDoc,
                                  text: setting.label,
                                  onTap: () {
                                    if (setting.key == 'privacy_policy') {
                                      context.push(AppRouteName.privacyPolicy); 
                                    } else if (setting.key ==
                                        'terms_conditions') {
                                      context.push(AppRouteName.termsAndConditions);
                                    }
                                  },
                                ).paddingSymmetric(vertical: 20),

                                /// Delete Account not from api - appending from ui (Todo from api list)
                                if (setting.key == 'privacy_policy')
                                  BlocConsumer<
                                    DriverProfileCubit,
                                    DriverProfileState
                                  >(
                                    listener: (context, state) {
                                      final status =
                                          state.deleteAccountUIState?.status;
                                      if (status == Status.SUCCESS) {
                                          // Show toast first
                                          ToastMessages.success(
                                            message: context.appText.accountDeletedSuccessfully,
                                            duration: Duration(milliseconds: 1000)
                                            
                                          );
                                          driverProfileCubit.restState();
                                          // Delay navigation so user can see toast
                                          Future.delayed(const Duration(milliseconds: 1200), () {
                                            if (!mounted) return; 
                                            disposeFunction();
                                            LpBottomNavigation.selectedIndexNotifier.value = 0;
                                            if(!context.mounted) return;
                                            // Navigate to login screen
                                            context.go(
                                              AppRouteName.login,
                                              extra: {"showBackButton": false},
                                            );
                                          });
                                        }

                                      if (status == Status.ERROR) {
                                        final error =
                                            state
                                                .deleteAccountUIState
                                                ?.errorType;
                                        ToastMessages.error(
                                          message: getErrorMsg(
                                            errorType: error ?? GenericError(),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      return linkTile(
                                        context,
                                        icon: AppIcons.svg.delete,
                                        text: context.appText.deleteAccount,
                                        onTap:
                                            () => deleteAccountDialogPopUp(
                                              context,
                                            ),
                                        iconSize: 18,
                                        iconColor: AppColors.activeRedColor,
                                      );
                                    },
                                  ).paddingSymmetric(vertical: 20),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                       Visibility(
                         visible: section!="Notification",
                         child:  dividerWidget(),),
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
      children: [
        Text(text, style: AppTextStyle.body3),
        AppSwitchToggle(switchBool: selected, onChanged: onChanged),
      ],
    ).paddingSymmetric(vertical: 15);
  }

  Widget languageRadio(String text, bool selected) {
    return InkWell(
      onTap: () {
        _updateLanguage(text);
      },
      child: Row(
        children: [
          RadioButton(
            radioBool: selected,
            onChanged: () {
              _updateLanguage(text);
            },
          ),
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

  Widget headingText(String text) => Text(
    text,
    style: AppTextStyle.body2.copyWith(color: AppColors.textBlackDetailColor),
  );

  Widget buildLinks(BuildContext context) {
    return Column(
      children: [
        linkTile(
          context,
          icon: AppIcons.svg.tAndCDoc,
          text: context.appText.termsAndConditions.capitalizeFirst,
          onTap:
              () => context.push(AppRouteName.termsAndConditions),
        ).paddingSymmetric(vertical: 20),
        linkTile(
          context,
          icon: AppIcons.svg.privacyLock,
          text: context.appText.privacyPolicy,
          onTap: () => context.push(AppRouteName.privacyPolicy),
        ),
      ],
    );
  }

  Widget linkTile(
    BuildContext context, {
    required String icon,
    required String text,
    required VoidCallback onTap,
    double iconSize = 20,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: iconSize,
            width: iconSize,
            color: iconColor,
          ),
          const SizedBox(width: 20),
          Text(text),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: iconColor ?? AppColors.black,
          ),
        ],
      ),
    );
  }
}
