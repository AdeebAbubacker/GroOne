import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/app_lock_screen/app_lock_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_screen.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extra_utils.dart';


class LpBottomNavigation extends StatefulWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

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
      builder: (BuildContext context) {
        return showAlertDialogue(
          yesButtonText: "Exit",
          context: context,
          onClickYesButton: () {
            context.pop();
            SystemNavigator.pop();
          },
          child: Column(
            spacing: 20,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 24),
                ),
              ),
              Image.asset(
                AppImage.png.markAsFavourite,
                height: 150,
              ),
              const Text(
                "Are you sure want to exit?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
      child: AppLockScreen(
        child: ValueListenableBuilder<int>(
          valueListenable: LpBottomNavigation.selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            return Scaffold(
              body: pages[selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.primaryColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                currentIndex: selectedIndex,
                onTap: (index) {
                  LpBottomNavigation.selectedIndexNotifier.value = index;
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(CupertinoIcons.home),
                    ),
                    label: context.appText.home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(CupertinoIcons.cube),
                    ),
                    label: context.appText.loads,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Icons.headset_mic_rounded),
                    ),
                    label: context.appText.support,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
