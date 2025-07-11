import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_screen.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';


class BothBottomNavigation extends StatefulWidget {
  const BothBottomNavigation({super.key});

  @override
  State<BothBottomNavigation> createState() => _BothBottomNavigationState();
}

class _BothBottomNavigationState extends State<BothBottomNavigation> {

  final profileCubit = locator<ProfileCubit>();
  ProfileDetailModel? profileResponse;

  @override
  void initState() {
    // TODO: implement initState
    frameCallback((){
      profileCubit.fetchUserRole();
    });
    super.initState();
  }

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


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {

        if (state.profileDetailUIState?.status== Status.SUCCESS) {
          profileResponse = state.profileDetailUIState?.data;
          bool isKyc = profileResponse?.customer?.isKyc == 3;

          VpVariables.setIsKycVerified(
            isKycStatus: profileResponse?.customer?.isKyc ?? 0,
            isKyc: isKyc,
            companyId: profileResponse?.customer?.companyTypeId ?? 0,
            profileDetailModel: profileResponse,
          );
        }
      },
      builder: (context, state) {

        int? role = profileCubit.userRole;

        debugPrint("Role : $role");

        if((role != null && role == 3)) {
          pages.add(HomeScreenLoadProvider());
        }

        return Scaffold(
          body: pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            //backgroundColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.greyIconColor,
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
                label: context.appText.myLoads,
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.headset_mic_rounded),
                ),
                label: context.appText.support,
              ),

                BottomNavigationBarItem(
                  icon:  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.compare_arrows_rounded),
                    //child: SvgPicture.asset(AppIcons.svg.switchIcon),
                  ),
                  label: "Switch Account",
                ),
            ],
          ),
        );
      },
    );
  }
}
