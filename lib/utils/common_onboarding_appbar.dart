import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_functions.dart';


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
            context.push(AppRouteName.chooseLanguage, extra: {"isCloseButton": true});
          },
          icon: AppIcons.svg.translation,
        ),

        // Support
        AppIconButton(
          onPressed: ()=> commonSupportDialog(context),
          icon: AppIcons.svg.support,
        ),

        InkWell(
          onTap: (){},
          child: Image.asset(AppImage.png.appIcon, width: 80, height: 30),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight
  );

}
