import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/view/support/view/lp_support.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/extra_utils.dart';
import '../../lp_home/view/home_screen_load_provider.dart';

class LpBottomNavigation extends StatefulWidget {
  const LpBottomNavigation({super.key});

  @override
  State<LpBottomNavigation> createState() => _LpBottomNavigationState();
}

class _LpBottomNavigationState extends State<LpBottomNavigation> {
  final List<Widget> pages = [
    HomeScreenLoadProvider(),
    LpLoadsScreen(),
    LpSupport(showBackButton: false),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    setState(() {});
  }

  int selectedIndex = 0;

  showExitDialogue({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Dismiss only with button if needed
      builder: (BuildContext context) {
        return showAlertDialogue(
          yesButtonText: "Log Out",
          context: context,
          onClickYesButton: () {
            context.pop();
            SystemNavigator.pop();
          },
          child: Column(
            spacing: 20.h,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 24),
                ),
              ),

              // Illustration
              Image.asset(
                AppImage.png.markAsFavourite,
                // replace with your image asset
                height: 150,
              ),

              // Title
              const Text(
                "Are you sure want to exit?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // Subtitle
              const Text(
                "",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitDialogue(context: context);
        return true;
      },
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
          // Bright blue
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.home),
              ),
              label: context.appText.home,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  AppImage.png.loadImage,
                  height: 22.h,
                  width: 22.w,
                ),
              ),
              label: context.appText.loads,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.headset_mic_outlined),
              ),
              label: context.appText.support,
            ),
          ],
        ),
      ),
    );
  }
}
