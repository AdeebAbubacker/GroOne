import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../kavach/view/kavach_support_screen.dart' show KavachSupportScreen;
import 'buy_new_fastag_screen.dart';

class FastagNewUserScreen extends StatelessWidget {
  const FastagNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),
            
            // Main Content - Empty State
            Expanded(
              child: _buildEmptyState(),
            ),
            
            // Footer with Branding
            buildGroBannerImageWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CommonAppBar(
                  title: Text(context.appText.fastag),
                  centreTile: false,
                  actions: [
                   AppIconButton(
                      onPressed: () {
                         Navigator.push(context,commonRoute(BuyNewFastagScreen()));
                      
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                    ),
                    4.width,
                    AppIconButton(
                      onPressed: () {
                    
                      },
                      icon: Image.asset(AppIcons.png.moreVertical),
                    ),
                  ],
                );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.png.fastagNewUser)
          
        ],
      ),
    );
  }

  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }
}