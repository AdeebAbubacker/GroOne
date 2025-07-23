import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class LpBottomNavigation extends StatefulWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  const LpBottomNavigation({super.key});

  @override
  State<LpBottomNavigation> createState() => _LpBottomNavigationState();
}

class _LpBottomNavigationState extends State<LpBottomNavigation> {
  late final ProfileCubit profileCubit;

  ProfileDetailModel? profileResponse;

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

    if (index == 3 && (role != null && role == 3)) {
      AppDialog.show(context, child: CommonDialogView(
        showYesNoButtonButtons: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.switchText,
        child: Column(
          children: [
            SvgPicture.asset(AppImage.svg.switchVp),
            Text(context.appText.switchToVp, style: AppTextStyle.h3w500.copyWith(fontSize: 20, color: AppColors.black)),
            10.height,
            Text(context.appText.switchToVpDesc, textAlign: TextAlign.center, style: AppTextStyle.body3.copyWith(color: AppColors.textGreyDetailColor)),
            10.height,
          ],
        ),
        onClickYesButton: () {
          context.go(AppRouteName.vpBottomNavigationBar);
        },
      ));
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

        if ((role != null && role == 3)) {
          pages.add(HomeScreenLoadProvider());
        }

        return ValueListenableBuilder<int>(
          valueListenable: LpBottomNavigation.selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            return Scaffold(
              body: pages[selectedIndex],
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
                      ),
                      label: context.appText.switchAccount,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
