import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/localization_bloc/localization_bloc.dart';
import 'package:gro_one_app/core/localization_bloc/localization_event.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/key_helper.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool isCloseButton;
  const ChooseLanguageScreen({super.key, this.isCloseButton = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final _languageCubit = locator<LanguageCubit>();

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = locator<SecuredSharedPreferences>();
    final savedLangCode = await prefs.get(AppString.sessionKey.selectedLanguage);

    await _languageCubit.loadLanguages();

    if (savedLangCode != null) {
      final state = _languageCubit.state;
      final index = state.languages.indexWhere(
            (lang) => lang.name.toLowerCase().startsWith(savedLangCode.toLowerCase()),
      );
      if (index != -1) {
        _languageCubit.changeIndex(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonOnboardingAppbar(
        showBackButton: false,
        showTranslateButton: false,
        isCrossLeadingIcon: widget.isCloseButton,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(commonSafeAreaPadding),
        child: BlocBuilder<LanguageCubit, LanguageState>(
          bloc: _languageCubit,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text('${context.appText.choosePreferredLanguage} ${context.appText.language}',style: AppTextStyle.textBlackColors20w400,),
                30.height,
                if (state.languages.isEmpty)
                  CircularProgressIndicator().center().expand()
                else
                  ListView.separated(
                    key: AppKeys.lst('language'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => 15.height,
                    itemCount: state.languages.length,
                    itemBuilder: (context, index) {
                      final lang = state.languages[index];
                      return chooseLanguageTile(
                        title: lang.languageText,
                        subtitle: lang.name,
                        isSelected: state.index == index,
                        imageString: getImage(lang.name),
                        onTap: () async {
                          _languageCubit.changeIndex(index);
                          final langCode = lang.name.toLowerCase().substring(0, 2);
                          context.read<LocaleBloc>().add(ChangeLocale(Locale(langCode)));
                          await locator<SecuredSharedPreferences>().saveKey(AppString.sessionKey.selectedLanguage, lang.name);
                        },
                      );
                    },
                  ).expand(),
                Column(
                  children: [
                    Text(
                      context.appText.chooseLanguage,
                      style: AppTextStyle.textDarkGreyColor14w400,
                    ).align(Alignment.center),
                    10.height,
                    AppButton(
                      key: AppKeys.btn('next'),
                      title: context.appText.next,
                      onPressed: () {
                        if (widget.isCloseButton) {
                          Navigator.of(context).pop();
                        } else {
                          context.push(AppRouteName.login);
                        }
                      },
                    ),
                    10.height,
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget chooseLanguageTile({
    required String title,
    required bool isSelected,
    required String subtitle,
    required GestureTapCallback onTap,
    required String imageString,
  }) {
    final shouldShowSubtitle = subtitle.isNotEmpty && title != 'English';

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: isSelected ? AppColors.primaryColor : AppColors.disableColor,
        ),
      ),
      child: Center(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : AppColors.disableColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            height: 18,
            width: 18,
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          title: Text(title, style: AppTextStyle.textBlackColor20w500),
          subtitle: shouldShowSubtitle
              ? Text(subtitle, style: AppTextStyle.textGreyColor14w400)
              : null,
          trailing: Image.asset(width: 78, height: 50, imageString),
        ),
      ),
    );
  }

  String getImage(String name) {
    if (name.contains('Tamil')) return AppImage.png.tamilLanguage;
    if (name.contains('Hindi')) return AppImage.png.hindiLanguage;
    return AppImage.png.englishLanguage;
  }
}
