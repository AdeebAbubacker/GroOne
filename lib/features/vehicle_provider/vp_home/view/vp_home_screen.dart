import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_pending_dialogue.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_model.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/my_loads_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/blue_membership_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../load_provider/lp_home/cubit/lp_home_cubit.dart';
import '../../../load_provider/lp_home/cubit/lp_home_state.dart';
import '../../../load_provider/lp_home/view/widgets/incomplete_kyc_status_widget.dart';
import '../bloc/load_accpect/vp_accept_load_bloc.dart';
import '../bloc/load_accpect/vp_accept_load_state.dart';
import '../bloc/vp_home_bloc/vp_home_bloc.dart';

class VpHomeScreen extends StatefulWidget {
  final void Function(int bottomTabIndex, {int? allLoadsSubTabIndex})
  onViewAllOrSeeMore;

  const VpHomeScreen({super.key, required this.onViewAllOrSeeMore});

  @override
  State<VpHomeScreen> createState() => _VpHomeScreenState();
}

class _VpHomeScreenState extends State<VpHomeScreen> {

  // ProfileDetailModel? profileResponse;
   VpMyLoadResponse? vpMyLoadResponse;

  final lpHomeCubit = locator<LPHomeCubit>();
  final vpHomeBloc = locator<VpCreationBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();

  final searchController = TextEditingController();

  bool showKycSuccessBanner = false;

  String profileImage = "";

  String? sessionBlueId;

  int isKycValid = 0;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    vpRecentLoadListBloc.add(VpRecentLoadEvent());
    vpHomeScreenBloc.add(VpMyLoadListRequested());
    await lpHomeCubit.fetchProfileDetail();
    await lpHomeCubit.startKycSuccessTimer();
    await lpHomeCubit.getBlueId();
  });


  void disposeFunction() => frameCallback(() {});


   // Blue Membership Dialog
   void blueMembershipDialog(BuildContext context, String blueId)=> frameCallback(() {
     AppDialog.show(
       context,
       child: CommonDialogView(
         hideCloseButton: true,
         child: BlueMembershipDialogView(
           blueId: blueId,
           afterDismiss: () async {
             debugPrint("Clear Blue ID VP");
             await lpHomeCubit.clearBlueId();
           },
         ),
       ),
     );
   });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: RefreshIndicator(
        onRefresh: () async {
          initFunction();
        },
        child: SafeArea(
          child: Column(
            children: [
              10.height,
              buildKycLabelWidget(),
              10.height,
              OurValueAddedServicesWidget(),
              10.height,
              _buildMyLoadsWidget(context),
              10.height,
              _buildRecentAddedLoadWidget(context),
            ],
          ).withScroll(),
        ),
      )
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
          icon: SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC Blinking
        BlocProvider<LPHomeCubit>.value(
          value: locator<LPHomeCubit>(),   // singleton from get_it
          child: BlocConsumer<LPHomeCubit, LPHomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              final profileState = state.profileDetailUIState;

              if (profileState == null ||
                  profileState.status != Status.SUCCESS ||
                  profileState.data == null ||
                  profileState.data?.data == null ||
                  profileState.data?.data?.customer == null) {
                return const SizedBox.shrink();
              }

              final customer = profileState.data!.data!.customer!;
              final int kycFlag = customer.isKyc.toInt(); // 0 / 2 / 3
              CustomLog.debug(this, 'is KYC : $kycFlag');

              if (kycFlag == 3) {
                return const SizedBox.shrink();
              }

              if (kycFlag == 2) {
                return const SizedBox.shrink();
              }

              return kycWidget(
                onTap: () => commonBottomSheetWithBGBlur(
                  context: context,
                  screen: EnterAadhaarNumberBottomSheet(),
                ),
              );

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
                  if (state.profileDetailUIState?.data?.data?.details != null) {
                    return Row(
                      children: [
                        10.width,

                        // Profile
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.greyIconBackgroundColor),
                          child: Text(getInitialsFromName(this, name : state.profileDetailUIState!.data!.data!.details!.companyName)),
                        ).onClick((){
                          Navigator.push(context, commonRoute(ProfileScreen(profileData: state.profileDetailUIState!.data!.data!), isForward: true)).then((v) {
                            frameCallback(() =>  lpHomeCubit.fetchProfileDetail());
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

  // Kyc & Blue Id
  Widget buildKycLabelWidget(){
    return BlocConsumer<LPHomeCubit, LPHomeState>(
      listener: (context, state) async {
        final profileState = state.profileDetailUIState;
        if (profileState != null &&
            profileState.status == Status.SUCCESS &&
            profileState.data?.data?.customer != null &&
            state.showSuccessKyc) {

          final blueIdFromApi = profileState.data!.data!.customer!.blueId;
          final blueIdFromStorage = await lpHomeCubit.getBlueId();

          debugPrint("💡 BlueId from API: $blueIdFromApi");
          debugPrint("💾 BlueId in storage: $blueIdFromStorage");

          // Show dialog if Blue ID is newly stored
          if ((blueIdFromStorage == null || blueIdFromStorage.isEmpty) && blueIdFromApi.isNotEmpty) {
            if (!context.mounted) return;
            sessionBlueId = blueIdFromApi;
            blueMembershipDialog(context, blueIdFromApi);
          }
        }
      },
      builder: (context, state) {
        final profileState = state.profileDetailUIState;

        if (profileState != null &&
            profileState.status == Status.SUCCESS &&
            profileState.data != null &&
            profileState.data?.data != null &&
            profileState.data?.data?.customer != null) {

          final customer = profileState.data!.data!.customer!;

          isKycValid = customer.isKyc.toInt();

          if (customer.isKyc == 3) {
            return (state.showSuccessKyc && sessionBlueId == null) ? kycSuccessStatusWidget() :  0.width;
          } else if (customer.isKyc == 2) {
            return kycInProgressStatusWidget();
          } else {
            return IncompleteKycStatusWidget();
          }
        }
        return  20.width;
      },
    );
  }

  // My Loads
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
          // Check if data is empty, return empty widget
          if (state.vpMyLoadResponse.data.isEmpty) {
            return const SizedBox.shrink(); // Hides the entire widget
          }

          vpMyLoadResponse = state.vpMyLoadResponse;

          return Container(
            decoration: commonContainerDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.appText.myLoads,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.body1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: Size(68, 30),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "View All",
                        style: AppTextStyle.h5WhiteColor,
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 1);
                    //   },
                    //   style: AppButtonStyle.primaryTextButton,
                    //   child: Text("View All", style: AppTextStyle.h5WhiteColor),
                    // ),
                  ],
                ),
                10.height,

                // List
                ListView.separated(
                  itemCount:
                      state.vpMyLoadResponse.data.length > 3
                          ? 3
                          : state.vpMyLoadResponse.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => 20.height,
                  itemBuilder: (context, index) {
                    final data = state.vpMyLoadResponse.data[index];
                    return MyLoadsListBody(
                      data: data,
                      onClickAssignDriver: () {
                        final isKycDone = VpVariables.isKycVerified;
                        if (isKycDone) {
                          // Navigate to trip scheduling
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
                                  lpHomeBloc.add(
                                    GetProfileDetailApiRequest(
                                      lpHomeBloc.userId ?? "0",
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        }
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
          return const Center(
            child: CircularProgressIndicator(),
          ).paddingSymmetric(vertical: 100);
        }

        return genericErrorWidget(error: GenericError());
      },
    );
  }


  // Recent Loads
  Widget _buildRecentAddedLoadWidget(BuildContext context) {
    return BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
      bloc: locator<VpAcceptLoadBloc>(),
      listener: (context, state) {
        if (state is VpAcceptLoadSuccess) {
          vpRecentLoadListBloc.add(VpRecentLoadEvent());
          vpHomeScreenBloc.add(VpMyLoadListRequested());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              AppDialog.show(
                context,
                child: SuccessDialogView(
                  message: 'Load Accepted Successfully',
                  afterDismiss: () {
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              );
            }
          });
        }
        if (state is VpAcceptLoadError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      child: Container(
        decoration: commonContainerDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            10.height,
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.appText.availableLoads,
                  style: AppTextStyle.body1,
                ).expand(),
                ElevatedButton(
                  onPressed: () {
                    widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(68, 30),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    context.appText.seeMore,
                    style: AppTextStyle.h5WhiteColor,
                  ),
                ),
              ],
            ),
            20.height,
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
                  final loads = state.vpRecentLoadResponse.data;
                  if (loads.isEmpty) {
                    return genericErrorWidget(error: NotFoundError());
                  }
                  return ListView.separated(
                    itemCount: loads.length > 3 ? 3 : loads.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => 20.height,
                    itemBuilder: (context, index) {


                      return RecentAddedLoadListBody(
                        data: loads[index],
                        isKycDone: VpVariables.isKycVerified,
                      );
                    },
                  );
                }
                return genericErrorWidget(error: GenericError());
              },
            ),
            20.height,
          ],
        ).paddingSymmetric(horizontal: commonSafeAreaPadding),
      ),
    );
  }
}


