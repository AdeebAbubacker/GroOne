import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/fleet_my_orders/views/fleet_my_orders_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_loads_screen.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
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

class LpBottomNavigation extends StatefulWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  const LpBottomNavigation({super.key});

  @override
  State<LpBottomNavigation> createState() => _LpBottomNavigationState();
}

class _LpBottomNavigationState extends State<LpBottomNavigation> {

  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  late final ProfileCubit profileCubit;

  ProfileDetailModel? profileResponse;

  final List<int> _navigationHistory = [0]; // start with home tab


  final documentTypeCubit=locator<DocumentTypeCubit>();

  @override
  void initState() {
    // Initialize profileCubit here to ensure dependency injection is ready
    profileCubit = locator<ProfileCubit>();
    frameCallback(() {
      profileCubit.fetchUserRole();
      setState(() {});
    });
    profileCubit.switchToVp(false);
    documentTypeCubit.getDocumentTypeList();
    super.initState();
  }


  void onItemTapped(int index) {
    int? role = profileCubit.userRole;

    if (index == 3 && (role != null && role == 3)) {
      AppDialog.show(context, child: CommonDialogView(
        showYesNoButtonButtons: true,
        hideCloseButton: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.switchText,
        child: Column(
          children: [
            SvgPicture.asset(AppImage.svg.switchVp),
            Text(context.appText.switchToVp, style: AppTextStyle.h3w500.copyWith(fontSize: 20, color: AppColors.black)),
            10.height,
            Text(context.appText.switchToVpDesc, textAlign: TextAlign.center, style: AppTextStyle.body3.copyWith(color: AppColors.textGreyDetailColor)),
          ],
        ),
        onClickYesButton: () {
          profileCubit.switchToVp(true);
          analyticsHelper.logEvent(AnalyticEventName.SWITCH_TO_VP);
          context.go(AppRouteName.vpBottomNavigationBar);
        },
      ));
    } else {
      if (LpBottomNavigation.selectedIndexNotifier.value != index) {
        _navigationHistory.add(index); // push to history
      }
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

        final List<Widget> pages = [
          HomeScreenLoadProvider(),
          if (role == 4)
           FleetMyOrdersScreen()
          else
           LpLoadsScreen(),
          LpSupport(showBackButton: false),
        ];

        if ((role != null && role == 3)) {
          pages.add(HomeScreenLoadProvider());
        }

        return ValueListenableBuilder<int>(
          valueListenable: LpBottomNavigation.selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            final safeIndex = selectedIndex.clamp(0, pages.length - 1);

            return WillPopScope(
                onWillPop: () async {
              if (_navigationHistory.length > 1) {
                _navigationHistory.removeLast();
                LpBottomNavigation.selectedIndexNotifier.value = _navigationHistory.last;
                return false; // prevent app exit
              }
              return true; // allow app to exit
            },
            child: Scaffold(
                  body: pages[safeIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: AppColors.primaryColor,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppColors.white,
                    unselectedItemColor: Colors.white54,
                    currentIndex: safeIndex,
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
                        label: role == 4 ? context.appText.myOrders : context.appText.myLoads,
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
                )
            );
          },
        );
      },
    );
  }
}
