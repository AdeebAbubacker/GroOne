import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {

  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  late final ProfileCubit profileCubit;

  ProfileDetailModel? profileResponse;

  String profileImage = "";

  int selectedIndex = 0;
  int vpAllLoadsInitialTabIndex = 0;
  int bottomHt = 50;

  @override
  void initState() {
    // Initialize profileCubit here to ensure dependency injection is ready
    profileCubit = locator<ProfileCubit>();
    initFunction();
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchProfileDetail(instance: this);
    profileCubit.fetchUserRole();
    setState(() {});
  });

  void onItemTapped(int index) {
    if(index == 3) {
      AppDialog.show(context, child: CommonDialogView(
        showYesNoButtonButtons: true,
        hideCloseButton: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.switchText,
        child: Column(
          children: [
            SvgPicture.asset(AppImage.svg.switchLp),
            Text(context.appText.switchToLp, style: AppTextStyle.h3w500.copyWith(fontSize: 20, color: AppColors.black)),
            10.height,
            Text(context.appText.switchToLpDesc, textAlign: TextAlign.center, style: AppTextStyle.body3.copyWith(color: AppColors.textGreyDetailColor)),
          ],
        ),
        onClickYesButton: () {
          analyticsHelper.logEvent(AnalyticEventName.SWITCH_TO_LP);
          changeTab(index, allLoadsSubTabIndex: 0);
        },
      ));
    } else {
      changeTab(index, allLoadsSubTabIndex: 0);
    }
  }

  void changeTab(int bottomTabIndex, {int? allLoadsSubTabIndex}) {
    setState(() {
      selectedIndex = bottomTabIndex;
      if (allLoadsSubTabIndex != null) {
        vpAllLoadsInitialTabIndex = allLoadsSubTabIndex;
      } else {
        vpAllLoadsInitialTabIndex = 0;
      }
      int? role = profileCubit.userRole;

      if (selectedIndex == 3 && (role != null && role == 3)) {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    });
  }

  List<Widget> get _pages {
    return [
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
      VpAllLoadsScreen(initialTabIndex: vpAllLoadsInitialTabIndex),
      Center(child: Text(context.appText.support)),
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {
        if (state.profileDetailUIState?.status == Status.SUCCESS) {
          profileResponse = state.profileDetailUIState?.data;
          bool isKyc = profileResponse?.customer?.isKyc == 3;

          print("kyc status ${ profileResponse?.customer?.isKyc}");



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
          _pages.add(VpHomeScreen(onViewAllOrSeeMore: changeTab));
        }

        return Scaffold(
          body: _pages[selectedIndex],
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

              if (profileCubit.userRole != null && profileCubit.userRole == 3)
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.compare_arrows_rounded),
                    //child: SvgPicture.asset(AppIcons.svg.switchIcon),
                  ),
                  label: context.appText.switchAccount,
                ),
            ],
          ),
        );
      },
    );
  }
}

class VpVariables {
  static int kycStatus = 0;
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
    kycStatus = isKycStatus.toInt();
    companyId = companyId;
    profileResponse = profileDetailModel;
  }
}
