import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_pending_dialogue.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/our_value_added_service/view/our_value_added_service_widget.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/view/available_loads_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/my_loads_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/trip_scheduling_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_video.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:video_player/video_player.dart';


class VpHomeScreen extends StatefulWidget {
  const VpHomeScreen({super.key});

  @override
  State<VpHomeScreen> createState() => _VpHomeScreenState();
}

class _VpHomeScreenState extends State<VpHomeScreen> {

  late VideoPlayerController _controller;

  String profileImage = "";
  final vpHomeBloc = locator<VpCreationBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();

  final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();


  final searchController = TextEditingController();
  ProfileDetailModel? profileResponse;
  VpMyLoadResponse? vpMyLoadResponse;

  @override
  void initState() {
    // TODO: implement initState
    initializeVideoPlayer(context);
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    vpRecentLoadListBloc.add(VpRecentLoadEvent());
    vpHomeScreenBloc.add(VpMyLoadListRequested());
    lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? ""));
  });

  void disposeFunction() => frameCallback(() {});


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      isLeading: false,
      leading: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      actions: [
        // KYC
        if( _controller.value.isInitialized)
        kycWidget(
          controller: _controller,
          onTap: () {
            commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet()).then((value) {
              lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "0"),
              );
            });
          },
        ),
        10.width,

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

  /// Body
  Widget _buildBody(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          vpRecentLoadListBloc.add(VpRecentLoadEvent());
          vpHomeScreenBloc.add(VpMyLoadListRequested());
        },
        child: SafeArea(
          child:
              Column(
                children: [
                  Builder(
                      builder: (context) {
                        if ( profileResponse != null ) {
                          if (profileResponse!.data != null && profileResponse!.data!.customer != null) {
                            if (profileResponse!.data!.customer!.isKyc == 3) {
                              return SvgPicture.asset(AppImage.svg.kycSuccessStatus, height: 50.h);
                            } else {
                              return buildKYCStatusWidget();
                            }
                          }
                        }
                        return SizedBox();
                      }
                  ),

                  buildValueAddedService(context),
                  20.height,
                  _buildMyLoadsWidget(context),
                  20.height,
                  _buildRecentAddedLoadWidget(context),
                ],
              ).withScroll(),
        ),
      ),
    );
  }

  /// KYC Widget
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

  /// Search And Filter
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

  /// My Loads
  Widget _buildMyLoadsWidget(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is VpMyLoadListSuccess) {
          vpMyLoadResponse = state.vpMyLoadResponse;
        }
      },
      bloc: vpHomeScreenBloc,
      builder: (context, state) {
        if (state is VpMyLoadListSuccess) {
          return Container(
            decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appText.myLoads, textAlign: TextAlign.start, style: AppTextStyle.body1),

                    // See More
                    //if (state is VpMyLoadListSuccess)
                    // if (state.vpMyLoadResponse.data.length > 2)
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, commonRoute(const AvailableLoadsScreen(), isForward: true));
                      },
                      style: AppButtonStyle.primaryTextButton,
                      child: Text(context.appText.seeMore, style: AppTextStyle.body3WhiteColor),
                    )
                  ],
                ),
                10.height,

                // List
                Builder(
                  builder: (context) {
                    if (vpMyLoadResponse == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (vpMyLoadResponse!.data.isEmpty) {
                      return Center(
                        child: Image.asset(
                          AppImage.png.noShipment,
                          width: 201.w,
                          height: 134.h,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: vpMyLoadResponse!.data.length > 2 ? 2 : vpMyLoadResponse!.data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => 20.height,
                      itemBuilder: (context, index) {
                        final data = vpMyLoadResponse!.data[index];

                        return MyLoadsListBody(
                          data: data,
                          onClickAssignDriver: () {
                            final isKycDone = profileResponse?.data?.customer?.isKyc == 3;
                            if (isKycDone) {
                              Navigator.push(context, commonRoute(TripSchedulingScreen(data: data, allProfileDetails: profileResponse!.data!), isForward: true));
                            } else {
                              commonBottomSheetWithBGBlur(
                                context: context,
                                screen: KycPendingDialogue(
                                  onPressed: () {
                                    context.pop();
                                    commonBottomSheetWithBGBlur(
                                      context: context,
                                      screen: EnterAadhaarNumberBottomSheet(),
                                    ).then((_) {
                                      lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "0"));
                                    });
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                20.height,
              ],
            ).paddingSymmetric(horizontal: commonSafeAreaPadding),
          );
        }
        if (state is VpMyLoadListError) {
           return genericErrorWidget(error: state.errorType);
        }
        if (state is VpMyLoadListLoading) {
           return CircularProgressIndicator().paddingSymmetric(vertical: 100).center();
        } else {
          return genericErrorWidget(error: GenericError());
        }
      },
    );
  }

  /// Recent Loads
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
              Text(context.appText.recentAddedLoad, style: AppTextStyle.body1).expand(),

              // See More
              TextButton(
                onPressed: () {
                  Navigator.push(context, commonRoute(const AvailableLoadsScreen(), isForward: true));
                },
                style: AppButtonStyle.primaryTextButton,
                child: Text(context.appText.seeMore, style: AppTextStyle.body3WhiteColor),
              ),

            ],
          ),
          10.height,
          buildSearchBarAndFilterWidget(context),
          20.height,

          // List
          BlocBuilder<VpRecentLoadListBloc, VpRecentLoadListState>(
            bloc: vpRecentLoadListBloc,
            builder: (context, state) {
              if (state is VpRecentLoadListLoading) {
                 return CircularProgressIndicator().center();
              }
              if (state is VpRecentLoadListError) {
                 return genericErrorWidget(error: state.errorType);
              }
              if (state is VpRecentLoadListSuccess) {
                if(state.vpRecentLoadResponse.data.isNotEmpty){
                  return ListView.separated(
                    itemCount: state.vpRecentLoadResponse.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => 20.height,
                    itemBuilder: (context, index) {
                      return RecentAddedLoadListBody(data: state.vpRecentLoadResponse.data[index]);
                    },
                  );
                }else{
                  return genericErrorWidget(error: NotFoundError());
                }
              } else {
                return genericErrorWidget(error: GenericError());
              }
            },
          ),
          20.height,
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding),
    );
  }


}
