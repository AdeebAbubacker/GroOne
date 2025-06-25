import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/common_widgets.dart';
import '../../../utils/app_video.dart';
import '../../../utils/constant_variables.dart';
import '../../kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import '../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../load_provider/lp_home/cubit/lp_home_cubit.dart';
import '../../load_provider/lp_home/cubit/lp_home_state.dart';
import '../../load_provider/lp_home/model/profile_detail_model.dart';
import '../../profile/view/profile_screen.dart';

class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {

  final lpHomeCubit = locator<LPHomeCubit>();

  String profileImage = "";
  ProfileDetailModel? profileResponse;
  int selectedIndex = 0;
  int vpAllLoadsInitialTabIndex = 0;
  final lpHomeBloc = locator<LpHomeBloc>();
  int bottomHt = 50;



  @override
  void initState() {
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    await lpHomeCubit.fetchProfileDetail();
    await lpHomeCubit.getBlueId();
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
    });
  }

  List<Widget> get _pages {
    return [
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
      VpAllLoadsScreen(initialTabIndex: vpAllLoadsInitialTabIndex),
      const Center(child: Text('Support')),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<LPHomeCubit, LPHomeState>(
      bloc: lpHomeCubit,
      listener: (context, state) {

        if (state.profileDetailUIState?.status==Status.SUCCESS) {
          profileResponse = state.profileDetailUIState?.data;
          bool isKyc = profileResponse?.data?.customer?.isKyc == 3;



          VpVariables.setIsKycVerified(
            isKycStatus: profileResponse?.data?.customer?.isKyc ?? 0,
            isKyc: isKyc,

            profileDetailModel: profileResponse,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.primaryColor,
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
                label: context.appText.myLoads,
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
      },
    );
  }


  // Appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      elevation: 1.0,
      isLeading: false,
      leading: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),

      actions: [

        // Notification
        IconButton(
          onPressed: () {},
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC Blinking
        BlocProvider<LPHomeCubit>.value(
          value: locator<LPHomeCubit>(), // singleton from locator
          child: BlocConsumer<LPHomeCubit, LPHomeState>(
            listener: (context, state) { },
            builder: (context, state) {
              CustomLog.debug(this, "is Kyc : ${state.profileDetailUIState?.data?.data?.customer?.isKyc}");
              if (state.profileDetailUIState != null && state.profileDetailUIState?.status == Status.SUCCESS) {
                if (state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.data != null) {
                  if (state.profileDetailUIState?.data?.data?.customer != null && state.profileDetailUIState?.data?.data?.customer?.isKyc == 3) {
                    if (state.showSuccessKyc) {
                      return 0.width;
                    } else {
                      return 0.width;
                    }
                  } else if (state.profileDetailUIState?.data?.data?.customer?.isKyc == 2){
                    return 0.width; // kycInProgressStatusWidget
                  } else {
                    return kycWidget(
                      onTap: () =>  commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet()),
                    );
                  }
                }
              }
              return 0.width;
            },
          ),
        ),

        // Profile
        BlocProvider<LPHomeCubit>.value(
          value: locator<LPHomeCubit>(), // singleton from locator
          child: BlocConsumer<LPHomeCubit, LPHomeState>(
            listener: (context, state) { },
            builder: (context, state) {
              if (state.profileDetailUIState != null && state.profileDetailUIState?.status == Status.SUCCESS) {
                if (state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.data != null) {
                  if (state.profileDetailUIState?.data?.data?.customer != null) {
                    return Row(
                      children: [
                        10.width,

                        // Profile
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.greyIconBackgroundColor),
                          child: Text(getInitialsFromName(this, name : state.profileDetailUIState!.data!.data!.customer!.customerName)),
                        ).onClick((){
                          Navigator.push(context, commonRoute(ProfileScreen(profileData: state.profileDetailUIState!.data!.data!), isForward: true)).then((v) {
                            frameCallback(() =>  lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "")));
                          });
                        }).paddingRight(commonSafeAreaPadding),
                      ],
                    );
                  }
                }
              }
              return 0.width;
            },
          ),
        ),

      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }
}

class VpVariables {
  static int isKycStatus = 0;
  static bool isKycVerified = false;
  static ProfileDetailModel? profileResponse;

  static setIsKycVerified({
    required bool isKyc,
    required num isKycStatus,
    ProfileDetailModel? profileDetailModel,
  }) {
    isKycVerified = isKyc;
    isKycStatus = isKycStatus;
    profileResponse = profileDetailModel;
  }
}
