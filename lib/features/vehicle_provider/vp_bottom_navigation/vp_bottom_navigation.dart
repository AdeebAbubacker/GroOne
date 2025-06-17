import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:video_player/video_player.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/toast_messages.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/app_video.dart';
import '../../kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import '../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../load_provider/lp_home/model/profile_detail_response_model.dart';
import '../../profile/view/profile_screen.dart';


class VPBottomNavigationBar extends StatefulWidget {
  const VPBottomNavigationBar({super.key});

  @override
  State<VPBottomNavigationBar> createState() => _VPBottomNavigationBarState();
}

class _VPBottomNavigationBarState extends State<VPBottomNavigationBar> {
  String profileImage = "";
  ProfileDetailModel? profileResponse;
  int selectedIndex = 0;
  int vpAllLoadsInitialTabIndex = 0;
  final lpHomeBloc = locator<LpHomeBloc>();
  late VideoPlayerController _controller;

  @override
  void initState() {
    initializeVideoPlayer(context);
    initFunction();
    super.initState();
  }

  void initializeVideoPlayer(BuildContext context){
    _controller = VideoPlayerController.asset(AppVideo.kycBlinking)
      ..initialize().then((_) {
        if (mounted) {
          _controller.play();
        }
        setState(() {});
      });
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration && _controller.value.isInitialized && mounted) {
        _controller.play();
        setState(() {});
      }
    });
  }

  // void initFunction() => frameCallback(() async {
  //   await lpHomeBloc.getUserId() ?? "";
  //
  //   final completer = Completer();
  //   final subscription = lpHomeBloc.stream.listen((state) {
  //     if (state is ProfileDetailSuccess) {
  //       profileResponse = state.profileDetailResponse;
  //       completer.complete();
  //     }
  //   });
  //   lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
  //   await completer.future;
  //   await subscription.cancel();
  // });

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";

    final completer = Completer();
    final subscription = lpHomeBloc.stream.listen((state) {
      if (state is ProfileDetailSuccess) {
        profileResponse = state.profileDetailResponse;
        bool isKyc = profileResponse?.data?.customer?.isKyc==3;
        VpVariables.setIsKycVerified(isKyc);
        completer.complete();
      }
    });
    lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
    await completer.future;
    await subscription.cancel();
  });



  // final List<Widget> pages = [
  //   VpHomeScreen(),
  //   VpAllLoadsScreen(),
  //   Center(child: Text('Support')),
  // ];

  // void onItemTapped(int index) {
  //   selectedIndex = index;
  //   setState(() {});
  // }
  void onItemTapped(int index) {
    changeTab(index, allLoadsSubTabIndex: 0);
  }

  void changeTab(int bottomTabIndex, {int? allLoadsSubTabIndex}) {
    setState(() {
      selectedIndex = bottomTabIndex;
      if (allLoadsSubTabIndex != null) {
        vpAllLoadsInitialTabIndex = allLoadsSubTabIndex;
      } else {
        vpAllLoadsInitialTabIndex = 0; // Reset or set a default if not specified
      }
    });
  }

  List<Widget> get _pages {
    return [
      VpHomeScreen(onViewAllOrSeeMore: changeTab),
      // This is the crucial part: VpAllLoadsScreen is now created with the
      // current value of vpAllLoadsInitialTabIndex every time _pages is accessed.
      VpAllLoadsScreen(initialTabIndex: vpAllLoadsInitialTabIndex),
      const Center(child: Text('Support')),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Image.asset(AppIcons.png.appIcon,height: 30,),
      actions: [
        Builder(
            builder: (context) {
              if ( profileResponse != null ) {
                if (profileResponse!.data != null && profileResponse!.data!.customer != null) {
                  if (profileResponse!.data!.customer!.isKyc == 3) {
                    return 0.width;
                  } else {
                    return kycWidget(
                      onTap: () {
                      commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                    },
                    );
                  }
                }
              }
              return SizedBox();
            }
        ),
        IconButton(onPressed: () {

        }, icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),),
        15.width,
        // Profile
        BlocConsumer<LpHomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ProfileDetailSuccess) {
              profileResponse = state.profileDetailResponse;
              profileImage =
                  state.profileDetailResponse.data!.details!.profileImageUrl ??
                      "";
              setState(() {});
            }
            if (state is ProfileDetailError) {
              ToastMessages.error(
                message: getErrorMsg(errorType: state.errorType),
              );
            }
          },
          bloc: lpHomeBloc,
          builder: (context, state) {
            return InkWell(
              onTap: () {
                Navigator.push(context, commonRoute(ProfileScreen(profileData: profileResponse!.data!), isForward: true),
                ).then((v) {
                  frameCallback(() => lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "")));
                });
              },
              child: commonCacheNetworkImage(
                radius: 50,
                height: 40,
                width: 40,
                path: profileImage,
                errorImage: AppImage.png.userProfileError,
              ),
            );
          },
        ),
        15.width,
      ],
    );
  }
  Widget buildKYCStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.appRedColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.png.alertTriangle, width: 20),
          10.width,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.appText.your,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
                TextSpan(
                  text: "  ${context.appText.kyc}  ",
                  style: AppTextStyle.textDarkGreyColor14w500.copyWith(
                    color: AppColors.orangeTextColor,
                  ),
                ),
                TextSpan(
                  text: context.appText.stillPending,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class VpVariables {
  static bool isKycVerified = false;

  static setIsKycVerified(bool isKyc){
    isKycVerified = isKyc;
  }
}