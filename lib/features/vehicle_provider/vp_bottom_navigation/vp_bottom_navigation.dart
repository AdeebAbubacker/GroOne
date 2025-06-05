import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_tracking/view/vp_trip_tracking.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';

class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {

  final List<Widget> pages = [
    VpHomeScreen(),
    VpTripTracking(),
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
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.headset_mic_rounded),
            ),
            label: context.appText.support,
          ),
        ],
      ),
    );
  }
}
