import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/incomplete_kyc_status_widget.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_available_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_my_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/my_loads_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/blue_membership_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';


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
   final profileCubit = locator<ProfileCubit>();
   final lpHomeBloc = locator<LpHomeBloc>();
   final vpHomeScreenBloc = locator<VpHomeBloc>();
   final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();
   final lpHomeCubit = locator<LPHomeCubit>();


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
    lpHomeBloc.getUserId();
    await profileCubit.fetchUserId();
    vpRecentLoadListBloc.add(VpRecentLoadEvent());
    vpHomeScreenBloc.add(VpMyLoadListRequested());
    lpHomeCubit.setBluIDFlag();
    profileCubit.fetchCompanyTypeId();
    await profileCubit.fetchProfileDetail(instance: this);
  });


  void disposeFunction() => frameCallback(() {

  });


   // Blue Membership Dialog
   void blueMembershipDialog(BuildContext context, String blueId)=> frameCallback(() {
     AppDialog.show(
       context,
       child: CommonDialogView(
         hideCloseButton: true,
         child: BlueMembershipDialogView(blueId: blueId),
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
          onPressed: () {

          },
          icon: SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC Blinking
        BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {},
          builder: (context, state) {
            final profileState = state.profileDetailUIState;

            if (profileState == null || profileState.status != Status.SUCCESS ||
                profileState.data == null || profileState.data?.customer == null) {
              return const SizedBox.shrink();
            }

            final customer = profileState.data!.customer!;
            final int kycFlag = customer.isKyc.toInt(); // 1 / 2 / 3
            final companyId = profileState.data?.customer?.companyTypeId;

            CustomLog.debug(this, 'is KYC : $kycFlag');
            CustomLog.debug(this, 'Company Id : $companyId');

            if (kycFlag == 3 || kycFlag == 2) {
              return const SizedBox.shrink();
            }

            if (kycFlag == 1) {
              return kycWidget(
                onTap: () {
                  if (companyId != null && (companyId == 2 || companyId == 1)) {
                    commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                  } else {
                    Navigator.of(context).push(commonRoute(KycUploadDocumentScreen()));
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }

          },
        ),

        // Profile
        BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            final status = state.profileDetailUIState?.status;

            if (status == Status.ERROR) {
              final error = state.profileDetailUIState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
            }
          },
          builder: (context, state) {
            if (state.profileDetailUIState != null && state.profileDetailUIState?.status == Status.SUCCESS) {
              if (state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.customer != null) {
                final blueId = state.profileDetailUIState!.data!.customer?.blueId;
                return Row(
                  children: [
                    10.width,

                    // Profile
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: commonContainerDecoration(borderColor: blueId != null && blueId.isNotEmpty ? AppColors.primaryColor : Colors.transparent, borderWidth : 2, borderRadius: BorderRadius.circular(100), color: AppColors.extraLightBackgroundGray),
                      child: Text(getInitialsFromName(this, name : state.profileDetailUIState!.data!.customer!.companyName)),
                    ).onClick((){
                      Navigator.push(context, commonRoute(ProfileScreen(), isForward: true)).then((v) {
                        profileCubit.fetchProfileDetail(instance: this);
                      });
                    }).paddingRight(commonSafeAreaPadding),
                  ],
                );
              }
            }
            return Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.extraLightBackgroundGray),
              child: Text(getInitialsFromName(this, name : "")),
            ).onClick((){
              Navigator.push(context, commonRoute(ProfileScreen(), isForward: true));
            }).paddingRight(commonSafeAreaPadding);
          },
        ),

      ],
    );
  }

  // Kyc & Blue Id
  Widget buildKycLabelWidget(){
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listenWhen: (previous, current) => previous.profileDetailUIState?.status != current.profileDetailUIState?.status,
      listener: (context, state)   async {
        final profileState = state.profileDetailUIState;

        if (profileState != null && profileState.status == Status.SUCCESS && profileState.data?.customer != null) {

          final blueIdFromApi = profileState.data!.customer!.blueId;
          final blueIdFromStorage = await profileCubit.fetchBlueId();
          // bool popupShownFlag = await profileCubit.getHasShowBluePopup();
          final blueIdFlag = profileState.data!.customer?.blueIdFlg  ?? false;
          debugPrint("💡 BlueId from API: $blueIdFromApi");
          debugPrint("💾 BlueId in storage: $blueIdFromStorage");
          // debugPrint("🔐 BlueId popup shown flag: $popupShownFlag");

          if (blueIdFromApi.isNotEmpty && blueIdFlag) {

            if (!context.mounted) return;
            sessionBlueId = blueIdFromApi;
            blueMembershipDialog(context, blueIdFromApi);

            await profileCubit.startKycSuccessTimer(true);
            // Set flag that popup is shown
            await  profileCubit.saveHasShowBluePopup(false);
          }

          profileCubit.startKycSuccessTimer(false);
        }
      },
      builder: (context, state) {
        final profileState = state.profileDetailUIState;

        if (profileState != null && profileState.status == Status.SUCCESS && profileState.data != null  && profileState.data?.customer != null) {

          final customer = profileState.data!.customer!;
          final companyId = profileState.data?.customer?.companyTypeId;
          final companyName = profileState.data?.customer?.companyName;

          CustomLog.debug(this, "Company Name: $companyName");
          CustomLog.debug(this, "Is Kyc : ${customer.isKyc}");

          isKycValid = customer.isKyc.toInt();

          if (customer.isKyc == 3) {
            return (state.showSuccessKyc && sessionBlueId == null) ? kycSuccessStatusWidget().paddingTop(10) :  0.width;
          } else if (customer.isKyc == 2) {
            return kycInProgressStatusWidget().paddingTop(10);
          } else if (customer.isKyc == 1) {
            return IncompleteKycStatusWidget(companyId: companyId).paddingTop(10);
          }
        }
        return  20.width;
      },
    );
  }

  // My Loads
  Widget _buildMyLoadsWidget(BuildContext context) {
    return BlocConsumer(
      bloc: vpHomeScreenBloc,
      listener: (context, state) {
        if (state is VpMyLoadListSuccess) {
          vpMyLoadResponse = state.vpMyLoadResponse;
        }
      },
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
                        context.appText.viewAll,
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
                  itemCount: state.vpMyLoadResponse.data.length > 3 ? 3 : state.vpMyLoadResponse.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => 20.height,
                  itemBuilder: (context, index) {
                    final data = state.vpMyLoadResponse.data[index];
                    return GestureDetector(
                      onTap: () async {
                        await  context.push(AppRouteName.loadDetailsScreen,extra: {
                          "loadId":data.id
                        }).then((value) {
                          vpHomeScreenBloc.add(VpMyLoadListRequested());
                        },);
                      },
                      child: VpAllLoadMyLoadWidget(
                        data: data,
                        onBack: (){
                          vpHomeScreenBloc.add(VpMyLoadListRequested());
                        },
                        onClickAssignDriver: () {
                          final isKycDone = VpVariables.isKycVerified;
                          final companyId = int.parse(profileCubit.companyTypeId ?? "0");
                          if (isKycDone) {
                            context.push(AppRouteName.loadDetailsScreen, extra: {"loadId":data.id});
                          } else if (companyId == 2 || companyId == 1) {
                            commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                          } else {
                            Navigator.of(context).push(commonRoute(KycUploadDocumentScreen()));
                          }
                        },
                      ),
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
                  message: context.appText.loadAcceptedSuccessfully,
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
                      final companyId = int.parse(profileCubit.companyTypeId ?? "0");
                      return RecentAddedLoadListBody(
                        data: loads[index],
                        isKycDone: VpVariables.isKycVerified,
                        companyTypeId: companyId,
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


