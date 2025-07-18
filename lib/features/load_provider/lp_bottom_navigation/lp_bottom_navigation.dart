import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_screen.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LpBottomNavigation extends StatefulWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  const LpBottomNavigation({super.key});

  @override
  State<LpBottomNavigation> createState() => _LpBottomNavigationState();
}

class _LpBottomNavigationState extends State<LpBottomNavigation> {
  late final ProfileCubit profileCubit;

  ProfileDetailModel? profileResponse;

  int selectedIndex = 0;

  List<String> tabTitles = [
    "Home",
    "My Loads",
    "Support",
    // "Switch Account",
  ];

  List<IconData> tabIcons = [
    CupertinoIcons.home,
    CupertinoIcons.cube,
    Icons.headset_mic_rounded,
    // Icons.compare_arrows_rounded,
  ];

  @override
  void initState() {
    // Initialize profileCubit here to ensure dependency injection is ready
    profileCubit = locator<ProfileCubit>();
    frameCallback(() {
      profileCubit.fetchUserRole();
      setState(() {});
    });
    super.initState();
  }

  final List<Widget> pages = [
    HomeScreenLoadProvider(),
    LpLoadsScreen(),
    LpSupport(showBackButton: false),
  ];

  void onItemTapped(int index) {
    int? role = profileCubit.userRole;

    debugPrint("Role : $role");

    if (index == 3 && (role != null && role == 3)) {
      context.go(AppRouteName.vpBottomNavigationBar);
    } else {
      LpBottomNavigation.selectedIndexNotifier.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {
        if (state.profileDetailUIState?.status == Status.SUCCESS) {
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

        if ((role != null && role == 3)) {
          pages.add(HomeScreenLoadProvider());
        }

        return ValueListenableBuilder<int>(
          valueListenable: LpBottomNavigation.selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            return Scaffold(
              body: pages[selectedIndex],
              //bottomNavigationBar: _buildBottomNavigationBarWidget(),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.primaryColor,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54,
                currentIndex: selectedIndex,
                onTap: onItemTapped,
                items: [
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(CupertinoIcons.home),
                    ),
                    label: context.appText.home,
                  ),

                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(CupertinoIcons.cube),
                    ),
                    label: context.appText.myLoads,
                  ),

                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(Icons.headset_mic_rounded),
                    ),
                    label: context.appText.support,
                  ),

                  if (profileCubit.userRole != null &&
                      profileCubit.userRole == 3)
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
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
      },
    );
  }

  Widget _buildBottomNavigationBarWidget() {
    return Container(
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < tabTitles.length; i++)
            InkWell(
              onTap: () {
                onItemTapped(i);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tabIcons[i],
                    color:
                        selectedIndex == i ? AppColors.white : Colors.white54,
                  ),
                  5.height,
                  Text(
                    tabTitles[i],
                    style:
                        selectedIndex == i
                            ? AppTextStyle.bodyWhiteColor
                            : AppTextStyle.body.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
        ],
      ).paddingOnly(top: 20, bottom: 30, right: 20, left: 20),
    );
  }
}
