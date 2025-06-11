import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../dependency_injection/locator.dart';
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
import '../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../../load_provider/lp_home/model/profile_detail_response_model.dart';
import '../../../profile/view/profile_screen.dart';

class VpAllLoadsScreen extends StatefulWidget {
  const VpAllLoadsScreen({super.key});

  @override
  State<VpAllLoadsScreen> createState() => _VpAllLoadsScreenState();
}

class _VpAllLoadsScreenState extends State<VpAllLoadsScreen> with TickerProviderStateMixin{
  late TabController _tabController;

  String profileImage = "";
  final searchController = TextEditingController();
  ProfileDetailModel? profileResponse;
  final lpHomeBloc = locator<LpHomeBloc>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {}); // Safe setState
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: const BoxDecoration(), // remove default indicator
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: List.generate(4, (index) {
                final tabLabels = ['Available Loads', 'My Loads', 'Confirmed', 'Assigned'];
                final isSelected = _tabController.index == index;
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabLabels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                 Placeholder(),
                 Placeholder(),
                 Placeholder(),
                 Placeholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      leading: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      actions: [
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
                  frameCallback(() => lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "")));
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

        // Notification
        AppIconButton(
          onPressed: (){},
          style: AppButtonStyle.circularIconButtonStyle,
          icon: Icons.notifications,
          iconColor: AppColors.primaryColor,
        ),
        15.width,
      ],
    );
  }
}
