import 'package:flutter/material.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';


class CommonOnboardingAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool? showBackButton;
  final bool? showTranslateButton;
  final bool? isCrossLeadingIcon;
  const CommonOnboardingAppbar({super.key,  this.showBackButton = true, this.showTranslateButton = true, this.isCrossLeadingIcon = false});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      scrolledUnderElevation: 0.0,
      isLeading: isCrossLeadingIcon! ? isCrossLeadingIcon : showBackButton,
      isCrossLeadingIcon: isCrossLeadingIcon!,
      actions: [

        // Language Selection
        if(showTranslateButton!)
        AppIconButton(
          onPressed: (){
            Navigator.push(context, commonRoute(ChooseLanguageScreen(isCloseButton: true)));
          },
          icon: AppIcons.svg.translation,
        ),

        // Support
        AppIconButton(
          onPressed: ()=> commonSupportDialog(context),
          icon: AppIcons.svg.support,
        ),
        20.width,

        InkWell(
          onTap: (){
            Navigator.of(context).push(commonRoute(LpBottomNavigation()));
          },
          child: Image.asset(AppImage.png.appIcon, width: 80),
        ),
        20.width,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight
  );

}
