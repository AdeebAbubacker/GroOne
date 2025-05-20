import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/load_provider/home/view/home_screen_load_provider.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';

class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {

  final List<Widget> pages = [
    VpHomeScreen(),
    Center(child: Text('Loads')),
    Center(child: Text('Support')),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    setState(() {});
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label:context.appText.loads
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
    );
  }
}
