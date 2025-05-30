import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/view/lp_profile_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/our_value_added_service_widget.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/view/available_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/my_loads_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/trip_scheduling_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/routing/app_routes.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../kyc/view/widgets/kyc_bottom_sheet.dart';

class VpHomeScreen extends StatefulWidget {
  const VpHomeScreen({super.key});

  @override
  State<VpHomeScreen> createState() => _VpHomeScreenState();
}

class _VpHomeScreenState extends State<VpHomeScreen> {
  String profileImage = "";
  final vpHomeBloc = locator<VpCreationBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final searchController = TextEditingController();
  ProfileDetailResponse? profileResponse;
  VpMyLoadResponse? vpMyLoadResponse;

  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => addPostFrameCallback(() async {
    vpHomeScreenBloc.add(VpMyLoadListRequested());
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? ""));
    //  Call your init methods
  });

  void disposeFunction() => addPostFrameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  // AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      leading: Image.asset(
        AppIcons.png.appIcon,
      ).paddingLeft(commonSafeAreaPadding),
      actions: [
        // KYC
        kycWidget(
          onTap: () {
            commonBottomSheetWithBGBlur(
              context: context,

              screen: KycBottomSheet(),
            );
          },
        ),
        10.width,

        // Profile
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              commonRoute(
                LpProfileScreen(profileData: profileResponse!.data!),
                isForward: true,
              ),
            ).then((v) {
              addPostFrameCallback(
                () => lpHomeBloc.add(
                  ProfileDetailRequested(lpHomeBloc.userId ?? ""),
                ),
              );
            });
          },
          child: commonCacheNetworkImage(
            radius: 50,
            height: 40,
            width: 40,
            path: profileImage ?? "",
            errorImage: AppImage.png.userProfileError,
          ).paddingRight(commonSafeAreaPadding),
        ),
      ],
    );
  }

  // Body
  Widget _buildBody(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Column(
              children: [
                20.height,
                valueAddedService(context),
                20.height,
                _buildMyLoadsWidget(context),
                20.height,
                _buildRecentAddedLoadWidget(context),
              ],
            ).withScroll(),
      ),
    );
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        // Search bar
        AppSearchBar(searchController: searchController).expand(),
        15.width,

        // Filter Button
        AppIconButton(
          onPressed: () {
            //  commonBottomSheetWithBGBlur(context: context, screen: KavachModelsFilterBottomSheetScreen());
          },
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(
            AppIcons.svg.filter,
            width: 20,
            colorFilter: AppColors.svg(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildMyLoadsWidget(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is VpMyLoadListSuccess) {
          vpMyLoadResponse = state.vpMyLoadResponse;
        }

        if (state is VpMyLoadListError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      bloc: vpHomeScreenBloc,
      builder: (context, state) {
        return Container(
          decoration: commonContainerDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            children: [
              10.height,
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Loads", style: AppTextStyle.body1).expand(),

                  // See More
                ],
              ),

              10.height,
              // List
              vpMyLoadResponse != null
                  ? vpMyLoadResponse!.data.isNotEmpty
                      ? ListView.separated(
                        itemCount: vpMyLoadResponse!.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => 20.height,
                        itemBuilder: (context, index) {
                          var data = vpMyLoadResponse!.data[index];
                          return MyLoadsListBody(
                            data: data,
                            onClickAssignDriver: () {
                              Navigator.push(
                                context,
                                commonRoute(TripSchedulingScreen(data: data,allProfileDetails:profileResponse!.data!)),
                              ).then((value) {
                                vpHomeScreenBloc.add(VpMyLoadListRequested());
                              },);
                            },
                          );
                        },
                      )
                      : Center(
                        child: Image.asset(
                          width: 201.w,
                          height: 134.h,
                          AppImage.png.noShipment,
                        ),
                      )
                  : Center(child: CircularProgressIndicator()),

              20.height,
            ],
          ).paddingSymmetric(horizontal: commonSafeAreaPadding),
        );
      },
    );
  }

  Widget _buildRecentAddedLoadWidget(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          10.height,
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.appText.recentAddedLoad,
                style: AppTextStyle.body1,
              ).expand(),

              // See More
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    commonRoute(const AvailableLoadsScreen()),
                  );
                },
                style: AppButtonStyle.primaryTextButton,
                child: Text(
                  context.appText.seeMore,
                  style: AppTextStyle.body3WhiteColor,
                ),
              ),
            ],
          ),
          10.height,
          buildSearchBarAndFilterWidget(context),
          10.height,
          // List
          ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 20.height,
            itemBuilder: (context, index) {
              return RecentAddedLoadListBody();
            },
          ),

          20.height,
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding),
    );
  }
}
