import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../core/localization_bloc/localization_bloc.dart';
import '../../../core/localization_bloc/localization_event.dart';
import '../../../routing/app_route_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_string.dart';
import '../../../utils/customButton.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key, this.isCloseButton = false});
  final bool isCloseButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(commonSafeAreaPadding),
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.height,

                // App bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(isCloseButton)
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.clear),
                      )
                    else
                      10.width,

                    Image.asset(
                      AppImage.png.appIcon,
                      width: 74.25.w,
                      height: 33.h,
                    ),
                  ],
                ),
                30.height,


                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: context.appText.choosePreferredLanguage,
                        style: AppTextStyle.textBlackColors20w400,
                      ),
                      TextSpan(
                        text: " ${context.appText.language}",
                        style: AppTextStyle.textBlackColor20w500,
                      ),
                    ],
                  ),
                ),
                20.height,


                chooseLanguageTile(
                  isSelected: state.index == 0 ? true : false,
                  text1: AppString.label.english,
                  text2: AppString.label.english,
                  onTap: () {
                    context.read<LanguageBloc>().add(
                      const ChangeIndex(index: 0),
                    );
                    context.read<LocaleBloc>().add(
                      ChangeLocale(const Locale('en')),
                    );
                  },
                  imageString: AppImage.png.englishLanguage,
                ),
                20.height,

                chooseLanguageTile(
                  isSelected: state.index == 1 ? true : false,
                  text1: AppString.label.hindi2,
                  text2: AppString.label.hindi,
                  onTap: () {
                    // context.read<LanguageBloc>().add(
                    //   const ChangeIndex(index: 1),
                    // );
                    // context.read<LocaleBloc>().add(ChangeLocale(const Locale('hi')));
                  },
                  imageString: AppImage.png.hindiLanguage,
                ),
                20.height,

                chooseLanguageTile(
                  isSelected: state.index == 2 ? true : false,
                  text1: AppString.label.tamil,
                  text2: AppString.label.tamil2,
                  onTap: () {
                    // context.read<LanguageBloc>().add(
                    //   const ChangeIndex(index: 2),
                    // );
                    // context.read<LocaleBloc>().add(ChangeLocale(const Locale('ta')));
                  },
                  imageString: AppImage.png.tamilLanguage,
                ),

                Expanded(child: SizedBox()),


                Column(
                  children: [

                    Text(
                      context.appText.chooseLanguage,
                      style: AppTextStyle.textDarkGreyColor14w400,
                    ).align(Alignment.center),
                    10.height,

                    AppButton(
                      title: context.appText.next,
                      onPressed: () {
                        context.push(AppRouteName.chooseRoleScreen);
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
    required String text1,
    required bool isSelected,
    required String text2,
    required GestureTapCallback onTap,
    required String imageString,
  }) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
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
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : AppColors.disableColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            height: 18.h,
            width: 18.w,
            padding: EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          subtitle:
              text2.isNotEmpty
                  ? Text(text2, style: AppTextStyle.textGreyColor14w400)
                  : null,
          title: Text(text1, style: AppTextStyle.textBlackColor20w500),
          trailing: Image.asset(width: 78.w, height: 50.h, imageString),
        ),
      ),
    );
  }
}
