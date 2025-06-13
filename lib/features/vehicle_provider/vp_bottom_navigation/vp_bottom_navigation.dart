import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/toast_messages.dart';
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
  final lpHomeBloc = locator<LpHomeBloc>();

  final List<Widget> pages = [
    VpHomeScreen(),
    VpAllLoadsScreen(),
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
      appBar: _buildAppBar(context),
      body: pages[selectedIndex],
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
        IconButton(
          onPressed: () {},
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),
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
}
