import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';


class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {

  final profileCubit = locator<ProfileCubit>();

  ProfileDetailModel? profileResponse;

  String profileImage = "";

  int selectedIndex = 0;
  int vpAllLoadsInitialTabIndex = 0;
  int bottomHt = 50;



  @override
  void initState() {
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    profileCubit.fetchUserRole();
    await profileCubit.fetchProfileDetail();
    setState(() {});
  });


  void onItemTapped(int index) {
    changeTab(index, allLoadsSubTabIndex: 0);
  }

  void changeTab(int bottomTabIndex, {int? allLoadsSubTabIndex}) {
    setState(() {
      selectedIndex = bottomTabIndex;
      if (allLoadsSubTabIndex != null) {
        vpAllLoadsInitialTabIndex = allLoadsSubTabIndex;
      } else {
        vpAllLoadsInitialTabIndex = 0;
      }
      debugPrint("Selective Index : $selectedIndex");

      int? role = profileCubit.userRole;

      if(selectedIndex == 3 && (role != null && role == 3)) {
        context.go(AppRouteName.lpBottomNavigationBar);
      }

    });
  }

  List<Widget> get _pages {
    return [
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
      VpAllLoadsScreen(initialTabIndex: vpAllLoadsInitialTabIndex),
      const Center(child: Text('Support')),
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {

        if (state.profileDetailUIState?.status==Status.SUCCESS) {
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
          _pages.add(VpHomeScreen(onViewAllOrSeeMore: changeTab));
        }

        return Scaffold(
          body: _pages[selectedIndex],
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

              if (profileCubit.userRole != null && profileCubit.userRole == 3)
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

class VpVariables {
  static int isKycStatus = 0;
  static bool isKycVerified = false;
  static num? companyId;
  static ProfileDetailModel? profileResponse;

  static setIsKycVerified({
    required bool isKyc,
    required num isKycStatus,
    required num companyId,
    ProfileDetailModel? profileDetailModel,
  }) {
    isKycVerified = isKyc;
    isKycStatus = isKycStatus;
    companyId = companyId;
    profileResponse = profileDetailModel;
  }
}
